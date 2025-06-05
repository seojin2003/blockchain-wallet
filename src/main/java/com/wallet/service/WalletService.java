package com.wallet.service;

import com.wallet.entity.Member;
import com.wallet.entity.Transaction;
import com.wallet.entity.TransactionType;
import com.wallet.entity.TransactionStatus;
import com.wallet.entity.NotificationType;
import com.wallet.repository.MemberRepository;
import com.wallet.repository.TransactionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.web3j.crypto.ECKeyPair;
import org.web3j.crypto.Keys;
import org.web3j.utils.Numeric;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.security.SecureRandom;

@Service
@RequiredArgsConstructor
public class WalletService {

    private final MemberRepository memberRepository;
    private final TransactionRepository transactionRepository;
    private final NotificationService notificationService;
    private final SecureRandom secureRandom = new SecureRandom();

    @Transactional
    public void createWallet(Member member) throws Exception {
        ECKeyPair ecKeyPair = Keys.createEcKeyPair();
        String privateKey = ecKeyPair.getPrivateKey().toString(16);
        String address = "0x" + Keys.getAddress(ecKeyPair);

        member.setWalletAddress(address);
        member.setPrivateKey(privateKey);
    }

    @Transactional(readOnly = true)
    public BigDecimal getBalance(String address) {
        // 해당 주소를 가진 회원 찾기
        Member member = memberRepository.findByWalletAddress(address)
            .orElse(null);
            
        if (member == null) {
            return BigDecimal.ZERO;
        }

        // 회원의 거래 내역을 기반으로 잔액 계산
        List<Transaction> transactions = transactionRepository.findByMemberOrderByCreatedAtDesc(member);
        BigDecimal balance = BigDecimal.ZERO;

        for (Transaction tx : transactions) {
            if (tx.getStatus().equals("COMPLETED")) {
                if (tx.getType().equals("DEPOSIT")) {
                    balance = balance.add(tx.getAmount());
                } else if (tx.getType().equals("WITHDRAW")) {
                    balance = balance.subtract(tx.getAmount());
                }
            }
        }

        return balance;
    }

    @Transactional
    public Transaction deposit(Member member, String fromAddress, BigDecimal amount) {
        Transaction transaction = Transaction.builder()
                .member(member)
                .type("DEPOSIT")
                .amount(amount)
                .fromAddress(fromAddress)
                .toAddress(member.getWalletAddress())
                .status("COMPLETED")
                .transactionHash(generateDummyTransactionHash())
                .createdAt(LocalDateTime.now())
                .build();

        transaction = transactionRepository.save(transaction);
        notificationService.createTransactionNotification(member, amount.toString(), NotificationType.DEPOSIT);
        return transaction;
    }

    @Transactional
    public Transaction withdraw(Member member, String toAddress, BigDecimal amount) {
        BigDecimal balance = getBalance(member.getWalletAddress());
        if (balance.compareTo(amount) < 0) {
            throw new RuntimeException("잔액이 부족합니다.");
        }

        Transaction withdrawTransaction = Transaction.builder()
                .member(member)
                .type("WITHDRAW")
                .amount(amount)
                .fromAddress(member.getWalletAddress())
                .toAddress(toAddress)
                .status("COMPLETED")
                .transactionHash(generateDummyTransactionHash())
                .createdAt(LocalDateTime.now())
                .build();

        withdrawTransaction = transactionRepository.save(withdrawTransaction);
        notificationService.createTransactionNotification(member, amount.toString(), NotificationType.WITHDRAW);

        // 수신자가 우리 시스템의 사용자인 경우 입금 처리
        Member receiver = memberRepository.findByWalletAddress(toAddress)
            .orElse(null);

        if (receiver != null) {
            Transaction depositTransaction = Transaction.builder()
                    .member(receiver)
                    .type("DEPOSIT")
                    .amount(amount)
                    .fromAddress(member.getWalletAddress())
                    .toAddress(toAddress)
                    .status("COMPLETED")
                    .transactionHash(generateDummyTransactionHash())  // 새로운 해시 생성
                    .createdAt(LocalDateTime.now())
                    .build();
            
            transactionRepository.save(depositTransaction);
            notificationService.createTransactionNotification(receiver, amount.toString(), NotificationType.DEPOSIT);
        }

        return withdrawTransaction;
    }

    @Transactional(readOnly = true)
    public List<Transaction> getTransactionHistory(Member member) {
        return transactionRepository.findByMemberOrderByCreatedAtDesc(member);
    }
    
    private String generateDummyTransactionHash() {
        byte[] randomBytes = new byte[32];
        secureRandom.nextBytes(randomBytes);
        return "0x" + Numeric.toHexString(randomBytes).substring(2);  // "0x" 제외한 64자리 문자열
    }
} 