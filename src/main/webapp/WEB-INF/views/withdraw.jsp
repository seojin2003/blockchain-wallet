<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>출금하기</title>
    <link rel="stylesheet" href="/css/theme.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/theme.js"></script>
    <script src="/js/notification.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--bg-primary);
            color: var(--text-primary);
        }
        .nav {
            background-color: var(--nav-bg);
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
            color: var(--nav-text);
            font-size: 20px;
            font-weight: bold;
            text-decoration: none;
        }
        .nav-menu {
            display: flex;
            gap: 20px;
        }
        .nav-menu a {
            color: var(--nav-text);
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
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
        }
        .card {
            background-color: var(--bg-secondary);
            border-radius: 8px;
            box-shadow: var(--card-shadow);
            padding: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: var(--text-secondary);
        }
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            box-sizing: border-box;
            background-color: var(--bg-secondary);
            color: var(--text-primary);
        }
        .form-text {
            margin-top: 5px;
            font-size: 14px;
            color: var(--text-secondary);
        }
        .button {
            padding: 10px 20px;
            border-radius: 4px;
            border: none;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            display: inline-block;
        }
        .button-withdraw {
            background-color: #dc3545;
            color: white;
        }
        .button-cancel {
            background-color: #6c757d;
            color: white;
            margin-left: 10px;
        }
        .button:hover {
            opacity: 0.9;
        }
        .user-info {
            color: white;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
        }
        .alert-info {
            background-color: var(--alert-info-bg);
            color: var(--alert-info-text);
            border-color: var(--alert-info-border);
        }
        .form-control-static {
            padding: 8px 12px;
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 4px;
            margin-bottom: 10px;
        }
        
        .form-control-static strong {
            color: var(--text-primary);
            font-size: 16px;
        }
        h1 {
            color: var(--text-primary);
        }
    </style>
</head>
<body>
    <div class="nav">
        <div class="nav-container">
            <a href="/wallet" class="nav-logo">블록체인 월렛</a>
            <div class="nav-menu">
                <a href="/wallet"><i class="fas fa-wallet"></i> 지갑</a>
                <a href="/chart"><i class="fas fa-chart-line"></i> 시세</a>
                <a href="/notifications" class="notification-link">
                    <i class="fas fa-bell"></i>
                    <span id="notification-count" class="notification-badge" style="display: none;">0</span>
                </a>
            </div>
            <div class="user-info">
                ${member.name}님 | 
                <form action="/logout" method="post" style="display: inline;">
                    <sec:csrfInput />
                    <button type="submit" style="background: none; border: none; color: var(--nav-text); text-decoration: none; cursor: pointer;">로그아웃</button>
                </form>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="card">
            <h1>출금하기</h1>
            
            <div class="alert alert-info">
                출금하실 금액과 목적지 주소를 입력해주세요.
            </div>

            <form id="withdrawForm">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                
                <div class="form-group">
                    <label class="form-label">현재 잔액</label>
                    <div class="form-control-static">
                        <strong>${member.balance} ETH</strong>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">내 지갑 주소</label>
                    <input type="text" class="form-control" value="${member.walletAddress}" readonly>
                    <div class="form-text">이 주소에서 출금됩니다.</div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="address">목적지 주소</label>
                    <input type="text" class="form-control" id="address" name="address" required>
                    <div class="form-text">ETH를 받을 지갑 주소를 입력해주세요.</div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="amount">출금 금액</label>
                    <input type="number" class="form-control" id="amount" name="amount" step="0.00000001" required>
                    <div class="form-text">출금하실 ETH 수량을 입력해주세요.</div>
                </div>

                <div>
                    <button type="submit" class="button button-withdraw">출금하기</button>
                    <a href="/wallet" class="button button-cancel">취소</a>
                </div>
            </form>
        </div>
    </div>
    <script>
        function updateNotificationCount() {
            $.get('/notifications/count', function(count) {
                const badge = $('#notification-count');
                if (count > 0) {
                    badge.text(count).show();
                } else {
                    badge.hide();
                }
            });
        }

        $(document).ready(function() {
            updateNotificationCount();
            // 30초마다 알림 개수 업데이트
            setInterval(updateNotificationCount, 30000);

            $('#withdrawForm').on('submit', function(e) {
                e.preventDefault();
                
                const amount = parseFloat($('#amount').val());
                const address = $('#address').val();

                if (!address.startsWith('0x')) {
                    alert('올바른 이더리움 주소를 입력해주세요. (0x로 시작)');
                    return;
                }

                if (isNaN(amount) || amount <= 0) {
                    alert('올바른 출금 금액을 입력해주세요.');
                    return;
                }

                if (confirm('출금을 진행하시겠습니까?')) {
                    const token = $("input[name='${_csrf.parameterName}']").val();
                    
                    $.ajax({
                        url: '/api/wallet/withdraw',
                        type: 'POST',
                        data: {
                            toAddress: address,
                            amount: amount,
                            _csrf: token
                        },
                        success: function(response) {
                            alert('출금이 완료되었습니다.');
                            // 알림 개수 업데이트
                            updateNotificationCount();
                            window.location.href = '/wallet';
                        },
                        error: function(xhr) {
                            try {
                                const response = JSON.parse(xhr.responseText);
                                alert(response.error || '출금 처리 중 오류가 발생했습니다.');
                            } catch (e) {
                                alert('출금 처리 중 오류가 발생했습니다.');
                            }
                        }
                    });
                }
            });
        });
    </script>
</body>
</html> 