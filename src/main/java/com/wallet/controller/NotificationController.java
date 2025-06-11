package com.wallet.controller;

import com.wallet.entity.Member;
import com.wallet.entity.Notification;
import com.wallet.service.MemberService;
import com.wallet.service.NotificationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;
    private final MemberService memberService;

    @GetMapping("/notifications")
    public String notifications(@AuthenticationPrincipal User user, Model model) {
        Member member = memberService.findByUsername(user.getUsername());
        List<Notification> notifications = notificationService.getNotifications(member);
        model.addAttribute("member", member);
        model.addAttribute("notifications", notifications);
        return "notifications";
    }

    @PostMapping("/notifications/{id}/read")
    @ResponseBody
    public ResponseEntity<?> readNotification(@PathVariable Long id, @AuthenticationPrincipal User user) {
        try {
            Member member = memberService.findByUsername(user.getUsername());
            notificationService.markAsRead(id, member);
            return ResponseEntity.ok(Map.of("success", true));
        } catch (Exception e) {
            log.error("알림 읽음 처리 중 오류 발생: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    @PostMapping("/notifications/read-all")
    @ResponseBody
    public ResponseEntity<?> readAllNotifications(@AuthenticationPrincipal User user) {
        try {
            Member member = memberService.findByUsername(user.getUsername());
            notificationService.markAllAsRead(member);
            return ResponseEntity.ok(Map.of("success", true));
        } catch (Exception e) {
            log.error("전체 알림 읽음 처리 중 오류 발생: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    @PostMapping("/notifications/{id}/delete")
    @ResponseBody
    public ResponseEntity<?> deleteNotification(@PathVariable Long id, @AuthenticationPrincipal User user) {
        try {
            log.info("알림 삭제 요청 - ID: {}, User: {}", id, user.getUsername());
            Member member = memberService.findByUsername(user.getUsername());
            notificationService.deleteNotification(id, member);
            log.info("알림 삭제 완료 - ID: {}", id);
            return ResponseEntity.ok(Map.of("success", true));
        } catch (Exception e) {
            log.error("알림 삭제 중 오류 발생 - ID: {}, Error: {}", id, e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    @PostMapping("/notifications/delete-all")
    @ResponseBody
    public ResponseEntity<?> deleteAllNotifications(@AuthenticationPrincipal User user) {
        try {
            log.info("전체 알림 삭제 요청 - User: {}", user.getUsername());
            Member member = memberService.findByUsername(user.getUsername());
            notificationService.deleteAllNotifications(member);
            log.info("전체 알림 삭제 완료 - User: {}", user.getUsername());
            return ResponseEntity.ok(Map.of("success", true));
        } catch (Exception e) {
            log.error("전체 알림 삭제 중 오류 발생 - User: {}, Error: {}", user.getUsername(), e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    @GetMapping("/notifications/count")
    @ResponseBody
    public ResponseEntity<Map<String, Long>> getUnreadCount(@AuthenticationPrincipal User user) {
        try {
            Member member = memberService.findByUsername(user.getUsername());
            long count = notificationService.getUnreadCount(member);
            return ResponseEntity.ok(Map.of("count", count));
        } catch (Exception e) {
            log.error("알림 개수 조회 중 오류 발생: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("count", 0L));
        }
    }
} 