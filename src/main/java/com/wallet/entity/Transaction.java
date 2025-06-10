package com.wallet.entity;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import javax.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "transactions")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Transaction {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id")
    private Member member;
    
    @Column(name = "transaction_hash", length = 66)
    private String transactionHash;
    
    @Column(name = "from_address", length = 42)
    private String fromAddress;
    
    @Column(name = "to_address", length = 42)
    private String toAddress;
    
    @Column(precision = 40, scale = 18)
    private BigDecimal amount;
    
    @Column(length = 20)
    private String type;  // DEPOSIT, WITHDRAW
    
    @Column(length = 20)
    private String status;  // PENDING, COMPLETED, FAILED

    @Column(name = "balance_after", precision = 40, scale = 18)
    private BigDecimal balanceAfter;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "gas_price")
    private String gasPrice;

    @Column(name = "gas_used")
    private String gasUsed;

    @Column(name = "block_number")
    private String blockNumber;
    
    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }
} 