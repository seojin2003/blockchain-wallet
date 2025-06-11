<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>출금</title>
    <script src="/static/js/theme.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/static/css/theme.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
        .card {
            background-color: var(--bg-secondary);
            border-radius: 8px;
            box-shadow: var(--card-shadow);
            padding: 20px;
            margin-bottom: 20px;
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
        .button {
            padding: 10px 20px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .button-primary {
            background-color: var(--button-primary);
            color: white;
        }
        .button-secondary {
            background-color: var(--button-secondary);
            color: white;
        }
        .button:hover {
            opacity: 0.9;
        }
        .alert-info {
            background-color: var(--alert-info-bg);
            color: var(--text-primary);
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp" />

    <div class="container">
        <div class="card">
            <h2 class="text-2xl font-bold mb-4">출금</h2>
            <div class="alert-info">
                <p>출금하실 금액과 목적지 주소를 입력해주세요.</p>
            </div>
            <form id="withdrawForm">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <div class="form-group">
                    <label>현재 잔액</label>
                    <input type="text" class="form-control" value="${member.balance} ETH" readonly>
                </div>
                <div class="form-group">
                    <label>내 지갑 주소</label>
                    <input type="text" class="form-control" value="${member.walletAddress}" readonly>
                    <p class="text-sm text-gray-500 mt-1">이 주소에서 출금됩니다.</p>
                </div>
                <div class="form-group">
                    <label>목적지 주소</label>
                    <input type="text" class="form-control" id="toAddress" name="toAddress" required>
                    <p class="text-sm text-gray-500 mt-1">ETH를 받을 지갑 주소를 입력해주세요.</p>
                </div>
                <div class="form-group">
                    <label>출금 금액</label>
                    <input type="number" class="form-control" id="amount" name="amount" step="0.00000001" required>
                    <p class="text-sm text-gray-500 mt-1">출금하실 ETH 수량을 입력해주세요.</p>
                </div>
                <div class="button-group">
                    <button type="submit" class="button button-primary">
                        <i class="fas fa-paper-plane"></i>
                        출금하기
                    </button>
                    <a href="/wallet" class="button button-secondary">
                        <i class="fas fa-arrow-left"></i>
                        취소
                    </a>
                </div>
            </form>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            $('#withdrawForm').submit(function(e) {
                e.preventDefault();
                
                const toAddress = $('#toAddress').val();
                const amount = $('#amount').val();
                
                if (!toAddress || toAddress.trim() === '') {
                    alert('목적지 주소를 입력해주세요.');
                    return;
                }
                
                if (!amount || isNaN(amount) || parseFloat(amount) <= 0) {
                    alert('유효한 금액을 입력해주세요.');
                    return;
                }
                
                if (parseFloat(amount) > parseFloat('${member.balance}')) {
                    alert('잔액이 부족합니다.');
                    return;
                }
                
                if (confirm('출금하시겠습니까?')) {
                    $.ajax({
                        url: '/api/wallet/withdraw',
                        type: 'POST',
                        data: {
                            toAddress: toAddress,
                            amount: amount,
                            _csrf: $('input[name="_csrf"]').val()
                        },
                        success: function(response) {
                            alert('출금이 완료되었습니다.');
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