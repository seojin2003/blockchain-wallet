package com.wallet.controller;

import com.wallet.entity.Member;
import com.wallet.entity.Notification;
import com.wallet.service.MemberService;
import com.wallet.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

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
        Member member = memberService.findByUsername(user.getUsername());
        notificationService.markAsRead(id, member);
        return ResponseEntity.ok(Map.of("success", true));
    }

    @PostMapping("/notifications/read-all")
    @ResponseBody
    public ResponseEntity<?> readAllNotifications(@AuthenticationPrincipal User user) {
        Member member = memberService.findByUsername(user.getUsername());
        notificationService.markAllAsRead(member);
        return ResponseEntity.ok(Map.of("success", true));
    }

    @PostMapping("/notifications/{id}/delete")
    @ResponseBody
    public ResponseEntity<?> deleteNotification(@PathVariable Long id, @AuthenticationPrincipal User user) {
        try {
            Member member = memberService.findByUsername(user.getUsername());
            notificationService.deleteNotification(id, member);
            return ResponseEntity.ok(Map.of("success", true));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    @PostMapping("/notifications/delete-all")
    @ResponseBody
    public ResponseEntity<?> deleteAllNotifications(@AuthenticationPrincipal User user) {
        try {
            Member member = memberService.findByUsername(user.getUsername());
            notificationService.deleteAllNotifications(member);
            return ResponseEntity.ok(Map.of("success", true));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    @GetMapping("/notifications/count")
    @ResponseBody
    public ResponseEntity<Map<String, Long>> getUnreadCount(@AuthenticationPrincipal User user) {
        Member member = memberService.findByUsername(user.getUsername());
        long count = notificationService.getUnreadCount(member);
        return ResponseEntity.ok(Map.of("count", count));
    }
} 