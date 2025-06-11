<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>정보</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/static/js/theme.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/static/css/theme.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--bg-primary);
            color: var(--text-primary);
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
        }
        .info-section h3 {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: var(--text-primary);
        }
        .info-section p {
            margin-bottom: 10px;
            line-height: 1.6;
            color: var(--text-secondary);
        }
        .button {
            display: inline-block;
            padding: 10px 20px;
            background-color: var(--button-primary);
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            transition: opacity 0.2s;
        }
        .button:hover {
            opacity: 0.9;
        }
        .link-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .link-list li {
            margin-bottom: 10px;
        }
        .link-list a {
            color: var(--link-color);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .link-list a:hover {
            text-decoration: underline;
        }
        .icon {
            font-size: 16px;
            color: var(--text-secondary);
        }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp" />

    <div class="container">
        <div class="card">
            <h2 class="text-2xl font-bold mb-4">이더리움 정보</h2>
            
            <div class="info-section">
                <h3>이더리움이란?</h3>
                <p>
                    이더리움은 스마트 계약 기능을 갖춘 공개 블록체인 플랫폼입니다.
                    이더리움은 비탈릭 부테린이 2013년에 제안하고 2015년에 출시했습니다.
                    이더리움은 블록체인 기술을 기반으로 하며, 분산 애플리케이션(DApp)을 구축하고 실행할 수 있는 플랫폼을 제공합니다.
                </p>
            </div>

            <div class="info-section">
                <h3>주요 특징</h3>
                <ul class="list-disc list-inside mb-4 text-gray-600">
                    <li>스마트 계약: 프로그래밍 가능한 계약을 생성하고 실행</li>
                    <li>탈중앙화: 중앙 기관 없이 P2P 네트워크로 운영</li>
                    <li>보안성: 암호화 기술로 거래의 안전성 보장</li>
                    <li>확장성: 다양한 응용 프로그램 개발 가능</li>
                </ul>
            </div>

            <div class="info-section">
                <h3>관련 문서</h3>
                <ul class="link-list">
                    <li>
                        <a href="https://ethereum.org/ko/whitepaper/" target="_blank">
                            <i class="fas fa-file-pdf icon"></i>
                            이더리움 백서 (한국어)
                        </a>
                    </li>
                    <li>
                        <a href="https://ethereum.org/ko/developers/docs/" target="_blank">
                            <i class="fas fa-book icon"></i>
                            개발자 문서
                        </a>
                    </li>
                    <li>
                        <a href="https://ethereum.org/ko/learn/" target="_blank">
                            <i class="fas fa-graduation-cap icon"></i>
                            이더리움 학습 자료
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            // 알림 카운트 업데이트
            function updateNotificationCount() {
                $.get('/notifications/count', function(response) {
                    const count = response.count;
                    const badge = $('#notification-count');
                    if (count > 0) {
                        badge.text(count).show();
                    } else {
                        badge.hide();
                    }
                });
            }

            // 초기 알림 카운트 업데이트 및 주기적 업데이트 설정
            updateNotificationCount();
            setInterval(updateNotificationCount, 30000);
        });
    </script>
</body>
</html> 