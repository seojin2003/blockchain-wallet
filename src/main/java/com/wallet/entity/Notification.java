package com.wallet.entity;

import lombok.*;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "notifications")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Notification {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id")
    private Member member;
    
    @Column(nullable = false)
    private String title;
    
    @Column(nullable = false)
    private String message;
    
    @Column(nullable = false)
    private String type;
    
    @Column(name = "is_read", nullable = false)
    private boolean isRead;
    
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    public void setRead(boolean read) {
        this.isRead = read;
    }

    public boolean isRead() {
        return this.isRead;
    }

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    public static Notification createTransactionNotification(Member member, String title, String message, NotificationType type) {
        Notification notification = new Notification();
        notification.setMember(member);
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setType(type.toString());
        notification.setRead(false);
        return notification;
    }
} 