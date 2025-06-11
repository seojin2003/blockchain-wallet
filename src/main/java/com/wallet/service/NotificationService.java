package com.wallet.service;

import com.wallet.entity.Member;
import com.wallet.entity.Notification;
import com.wallet.entity.NotificationType;
import com.wallet.repository.NotificationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import javax.persistence.EntityManager;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class NotificationService {
    
    private final NotificationRepository notificationRepository;
    private final EntityManager entityManager;

    @Transactional
    public void createTransactionNotification(Member member, String amount, NotificationType type) {
        String title = type == NotificationType.DEPOSIT ? "입금 알림" : "출금 알림";
        String message = type == NotificationType.DEPOSIT ? 
            amount + " ETH가 입금되었습니다." : 
            amount + " ETH가 출금되었습니다.";

        Notification notification = Notification.builder()
                .member(member)
                .title(title)
                .message(message)
                .type(type.name())
                .isRead(false)
                .createdAt(LocalDateTime.now())
                .build();

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

    @Transactional
    public void markAsRead(Long notificationId, Member member) {
        Notification notification = notificationRepository.findById(notificationId)
            .orElseThrow(() -> new IllegalArgumentException("알림을 찾을 수 없습니다."));
        
        // 본인의 알림인지 확인
        if (!notification.getMember().getId().equals(member.getId())) {
            throw new IllegalArgumentException("본인의 알림만 읽음 처리할 수 있습니다.");
        }
        
        notification.setRead(true);
        notificationRepository.saveAndFlush(notification);
        entityManager.flush();
        entityManager.clear();
    }

    @Transactional
    public void deleteNotification(Long notificationId, Member member) {
        Notification notification = notificationRepository.findById(notificationId)
            .orElseThrow(() -> new IllegalArgumentException("알림을 찾을 수 없습니다."));
        
        // 본인의 알림인지 확인
        if (!notification.getMember().getId().equals(member.getId())) {
            throw new IllegalArgumentException("본인의 알림만 삭제할 수 있습니다.");
        }
        
        notificationRepository.delete(notification);
    }

    @Transactional
    public void markAllAsRead(Member member) {
        List<Notification> notifications = notificationRepository.findByMemberAndIsReadFalse(member);
        for (Notification notification : notifications) {
            notification.setRead(true);
            notificationRepository.save(notification);
        }
    }

    @Transactional
    public void deleteAllNotifications(Member member) {
        List<Notification> notifications = notificationRepository.findByMemberOrderByCreatedAtDesc(member);
        notificationRepository.deleteAll(notifications);
    }
} 