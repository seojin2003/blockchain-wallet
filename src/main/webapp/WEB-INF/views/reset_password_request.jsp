<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 재설정 요청</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/static/css/theme.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .reset-container {
            max-width: 400px;
            margin: 60px auto;
            background: var(--bg-secondary);
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            padding: 32px 24px;
        }
        .reset-title {
            font-size: 1.3rem;
            font-weight: bold;
            margin-bottom: 24px;
            color: var(--text-primary);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: var(--text-secondary);
            font-weight: 600;
        }
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            background-color: var(--bg-primary);
            color: var(--text-primary);
        }
        .btn {
            background-color: var(--button-primary);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1rem;
        }
        .btn:hover {
            background-color: #142339;
        }
        .message {
            margin-top: 16px;
            font-size: 1rem;
        }
        .success {
            color: #2ecc71;
        }
        .error {
            color: #e74c3c;
        }
    </style>
</head>
<body>
<jsp:include page="common/header.jsp" />
<div class="reset-container">
    <div class="reset-title">비밀번호 재설정 링크 요청</div>
    <form id="resetRequestForm" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <div class="form-group">
            <label class="form-label" for="email">이메일(아이디)</label>
            <input type="text" id="email" name="email" class="form-control" required>
        </div>
        <button type="submit" class="btn">재설정 링크 발송</button>
        <div id="reset-message" class="message"></div>
    </form>
</div>
<script>
$('#resetRequestForm').submit(function(e) {
    e.preventDefault();
    const email = $('#email').val();
    const csrfToken = $("input[name='${_csrf.parameterName}']").val();
    $.ajax({
        url: '/api/reset-password-request',
        type: 'POST',
        data: { email, _csrf: csrfToken },
        success: function(res) {
            $('#reset-message').removeClass('error').addClass('success').text('재설정 링크가 이메일로 발송되었습니다. 메일을 확인해 주세요.');
        },
        error: function(xhr) {
            $('#reset-message').removeClass('success').addClass('error').text(xhr.responseJSON?.error || '오류가 발생했습니다.');
        }
    });
});
</script>
</body>
</html> 