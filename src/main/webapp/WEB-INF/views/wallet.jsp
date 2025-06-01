<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>내 지갑</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }
        .nav {
            background-color: #2c3e50;
            padding: 15px 0;
            margin-bottom: 30px;
        }
        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }
        .nav-logo {
            color: white;
            font-size: 20px;
            font-weight: bold;
            text-decoration: none;
        }
        .nav-menu {
            display: flex;
            gap: 20px;
        }
        .nav-menu a {
            color: white;
            text-decoration: none;
            padding: 5px 10px;
            border-radius: 4px;
        }
        .nav-menu a:hover {
            background-color: rgba(255,255,255,0.1);
        }
        .nav-menu a.active {
            background-color: rgba(255,255,255,0.2);
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .info-section {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }
        .info-item {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }
        .info-label {
            font-weight: bold;
            color: #666;
            width: 120px;
        }
        .info-value {
            flex: 1;
            word-break: break-all;
        }
        .button-group {
            margin-top: 20px;
            display: flex;
            gap: 10px;
        }
        .button {
            padding: 10px 20px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            font-weight: bold;
            transition: background-color 0.2s;
        }
        .button-deposit {
            background-color: #2ecc71;
            color: white;
        }
        .button-withdraw {
            background-color: #e74c3c;
            color: white;
        }
        .button-create {
            background-color: #3498db;
            color: white;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f8f9fa;
            font-weight: bold;
            color: #666;
        }
        .type-deposit {
            color: #2ecc71;
        }
        .type-withdraw {
            color: #e74c3c;
        }
        .status-tag {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .user-info {
            color: white;
        }
    </style>
</head>
<body>
    <div class="nav">
        <div class="nav-container">
            <a href="/wallet" class="nav-logo">블록체인 월렛</a>
            <div class="nav-menu">
                <a href="/wallet" class="active">지갑</a>
                <a href="/chart">시세</a>
            </div>
            <div class="user-info">
                ${member.name}님 | <a href="/logout" style="color: white; text-decoration: none;">로그아웃</a>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="card">
            <h1>내 지갑 정보</h1>
            
            <div class="info-section">
                <div class="info-item">
                    <span class="info-label">이름:</span>
                    <span class="info-value">${member.name}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">지갑 주소:</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${empty member.walletAddress}">
                                <span style="color: #e74c3c;">지갑이 아직 생성되지 않았습니다.</span>
                                <form action="/api/wallet/create" method="post" style="display: inline;">
                                    <button type="submit" class="button button-create">지갑 생성하기</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                ${member.walletAddress}
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="info-item">
                    <span class="info-label">잔액:</span>
                    <span class="info-value">${balance} ETH</span>
                </div>
                <div class="button-group">
                    <c:if test="${not empty member.walletAddress}">
                        <a href="/deposit" class="button button-deposit">입금하기</a>
                        <a href="/withdraw" class="button button-withdraw">출금하기</a>
                    </c:if>
                </div>
            </div>

            <h2>거래 내역</h2>
            <c:choose>
                <c:when test="${empty transactions}">
                    <div style="text-align: center; padding: 40px; background-color: #f8f9fa; border-radius: 8px; margin: 20px 0; border: 1px solid #dee2e6;">
                        <div style="margin-bottom: 15px; font-size: 24px;">📝</div>
                        <p style="margin: 0; color: #6c757d; font-size: 16px;">아직 거래 내역이 없습니다.</p>
                        <p style="margin: 10px 0 0 0; color: #adb5bd; font-size: 14px;">입금 또는 출금을 진행하시면 이곳에 거래 내역이 표시됩니다.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>날짜</th>
                                <th>종류</th>
                                <th>금액</th>
                                <th>상태</th>
                                <th>거래 해시</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${transactions}" var="tx">
                                <tr>
                                    <td>${tx.createdAt}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${tx.type eq 'DEPOSIT'}">
                                                <span class="type-deposit">입금</span>
                                            </c:when>
                                            <c:when test="${tx.type eq 'WITHDRAW'}">
                                                <span class="type-withdraw">출금</span>
                                            </c:when>
                                            <c:otherwise>
                                                ${tx.type}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${tx.type eq 'DEPOSIT'}">
                                                <span class="type-deposit">+${tx.amount}</span>
                                            </c:when>
                                            <c:when test="${tx.type eq 'WITHDRAW'}">
                                                <span class="type-withdraw">-${tx.amount}</span>
                                            </c:when>
                                            <c:otherwise>
                                                ${tx.amount}
                                            </c:otherwise>
                                        </c:choose>
                                        ETH
                                    </td>
                                    <td>
                                        <span class="status-tag ${tx.status eq 'COMPLETED' ? 'status-completed' : 'status-pending'}">
                                            ${tx.status}
                                        </span>
                                    </td>
                                    <td style="font-family: monospace;">${tx.transactionHash}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const createWalletForm = document.querySelector('form[action="/api/wallet/create"]');
            if (createWalletForm) {
                createWalletForm.addEventListener('submit', function(e) {
                    e.preventDefault();
                    
                    fetch('/api/wallet/create', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        }
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.error) {
                            alert(data.error);
                        } else {
                            // 성공적으로 지갑이 생성되면 페이지 새로고침
                            window.location.reload();
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('지갑 생성 중 오류가 발생했습니다.');
                    });
                });
            }
        });
    </script>
</body>
</html> 