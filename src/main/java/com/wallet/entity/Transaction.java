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
@Table(
    name = "transactions",
    indexes = {
        @Index(name = "idx_transaction_hash", columnList = "transaction_hash", unique = true),
        @Index(name = "idx_member_created", columnList = "member_id,created_at")
    }
)
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
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;
    
    @Column(nullable = false, length = 20)
    private String type;  // "DEPOSIT" 또는 "WITHDRAW"
    
    @Column(nullable = false, precision = 20, scale = 8)
    private BigDecimal amount;
    
    @Column(name = "from_address", nullable = false, length = 42)
    private String fromAddress;
    
    @Column(name = "to_address", nullable = false, length = 42)
    private String toAddress;
    
    @Column(nullable = false, length = 20)
    private String status;  // "PENDING" 또는 "COMPLETED"
    
    @Column(name = "transaction_hash", nullable = false, unique = true, length = 66)
    private String transactionHash;
    
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }
} 