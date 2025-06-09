<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입 - 블록체인 월렛</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
        .register-container {
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
        .btn-check {
            background-color: var(--button-bg);
            color: var(--nav-text);
            padding: 0.75rem 1rem;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s ease;
            min-width: 90px;
        }
        .btn-check:hover {
            background-color: var(--button-hover);
            transform: translateY(-1px);
        }
        .btn-check:active {
            transform: translateY(0);
        }
        .login-link {
            text-align: center;
            margin-top: 1.5rem;
            color: var(--text-secondary);
        }
        .login-link a {
            color: var(--button-bg);
            text-decoration: none;
            font-weight: bold;
            transition: color 0.3s ease;
        }
        .login-link a:hover {
            color: var(--button-hover);
            text-decoration: none;
        }
        .message {
            margin-top: 0.5rem;
            font-size: 0.875rem;
        }
        .message.success {
            color: #2ecc71;
        }
        .message.error {
            color: #e74c3c;
        }
        .flex.gap-2 {
            display: flex;
            gap: 0.5rem;
        }
        #username {
            flex: 1;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h1 class="text-2xl font-bold mb-6 text-center">회원가입</h1>
        
        <form id="registerForm" class="space-y-6" method="POST">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            
            <div class="form-group">
                <label class="form-label" for="username">아이디</label>
                <div class="flex gap-2">
                    <input type="text" id="username" name="username" class="form-control" required>
                    <button type="button" id="checkUsername" class="btn-check">중복 확인</button>
                </div>
                <p id="usernameMessage" class="message"></p>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="password">비밀번호</label>
                <input type="password" id="password" name="password" class="form-control" required>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="confirmPassword">비밀번호 확인</label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
                <p id="passwordMessage" class="message"></p>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="name">이름</label>
                <input type="text" id="name" name="name" class="form-control" required>
            </div>
            
            <button type="submit" class="btn btn-primary">회원가입</button>
        </form>
        
        <div class="login-link">
            이미 계정이 있으신가요? <a href="/login">로그인</a>
        </div>
    </div>

    <script>
    $(document).ready(function() {
        let isUsernameChecked = false;
        let isUsernameAvailable = false;
        
        // 아이디 중복 확인
        $('#checkUsername').click(function() {
            const username = $('#username').val();
            if (!username) {
                alert('아이디를 입력해주세요.');
                return;
            }
            
            $.ajax({
                url: '/api/check-username',
                type: 'GET',
                data: { username: username },
                success: function(response) {
                    isUsernameChecked = true;
                    isUsernameAvailable = !response.exists;
                    
                    if (response.exists) {
                        $('#usernameMessage').text('이미 사용중인 아이디입니다.').removeClass('success').addClass('error');
                    } else {
                        $('#usernameMessage').text('사용 가능한 아이디입니다.').removeClass('error').addClass('success');
                    }
                },
                error: function() {
                    alert('중복 확인 중 오류가 발생했습니다.');
                }
            });
        });

        // 비밀번호 확인
        $('#confirmPassword').on('input', function() {
            const password = $('#password').val();
            const confirmPassword = $(this).val();
            
            if (password !== confirmPassword) {
                $('#passwordMessage').text('비밀번호가 일치하지 않습니다.').removeClass('success').addClass('error');
            } else {
                $('#passwordMessage').text('비밀번호가 일치합니다.').removeClass('error').addClass('success');
            }
        });

        // 폼 제출
        $('#registerForm').submit(function(e) {
            e.preventDefault();
            
            // 중복확인 체크
            if (!isUsernameChecked || !isUsernameAvailable) {
                alert('사용자명 중복확인을 해주세요.');
                return;
            }
            
            // 비밀번호 확인
            const password = $('#password').val();
            const confirmPassword = $('#confirmPassword').val();
            if (password !== confirmPassword) {
                alert('비밀번호가 일치하지 않습니다.');
                return;
            }
            
            // 회원가입 요청
            const token = $("input[name='${_csrf.parameterName}']").val();
            
            $.ajax({
                url: '/api/register',
                type: 'POST',
                data: {
                    username: $('#username').val(),
                    password: password,
                    name: $('#name').val(),
                    _csrf: token
                },
                success: function(response) {
                    alert('회원가입이 완료되었습니다.');
                    window.location.href = '/login';
                },
                error: function(xhr) {
                    alert(xhr.responseJSON?.error || '회원가입 중 오류가 발생했습니다.');
                }
            });
        });
    });
    </script>
</body>
</html> 