package com.wallet.repository;

import com.wallet.entity.Member;
import com.wallet.entity.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findByMemberOrderByCreatedAtDesc(Member member);
    List<Notification> findByMemberAndIsReadFalse(Member member);
    long countByMemberAndIsReadFalse(Member member);
    void deleteByMember(Member member);
} 