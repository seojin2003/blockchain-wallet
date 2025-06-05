package com.wallet.controller;

import com.wallet.entity.Member;
import com.wallet.service.ChartService;
import com.wallet.service.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class ChartController {

    private final ChartService chartService;
    private final MemberService memberService;

    @GetMapping("/chart")
    public String chartPage(@AuthenticationPrincipal User user, Model model) {
        if (user == null) {
            log.warn("Unauthorized access attempt to chart page");
            return "redirect:/login";
        }

        try {
            Member member = memberService.findByUsername(user.getUsername());
            model.addAttribute("member", member);
            return "chart";
        } catch (Exception e) {
            log.error("Error while loading chart page: {}", e.getMessage());
            return "redirect:/login";
        }
    }

    @GetMapping("/api/chart/price")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getPriceData(@RequestParam String period, @AuthenticationPrincipal User user) {
        if (user == null) {
            log.warn("Unauthorized access attempt to price API");
            return ResponseEntity.status(401).build();
        }

        try {
            log.info("차트 데이터 요청 - 기간: {}, 사용자: {}", period, user.getUsername());
            Map<String, Object> data = chartService.getPriceData(period);
            log.info("차트 데이터 응답 - 데이터 포인트 수: {}", ((List<?>) data.get("prices")).size());
            return ResponseEntity.ok(data);
        } catch (Exception e) {
            log.error("Error while fetching price data: {}", e.getMessage());
            return ResponseEntity.internalServerError().build();
        }
    }
} 