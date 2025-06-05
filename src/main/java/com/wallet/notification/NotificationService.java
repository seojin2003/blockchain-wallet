package com.wallet.notification;

import com.wallet.entity.Member;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class NotificationService {
    private final NotificationRepository notificationRepository;

    public void createDepositNotification(Member member, Double amount) {
        Notification notification = Notification.createDepositNotification(member, amount);
        notificationRepository.save(notification);
    }

    public void createWithdrawNotification(Member member, Double amount) {
        Notification notification = Notification.createWithdrawNotification(member, amount);
        notificationRepository.save(notification);
    }

    @Transactional(readOnly = true)
    public List<Notification> getNotifications(Member member) {
        return notificationRepository.findByMemberOrderByCreatedAtDesc(member);
    }

    @Transactional(readOnly = true)
    public long getUnreadCount(Member member) {
        return notificationRepository.countByMemberAndIsReadFalse(member);
    }

    public void markAsRead(Long notificationId) {
        notificationRepository.findById(notificationId)
                .ifPresent(notification -> notification.setRead(true));
    }

    public void markAllAsRead(Member member) {
        List<Notification> notifications = notificationRepository.findByMemberOrderByCreatedAtDesc(member);
        notifications.forEach(notification -> notification.setRead(true));
        notificationRepository.saveAll(notifications);
    }
} 