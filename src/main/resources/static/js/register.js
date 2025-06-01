document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('registerForm');
    const usernameInput = document.getElementById('username');
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const checkUsernameButton = document.getElementById('checkUsername');
    let isUsernameChecked = false;

    // 사용자명 중복 체크
    checkUsernameButton.addEventListener('click', function() {
        const username = usernameInput.value.trim();
        if (!username) {
            alert('사용자명을 입력해주세요.');
            return;
        }

        fetch(`/api/check-username?username=${encodeURIComponent(username)}`)
            .then(response => response.json())
            .then(data => {
                if (data.exists) {
                    alert('이미 사용 중인 사용자명입니다.');
                    isUsernameChecked = false;
                } else {
                    alert('사용 가능한 사용자명입니다.');
                    isUsernameChecked = true;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('중복 체크 중 오류가 발생했습니다.');
            });
    });

    // 사용자명 변경 시 중복체크 초기화
    usernameInput.addEventListener('input', function() {
        isUsernameChecked = false;
    });

    // 폼 제출 전 유효성 검사
    form.addEventListener('submit', function(e) {
        e.preventDefault();

        // 중복체크 확인
        if (!isUsernameChecked) {
            alert('사용자명 중복체크를 해주세요.');
            return;
        }

        // 비밀번호 확인
        if (passwordInput.value !== confirmPasswordInput.value) {
            alert('비밀번호가 일치하지 않습니다.');
            return;
        }

        // 폼 제출
        this.submit();
    });
}); 