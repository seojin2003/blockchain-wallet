package com.wallet.controller;

import com.wallet.entity.Member;
import com.wallet.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

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
} 