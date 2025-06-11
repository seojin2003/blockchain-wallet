<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>입금</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/static/js/theme.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/static/css/theme.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--bg-primary);
            color: var(--text-primary);
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .alert-info {
            background-color: var(--alert-info-bg);
            color: var(--text-primary);
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .button {
            display: inline-block;
            padding: 10px 20px;
            background-color: var(--button-primary);
            color: white;
            text-decoration: none;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }
        .button:hover {
            opacity: 0.9;
        }
        .copy-button {
            background: none;
            border: none;
            color: var(--button-primary);
            cursor: pointer;
            padding: 5px;
            margin-left: 8px;
            border-radius: 4px;
            transition: all 0.2s;
        }
        .copy-button:hover {
            background-color: var(--bg-hover);
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
        .address-container {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: var(--text-secondary);
        }
        .form-control {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            background-color: var(--bg-primary);
            color: var(--text-primary);
        }
        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp" />

    <div class="container">
        <div class="alert-info">
            <h2>입금</h2>
            <c:choose>
                <c:when test="${member.admin}">
                    <c:choose>
                        <c:when test="${!member.hasInitializedCoin}">
                            <p>초기 코인 발행이 필요합니다. 발행할 코인 수량을 입력해주세요.</p>
                            <form id="depositForm">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <div class="form-group">
                                    <label>발행 주소</label>
                                    <div class="address-container">
                                        <span id="wallet-address">${member.walletAddress}</span>
                                        <button type="button" onclick="copyToClipboard('wallet-address')" class="copy-button">
                                            <i class="fas fa-copy"></i>
                                        </button>
                                        <span class="copy-alert" id="copy-alert">
                                            <i class="fas fa-check"></i> 복사됨
                                        </span>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label>발행할 코인 수량</label>
                                    <input type="number" class="form-control" id="amount" name="amount" step="0.00000001" required>
                                </div>
                                <div class="button-group">
                                    <button type="submit" class="button">
                                        <i class="fas fa-coins"></i>
                                        코인 발행하기
                                    </button>
                                    <a href="/wallet" class="button">
                                        <i class="fas fa-arrow-left"></i>
                                        취소
                                    </a>
                                </div>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <p>코인이 이미 발행되었습니다. 추가 발행은 불가능합니다.</p>
                            <div class="address-container">
                                <p>내 지갑 주소: <span id="wallet-address">${member.walletAddress}</span>
                                <button onclick="copyToClipboard('wallet-address')" class="copy-button">
                                    <i class="fas fa-copy"></i>
                                </button>
                                <span class="copy-alert" id="copy-alert">
                                    <i class="fas fa-check"></i> 복사됨
                                </span></p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:otherwise>
                    <div class="address-container">
                        <p>내 지갑 주소: <span id="wallet-address">${member.walletAddress}</span>
                        <button onclick="copyToClipboard('wallet-address')" class="copy-button">
                            <i class="fas fa-copy"></i>
                        </button>
                        <span class="copy-alert" id="copy-alert">
                            <i class="fas fa-check"></i> 복사됨
                        </span></p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <c:if test="${!member.admin || member.hasInitializedCoin}">
            <a href="/wallet" class="button">
                <i class="fas fa-arrow-left"></i>
                지갑으로 돌아가기
            </a>
        </c:if>
    </div>

    <script>
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

        $(document).ready(function() {
            $('#depositForm').submit(function(e) {
                e.preventDefault();
                
                const amount = $('#amount').val();
                
                if (!amount || isNaN(amount) || parseFloat(amount) <= 0) {
                    alert('유효한 금액을 입력해주세요.');
                    return;
                }
                
                if (confirm('코인을 발행하시겠습니까? 이 작업은 취소할 수 없습니다.')) {
                    const token = $('input[name="_csrf"]').val();
                    const header = $('meta[name="_csrf_header"]').attr('content');
                    
                    $.ajax({
                        url: '/api/wallet/initial-deposit',
                        type: 'POST',
                        contentType: 'application/x-www-form-urlencoded',
                        data: {
                            fromAddress: '${member.walletAddress}',
                            amount: amount,
                            _csrf: token
                        },
                        beforeSend: function(xhr) {
                            xhr.setRequestHeader(header, token);
                        },
                        success: function(response) {
                            alert('코인이 발행되었습니다.');
                            window.location.href = '/wallet';
                        },
                        error: function(xhr) {
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
    </script>
</body>
</html> 