package com.wallet.repository;

import com.wallet.entity.Member;
import com.wallet.entity.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Long> {
    List<Transaction> findByMemberOrderByCreatedAtDesc(Member member);
    Optional<Transaction> findByTransactionHash(String transactionHash);
    List<Transaction> findByToAddressOrFromAddress(String toAddress, String fromAddress);
} 