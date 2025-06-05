<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>알림</title>
    <link rel="stylesheet" href="/css/theme.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/js/theme.js"></script>
    <style>
        .notification-list {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .notification-item {
            background-color: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background-color 0.3s;
        }
        .notification-item:hover {
            background-color: var(--bg-hover);
        }
        .notification-item.unread {
            border-left: 4px solid #3498db;
        }
        .notification-content {
            flex: 1;
        }
        .notification-title {
            font-weight: bold;
            color: var(--text-primary);
            margin-bottom: 5px;
        }
        .notification-message {
            color: var(--text-secondary);
            font-size: 14px;
        }
        .notification-time {
            color: var(--text-secondary);
            font-size: 12px;
            margin-top: 5px;
        }
        .notification-actions {
            margin-left: 15px;
        }
        .mark-read-btn {
            background: none;
            border: none;
            color: #3498db;
            cursor: pointer;
            padding: 5px;
            font-size: 14px;
        }
        .mark-read-btn:hover {
            text-decoration: underline;
        }
        .notification-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .mark-all-read-btn {
            background-color: var(--button-primary);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
        }
        .mark-all-read-btn:hover {
            opacity: 0.9;
        }
        .empty-notifications {
            text-align: center;
            padding: 40px;
            color: var(--text-secondary);
        }
    </style>
</head>
<body>
    <div class="nav">
        <div class="nav-container">
            <a href="/wallet" class="nav-logo">블록체인 월렛</a>
            <div class="nav-menu">
                <a href="/wallet">지갑</a>
                <a href="/chart">시세</a>
                <a href="/notifications" class="active">알림</a>
            </div>
            <div class="user-info">
                ${member.name}님 | <a href="/logout" style="color: white; text-decoration: none;">로그아웃</a>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="notification-list">
            <div class="notification-header">
                <h1>알림</h1>
                <button class="mark-all-read-btn" onclick="markAllAsRead()">모두 읽음 표시</button>
            </div>

            <c:choose>
                <c:when test="${empty notifications}">
                    <div class="empty-notifications">
                        <p>알림이 없습니다.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${notifications}" var="notification">
                        <div class="notification-item ${notification.read ? '' : 'unread'}" data-id="${notification.id}">
                            <div class="notification-content">
                                <div class="notification-title">${notification.title}</div>
                                <div class="notification-message">${notification.message}</div>
                                <div class="notification-time">
                                    <fmt:formatDate value="${notification.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                </div>
                            </div>
                            <c:if test="${!notification.read}">
                                <div class="notification-actions">
                                    <button class="mark-read-btn" onclick="markAsRead(${notification.id})">읽음 표시</button>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        function markAsRead(id) {
            $.post('/notifications/' + id + '/read')
                .done(function() {
                    const notification = $('[data-id="' + id + '"]');
                    notification.removeClass('unread');
                    notification.find('.notification-actions').remove();
                });
        }

        function markAllAsRead() {
            $.post('/notifications/read-all')
                .done(function() {
                    $('.notification-item').removeClass('unread');
                    $('.notification-actions').remove();
                });
        }
    </script>
</body>
</html> 