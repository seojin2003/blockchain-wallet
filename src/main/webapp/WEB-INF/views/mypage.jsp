<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
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
        .mypage-container {
            max-width: 500px;
            margin: 40px auto;
            background: var(--bg-secondary);
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            padding: 32px 24px;
        }
        .mypage-title {
            font-size: 1.5rem;
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
        .error-message {
            color: #e74c3c;
            margin-bottom: 10px;
        }
        .success-message {
            color: #2ecc71;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp" />
    <script>
    // 페이지 진입 시 현재 테마 적용
    const currentTheme = localStorage.getItem('theme') || 'light';
    setTheme(currentTheme);
    </script>
    <div class="mypage-container">
        <div class="mypage-title">마이페이지</div>
        <form id="nameForm" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <div class="form-group">
                <label class="form-label" for="name">이름</label>
                <input type="text" id="name" name="name" class="form-control" value="${member.name}" required>
            </div>
            <button type="submit" class="btn">이름 변경</button>
            <div id="name-message" class="error-message" style="display:none;"></div>
        </form>
        <hr style="margin: 32px 0;">
        <div class="form-group">
            <label class="form-label">아이디(이메일)</label>
            <input type="text" class="form-control" value="${member.username}" readonly>
        </div>
        <form id="passwordForm" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <div class="form-group">
                <label class="form-label" for="currentPassword">현재 비밀번호</label>
                <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
            </div>
            <div class="form-group">
                <label class="form-label" for="newPassword">새 비밀번호</label>
                <input type="password" id="newPassword" name="newPassword" class="form-control" required>
            </div>
            <div class="form-group">
                <label class="form-label" for="confirmPassword">새 비밀번호 확인</label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
            </div>
            <button type="submit" class="btn">비밀번호 변경</button>
            <div id="password-message" class="error-message" style="display:none;"></div>
        </form>
    </div>
    <script>
    // 이름 변경 폼 처리
    $('#nameForm').submit(function(e) {
        e.preventDefault();
        const name = $('#name').val();
        const csrfToken = $("input[name='${_csrf.parameterName}']").val();
        $.ajax({
            url: '/api/mypage/name',
            type: 'POST',
            data: { name, _csrf: csrfToken },
            success: function(res) {
                $('#name-message').removeClass('error-message').addClass('success-message').text('이름이 변경되었습니다.').show();
            },
            error: function(xhr) {
                if (xhr.status === 403) {
                    window.location.href = '/login';
                    return;
                }
                $('#name-message').removeClass('success-message').addClass('error-message').text(xhr.responseJSON?.error || '오류가 발생했습니다.').show();
            }
        });
    });
    // 비밀번호 변경 폼 처리
    $('#passwordForm').submit(function(e) {
        e.preventDefault();
        const currentPassword = $('#currentPassword').val();
        const newPassword = $('#newPassword').val();
        const confirmPassword = $('#confirmPassword').val();
        const csrfToken = $("input[name='${_csrf.parameterName}']").val();
        if (newPassword !== confirmPassword) {
            $('#password-message').removeClass('success-message').addClass('error-message').text('새 비밀번호가 일치하지 않습니다.').show();
            return;
        }
        $.ajax({
            url: '/api/mypage/password',
            type: 'POST',
            data: { currentPassword, newPassword, _csrf: csrfToken },
            success: function(res) {
                $('#password-message').removeClass('error-message').addClass('success-message').text('비밀번호가 변경되었습니다.').show();
                $('#currentPassword, #newPassword, #confirmPassword').val('');
                setTimeout(function() {
                    window.location.href = '/login';
                }, 1000);
            },
            error: function(xhr) {
                if (xhr.status === 403) {
                    window.location.href = '/login';
                    return;
                }
                $('#password-message').removeClass('success-message').addClass('error-message').text(xhr.responseJSON?.error || '오류가 발생했습니다.').show();
            }
        });
    });
    </script>
</body>
</html> 