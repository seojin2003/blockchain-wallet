<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>시세 차트</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }
        .nav {
            background-color: #2c3e50;
            padding: 15px 0;
            margin-bottom: 30px;
        }
        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }
        .nav-logo {
            color: white;
            font-size: 20px;
            font-weight: bold;
            text-decoration: none;
        }
        .nav-menu {
            display: flex;
            gap: 20px;
        }
        .nav-menu a {
            color: white;
            text-decoration: none;
            padding: 5px 10px;
            border-radius: 4px;
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
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
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
        }
        .price-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }
        .price-item {
            text-align: center;
        }
        .price-label {
            font-size: 14px;
            color: #666;
            margin-bottom: 5px;
        }
        .price-value {
            font-size: 24px;
            font-weight: bold;
            color: #2c3e50;
        }
        .price-change {
            font-size: 14px;
            margin-top: 5px;
        }
        .price-up {
            color: #2ecc71;
        }
        .price-down {
            color: #e74c3c;
        }
        .time-filter {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .time-button {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            background-color: #f8f9fa;
            color: #666;
            cursor: pointer;
            transition: all 0.2s;
        }
        .time-button:hover {
            background-color: #e9ecef;
        }
        .time-button.active {
            background-color: #2c3e50;
            color: white;
        }
        .user-info {
            color: white;
        }
        .price-premium {
            font-size: 14px;
            margin-top: 5px;
            color: #3498db;
        }
        .price-premium::before {
            content: "프리미엄 ";
        }
    </style>
</head>
<body>
    <div class="nav">
        <div class="nav-container">
            <a href="/wallet" class="nav-logo">블록체인 월렛</a>
            <div class="nav-menu">
                <a href="/wallet">지갑</a>
                <a href="/chart" class="active">시세</a>
            </div>
            <div class="user-info">
                ${member.name}님 | <a href="/logout" style="color: white; text-decoration: none;">로그아웃</a>
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
                <button class="time-button" data-period="1W">1주</button>
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

        // 차트 초기화 함수
        function initializeChart() {
            const ctx = document.getElementById('priceChart').getContext('2d');
            chart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: [],
                    datasets: [{
                        label: 'ETH/KRW',
                        data: [],
                        borderColor: '#2c3e50',
                        borderWidth: 2,
                        pointRadius: 1,
                        pointHoverRadius: 5,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            mode: 'index',
                            intersect: false,
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
                                display: false
                            },
                            ticks: {
                                maxRotation: 45,
                                minRotation: 45,
                                autoSkip: true,
                                maxTicksLimit: 12,
                                font: {
                                    size: 11
                                }
                            }
                        },
                        y: {
                            grid: {
                                color: '#f0f0f0'
                            },
                            ticks: {
                                callback: function(value) {
                                    if (value >= 1000000000000) {
                                        return (value / 1000000000000).toFixed(1) + '조';
                                    } else if (value >= 100000000) {
                                        return (value / 100000000).toFixed(1) + '억';
                                    } else if (value >= 10000) {
                                        return (value / 10000).toFixed(1) + '만';
                                    }
                                    return value;
                                },
                                font: {
                                    size: 11
                                }
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
                element.style.color = '#c84a31';
            } else if (value < 0) {
                element.style.color = '#1261c4';
            } else {
                element.style.color = '#333';
            }
        }

        // 차트 데이터 업데이트 함수
        function updateChart(period) {
            fetch(`/api/chart/price?period=${period}`)
                .then(response => {
                    if (!response.ok) {
                        if (response.status === 401) {
                            window.location.href = '/login';
                            throw new Error('로그인이 필요합니다.');
                        }
                        throw new Error('API 호출 중 오류가 발생했습니다.');
                    }
                    return response.json();
                })
                .then(data => {
                    if (!chart) {
                        initializeChart();
                    }

                    chart.data.labels = data.labels;
                    chart.data.datasets[0].data = data.prices;
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
                })
                .catch(error => {
                    console.error('Error:', error);
                });
        }

        // 시간 필터 버튼 이벤트
        document.querySelectorAll('.time-button').forEach(button => {
            button.addEventListener('click', function() {
                document.querySelectorAll('.time-button').forEach(btn => btn.classList.remove('active'));
                this.classList.add('active');
                updateChart(this.dataset.period);
            });
        });

        // 페이지 로드 시 차트 초기화 및 데이터 로드
        document.addEventListener('DOMContentLoaded', function() {
            initializeChart();
            updateChart('1D');
        });

        // 5초마다 데이터 업데이트
        setInterval(() => {
            const activePeriod = document.querySelector('.time-button.active').dataset.period;
            updateChart(activePeriod);
        }, 5000);
    </script>
</body>
</html> 