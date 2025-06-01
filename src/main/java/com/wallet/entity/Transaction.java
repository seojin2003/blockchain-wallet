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
    
    @Column(nullable = false)
    private String type;  // "DEPOSIT" 또는 "WITHDRAW"
    
    @Column(nullable = false)
    private BigDecimal amount;
    
    @Column(name = "from_address", nullable = false)
    private String fromAddress;
    
    @Column(name = "to_address", nullable = false)
    private String toAddress;
    
    @Column(nullable = false)
    private String status;  // "PENDING" 또는 "COMPLETED"
    
    @Column(name = "transaction_hash", nullable = false)
    private String transactionHash;
    
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
} 