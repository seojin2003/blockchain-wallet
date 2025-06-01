package com.wallet.dto;

import com.wallet.entity.Transaction;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class TransactionDTO {
    private String type;
    private String amount;
    private String status;
    private String transactionHash;
    private String createdAt;

    public static TransactionDTO from(Transaction transaction) {
        return TransactionDTO.builder()
                .type(transaction.getType())
                .amount(transaction.getAmount() != null ? transaction.getAmount().toPlainString() : "0")
                .status(transaction.getStatus())
                .transactionHash(transaction.getTransactionHash())
                .createdAt(transaction.getCreatedAt() != null ? 
                    transaction.getCreatedAt().format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) : "")
                .build();
    }
} 