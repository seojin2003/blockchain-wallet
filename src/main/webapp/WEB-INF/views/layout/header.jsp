<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>블록체인 월렛</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/theme.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="/js/theme.js"></script>
</head>
<body>
    <div class="nav">
        <div class="nav-container">
            <div class="nav-left">
                <a href="/wallet" class="nav-logo">블록체인 월렛</a>
                <div class="nav-menu">
                    <a href="/wallet" class="${fn:contains(pageContext.request.requestURI, '/wallet') ? 'active' : ''}">
                        <i class="fas fa-wallet"></i>
                        지갑
                    </a>
                    <a href="/chart" class="${fn:contains(pageContext.request.requestURI, '/chart') ? 'active' : ''}">
                        <i class="fas fa-chart-line"></i>
                        시세
                    </a>
                    <a href="/notifications" class="notification-link">
                        <i class="fas fa-bell"></i>
                        <span id="notification-count" class="notification-badge" style="display: none;">0</span>
                    </a>
                </div>
            </div>
            <div class="nav-right">
                <button class="theme-toggle" onclick="toggleTheme()">
                    <i class="fas fa-sun light-icon"></i>
                    <i class="fas fa-moon dark-icon"></i>
                </button>
                <div class="user-info">
                    <span>${member.name}님</span> | 
                    <form action="/logout" method="post" style="display: inline;">
                        <sec:csrfInput />
                        <button type="submit" class="logout-btn">로그아웃</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html> 