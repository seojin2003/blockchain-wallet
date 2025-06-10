<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>입금</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/static/css/theme.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/static/js/theme.js"></script>
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
            align-items: center;
            padding: 0 20px;
            gap: 40px;
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
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .nav-menu a i {
            font-size: 16px;
        }
        .nav-menu a:hover {
            background-color: rgba(255,255,255,0.1);
        }
        .nav-menu a.active {
            background-color: rgba(255,255,255,0.2);
        }
        .user-info {
            margin-left: auto;
            display: flex;
            align-items: center;
            gap: 10px;
            color: white;
            font-size: 14px;
        }
        .user-info button {
            color: white;
            text-decoration: none;
            background: none;
            border: none;
            cursor: pointer;
            font-size: 14px;
            padding: 0;
        }
        .user-info button:hover {
            text-decoration: underline;
        }
        .notification-badge {
            position: absolute;
            top: -8px;
            right: -8px;
            background-color: #e74c3c;
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 12px;
            min-width: 18px;
            text-align: center;
            font-weight: bold;
            z-index: 1;
        }
        .notification-link {
            position: relative;
            display: inline-block;
        }
        .notification-icon {
            position: relative;
            color: var(--nav-text);
            font-size: 20px;
            cursor: pointer;
            margin-right: 20px;
        }
        .notification-count {
            position: absolute;
            top: -8px;
            right: -8px;
            background-color: #e74c3c;
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 12px;
            min-width: 20px;
            text-align: center;
        }
        .container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
        }
        .card {
            background-color: var(--bg-secondary);
            border-radius: 8px;
            box-shadow: var(--card-shadow);
            padding: 20px;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
        }
        .alert-info {
            background-color: var(--alert-info-bg);
            border-color: var(--alert-info-border);
            color: var(--alert-info-text);
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: var(--text-primary);
        }
        .form-control {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            background-color: var(--input-bg);
            color: var(--text-primary);
        }
        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
        }
        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        .btn-deposit {
            padding: 10px 20px;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-deposit:hover {
            background-color: var(--primary-color-hover);
        }
        .btn-cancel {
            padding: 10px 20px;
            background-color: #2c3e50;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
            font-weight: 500;
            text-align: center;
            transition: background-color 0.2s;
        }
        .btn-cancel:hover {
            background-color: #1a2632;
        }
        .copy-button {
            background: none;
            border: none;
            color: #3498db;
            cursor: pointer;
            padding: 5px;
            margin-left: 8px;
            border-radius: 4px;
            transition: all 0.2s;
            position: relative;
        }
        .copy-button:hover {
            background-color: rgba(52, 152, 219, 0.1);
        }
        .copy-alert {
            display: inline-block;
            margin-left: 10px;
            color: #2ecc71;
            font-size: 14px;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        .copy-alert.show {
            opacity: 1;
        }
    </style>
</head>
<body>
    <div class="nav">
        <div class="nav-container">
            <a href="/wallet" class="nav-logo">블록체인 월렛</a>
            <div class="nav-menu">
                <a href="/wallet">
                    <i class="fas fa-wallet"></i>
                    지갑
                </a>
                <a href="/chart">
                    <i class="fas fa-chart-line"></i>
                    시세
                </a>
                <a href="/notifications" class="notification-link">
                    <i class="fas fa-bell"></i>
                    <span id="notification-count" class="notification-badge" style="display: none;">0</span>
                </a>
            </div>
            <div class="user-info">
                <span><sec:authentication property="principal.username"/>님</span>
                |
                <form action="/logout" method="post" style="display: inline;">
                    <sec:csrfInput />
                    <button type="submit">로그아웃</button>
                </form>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="card">
            <h1>입금</h1>
            
            <c:choose>
                <c:when test="${member.admin}">
                    <c:choose>
                        <c:when test="${!member.hasInitializedCoin}">
                            <div class="alert alert-info">
                                <strong>초기 코인 발행</strong>
                                <p class="mb-0">* 코인 발행은 최초 1회만 가능합니다. 신중하게 입력해주세요.</p>
                            </div>
                            <form id="depositForm">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <div class="form-group">
                                    <label for="fromAddress">발행 주소:</label>
                                    <input type="text" class="form-control" id="fromAddress" name="fromAddress" value="${member.walletAddress}" readonly>
                                </div>
                                <div class="form-group">
                                    <label for="amount">발행할 총 코인 수량:</label>
                                    <input type="number" class="form-control" id="amount" name="amount" step="0.00000001" required>
                                </div>
                                <div class="button-group">
                                    <button type="submit" class="btn-cancel">코인 발행하기</button>
                                    <a href="/wallet" class="btn-cancel">취소</a>
                                </div>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-info">
                                <strong>코인 발행 완료</strong>
                                <p>이미 초기 코인이 발행되었습니다. 추가 발행은 불가능합니다.</p>
                                <p>내 지갑 주소: ${member.walletAddress}</p>
                            </div>
                            <div class="button-group">
                                <a href="/wallet" class="btn-cancel">지갑으로 돌아가기</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info">
                        <p>내 지갑 주소: <span id="wallet-address">${member.walletAddress}</span>
                        <button onclick="copyToClipboard('wallet-address')" class="copy-button">
                            <i class="fas fa-copy"></i>
                        </button>
                        <span class="copy-alert" id="copy-alert">
                            <i class="fas fa-check"></i> 복사됨
                        </span></p>
                    </div>
                    <div class="button-group">
                        <a href="/wallet" class="btn-cancel">지갑으로 돌아가기</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        function updateNotificationCount() {
            $.get('/notifications/count', function(response) {
                const count = response.count;
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
            
            // CSRF 토큰 설정
            var token = $("input[name='${_csrf.parameterName}']").val();
            var header = "${_csrf.headerName}";
            
            // AJAX 기본 설정
            $.ajaxSetup({
                beforeSend: function(xhr) {
                    xhr.setRequestHeader(header, token);
                }
            });

            $('#depositForm').submit(function(e) {
                e.preventDefault();
                
                const fromAddress = $('#fromAddress').val();
                const amount = $('#amount').val();
                
                // 입력값 검증
                if (!fromAddress || fromAddress.trim() === '') {
                    alert('발행 주소를 입력해주세요.');
                    return;
                }
                
                if (!amount || isNaN(amount) || parseFloat(amount) <= 0) {
                    alert('유효한 금액을 입력해주세요.');
                    return;
                }
                
                // 최대값 검증 (40자리, 소수점 18자리까지 허용)
                const MAX_DIGITS = 40;
                const MAX_DECIMALS = 18;
                
                const parts = amount.toString().split('.');
                const integerPart = parts[0];
                const decimalPart = parts[1] || '';
                
                if (integerPart.length + decimalPart.length > MAX_DIGITS) {
                    alert('숫자가 너무 큽니다. 최대 ' + MAX_DIGITS + '자리까지 입력 가능합니다.');
                    return;
                }
                
                if (decimalPart.length > MAX_DECIMALS) {
                    alert('소수점 이하 ' + MAX_DECIMALS + '자리까지만 입력 가능합니다.');
                    return;
                }
                
                if (confirm('코인을 발행하시겠습니까? 이 작업은 취소할 수 없습니다.')) {
                    const requestData = {
                        fromAddress: fromAddress,
                        amount: amount,
                        _csrf: $('input[name="_csrf"]').val()
                    };
                    
                    console.log('요청 데이터:', requestData);
                    
                    // 관리자의 초기 코인 발행인 경우
                    const apiUrl = '<c:choose><c:when test="${member.admin && !member.hasInitializedCoin}">/api/wallet/initial-deposit</c:when><c:otherwise>/api/wallet/deposit</c:otherwise></c:choose>';
                    
                    $.ajax({
                        url: apiUrl,
                        type: 'POST',
                        contentType: 'application/x-www-form-urlencoded',
                        data: requestData,
                        success: function(response) {
                            console.log('성공 응답:', response);
                            alert(response.message);
                            window.location.href = '/wallet';
                        },
                        error: function(xhr, status, error) {
                            console.error('에러 상태:', status);
                            console.error('에러 메시지:', error);
                            console.error('서버 응답:', xhr.responseText);
                            
                            let errorMsg;
                            try {
                                const errorResponse = JSON.parse(xhr.responseText);
                                errorMsg = errorResponse.error || '오류가 발생했습니다.';
                            } catch (e) {
                                errorMsg = '서버와의 통신 중 오류가 발생했습니다.';
                            }
                            
                            alert(errorMsg);
                        }
                    });
                }
            });
        });

        function copyToClipboard(elementId) {
            const text = document.getElementById(elementId).textContent;
            navigator.clipboard.writeText(text).then(() => {
                const alert = document.getElementById('copy-alert');
                alert.classList.add('show');
                setTimeout(() => {
                    alert.classList.remove('show');
                }, 2000);
            }).catch(err => {
                console.error('클립보드 복사 실패:', err);
                alert('클립보드 복사에 실패했습니다.');
            });
        }
    </script>
</body>
</html> 