package com.wallet.service;

import com.wallet.entity.Member;
import com.wallet.entity.NotificationType;
import com.wallet.entity.Transaction;
import com.wallet.repository.TransactionRepository;
import com.wallet.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class TransactionService {
    
    private final TransactionRepository transactionRepository;
    private final NotificationService notificationService;
    private final MemberRepository memberRepository;

    private String generateTransactionHash() {
        return "0x" + UUID.randomUUID().toString().replace("-", "");
    }

    @Transactional
    public void processDeposit(Member member, BigDecimal amount) {
        // 현재 잔액 조회
        BigDecimal currentBalance = member.getBalance();
        log.info("현재 잔액: {}", currentBalance);
        
        // 거래 후 잔액 계산
        BigDecimal balanceAfter = currentBalance.add(amount);
        log.info("거래 후 잔액: {}", balanceAfter);
        
        // 거래 정보 저장
        Transaction transaction = Transaction.builder()
            .member(member)
            .type("DEPOSIT")
            .amount(amount)
            .status("COMPLETED")
            .balanceAfter(balanceAfter)
            .fromAddress(member.getWalletAddress())
            .toAddress(member.getWalletAddress())
            .transactionHash(generateTransactionHash())
            .createdAt(LocalDateTime.now())
            .build();
        
        log.info("저장할 거래 정보: type={}, amount={}, balanceAfter={}", 
            transaction.getType(), transaction.getAmount(), transaction.getBalanceAfter());
        
        transaction = transactionRepository.save(transaction);
        log.info("저장된 거래 정보: id={}, balanceAfter={}", 
            transaction.getId(), transaction.getBalanceAfter());
        
        // 회원 잔액 업데이트
        member.setBalance(balanceAfter);
        memberRepository.save(member);
        
        notificationService.createTransactionNotification(member, amount.toString(), NotificationType.DEPOSIT);
    }

    @Transactional
    public void processWithdraw(Member member, BigDecimal amount) {
        // 현재 잔액 조회
        BigDecimal currentBalance = member.getBalance();
        log.info("현재 잔액: {}", currentBalance);
        
        // 거래 후 잔액 계산
        BigDecimal balanceAfter = currentBalance.subtract(amount);
        log.info("거래 후 잔액: {}", balanceAfter);
        
        // 잔액이 부족한 경우 예외 처리
        if (balanceAfter.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("잔액이 부족합니다.");
        }
        
        // 거래 정보 저장
        Transaction transaction = Transaction.builder()
            .member(member)
            .type("WITHDRAW")
            .amount(amount)
            .status("COMPLETED")
            .balanceAfter(balanceAfter)
            .fromAddress(member.getWalletAddress())
            .toAddress(member.getWalletAddress())
            .transactionHash(generateTransactionHash())
            .createdAt(LocalDateTime.now())
            .build();
        
        log.info("저장할 거래 정보: type={}, amount={}, balanceAfter={}", 
            transaction.getType(), transaction.getAmount(), transaction.getBalanceAfter());
        
        transaction = transactionRepository.save(transaction);
        log.info("저장된 거래 정보: id={}, balanceAfter={}", 
            transaction.getId(), transaction.getBalanceAfter());
        
        // 회원 잔액 업데이트
        member.setBalance(balanceAfter);
        memberRepository.save(member);
        
        notificationService.createTransactionNotification(member, amount.toString(), NotificationType.WITHDRAW);
    }
} 