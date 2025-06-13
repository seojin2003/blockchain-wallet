<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<head>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
</head>

<style>
    .nav {
        background-color: var(--nav-bg);
        padding: 15px 0;
        margin-bottom: 30px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
    .nav-container {
        max-width: 1200px;
        margin: 0 auto;
        display: flex;
        align-items: center;
        padding: 0 20px;
        gap: 40px;
        height: 40px;
    }
    .nav-logo {
        color: white;
        font-size: 20px;
        font-weight: bold;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 8px;
        height: 100%;
    }
    .nav-logo:hover {
        opacity: 0.9;
    }
    .nav-menu {
        display: flex;
        gap: 20px;
        height: 100%;
    }
    .nav-menu a {
        color: white;
        text-decoration: none;
        padding: 8px 16px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 14px;
        transition: all 0.2s;
        height: 100%;
    }
    .nav-menu a i {
        font-size: 16px;
    }
    .nav-menu a:hover {
        background-color: rgba(255, 255, 255, 0.1);
    }
    .nav-menu a.active {
        background-color: rgba(255, 255, 255, 0.2);
    }
    .user-info {
        margin-left: auto;
        display: flex;
        align-items: center;
        gap: 20px;
        color: white;
        height: 100%;
    }
    .notification-link {
        position: relative;
        color: white;
        text-decoration: none;
        padding: 8px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s;
        font-size: 16px;
        height: 100%;
    }
    .notification-link:hover {
        background-color: rgba(255, 255, 255, 0.1);
    }
    .notification-badge {
        position: absolute;
        top: -8px;
        right: -8px;
        background-color: #e74c3c;
        color: white;
        border-radius: 50%;
        padding: 2px 6px;
        font-size: 12px;
        min-width: 18px;
        height: 18px;
        text-align: center;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .user-profile {
        display: flex;
        align-items: center;
        gap: 8px;
        color: white;
        font-size: 14px;
        height: 100%;
    }
    .logout-button {
        background: none;
        border: none;
        color: white;
        cursor: pointer;
        padding: 0;
        font-size: 14px;
        display: flex;
        align-items: center;
        height: 100%;
    }
    .logout-button:hover {
        text-decoration: underline;
    }
</style>

<div class="nav">
    <div class="nav-container">
        <a href="/wallet" class="nav-logo">
            <i class="fas fa-wallet"></i>
            블록체인 월렛
        </a>
        <div class="nav-menu">
            <a href="/wallet" class="${pageContext.request.servletPath == '/WEB-INF/views/wallet.jsp' ? 'active' : ''}">
                <i class="fas fa-wallet"></i>
                지갑
            </a>
            <a href="/chart" class="${pageContext.request.servletPath == '/WEB-INF/views/chart.jsp' ? 'active' : ''}">
                <i class="fas fa-chart-line"></i>
                시세
            </a>
            <a href="/info" class="${pageContext.request.servletPath == '/WEB-INF/views/info.jsp' ? 'active' : ''}">
                <i class="fas fa-info-circle"></i>
                정보
            </a>
        </div>
        <div class="user-info">
            <a href="/notifications" class="notification-link">
                <i class="fas fa-bell"></i>
                <span id="notification-count" class="notification-badge" style="display: none;">0</span>
            </a>
            <div class="user-profile">
                <i class="fas fa-user"></i>
                <a href="/mypage" style="color:inherit; text-decoration:none;"><sec:authentication property="principal.username"/>님</a>
            </div>
            <form action="/logout" method="post" style="display: flex; align-items: center; height: 100%;">
                <sec:csrfInput />
                <button type="submit" class="logout-button">로그아웃</button>
            </form>
        </div>
    </div>
</div>

<script>
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

    $(document).ready(function() {
        updateNotificationCount();
        setInterval(updateNotificationCount, 30000);
    });
</script> 