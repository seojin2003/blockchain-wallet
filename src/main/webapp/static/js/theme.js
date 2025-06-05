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
document.addEventListener('DOMContentLoaded', () => {
    // 저장된 테마 또는 시스템 설정 확인
    const savedTheme = localStorage.getItem('theme');
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    const theme = savedTheme || (prefersDark ? 'dark' : 'light');
    
    setTheme(theme);

    // 테마 토글 버튼이 없으면 생성
    if (!document.querySelector('.theme-toggle')) {
        const toggleButton = document.createElement('button');
        toggleButton.className = 'theme-toggle';
        toggleButton.innerHTML = `<span id="themeIcon">${theme === 'dark' ? '☀️' : '🌙'}</span>`;
        toggleButton.onclick = toggleTheme;
        document.body.appendChild(toggleButton);
    }
}); 