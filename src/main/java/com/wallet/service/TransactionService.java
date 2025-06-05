package com.wallet.service;

import com.wallet.entity.Member;
import com.wallet.entity.NotificationType;
import com.wallet.entity.Transaction;
import com.wallet.repository.TransactionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;

@Service
@RequiredArgsConstructor
public class TransactionService {
    
    private final TransactionRepository transactionRepository;
    private final NotificationService notificationService;

    @Transactional
    public void processDeposit(Member member, BigDecimal amount) {
        Transaction transaction = new Transaction();
        transaction.setMember(member);
        transaction.setType("DEPOSIT");
        transaction.setAmount(amount);
        transaction.setStatus("COMPLETED");
        
        transactionRepository.save(transaction);
        notificationService.createTransactionNotification(member, amount.toString(), NotificationType.DEPOSIT);
    }

    @Transactional
    public void processWithdraw(Member member, BigDecimal amount) {
        Transaction transaction = new Transaction();
        transaction.setMember(member);
        transaction.setType("WITHDRAW");
        transaction.setAmount(amount);
        transaction.setStatus("COMPLETED");
        
        transactionRepository.save(transaction);
        notificationService.createTransactionNotification(member, amount.toString(), NotificationType.WITHDRAW);
    }
} 