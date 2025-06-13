<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 재설정</title>
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
    <div class="reset-title">비밀번호 재설정</div>
    <form id="resetPasswordForm" method="post">
        <input type="hidden" id="token" name="token" value="${token}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" id="csrfToken" />
        <div class="form-group">
            <label class="form-label" for="newPassword">새 비밀번호</label>
            <input type="password" id="newPassword" name="newPassword" class="form-control" required>
        </div>
        <div class="form-group">
            <label class="form-label" for="confirmPassword">새 비밀번호 확인</label>
            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
        </div>
        <button type="submit" class="btn">비밀번호 변경</button>
        <div id="reset-message" class="message"></div>
    </form>
</div>
<script>
$('#resetPasswordForm').submit(function(e) {
    e.preventDefault();
    const token = $('#token').val();
    const newPassword = $('#newPassword').val();
    const confirmPassword = $('#confirmPassword').val();
    const csrfToken = $('#csrfToken').val();
    if (newPassword !== confirmPassword) {
        $('#reset-message').removeClass('success').addClass('error').text('새 비밀번호가 일치하지 않습니다.');
        return;
    }
    $.ajax({
        url: '/api/reset-password',
        type: 'POST',
        data: { token, newPassword, _csrf: csrfToken },
        success: function(res) {
            $('#reset-message').removeClass('error').addClass('success').text('비밀번호가 성공적으로 변경되었습니다. 로그인 페이지로 이동합니다.');
            setTimeout(function() {
                window.location.href = '/login';
            }, 1500);
        },
        error: function(xhr) {
            $('#reset-message').removeClass('success').addClass('error').text(xhr.responseJSON?.error || '오류가 발생했습니다.');
        }
    });
});
</script>
</body>
</html> 