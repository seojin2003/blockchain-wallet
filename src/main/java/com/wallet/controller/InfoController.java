package com.wallet.controller;

import com.wallet.entity.Member;
import com.wallet.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class InfoController {
    private final MemberService memberService;

    @GetMapping("/info")
    public String info(Model model) {
        try {
            Member member = memberService.getCurrentMember();
            model.addAttribute("member", member);
        } catch (Exception e) {
            model.addAttribute("member", null);
        }
        return "info";
    }
} 