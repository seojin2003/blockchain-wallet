package com.wallet.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.text.NumberFormat;
import java.util.Locale;

@Service
@RequiredArgsConstructor
public class ChartService {

    private final RestTemplate restTemplate;
    private static final String COINGECKO_API_URL = "https://api.coingecko.com/api/v3";
    private static final String UPBIT_API_URL = "https://api.upbit.com/v1";
    private final Map<String, CacheEntry> cache = new ConcurrentHashMap<>();
    private static final long CACHE_DURATION = 5000; // 5초 캐시
    private final NumberFormat koreanWonFormat = NumberFormat.getNumberInstance(Locale.KOREA);

    private static class CacheEntry {
        final Map<String, Object> data;
        final long timestamp;

        CacheEntry(Map<String, Object> data) {
            this.data = data;
            this.timestamp = System.currentTimeMillis();
        }

        boolean isExpired() {
            return System.currentTimeMillis() - timestamp > CACHE_DURATION;
        }
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> getPriceData(String period) {
        // 캐시 확인
        CacheEntry cachedData = cache.get(period);
        if (cachedData != null && !cachedData.isExpired()) {
            return cachedData.data;
        }

        Map<String, Object> result = new HashMap<>();
        
        try {
            // 업비트 현재가 조회
            String upbitUrl = UPBIT_API_URL + "/ticker?markets=KRW-ETH";
            List<Map<String, Object>> upbitResponse = restTemplate.getForObject(upbitUrl, List.class);
            
            BigDecimal upbitCurrentPrice = BigDecimal.ZERO;
            BigDecimal upbitHighPrice = BigDecimal.ZERO;
            BigDecimal upbitLowPrice = BigDecimal.ZERO;
            BigDecimal upbitVolume = BigDecimal.ZERO;
            
            if (upbitResponse != null && !upbitResponse.isEmpty()) {
                Map<String, Object> upbitData = upbitResponse.get(0);
                upbitCurrentPrice = new BigDecimal(upbitData.get("trade_price").toString());
                upbitHighPrice = new BigDecimal(upbitData.get("high_price").toString());
                upbitLowPrice = new BigDecimal(upbitData.get("low_price").toString());
                upbitVolume = new BigDecimal(upbitData.get("acc_trade_price_24h").toString());
            }

            // CoinGecko API 호출
            long endTime = System.currentTimeMillis() / 1000;
            long startTime = calculateStartTime(period, endTime);
            
            String url = String.format(
                "%s/coins/ethereum/market_chart/range?vs_currency=krw&from=%d&to=%d",
                COINGECKO_API_URL, startTime, endTime
            );
            
            Map<String, List<List<Number>>> response = restTemplate.getForObject(url, Map.class);
            
            if (response != null && response.containsKey("prices")) {
                List<List<Number>> prices = response.get("prices");
                List<String> labels = new ArrayList<>();
                List<BigDecimal> priceData = new ArrayList<>();
                
                BigDecimal globalCurrentPrice = BigDecimal.ZERO;
                BigDecimal globalHighPrice = BigDecimal.ZERO;
                BigDecimal globalLowPrice = new BigDecimal("999999999999");
                
                for (List<Number> price : prices) {
                    long timestamp = price.get(0).longValue();
                    BigDecimal priceValue = new BigDecimal(price.get(1).toString());
                    
                    LocalDateTime dateTime = LocalDateTime.ofEpochSecond(timestamp / 1000, 0, ZoneOffset.UTC);
                    String label = formatDateTime(dateTime, period);
                    
                    labels.add(label);
                    priceData.add(priceValue);
                    
                    if (priceValue.compareTo(globalHighPrice) > 0) {
                        globalHighPrice = priceValue;
                    }
                    if (priceValue.compareTo(globalLowPrice) < 0) {
                        globalLowPrice = priceValue;
                    }
                    
                    globalCurrentPrice = priceValue;
                }
                
                // 가격 변동률 계산
                BigDecimal firstPrice = priceData.get(0);
                BigDecimal priceChange = upbitCurrentPrice.subtract(firstPrice)
                    .divide(firstPrice, 2, BigDecimal.ROUND_HALF_UP)
                    .multiply(new BigDecimal("100"));

                // 김치 프리미엄 계산
                BigDecimal premium = upbitCurrentPrice.subtract(globalCurrentPrice)
                    .divide(globalCurrentPrice, 4, BigDecimal.ROUND_HALF_UP)
                    .multiply(new BigDecimal("100"));
                
                // 결과 맵 구성
                result.put("labels", labels);
                result.put("prices", priceData);
                result.put("currentPrice", formatKoreanWon(upbitCurrentPrice));
                result.put("highPrice", formatKoreanWon(upbitHighPrice));
                result.put("lowPrice", formatKoreanWon(upbitLowPrice));
                result.put("priceChange", priceChange.setScale(2, BigDecimal.ROUND_HALF_UP));
                result.put("volume", formatVolume(upbitVolume));
                result.put("globalPrice", formatKoreanWon(globalCurrentPrice));
                result.put("premium", premium.setScale(2, BigDecimal.ROUND_HALF_UP));

                cache.put(period, new CacheEntry(result));
            }
        } catch (Exception e) {
            result.put("labels", new ArrayList<>());
            result.put("prices", new ArrayList<>());
            result.put("currentPrice", "0원");
            result.put("highPrice", "0원");
            result.put("lowPrice", "0원");
            result.put("priceChange", BigDecimal.ZERO);
            result.put("volume", "0원");
            result.put("globalPrice", "0원");
            result.put("premium", BigDecimal.ZERO);
        }
        
        return result;
    }

    private String formatKoreanWon(BigDecimal value) {
        if (value.compareTo(new BigDecimal("100000000000")) >= 0) { // 1000억 이상
            return koreanWonFormat.format(value.divide(new BigDecimal("100000000"), 1, BigDecimal.ROUND_HALF_UP)) + "억원";
        } else if (value.compareTo(new BigDecimal("100000000")) >= 0) { // 1억 이상
            return koreanWonFormat.format(value.divide(new BigDecimal("100000000"), 1, BigDecimal.ROUND_HALF_UP)) + "억원";
        } else if (value.compareTo(new BigDecimal("10000")) >= 0) { // 1만 이상
            return koreanWonFormat.format(value.divide(new BigDecimal("10000"), 1, BigDecimal.ROUND_HALF_UP)) + "만원";
        } else {
            return koreanWonFormat.format(value) + "원";
        }
    }

    private String formatVolume(BigDecimal value) {
        if (value.compareTo(new BigDecimal("1000000000000")) >= 0) { // 1조 이상
            return koreanWonFormat.format(value.divide(new BigDecimal("1000000000000"), 1, BigDecimal.ROUND_HALF_UP)) + "조원";
        } else if (value.compareTo(new BigDecimal("100000000")) >= 0) { // 1억 이상
            return koreanWonFormat.format(value.divide(new BigDecimal("100000000"), 1, BigDecimal.ROUND_HALF_UP)) + "억원";
        } else {
            return koreanWonFormat.format(value.divide(new BigDecimal("10000"), 1, BigDecimal.ROUND_HALF_UP)) + "만원";
        }
    }
    
    private long calculateStartTime(String period, long endTime) {
        long secondsInDay = 24 * 60 * 60;
        switch (period) {
            case "1D":
                return endTime - secondsInDay;
            case "1W":
                return endTime - (7 * secondsInDay);
            case "1M":
                return endTime - (30 * secondsInDay);
            case "3M":
                return endTime - (90 * secondsInDay);
            case "1Y":
                return endTime - (365 * secondsInDay);
            default:
                return endTime - secondsInDay;
        }
    }
    
    private String formatDateTime(LocalDateTime dateTime, String period) {
        switch (period) {
            case "1D":
                return String.format("%02d:%02d", dateTime.getHour(), dateTime.getMinute());
            case "1W":
                return String.format("%02d/%02d %02d:%02d",
                    dateTime.getMonthValue(), dateTime.getDayOfMonth(),
                    dateTime.getHour(), dateTime.getMinute());
            case "1M":
                return String.format("%02d/%02d %02d:%02d",
                    dateTime.getMonthValue(), dateTime.getDayOfMonth(),
                    dateTime.getHour(), dateTime.getMinute());
            case "3M":
                return String.format("%02d/%02d %02d:%02d",
                    dateTime.getMonthValue(), dateTime.getDayOfMonth(),
                    dateTime.getHour(), dateTime.getMinute());
            case "1Y":
                return String.format("%02d/%02d %02d:%02d",
                    dateTime.getMonthValue(), dateTime.getDayOfMonth(),
                    dateTime.getHour(), dateTime.getMinute());
            default:
                return String.format("%02d/%02d %02d:%02d",
                    dateTime.getMonthValue(), dateTime.getDayOfMonth(),
                    dateTime.getHour(), dateTime.getMinute());
        }
    }
} 