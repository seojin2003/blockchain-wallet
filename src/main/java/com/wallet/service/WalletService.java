package com.wallet.service;

import com.wallet.entity.Member;
import com.wallet.entity.Transaction;
import com.wallet.entity.TransactionType;
import com.wallet.entity.TransactionStatus;
import com.wallet.repository.MemberRepository;
import com.wallet.repository.TransactionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.web3j.crypto.ECKeyPair;
import org.web3j.crypto.Keys;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class WalletService {

    private final MemberRepository memberRepository;
    private final TransactionRepository transactionRepository;
    private final Random random = new Random();

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
        Member member = memberRepository.findByWalletAddress(address);
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

        return transactionRepository.save(transaction);
    }

    @Transactional
    public Transaction withdraw(Member member, String toAddress, BigDecimal amount) throws Exception {
        BigDecimal balance = getBalance(member.getWalletAddress());
        if (balance.compareTo(amount) < 0) {
            throw new Exception("잔액이 부족합니다.");
        }

        String transactionHash = generateDummyTransactionHash();

        // 출금 거래 생성 (보내는 사람)
        Transaction withdrawTransaction = Transaction.builder()
                .member(member)
                .type("WITHDRAW")
                .amount(amount)
                .fromAddress(member.getWalletAddress())
                .toAddress(toAddress)
                .status("COMPLETED")
                .transactionHash(transactionHash)
                .createdAt(LocalDateTime.now())
                .build();

        // 출금 거래 저장
        withdrawTransaction = transactionRepository.save(withdrawTransaction);

        // 받는 사람의 Member 찾기
        Member receiver = memberRepository.findByWalletAddress(toAddress);
        
        // 받는 사람이 우리 서비스의 회원인 경우 입금 거래도 생성
        if (receiver != null) {
            Transaction depositTransaction = Transaction.builder()
                    .member(receiver)
                    .type("DEPOSIT")
                    .amount(amount)
                    .fromAddress(member.getWalletAddress())
                    .toAddress(toAddress)
                    .status("COMPLETED")
                    .transactionHash(transactionHash)  // 같은 거래 해시 사용
                    .createdAt(LocalDateTime.now())
                    .build();
            
            transactionRepository.save(depositTransaction);
        }

        return withdrawTransaction;
    }

    @Transactional(readOnly = true)
    public List<Transaction> getTransactionHistory(Member member) {
        return transactionRepository.findByMemberOrderByCreatedAtDesc(member);
    }
    
    private String generateDummyTransactionHash() {
        return "0x" + UUID.randomUUID().toString().replace("-", "");
    }
} 