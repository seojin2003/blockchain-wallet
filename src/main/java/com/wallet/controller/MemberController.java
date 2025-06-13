package com.wallet.controller;

import com.wallet.entity.Member;
import com.wallet.service.MemberService;
import com.wallet.service.MailService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Controller
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;
    private final MailService mailService;

    @GetMapping("/signup")
    public String signupForm() {
        return "redirect:/register";
    }

    @GetMapping("/register")
    public String registerForm() {
        return "register";
    }

    @GetMapping("/login")
    public String loginForm() {
        return "login";
    }

    @GetMapping("/api/login")
    public String redirectToLogin() {
        return "redirect:/login";
    }

    @PostMapping("/api/register")
    @ResponseBody
    public ResponseEntity<?> register(@RequestParam String username,
                                    @RequestParam String password,
                                    @RequestParam String name) {
        try {
            Member member = memberService.register(username, password, name);
            Map<String, String> response = new HashMap<>();
            response.put("message", "회원가입이 완료되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/api/login")
    @ResponseBody
    public ResponseEntity<?> login(@RequestParam String username,
                                 @RequestParam String password,
                                 HttpSession session) {
        try {
            Member member = memberService.login(username, password);
            session.setAttribute("memberId", member.getId());
            session.setAttribute("username", member.getUsername());
            
            Map<String, String> response = new HashMap<>();
            response.put("message", "로그인에 성공했습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/api/logout")
    @ResponseBody
    public ResponseEntity<?> logout(HttpSession session) {
        session.invalidate();
        Map<String, String> response = new HashMap<>();
        response.put("message", "로그아웃되었습니다.");
        return ResponseEntity.ok(response);
    }

    @GetMapping("/api/check-username")
    @ResponseBody
    public ResponseEntity<?> checkUsername(@RequestParam String username) {
        boolean exists = memberService.checkUsername(username);
        Map<String, Boolean> response = new HashMap<>();
        response.put("exists", exists);
        return ResponseEntity.ok(response);
    }

    // 마이페이지 진입
    @GetMapping("/mypage")
    public String mypage(HttpSession session, Map<String, Object> model) {
        Member member = memberService.getCurrentMember(); // 현재 로그인 회원 정보 가져오기
        model.put("member", member);
        return "mypage";
    }

    // 이름 변경
    @PostMapping("/api/mypage/name")
    @ResponseBody
    public ResponseEntity<?> changeName(@RequestParam String name) {
        try {
            memberService.changeName(name);
            Map<String, String> response = new HashMap<>();
            response.put("message", "이름이 변경되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 비밀번호 변경
    @PostMapping("/api/mypage/password")
    @ResponseBody
    public ResponseEntity<?> changePassword(@RequestParam String currentPassword,
                                            @RequestParam String newPassword) {
        try {
            boolean result = memberService.changePassword(currentPassword, newPassword);
            if (!result) {
                Map<String, String> response = new HashMap<>();
                response.put("error", "비밀번호가 올바르지 않습니다.");
                return ResponseEntity.badRequest().body(response);
            }
            Map<String, String> response = new HashMap<>();
            response.put("message", "비밀번호가 변경되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 비밀번호 재설정 요청 페이지
    @GetMapping("/reset-password-request")
    public String resetPasswordRequestPage() {
        return "reset_password_request";
    }

    // 비밀번호 재설정 링크 요청 API
    @PostMapping("/api/reset-password-request")
    @ResponseBody
    public ResponseEntity<?> resetPasswordRequest(@RequestParam String email) {
        try {
            Member member = memberService.findByUsername(email);
            // 토큰 생성 및 만료시간(30분) 설정
            String token = UUID.randomUUID().toString();
            LocalDateTime expiry = LocalDateTime.now().plusMinutes(30);
            member.setResetPasswordToken(token);
            member.setResetPasswordTokenExpiry(expiry);
            memberService.save(member);

            // 이메일 발송 (HTML)
            String resetLink = "http://localhost:8080/reset-password?token=" + token;
            String subject = "[블록체인 월렛] 비밀번호 재설정 링크";
            String html = "아래 링크를 클릭하여 비밀번호를 재설정하세요.<br><br>" +
                "<a href='" + resetLink + "'>비밀번호 재설정하기</a><br><br>" +
                "이 링크는 30분간만 유효합니다.";
            mailService.sendHtmlMail(member.getUsername(), subject, html);

            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // 메일 발송 테스트용 임시 API
    @GetMapping("/api/test-mail")
    @ResponseBody
    public ResponseEntity<?> testMail(@RequestParam String to) {
        try {
            mailService.sendMail(to, "테스트 메일", "이것은 테스트 메일입니다. 서버에서 정상적으로 발송되었습니다.");
            return ResponseEntity.ok(Map.of("message", "메일 발송 성공"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // 비밀번호 재설정 페이지 진입
    @GetMapping("/reset-password")
    public String resetPasswordPage(@RequestParam String token, Model model) {
        model.addAttribute("token", token);
        return "reset_password";
    }

    @PostMapping("/api/reset-password")
    @ResponseBody
    public ResponseEntity<?> resetPassword(
            @RequestParam String token,
            @RequestParam String newPassword) {
        try {
            // 토큰으로 회원 찾기
            Optional<Member> optionalMember = memberService.findByResetPasswordToken(token);
            if (optionalMember.isEmpty()) {
                throw new RuntimeException("유효하지 않거나 만료된 토큰입니다.");
            }
            Member member = optionalMember.get();
            // 토큰 만료 체크
            if (member.getResetPasswordTokenExpiry() == null ||
                member.getResetPasswordTokenExpiry().isBefore(LocalDateTime.now())) {
                throw new RuntimeException("토큰이 만료되었습니다. 다시 요청해 주세요.");
            }
            // 비밀번호 변경
            member.setPassword(memberService.encodePassword(newPassword));
            // 토큰 무효화
            member.setResetPasswordToken(null);
            member.setResetPasswordTokenExpiry(null);
            memberService.save(member);
            return ResponseEntity.ok(Map.of("message", "비밀번호가 성공적으로 변경되었습니다."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
} 