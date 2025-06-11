package com.wallet.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.text.NumberFormat;
import java.util.Locale;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChartService {

    private final RestTemplate restTemplate;
    private static final String COINGECKO_API_URL = "https://api.coingecko.com/api/v3";
    private static final String UPBIT_API_URL = "https://api.upbit.com/v1";
    private final Map<String, CacheEntry> cache = new ConcurrentHashMap<>();
    private static final long CACHE_DURATION = 10000; // 10초 캐시
    private final NumberFormat koreanWonFormat = NumberFormat.getNumberInstance(Locale.KOREA);
    private final Random random = new Random();

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
        try {
            log.info("차트 데이터 조회 시작 - 기간: {}", period);
            
            // 현재가 정보 가져오기
            String tickerUrl = UPBIT_API_URL + "/ticker?markets=KRW-ETH";
            log.info("티커 API 호출: {}", tickerUrl);
            
            ResponseEntity<List> tickerResponse = restTemplate.getForEntity(tickerUrl, List.class);
            
            if (!tickerResponse.getStatusCode().is2xxSuccessful()) {
                log.error("Upbit API 호출 실패 - 상태 코드: {}", tickerResponse.getStatusCode());
                throw new RuntimeException("Upbit API 호출 실패: " + tickerResponse.getStatusCode());
            }

            List<Map<String, Object>> tickerData = (List<Map<String, Object>>) tickerResponse.getBody();
            if (tickerData == null || tickerData.isEmpty()) {
                log.error("티커 데이터가 비어있음");
                throw new RuntimeException("티커 데이터가 비어있습니다.");
            }

            Map<String, Object> ticker = tickerData.get(0);
            log.info("티커 데이터: {}", ticker);
            
            // 데이터 파싱
            BigDecimal currentPrice = new BigDecimal(ticker.get("trade_price").toString());
            BigDecimal highPrice = new BigDecimal(ticker.get("high_price").toString());
            BigDecimal lowPrice = new BigDecimal(ticker.get("low_price").toString());
            BigDecimal volume = new BigDecimal(ticker.get("acc_trade_price_24h").toString());
            BigDecimal changeRate = new BigDecimal(ticker.get("signed_change_rate").toString())
                .multiply(new BigDecimal("100"));

            // 기간에 따른 캔들 타입과 개수 설정
            String candleType;
            int candleCount;
            
            switch (period) {
                case "1D":
                    candleType = "minutes/15";  // 15분봉
                    candleCount = 96;           // 24시간 = 96개
                    break;
                case "1W":
                    candleType = "days";        // 일봉
                    candleCount = 7;            // 1주일 = 7개
                    break;
                case "1M":
                    candleType = "days";        // 일봉
                    candleCount = 30;           // 1개월 = 30개
                    break;
                case "3M":
                    candleType = "weeks";       // 주봉
                    candleCount = 12;           // 3개월 = 12주
                    break;
                case "1Y":
                    candleType = "months";      // 월봉
                    candleCount = 12;           // 1년 = 12개월
                    break;
                default:
                    candleType = "minutes/15";  // 기본값: 15분봉
                    candleCount = 96;           // 24시간
            }

            // 캔들 데이터 가져오기
            String candlesUrl = UPBIT_API_URL + "/candles/" + candleType + "?market=KRW-ETH&count=" + candleCount;
            
            log.info("캔들 API 호출: {}", candlesUrl);
            ResponseEntity<List> candlesResponse = restTemplate.getForEntity(candlesUrl, List.class);
            
            if (!candlesResponse.getStatusCode().is2xxSuccessful()) {
                log.error("캔들 API 호출 실패 - 상태 코드: {}", candlesResponse.getStatusCode());
                throw new RuntimeException("Upbit API 호출 실패: " + candlesResponse.getStatusCode());
            }

            List<Map<String, Object>> candleData = (List<Map<String, Object>>) candlesResponse.getBody();
            if (candleData == null || candleData.isEmpty()) {
                log.error("캔들 데이터가 비어있음");
                throw new RuntimeException("캔들 데이터가 비어있습니다.");
            }

            log.info("캔들 데이터 개수: {}", candleData.size());
            log.info("첫 번째 캔들: {}", candleData.get(0));
            log.info("마지막 캔들: {}", candleData.get(candleData.size() - 1));

            // 차트 데이터 생성
            List<String> labels = new ArrayList<>();
            List<BigDecimal> prices = new ArrayList<>();
            
            // 캔들 데이터를 시간순으로 정렬 (과거 -> 현재)
            Collections.reverse(candleData); // 현재->과거 순서를 과거->현재 순서로 변경
            
            for (Map<String, Object> candle : candleData) {
                // 시간 포맷팅
                String timestamp = candle.get("candle_date_time_kst").toString();
                String label;
                
                switch (period) {
                    case "1D":
                        label = timestamp.substring(11, 16);  // HH:mm
                        break;
                    case "1W":
                    case "1M":
                        label = timestamp.substring(5, 10);   // MM-dd
                        break;
                    case "3M":
                    case "1Y":
                        label = timestamp.substring(0, 10);   // YYYY-MM-dd
                        break;
                    default:
                        label = timestamp.substring(11, 16);  // HH:mm
                }
                
                labels.add(label);
                
                // 현재가 사용
                BigDecimal candlePrice = new BigDecimal(candle.get("trade_price").toString());
                prices.add(candlePrice);
                
                log.debug("데이터 포인트 추가 - 시간: {}, 가격: {}", label, candlePrice);
            }

            Map<String, Object> result = new HashMap<>();
            result.put("labels", labels);
            result.put("prices", prices);
            result.put("currentPrice", formatKoreanWon(currentPrice));
            result.put("highPrice", formatKoreanWon(highPrice));
            result.put("lowPrice", formatKoreanWon(lowPrice));
            result.put("priceChange", changeRate.setScale(2, RoundingMode.HALF_UP));
            result.put("volume", formatVolume(volume));
            result.put("globalPrice", formatKoreanWon(currentPrice));
            result.put("premium", BigDecimal.ZERO);

            log.info("차트 데이터 생성 완료 - 데이터 포인트 수: {}", prices.size());
            log.debug("생성된 레이블: {}", labels);
            log.debug("생성된 가격 데이터: {}", prices);
            
            return result;

        } catch (Exception e) {
            log.error("차트 데이터 조회 중 오류 발생: {}", e.getMessage(), e);
            
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("labels", new ArrayList<>());
            errorResult.put("prices", new ArrayList<>());
            errorResult.put("currentPrice", "0원");
            errorResult.put("highPrice", "0원");
            errorResult.put("lowPrice", "0원");
            errorResult.put("priceChange", BigDecimal.ZERO);
            errorResult.put("volume", "0원");
            errorResult.put("globalPrice", "0원");
            errorResult.put("premium", BigDecimal.ZERO);
            
            return errorResult;
        }
    }

    private String formatKoreanWon(BigDecimal value) {
        if (value.compareTo(new BigDecimal("100000000000")) >= 0) { // 1000억 이상
            return koreanWonFormat.format(value.divide(new BigDecimal("100000000"), 1, RoundingMode.HALF_UP)) + "억원";
        } else if (value.compareTo(new BigDecimal("100000000")) >= 0) { // 1억 이상
            return koreanWonFormat.format(value.divide(new BigDecimal("100000000"), 1, RoundingMode.HALF_UP)) + "억원";
        } else if (value.compareTo(new BigDecimal("10000")) >= 0) { // 1만 이상
            return koreanWonFormat.format(value.divide(new BigDecimal("10000"), 1, RoundingMode.HALF_UP)) + "만원";
        } else {
            return koreanWonFormat.format(value) + "원";
        }
    }

    private String formatVolume(BigDecimal value) {
        if (value.compareTo(new BigDecimal("1000000000000")) >= 0) { // 1조 이상
            return koreanWonFormat.format(value.divide(new BigDecimal("1000000000000"), 1, RoundingMode.HALF_UP)) + "조원";
        } else if (value.compareTo(new BigDecimal("100000000")) >= 0) { // 1억 이상
            return koreanWonFormat.format(value.divide(new BigDecimal("100000000"), 1, RoundingMode.HALF_UP)) + "억원";
        } else {
            return koreanWonFormat.format(value.divide(new BigDecimal("10000"), 1, RoundingMode.HALF_UP)) + "만원";
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
                return String.format("%02d/%02d", dateTime.getMonthValue(), dateTime.getDayOfMonth());
            case "1M":
                return String.format("%02d/%02d", dateTime.getMonthValue(), dateTime.getDayOfMonth());
            case "3M":
                return String.format("%d/%02d", dateTime.getMonthValue(), dateTime.getDayOfMonth());
            case "1Y":
                return String.format("%d/%02d", dateTime.getMonthValue(), dateTime.getDayOfMonth());
            default:
                return String.format("%02d:%02d", dateTime.getHour(), dateTime.getMinute());
        }
    }
} 