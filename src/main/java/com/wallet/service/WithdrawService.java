package com.wallet.service;

import com.wallet.entity.Member;
import com.wallet.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

@Service
@RequiredArgsConstructor
public class WithdrawService {

    private final MemberRepository memberRepository;

    @Transactional
    public void processWithdraw(String username, String address, BigDecimal amount) {
        Member member = memberRepository.findByUsername(username);
        if (member == null) {
            throw new RuntimeException("사용자를 찾을 수 없습니다.");
        }

        // 잔액 검증
        if (member.getBalance().compareTo(amount) < 0) {
            throw new RuntimeException("잔액이 부족합니다.");
        }

        // 주소 형식 검증
        if (!isValidEthereumAddress(address)) {
            throw new RuntimeException("올바르지 않은 이더리움 주소입니다.");
        }

        // 최소 출금 금액 검증
        if (amount.compareTo(new BigDecimal("0.01")) < 0) {
            throw new RuntimeException("최소 출금 금액은 0.01 ETH입니다.");
        }

        // 출금 처리
        member.setBalance(member.getBalance().subtract(amount));
        memberRepository.save(member);
    }

    private boolean isValidEthereumAddress(String address) {
        // 이더리움 주소 형식 검증 (0x로 시작하는 40자리 16진수)
        return address != null && 
               address.matches("^0x[0-9a-fA-F]{40}$");
    }
} 