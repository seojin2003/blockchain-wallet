<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인 - 블록체인 월렛</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/css/theme.css">
    <style>
        :root {
            --button-bg: var(--nav-bg);
            --button-hover: #142339;
        }
        
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: var(--bg-primary);
            color: var(--text-primary);
        }
        .login-container {
            background-color: var(--bg-secondary);
            padding: 2rem;
            border-radius: 8px;
            box-shadow: var(--card-shadow);
            width: 100%;
            max-width: 400px;
        }
        .form-group {
            margin-bottom: 1rem;
        }
        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--text-secondary);
            font-weight: bold;
        }
        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            background-color: var(--bg-secondary);
            color: var(--text-primary);
            transition: all 0.3s ease;
        }
        .form-control:focus {
            outline: none;
            border-color: var(--button-bg);
            box-shadow: 0 0 0 2px rgba(44, 62, 80, 0.2);
        }
        .btn {
            width: 100%;
            padding: 0.75rem;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn:hover {
            opacity: 0.9;
            transform: translateY(-1px);
        }
        .btn:active {
            transform: translateY(0);
        }
        .btn-primary {
            background-color: var(--button-bg);
            color: var(--nav-text);
        }
        .btn-primary:hover {
            background-color: var(--button-hover);
        }
        .signup-link {
            text-align: center;
            margin-top: 1.5rem;
            color: var(--text-secondary);
        }
        .signup-link a {
            color: var(--button-bg);
            text-decoration: none;
            font-weight: bold;
            transition: color 0.3s ease;
        }
        .signup-link a:hover {
            color: var(--button-hover);
            text-decoration: none;
        }
        .error-message {
            background-color: #fee2e2;
            border: 1px solid #ef4444;
            color: #b91c1c;
            padding: 0.75rem;
            border-radius: 4px;
            margin-bottom: 1rem;
            display: none;
        }
        .error-message.show {
            display: block;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h1 class="text-2xl font-bold mb-6 text-center">로그인</h1>
        
        <div id="error-message" class="error-message ${not empty param.error ? 'show' : ''}">
            <c:choose>
                <c:when test="${not empty sessionScope.loginError}">
                    ${sessionScope.loginError}
                </c:when>
                <c:otherwise>
                    아이디 또는 비밀번호가 올바르지 않습니다.
                </c:otherwise>
            </c:choose>
        </div>

        <form action="/login" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            
            <div class="form-group">
                <label class="form-label" for="username">아이디</label>
                <input type="text" id="username" name="username" class="form-control" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="password">비밀번호</label>
                <input type="password" id="password" name="password" class="form-control" required>
            </div>

            <button type="submit" class="btn btn-primary">로그인</button>
        </form>

        <div class="signup-link">
            계정이 없으신가요? <a href="/signup">회원가입</a>
        </div>
    </div>

    <script>
        // URL 파라미터에서 에러 여부 확인
        const urlParams = new URLSearchParams(window.location.search);
        const hasError = urlParams.get('error') !== null;
        const errorMessage = document.getElementById('error-message');
        
        if (hasError) {
            errorMessage.classList.add('show');
            // 세션에서 에러 메시지 제거
            <% session.removeAttribute("loginError"); %>
        }
    </script>
</body>
</html> 