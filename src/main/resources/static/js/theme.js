// 초기 테마 설정을 즉시 실행
(function() {
    const prefersDarkScheme = window.matchMedia('(prefers-color-scheme: dark)');
    const savedTheme = localStorage.getItem('theme');
    const theme = savedTheme || (prefersDarkScheme.matches ? 'dark' : 'light');
    document.documentElement.setAttribute('data-theme', theme);
})();

// 테마 설정 함수
function setTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem('theme', theme);
    
    // 체크박스 상태 업데이트
    const themeToggle = document.querySelector('.theme-controller');
    if (themeToggle) {
        themeToggle.checked = theme === 'dark';
    }

    // 토글 버튼 아이콘 업데이트
    const toggleThumb = document.querySelector('.toggle-thumb');
    if (toggleThumb) {
        toggleThumb.textContent = theme === 'dark' ? '🌙' : '☀️';
    }
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

// DOM 로드 후 테마 컨트롤러 설정
document.addEventListener('DOMContentLoaded', function() {
    // 테마 토글 버튼 생성
    const toggleLabel = document.createElement('label');
    toggleLabel.className = 'toggle';
    toggleLabel.innerHTML = `
        <input type="checkbox" class="theme-controller" />
        <div class="toggle-thumb">☀️</div>
    `;

    // 로그아웃 링크 찾기
    const userInfo = document.querySelector('.user-info');
    if (userInfo) {
        // 로그아웃 링크 다음에 토글 버튼 추가
        userInfo.appendChild(toggleLabel);
    }

    // 저장된 테마 불러오기
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme) {
        setTheme(savedTheme);
    }

    // 테마 토글 이벤트
    const themeToggle = document.querySelector('.theme-controller');
    if (themeToggle) {
        themeToggle.addEventListener('change', function() {
            const newTheme = this.checked ? 'dark' : 'light';
            setTheme(newTheme);
        });
    }

    // 시스템 테마 변경 감지
    const prefersDarkScheme = window.matchMedia('(prefers-color-scheme: dark)');
    prefersDarkScheme.addListener((e) => {
        if (!localStorage.getItem('theme')) {
            const newTheme = e.matches ? 'dark' : 'light';
            setTheme(newTheme);
        }
    });
}); 