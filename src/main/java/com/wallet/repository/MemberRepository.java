package com.wallet.repository;

import com.wallet.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface MemberRepository extends JpaRepository<Member, Long> {
    Optional<Member> findByUsername(String username);
    Optional<Member> findByWalletAddress(String walletAddress);
    boolean existsByUsername(String username);
    Optional<Member> findByResetPasswordToken(String resetPasswordToken);
} 