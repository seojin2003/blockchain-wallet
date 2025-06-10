<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>시세</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/css/theme.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="/js/theme.js"></script>
    <script src="/js/notification.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--bg-primary);
            color: var(--text-primary);
        }
        .nav {
            background-color: var(--nav-bg);
            padding: 15px 0;
            margin-bottom: 30px;
        }
        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            padding: 0 20px;
            gap: 40px;
        }
        .nav-logo {
            color: var(--nav-text);
            font-size: 20px;
            font-weight: bold;
            text-decoration: none;
        }
        .nav-menu {
            display: flex;
            gap: 20px;
        }
        .nav-menu a {
            color: var(--nav-text);
            text-decoration: none;
            padding: 5px 10px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .nav-menu a i {
            font-size: 16px;
        }
        .nav-menu a:hover {
            background-color: rgba(255,255,255,0.1);
        }
        .nav-menu a.active {
            background-color: rgba(255,255,255,0.2);
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .card {
            background-color: var(--bg-secondary);
            border-radius: 8px;
            box-shadow: var(--card-shadow);
            padding: 20px;
            margin-bottom: 20px;
        }
        .info-section {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }
        .chart-container {
            position: relative;
            height: 400px;
            margin-top: 20px;
            background-color: var(--bg-secondary);
            border-radius: 8px;
            padding: 20px;
            border: 1px solid var(--border-color);
        }
        .price-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            padding: 20px;
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 8px;
        }
        .price-item {
            text-align: center;
            padding: 10px;
            flex: 1;
            margin: 0 5px;
            border-radius: 6px;
            background-color: var(--bg-primary);
        }
        .price-label {
            font-size: 14px;
            color: var(--text-secondary);
            margin-bottom: 5px;
        }
        .price-value {
            font-size: 24px;
            font-weight: bold;
            color: var(--text-primary);
        }
        .price-change {
            font-size: 14px;
            margin-top: 5px;
        }
        .price-up {
            color: #ff5757 !important;
        }
        .price-down {
            color: #4d9eff !important;
        }
        .time-filter {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .time-button {
            padding: 8px 16px;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            background-color: var(--bg-secondary);
            color: var(--text-primary);
            cursor: pointer;
            transition: all 0.2s;
        }
        .time-button:hover {
            background-color: var(--bg-primary);
        }
        .time-button.active {
            background-color: #3498db;
            color: white;
            border-color: #3498db;
        }
        .user-info {
            margin-left: auto;
            display: flex;
            align-items: center;
            gap: 10px;
            color: white;
            font-size: 14px;
        }
        .user-info button {
            color: white;
            text-decoration: none;
            background: none;
            border: none;
            cursor: pointer;
            font-size: 14px;
            padding: 0;
        }
        .user-info button:hover {
            text-decoration: underline;
        }
        .price-premium {
            font-size: 14px;
            margin-top: 5px;
            color: #3498db;
        }
        .price-premium::before {
            content: "프리미엄 ";
        }
        h1, h2 {
            color: var(--text-primary);
            margin-bottom: 20px;
        }
        .notification-link {
            position: relative;
            display: inline-block;
        }
        
        .notification-badge {
            position: absolute;
            top: -8px;
            right: -8px;
            background-color: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 12px;
            min-width: 18px;
            text-align: center;
            font-weight: bold;
            z-index: 1;
        }
    </style>
</head>
<body>
    <div class="nav">
        <div class="nav-container">
            <a href="/wallet" class="nav-logo">블록체인 월렛</a>
            <div class="nav-menu">
                <a href="/wallet"><i class="fas fa-wallet"></i> 지갑</a>
                <a href="/chart" class="active"><i class="fas fa-chart-line"></i> 시세</a>
                <a href="/notifications" class="notification-link">
                    <i class="fas fa-bell"></i>
                    <span id="notification-count" class="notification-badge" style="display: none;">0</span>
                </a>
            </div>
            <div class="user-info">
                <span><sec:authentication property="principal.username"/>님</span>
                |
                <form action="/logout" method="post" style="display: inline;">
                    <sec:csrfInput />
                    <button type="submit">로그아웃</button>
                </form>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="card">
            <h1>이더리움 시세</h1>
            
            <div class="price-info">
                <div class="price-item">
                    <div class="price-label">업비트 현재가</div>
                    <div class="price-value"><span id="currentPrice">0원</span></div>
                    <div class="price-change" id="priceChange">0.00%</div>
                </div>
                <div class="price-item">
                    <div class="price-label">글로벌 시세</div>
                    <div class="price-value"><span id="globalPrice">0원</span></div>
                    <div class="price-premium" id="premium">0.00%</div>
                </div>
                <div class="price-item">
                    <div class="price-label">24시간 고가</div>
                    <div class="price-value"><span id="highPrice">0원</span></div>
                </div>
                <div class="price-item">
                    <div class="price-label">24시간 저가</div>
                    <div class="price-value"><span id="lowPrice">0원</span></div>
                </div>
                <div class="price-item">
                    <div class="price-label">24시간 거래량</div>
                    <div class="price-value"><span id="volume">0원</span></div>
                </div>
            </div>

            <div class="time-filter">
                <button class="time-button active" data-period="1D">1일</button>
                <button class="time-button" data-period="1W">1주일</button>
                <button class="time-button" data-period="1M">1개월</button>
                <button class="time-button" data-period="3M">3개월</button>
                <button class="time-button" data-period="1Y">1년</button>
            </div>

            <div class="chart-container">
                <canvas id="priceChart"></canvas>
            </div>
        </div>
    </div>

    <script>
        let chart = null;
        let lastUpdateTime = 0;
        const UPDATE_INTERVAL = 3000; // 3초
        let currentPeriod = '1D'; // 현재 선택된 기간

        // 차트 초기화 함수
        function initializeChart() {
            const ctx = document.getElementById('priceChart').getContext('2d');
            const isDarkMode = document.documentElement.getAttribute('data-theme') === 'dark';
            
            chart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: [],
                    datasets: [{
                        label: 'ETH/KRW',
                        data: [],
                        borderColor: isDarkMode ? '#3498db' : '#2563eb',
                        backgroundColor: isDarkMode ? 'rgba(52, 152, 219, 0.1)' : 'rgba(37, 99, 235, 0.1)',
                        borderWidth: 2.5,
                        pointRadius: 0,
                        pointHoverRadius: 6,
                        pointHoverBackgroundColor: isDarkMode ? '#3498db' : '#2563eb',
                        pointHoverBorderColor: isDarkMode ? '#3498db' : '#2563eb',
                        pointHoverBorderWidth: 2,
                        tension: 0.4,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    animation: {
                        duration: 300
                    },
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            mode: 'index',
                            intersect: false,
                            backgroundColor: isDarkMode ? '#2c3e50' : 'rgba(255, 255, 255, 0.95)',
                            titleColor: isDarkMode ? '#ffffff' : '#1e293b',
                            bodyColor: isDarkMode ? '#ffffff' : '#1e293b',
                            borderColor: isDarkMode ? '#34495e' : '#e2e8f0',
                            borderWidth: 1,
                            padding: 12,
                            cornerRadius: 8,
                            titleFont: {
                                size: 14,
                                weight: 'bold'
                            },
                            bodyFont: {
                                size: 13
                            },
                            displayColors: false,
                            callbacks: {
                                label: function(context) {
                                    let value = context.raw;
                                    return new Intl.NumberFormat('ko-KR', {
                                        style: 'currency',
                                        currency: 'KRW',
                                        maximumFractionDigits: 0
                                    }).format(value);
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            grid: {
                                display: true,
                                color: isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.05)',
                                drawBorder: false
                            },
                            ticks: {
                                maxRotation: 0,
                                minRotation: 0,
                                autoSkip: true,
                                maxTicksLimit: 12,
                                padding: 8,
                                font: {
                                    size: 11,
                                    weight: '500'
                                },
                                color: isDarkMode ? '#a0aec0' : '#64748b'
                            }
                        },
                        y: {
                            grid: {
                                color: isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.05)',
                                drawBorder: false,
                                lineWidth: 1
                            },
                            ticks: {
                                callback: function(value) {
                                    return new Intl.NumberFormat('ko-KR', {
                                        style: 'currency',
                                        currency: 'KRW',
                                        maximumFractionDigits: 0
                                    }).format(value);
                                },
                                padding: 8,
                                font: {
                                    size: 11,
                                    weight: '500'
                                },
                                color: isDarkMode ? '#a0aec0' : '#64748b'
                            }
                        }
                    },
                    interaction: {
                        mode: 'nearest',
                        axis: 'x',
                        intersect: false
                    }
                }
            });
        }

        // 가격 변화 색상 설정 함수
        function setPriceChangeColor(element, value) {
            if (value > 0) {
                element.className = 'price-change price-up';
            } else if (value < 0) {
                element.className = 'price-change price-down';
            } else {
                element.className = 'price-change';
            }
        }

        // 차트 데이터 업데이트 함수
        async function updateChart(period, force = false) {
            currentPeriod = period;
            const now = Date.now();
            if (!force && now - lastUpdateTime < UPDATE_INTERVAL) {
                return;
            }
            lastUpdateTime = now;

            try {
                console.log('차트 업데이트 요청 - 기간:', period);
                const response = await fetch(`/api/chart/price?period=${period}&t=${now}`, {
                    headers: {
                        'Cache-Control': 'no-cache',
                        'Pragma': 'no-cache'
                    }
                });

                if (!response.ok) {
                    if (response.status === 401) {
                        window.location.href = '/login';
                        throw new Error('로그인이 필요합니다.');
                    }
                    throw new Error('API 호출 중 오류가 발생했습니다.');
                }

                const data = await response.json();
                console.log('받은 데이터:', data);
                
                if (!chart) {
                    initializeChart();
                }

                // 차트 데이터 업데이트
                chart.data.labels = data.labels;
                chart.data.datasets[0].data = data.prices;

                // Y축 범위 설정
                const prices = data.prices.map(p => parseFloat(p));
                const minPrice = Math.min(...prices);
                const maxPrice = Math.max(...prices);
                const padding = (maxPrice - minPrice) * 0.1;
                
                chart.options.scales.y.min = Math.floor(minPrice - padding);
                chart.options.scales.y.max = Math.ceil(maxPrice + padding);
                
                // 차트 업데이트
                chart.update();

                // 가격 정보 업데이트
                document.getElementById('currentPrice').textContent = data.currentPrice;
                document.getElementById('globalPrice').textContent = data.globalPrice;
                document.getElementById('highPrice').textContent = data.highPrice;
                document.getElementById('lowPrice').textContent = data.lowPrice;
                document.getElementById('volume').textContent = data.volume;

                const priceChange = document.getElementById('priceChange');
                const changeValue = parseFloat(data.priceChange);
                priceChange.textContent = (changeValue >= 0 ? '+' : '') + changeValue.toFixed(2) + '%';
                setPriceChangeColor(priceChange, changeValue);

                const premium = document.getElementById('premium');
                const premiumValue = parseFloat(data.premium);
                premium.textContent = (premiumValue >= 0 ? '+' : '') + premiumValue.toFixed(2) + '%';
                setPriceChangeColor(premium, premiumValue);

                console.log('차트 업데이트 완료 - 기간:', period);

            } catch (error) {
                console.error('Error:', error);
            }
        }

        // 시간 필터 버튼 이벤트
        document.querySelectorAll('.time-button').forEach(button => {
            button.addEventListener('click', async function() {
                // 이전 업데이트 타이머 제거
                if (window.updateTimer) {
                    clearInterval(window.updateTimer);
                }
                
                document.querySelectorAll('.time-button').forEach(btn => btn.classList.remove('active'));
                this.classList.add('active');
                
                // 차트 업데이트 전에 로딩 표시
                if (chart) {
                    chart.data.datasets[0].data = [];
                    chart.update('none');
                }
                
                await updateChart(this.dataset.period, true);
                
                // 새로운 업데이트 타이머 설정
                window.updateTimer = setInterval(() => {
                    updateChart(this.dataset.period);
                }, UPDATE_INTERVAL);
            });
        });

        function updateNotificationCount() {
            $.ajax({
                url: '/notifications/count',
                method: 'GET',
                success: function(response) {
                    const badge = $('#notification-count');
                    if (response.count > 0) {
                        badge.text(response.count).show();
                    } else {
                        badge.hide();
                    }
                },
                error: function(xhr, status, error) {
                    console.error('알림 개수 업데이트 실패:', error);
                }
            });
        }

        $(document).ready(function() {
            // 초기 알림 개수 업데이트
            updateNotificationCount();
            
            // 30초마다 알림 개수 업데이트
            setInterval(updateNotificationCount, 30000);

            // 차트 초기화 및 업데이트
            initializeChart();
            updateChart('1D', true);
            
            // 차트 자동 업데이트 타이머 설정
            window.updateTimer = setInterval(() => {
                updateChart('1D');
            }, UPDATE_INTERVAL);
        });

        // 페이지 언로드 시 타이머 정리
        window.addEventListener('beforeunload', function() {
            if (window.updateTimer) {
                clearInterval(window.updateTimer);
            }
        });
    </script>
</body>
</html> 