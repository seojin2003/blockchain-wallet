package com.wallet.service;

import com.wallet.entity.Member;
import com.wallet.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public Member register(String username, String password, String name) {
        if (memberRepository.existsByUsername(username)) {
            throw new RuntimeException("이미 사용 중인 아이디입니다.");
        }

        // 첫 번째 가입자를 관리자로 설정
        boolean isFirstMember = memberRepository.count() == 0;

        Member member = Member.builder()
                .username(username)
                .password(passwordEncoder.encode(password))
                .name(name)
                .isAdmin(isFirstMember)
                .balance(BigDecimal.ZERO)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        return memberRepository.save(member);
    }

    @Transactional(readOnly = true)
    public Member findByUsername(String username) {
        return memberRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다: " + username));
    }

    @Transactional(readOnly = true)
    public Optional<Member> findByWalletAddress(String walletAddress) {
        return memberRepository.findByWalletAddress(walletAddress);
    }

    @Transactional(readOnly = true)
    public boolean checkUsername(String username) {
        return memberRepository.existsByUsername(username);
    }

    @Transactional(readOnly = true)
    public Member findById(Long id) {
        return memberRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다. ID: " + id));
    }

    @Transactional
    public Member login(String username, String password) {
        Member member = memberRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("존재하지 않는 사용자입니다."));

        if (!passwordEncoder.matches(password, member.getPassword())) {
            throw new RuntimeException("비밀번호가 일치하지 않습니다.");
        }

        return member;
    }

    @Transactional
    public Member save(Member member) {
        return memberRepository.save(member);
    }

    // 현재 로그인한 회원 정보 반환
    @Transactional(readOnly = true)
    public Member getCurrentMember() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof User) {
            String username = ((User) principal).getUsername();
            return findByUsername(username);
        } else if (principal instanceof String) {
            // 인증되지 않은 경우
            throw new RuntimeException("로그인이 필요합니다.");
        }
        throw new RuntimeException("사용자 정보를 찾을 수 없습니다.");
    }

    // 이름 변경
    @Transactional
    public void changeName(String name) {
        Member member = getCurrentMember();
        member.setName(name);
        save(member);
    }

    // 비밀번호 변경 (현재 비밀번호 검증)
    @Transactional
    public boolean changePassword(String currentPassword, String newPassword) {
        Member member = getCurrentMember();
        if (!passwordEncoder.matches(currentPassword, member.getPassword())) {
            return false;
        }
        member.setPassword(passwordEncoder.encode(newPassword));
        save(member);
        return true;
    }

    @Transactional(readOnly = true)
    public Optional<Member> findByResetPasswordToken(String token) {
        return memberRepository.findByResetPasswordToken(token);
    }

    public String encodePassword(String rawPassword) {
        return passwordEncoder.encode(rawPassword);
    }
} 