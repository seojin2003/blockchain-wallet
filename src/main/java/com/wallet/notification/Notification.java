package com.wallet.notification;

import com.wallet.entity.Member;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Getter @Setter
@NoArgsConstructor
public class Notification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id")
    private Member member;

    private String title;           // 알림 제목
    private String message;         // 알림 내용
    private String type;            // 알림 타입 (DEPOSIT, WITHDRAW)
    private Double amount;          // 거래 금액
    private boolean isRead;         // 읽음 여부
    private LocalDateTime createdAt; // 생성 시간

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    public static Notification createDepositNotification(Member member, Double amount) {
        Notification notification = new Notification();
        notification.setMember(member);
        notification.setTitle("입금 완료");
        notification.setMessage(amount + " ETH가 입금되었습니다.");
        notification.setType("DEPOSIT");
        notification.setAmount(amount);
        notification.setRead(false);
        return notification;
    }

    public static Notification createWithdrawNotification(Member member, Double amount) {
        Notification notification = new Notification();
        notification.setMember(member);
        notification.setTitle("출금 완료");
        notification.setMessage(amount + " ETH가 출금되었습니다.");
        notification.setType("WITHDRAW");
        notification.setAmount(amount);
        notification.setRead(false);
        return notification;
    }
} 