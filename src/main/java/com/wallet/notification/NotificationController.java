package com.wallet.notification;

import com.wallet.entity.Member;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/notifications")
public class NotificationController {
    private final NotificationService notificationService;

    @GetMapping
    public String notifications(@AuthenticationPrincipal Member member, Model model) {
        model.addAttribute("notifications", notificationService.getNotifications(member));
        return "notifications";
    }

    @PostMapping("/{id}/read")
    @ResponseBody
    public void markAsRead(@PathVariable Long id) {
        notificationService.markAsRead(id);
    }

    @PostMapping("/read-all")
    @ResponseBody
    public void markAllAsRead(@AuthenticationPrincipal Member member) {
        notificationService.markAllAsRead(member);
    }

    @GetMapping("/count")
    @ResponseBody
    public long getUnreadCount(@AuthenticationPrincipal Member member) {
        return notificationService.getUnreadCount(member);
    }
} 