<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>시세</title>
    <script src="/static/js/theme.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/static/css/theme.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="/js/notification.js"></script>
    <script src="/js/chart.js"></script>
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
            background-color: var(--bg-primary);
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        h1 {
            font-size: 24px;
            font-weight: bold;
            color: var(--text-primary);
            margin-bottom: 24px;
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
    <jsp:include page="common/header.jsp" />
    
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
        $(document).ready(function() {
            // 알림 개수 업데이트
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

            // 초기 알림 개수 업데이트
            updateNotificationCount();
            
            // 30초마다 알림 개수 업데이트
            setInterval(updateNotificationCount, 30000);

            // ChartManager 초기화
            if (window.ChartManager) {
                ChartManager.init();
            }
        });
    </script>
</body>
</html> 