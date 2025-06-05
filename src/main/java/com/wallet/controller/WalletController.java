package com.wallet.controller;

import com.wallet.dto.TransactionDTO;
import com.wallet.entity.Member;
import com.wallet.entity.Transaction;
import com.wallet.service.MemberService;
import com.wallet.service.WalletService;
import com.wallet.util.DateFormatter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class WalletController {

    private final WalletService walletService;
    private final MemberService memberService;
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");

    @GetMapping("/wallet")
    public String wallet(@AuthenticationPrincipal User user, Model model) {
        try {
            Member member = memberService.findByUsername(user.getUsername());
            
            // 지갑 주소가 없으면 자동으로 생성
            if (member.getWalletAddress() == null || member.getWalletAddress().isEmpty()) {
                walletService.createWallet(member);
                memberService.save(member);
            }
            
            BigDecimal balance = walletService.getBalance(member.getWalletAddress());
            List<Transaction> transactions = walletService.getTransactionHistory(member);

            model.addAttribute("member", member);
            model.addAttribute("balance", balance != null ? balance.toPlainString() : "0");
            model.addAttribute("transactions", transactions.stream()
                    .map(TransactionDTO::from)
                    .collect(Collectors.toList()));

            return "wallet";
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }

    @GetMapping("/deposit")
    public String depositForm(@AuthenticationPrincipal User user, Model model) throws Exception {
        Member member = memberService.findByUsername(user.getUsername());
        model.addAttribute("member", member);
        return "deposit";
    }

    @PostMapping("/api/wallet/deposit")
    @ResponseBody
    public ResponseEntity<?> deposit(@AuthenticationPrincipal User user,
                                   @RequestParam String fromAddress,
                                   @RequestParam BigDecimal amount) {
        try {
            if (user == null) {
                throw new RuntimeException("로그인이 필요합니다.");
            }

            Member member = memberService.findByUsername(user.getUsername());
            Transaction transaction = walletService.deposit(member, fromAddress, amount);

            Map<String, String> response = new HashMap<>();
            response.put("message", "입금이 완료되었습니다.");
            response.put("transactionHash", transaction.getTransactionHash());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @GetMapping("/withdraw")
    public String withdrawForm(@AuthenticationPrincipal User user, Model model) {
        Member member = memberService.findByUsername(user.getUsername());
        BigDecimal balance = walletService.getBalance(member.getWalletAddress());
        member.setBalance(balance);
        model.addAttribute("member", member);
        return "withdraw";
    }

    @PostMapping("/api/wallet/withdraw")
    @ResponseBody
    public ResponseEntity<?> withdraw(@AuthenticationPrincipal User user,
                                    @RequestParam String toAddress,
                                    @RequestParam BigDecimal amount) {
        try {
            if (user == null) {
                throw new RuntimeException("로그인이 필요합니다.");
            }

            Member member = memberService.findByUsername(user.getUsername());
            Transaction transaction = walletService.withdraw(member, toAddress, amount);

            Map<String, String> response = new HashMap<>();
            response.put("message", "출금이 완료되었습니다.");
            response.put("transactionHash", transaction.getTransactionHash());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/api/wallet/create")
    @ResponseBody
    public ResponseEntity<?> createWallet(@AuthenticationPrincipal User user) {
        try {
            Member member = memberService.findByUsername(user.getUsername());
            walletService.createWallet(member);
            memberService.save(member);

            Map<String, String> response = new HashMap<>();
            response.put("address", member.getWalletAddress());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @GetMapping("/api/wallet/balance")
    @ResponseBody
    public ResponseEntity<?> getBalance(HttpSession session) {
        try {
            Long memberId = (Long) session.getAttribute("memberId");
            if (memberId == null) {
                throw new RuntimeException("로그인이 필요합니다.");
            }

            Member member = memberService.findById(memberId);
            BigDecimal balance = walletService.getBalance(member.getWalletAddress());

            Map<String, BigDecimal> response = new HashMap<>();
            response.put("balance", balance);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @GetMapping("/api/wallet/transactions")
    @ResponseBody
    public ResponseEntity<?> getTransactions(HttpSession session) {
        try {
            Long memberId = (Long) session.getAttribute("memberId");
            if (memberId == null) {
                throw new RuntimeException("로그인이 필요합니다.");
            }

            Member member = memberService.findById(memberId);
            List<Transaction> transactions = walletService.getTransactionHistory(member);

            return ResponseEntity.ok(transactions);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
} 