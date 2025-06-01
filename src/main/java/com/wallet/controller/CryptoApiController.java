package com.wallet.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

@RestController
@RequestMapping("/api/crypto")
@CrossOrigin(origins = "*")
public class CryptoApiController {
    
    private final String COINGECKO_API_BASE = "https://api.coingecko.com/api/v3";
    private final RestTemplate restTemplate;

    public CryptoApiController() {
        this.restTemplate = new RestTemplate();
    }

    @GetMapping("/price")
    public Object getPrice() {
        try {
            String url = COINGECKO_API_BASE + "/simple/price?ids=ethereum&vs_currencies=usd&include_24hr_change=true&include_24hr_high=true&include_24hr_low=true";
            ResponseEntity<Object> response = restTemplate.getForEntity(url, Object.class);
            return response.getBody();
        } catch (Exception e) {
            e.printStackTrace();
            return "{\"error\": \"" + e.getMessage() + "\"}";
        }
    }

    @GetMapping("/ohlc")
    public Object getOHLC(@RequestParam String days) {
        try {
            String url = COINGECKO_API_BASE + "/coins/ethereum/ohlc?vs_currency=usd&days=" + days;
            ResponseEntity<Object> response = restTemplate.getForEntity(url, Object.class);
            return response.getBody();
        } catch (Exception e) {
            e.printStackTrace();
            return "{\"error\": \"" + e.getMessage() + "\"}";
        }
    }

    @GetMapping("/market_chart")
    public Object getMarketChart(
            @RequestParam String days,
            @RequestParam(required = false) String interval) {
        try {
            String url = COINGECKO_API_BASE + "/coins/ethereum/market_chart?vs_currency=usd&days=" + days;
            if (interval != null && !interval.isEmpty()) {
                url += "&interval=" + interval;
            }
            ResponseEntity<Object> response = restTemplate.getForEntity(url, Object.class);
            return response.getBody();
        } catch (Exception e) {
            e.printStackTrace();
            return "{\"error\": \"" + e.getMessage() + "\"}";
        }
    }
} 