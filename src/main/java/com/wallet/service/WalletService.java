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
import lombok.extern.slf4j.Slf4j;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.security.SecureRandom;
import java.util.UUID;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class WalletService {

    private final MemberRepository memberRepository;
    private final TransactionRepository transactionRepository;
    private final MemberService memberService;
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

    @Transactional
    public Transaction processInitialDeposit(Member member, String fromAddress, BigDecimal amount) {
        try {
            log.info("초기 코인 발행 시작 - 회원: {}, 금액: {}", member.getUsername(), amount);

            // 잔액 초기화 체크
            if (member.getBalance() == null) {
                log.debug("잔액이 null이어서 0으로 초기화합니다.");
                member.setBalance(BigDecimal.ZERO);
            }

            // 새로운 잔액 계산
            BigDecimal newBalance = member.getBalance().add(amount);
            log.debug("새로운 잔액 계산: {} + {} = {}", member.getBalance(), amount, newBalance);

            // 트랜잭션 생성
            log.debug("트랜잭션 객체 생성 시작");
            Transaction transaction = Transaction.builder()
                .member(member)
                .fromAddress(fromAddress)
                .toAddress(member.getWalletAddress())
                .amount(amount)
                .type("DEPOSIT")
                .status("COMPLETED")
                .transactionHash(generateTransactionHash())
                .createdAt(LocalDateTime.now())
                .balanceAfter(newBalance)  // 새로 계산된 잔액 사용
                .build();
            log.debug("트랜잭션 객체 생성 완료: {}", transaction);

            // 트랜잭션 저장
            log.debug("트랜잭션 저장 시작");
            transaction = transactionRepository.save(transaction);
            log.debug("트랜잭션 저장 완료: {}", transaction);

            // 멤버 잔액 업데이트
            member.setBalance(newBalance);
            memberService.save(member);
            
            // 코인 발행 완료 표시
            member.setHasInitializedCoin(true);
            
            // 알림 생성
            notificationService.createTransactionNotification(member, amount.toPlainString(), NotificationType.DEPOSIT);
            
            log.info("초기 코인 발행 완료 - 트랜잭션 해시: {}", transaction.getTransactionHash());
            
            return transaction;
        } catch (Exception e) {
            log.error("초기 코인 발행 중 오류 발생", e);
            throw new RuntimeException("초기 코인 발행 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

    @Transactional
    public Transaction deposit(Member member, String fromAddress, BigDecimal amount) {
        try {
            log.info("코인 발행 시작 - 회원: {}, 금액: {}", member.getUsername(), amount);

            if (member.getBalance() == null) {
                member.setBalance(BigDecimal.ZERO);
            }

            // 새로운 잔액 계산
            BigDecimal newBalance = member.getBalance().add(amount);
            log.info("새로운 잔액 계산: {} + {} = {}", member.getBalance(), amount, newBalance);

            // 트랜잭션 생성
            Transaction transaction = Transaction.builder()
                .member(member)
                .fromAddress(fromAddress)
                .toAddress(member.getWalletAddress())
                .amount(amount)
                .type("DEPOSIT")
                .status("COMPLETED")
                .transactionHash(generateTransactionHash())
                .createdAt(LocalDateTime.now())
                .balanceAfter(newBalance)  // 새로 계산된 잔액 사용
                .build();

            // 멤버 잔액 업데이트
            member.setBalance(newBalance);
            memberService.save(member);

            // 트랜잭션 저장
            transaction = transactionRepository.save(transaction);
            
            log.info("코인 발행 완료 - 트랜잭션 해시: {}", transaction.getTransactionHash());
            
            return transaction;
        } catch (Exception e) {
            log.error("코인 발행 중 오류 발생", e);
            throw new RuntimeException("코인 발행 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

    @Transactional
    public Transaction withdraw(Member member, String toAddress, BigDecimal amount) {
        BigDecimal balance = getBalance(member.getWalletAddress());
        if (balance.compareTo(amount) < 0) {
            throw new RuntimeException("잔액이 부족합니다.");
        }

        // 출금자의 새로운 잔액 계산
        BigDecimal newBalance = member.getBalance().subtract(amount);

        // 출금 트랜잭션 생성
        Transaction withdrawTransaction = Transaction.builder()
                .member(member)
                .type("WITHDRAW")
                .amount(amount)
                .fromAddress(member.getWalletAddress())
                .toAddress(toAddress)
                .status("COMPLETED")
                .transactionHash(generateDummyTransactionHash())
                .createdAt(LocalDateTime.now())
                .balanceAfter(newBalance)  // 새로 계산된 잔액 사용
                .build();

        // 출금자의 잔액 업데이트
        member.setBalance(newBalance);
        memberService.save(member);

        withdrawTransaction = transactionRepository.save(withdrawTransaction);

        // 출금 알림 생성
        notificationService.createTransactionNotification(member, amount.toPlainString(), NotificationType.WITHDRAW);

        // 수신자가 우리 시스템의 사용자인 경우 입금 처리
        Member receiver = memberRepository.findByWalletAddress(toAddress)
            .orElse(null);

        if (receiver != null) {
            // 수신자의 새로운 잔액 계산
            BigDecimal receiverNewBalance = receiver.getBalance().add(amount);
            
            // 수신자의 잔액 업데이트
            receiver.setBalance(receiverNewBalance);
            memberService.save(receiver);

            Transaction depositTransaction = Transaction.builder()
                    .member(receiver)
                    .type("DEPOSIT")
                    .amount(amount)
                    .fromAddress(member.getWalletAddress())
                    .toAddress(toAddress)
                    .status("COMPLETED")
                    .transactionHash(generateDummyTransactionHash())
                    .createdAt(LocalDateTime.now())
                    .balanceAfter(receiverNewBalance)  // 수신자의 새로운 잔액 사용
                    .build();
            
            depositTransaction = transactionRepository.save(depositTransaction);

            // 입금 알림 생성
            notificationService.createTransactionNotification(receiver, amount.toPlainString(), NotificationType.DEPOSIT);
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

    private String generateTransactionHash() {
        return "0x" + UUID.randomUUID().toString().replace("-", "");
    }

    @Transactional(readOnly = true)
    public BigDecimal getBalance(String walletAddress) {
        return memberService.findByWalletAddress(walletAddress)
            .map(Member::getBalance)
            .orElse(BigDecimal.ZERO);
    }
} 