<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입 - 블록체인 월렛</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body class="bg-gray-100">
    <div class="min-h-screen flex items-center justify-center">
        <div class="bg-white p-8 rounded-lg shadow-lg w-96">
            <h2 class="text-2xl font-bold mb-6 text-center">회원가입</h2>
            
            <form id="registerForm" class="space-y-4">
                <div>
                    <label for="username" class="block text-sm font-medium text-gray-700">아이디</label>
                    <div class="flex space-x-2">
                        <input type="text" id="username" name="username" required
                               class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                        <button type="button" id="checkUsername" 
                                class="px-4 py-2 bg-gray-500 text-white rounded-md hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-gray-500">
                            중복확인
                        </button>
                    </div>
                    <p id="usernameMessage" class="mt-1 text-sm text-red-600 hidden"></p>
                </div>
                
                <div>
                    <label for="password" class="block text-sm font-medium text-gray-700">비밀번호</label>
                    <input type="password" id="password" name="password" required
                           class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                </div>
                
                <div>
                    <label for="confirmPassword" class="block text-sm font-medium text-gray-700">비밀번호 확인</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required
                           class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                    <p id="passwordMessage" class="mt-1 text-sm text-red-600 hidden"></p>
                </div>
                
                <div>
                    <label for="name" class="block text-sm font-medium text-gray-700">이름</label>
                    <input type="text" id="name" name="name" required
                           class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                </div>
                
                <button type="submit" 
                        class="w-full py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    회원가입
                </button>
            </form>
            
            <div class="mt-4 text-center">
                <a href="/login" class="text-sm text-indigo-600 hover:text-indigo-500">이미 계정이 있으신가요? 로그인하기</a>
            </div>
        </div>
    </div>

    <script>
    $(document).ready(function() {
        let isUsernameChecked = false;
        let isUsernameAvailable = false;
        
        // 사용자명 중복 체크
        $('#checkUsername').click(function() {
            const username = $('#username').val();
            if (!username) {
                $('#usernameMessage').text('사용자명을 입력해주세요.').removeClass('hidden').removeClass('text-green-600').addClass('text-red-600');
                return;
            }
            
            $.get('/api/check-username', { username: username })
                .done(function(response) {
                    isUsernameChecked = true;
                    if (response.exists) {
                        $('#usernameMessage').text('이미 사용 중인 사용자명입니다.').removeClass('hidden').removeClass('text-green-600').addClass('text-red-600');
                        isUsernameAvailable = false;
                    } else {
                        $('#usernameMessage').text('사용 가능한 사용자명입니다.').removeClass('hidden').removeClass('text-red-600').addClass('text-green-600');
                        isUsernameAvailable = true;
                    }
                })
                .fail(function() {
                    $('#usernameMessage').text('중복 확인 중 오류가 발생했습니다.').removeClass('hidden').removeClass('text-green-600').addClass('text-red-600');
                });
        });

        // 사용자명 변경 시 중복체크 초기화
        $('#username').change(function() {
            isUsernameChecked = false;
            isUsernameAvailable = false;
            $('#usernameMessage').addClass('hidden');
        });

        // 비밀번호 확인 실시간 체크
        $('#confirmPassword').on('input', function() {
            const password = $('#password').val();
            const confirmPassword = $(this).val();
            
            if (password !== confirmPassword) {
                $('#passwordMessage').text('비밀번호가 일치하지 않습니다.').removeClass('hidden').addClass('text-red-600');
            } else {
                $('#passwordMessage').text('비밀번호가 일치합니다.').removeClass('hidden').removeClass('text-red-600').addClass('text-green-600');
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
            $.ajax({
                url: '/api/register',
                type: 'POST',
                data: {
                    username: $('#username').val(),
                    password: password,
                    name: $('#name').val()
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