package com.wallet.service;

import com.wallet.entity.Member;
import com.wallet.entity.Notification;
import com.wallet.entity.NotificationType;
import com.wallet.repository.NotificationRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import javax.persistence.EntityManager;
import java.time.LocalDateTime;
import java.util.List;

@Slf4j
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
        log.debug("알림 생성 완료 - Member: {}, Type: {}, Amount: {}", member.getUsername(), type, amount);
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
        log.debug("알림 읽음 처리 시작 - ID: {}, Member: {}", notificationId, member.getUsername());
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
        log.debug("알림 읽음 처리 완료 - ID: {}", notificationId);
    }

    @Transactional
    public void deleteNotification(Long notificationId, Member member) {
        log.debug("알림 삭제 시작 - ID: {}, Member: {}", notificationId, member.getUsername());
        Notification notification = notificationRepository.findById(notificationId)
            .orElseThrow(() -> new IllegalArgumentException("알림을 찾을 수 없습니다."));
        
        // 본인의 알림인지 확인
        if (!notification.getMember().getId().equals(member.getId())) {
            throw new IllegalArgumentException("본인의 알림만 삭제할 수 있습니다.");
        }
        
        try {
            notificationRepository.delete(notification);
            notificationRepository.flush(); // 즉시 삭제 실행
            log.debug("알림 삭제 완료 - ID: {}", notificationId);
        } catch (Exception e) {
            log.error("알림 삭제 중 오류 발생 - ID: {}, Error: {}", notificationId, e.getMessage(), e);
            throw new RuntimeException("알림 삭제 중 오류가 발생했습니다.", e);
        }
    }

    @Transactional
    public void markAllAsRead(Member member) {
        log.debug("전체 알림 읽음 처리 시작 - Member: {}", member.getUsername());
        List<Notification> notifications = notificationRepository.findByMemberAndIsReadFalse(member);
        for (Notification notification : notifications) {
            notification.setRead(true);
            notificationRepository.save(notification);
        }
        notificationRepository.flush();
        log.debug("전체 알림 읽음 처리 완료 - Member: {}, Count: {}", member.getUsername(), notifications.size());
    }

    @Transactional
    public void deleteAllNotifications(Member member) {
        log.debug("전체 알림 삭제 시작 - Member: {}", member.getUsername());
        try {
            List<Notification> notifications = notificationRepository.findByMemberOrderByCreatedAtDesc(member);
            notificationRepository.deleteAll(notifications);
            notificationRepository.flush(); // 즉시 삭제 실행
            log.debug("전체 알림 삭제 완료 - Member: {}, Count: {}", member.getUsername(), notifications.size());
        } catch (Exception e) {
            log.error("전체 알림 삭제 중 오류 발생 - Member: {}, Error: {}", member.getUsername(), e.getMessage(), e);
            throw new RuntimeException("전체 알림 삭제 중 오류가 발생했습니다.", e);
        }
    }
} 