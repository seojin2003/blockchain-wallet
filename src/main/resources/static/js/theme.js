// 테마 설정 함수
function setTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem('theme', theme);
    updateThemeIcon(theme);
}

// 테마 아이콘 업데이트
function updateThemeIcon(theme) {
    const themeIcon = document.getElementById('themeIcon');
    if (themeIcon) {
        themeIcon.innerHTML = theme === 'dark' ? '☀️' : '🌙';
    }
}

// 테마 토글 함수
function toggleTheme() {
    const currentTheme = localStorage.getItem('theme') || 'light';
    const newTheme = currentTheme === 'light' ? 'dark' : 'light';
    setTheme(newTheme);
}

// 초기 테마 설정
document.addEventListener('DOMContentLoaded', function() {
    // 테마 토글 버튼 생성
    const toggleButton = document.createElement('button');
    toggleButton.className = 'theme-toggle';
    toggleButton.innerHTML = `
        <div class="toggle-track">
            <div class="toggle-sun">☀️</div>
            <div class="toggle-moon">🌙</div>
            <div class="toggle-thumb"></div>
        </div>
    `;

    // 로그아웃 링크 찾기
    const userInfo = document.querySelector('.user-info');
    if (userInfo) {
        // 로그아웃 링크 다음에 토글 버튼 추가
        userInfo.appendChild(toggleButton);
    }

    // 시스템 테마 감지
    const prefersDarkScheme = window.matchMedia('(prefers-color-scheme: dark)');

    // 저장된 테마 불러오기
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme) {
        document.documentElement.setAttribute('data-theme', savedTheme);
    } else if (prefersDarkScheme.matches) {
        document.documentElement.setAttribute('data-theme', 'dark');
    }

    // 테마 토글 이벤트
    toggleButton.addEventListener('click', function() {
        const currentTheme = document.documentElement.getAttribute('data-theme');
        const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
        
        document.documentElement.setAttribute('data-theme', newTheme);
        localStorage.setItem('theme', newTheme);

        // 테마 변경 이벤트 발생
        const event = new CustomEvent('themeChanged', {
            detail: { theme: newTheme }
        });
        document.dispatchEvent(event);
    });

    // 시스템 테마 변경 감지
    prefersDarkScheme.addListener((e) => {
        if (!localStorage.getItem('theme')) {
            const newTheme = e.matches ? 'dark' : 'light';
            document.documentElement.setAttribute('data-theme', newTheme);
        }
    });
}); 