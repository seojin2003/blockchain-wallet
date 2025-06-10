package com.wallet.dto;

import com.wallet.entity.Transaction;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import java.math.BigDecimal;
import java.math.RoundingMode;

@Getter
@Setter
@Builder
public class TransactionDTO {
    private String type;
    private String amount;
    private String status;
    private String transactionHash;
    private String createdAt;
    private String fromAddress;
    private String toAddress;
    private String gasPrice;
    private String gasUsed;
    private String blockNumber;
    private String balanceAfter;

    public static TransactionDTO from(Transaction transaction) {
        // 소수점 자릿수 설정 (8자리로 통일)
        final int DECIMAL_PLACES = 8;
        
        // 금액 포맷팅
        String formattedAmount = transaction.getAmount() != null ? 
            transaction.getAmount().setScale(DECIMAL_PLACES, RoundingMode.DOWN).toPlainString() : "0";
        
        // 거래 후 잔액 포맷팅
        String formattedBalanceAfter = transaction.getBalanceAfter() != null ? 
            transaction.getBalanceAfter().setScale(DECIMAL_PLACES, RoundingMode.DOWN).toPlainString() : "0";

        return TransactionDTO.builder()
                .type(transaction.getType())
                .amount(formattedAmount)
                .status(transaction.getStatus())
                .transactionHash(transaction.getTransactionHash())
                .fromAddress(transaction.getFromAddress())
                .toAddress(transaction.getToAddress())
                .gasPrice(transaction.getGasPrice())
                .gasUsed(transaction.getGasUsed())
                .blockNumber(transaction.getBlockNumber())
                .balanceAfter(formattedBalanceAfter)
                .createdAt(transaction.getCreatedAt() != null ? 
                    transaction.getCreatedAt().format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) : "")
                .build();
    }
} 