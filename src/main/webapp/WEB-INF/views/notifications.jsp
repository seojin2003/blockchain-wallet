<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>알림</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/static/css/theme.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="/static/js/theme.js"></script>
    <sec:csrfMetaTags />
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Arial', sans-serif;
            background-color: var(--bg-primary);
            color: var(--text-primary);
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }

        .notification-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .notification-actions {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 8px 16px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .btn:hover {
            opacity: 0.9;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-danger {
            background-color: var(--danger-color);
            color: white;
        }

        .notification-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .notification-item {
            background-color: var(--bg-secondary);
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            gap: 15px;
            position: relative;
            border-left: 4px solid transparent;
            transition: all 0.3s ease;
            opacity: 0.7;
        }

        .notification-item.unread {
            background-color: #ffffff;
            border-left: 4px solid #3498db;
            opacity: 1;
            box-shadow: 0 2px 8px rgba(52, 152, 219, 0.2);
        }

        .notification-item.unread .notification-title {
            font-weight: 700;
            color: #3498db;
        }

        .notification-item.unread .notification-message {
            color: var(--text-primary);
            opacity: 1;
            font-weight: 500;
        }

        .notification-item.unread .notification-time {
            font-weight: 600;
            color: #3498db;
        }

        .notification-icon {
            font-size: 24px;
            color: var(--text-secondary);
            opacity: 0.7;
            transition: all 0.2s ease;
        }

        .notification-item.unread .notification-icon {
            color: #3498db;
            opacity: 1;
        }

        .notification-content {
            flex-grow: 1;
        }

        .notification-title {
            font-weight: normal;
            margin-bottom: 5px;
            color: var(--text-secondary);
            opacity: 0.9;
        }

        .notification-message {
            color: var(--text-secondary);
            font-size: 14px;
            opacity: 0.8;
        }

        .notification-time {
            color: var(--text-secondary);
            font-size: 12px;
            margin-bottom: 10px;
            opacity: 0.7;
        }

        .notification-item-actions {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }

        .btn-text {
            background: none;
            border: none;
            padding: 4px 8px;
            color: var(--text-secondary);
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 4px;
            border-radius: 4px;
            transition: all 0.2s ease;
        }

        .btn-text:hover {
            color: var(--text-primary);
            background-color: rgba(255, 255, 255, 0.1);
        }

        .notification-item.unread .btn-text {
            color: #3498db;
        }

        .notification-item.unread .btn-text:hover {
            background-color: rgba(52, 152, 219, 0.1);
            color: #2980b9;
        }

        .no-notifications {
            text-align: center;
            padding: 40px;
            background-color: var(--bg-secondary);
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .no-notifications i {
            font-size: 48px;
            color: var(--text-secondary);
            margin-bottom: 20px;
        }

        .no-notifications p {
            color: var(--text-secondary);
            margin: 0;
        }

        .page-title {
            font-size: 24px;
            font-weight: bold;
            margin: 0;
            color: var(--text-primary);
        }
    </style>
</head>
<body>
    <%@ include file="common/header.jsp" %>
    
    <div class="container">
        <div class="notification-header">
            <h1 class="page-title">알림</h1>
            <c:if test="${not empty notifications}">
                <div class="notification-actions">
                    <button class="btn btn-primary" onclick="markAllAsRead()">
                        <i class="fas fa-check-double"></i>
                        모두 읽음
                    </button>
                    <button class="btn btn-danger" onclick="deleteAllNotifications()">
                        <i class="fas fa-trash"></i>
                        모두 삭제
                    </button>
                </div>
            </c:if>
        </div>
        
        <div class="notification-list">
            <c:choose>
                <c:when test="${empty notifications}">
                    <div class="no-notifications">
                        <i class="fas fa-bell-slash"></i>
                        <p>새로운 알림이 없습니다.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${notifications}" var="notification">
                        <div class="notification-item ${notification.read ? '' : 'unread'}" data-id="${notification.id}">
                            <div class="notification-icon">
                                <i class="fas fa-coins"></i>
                            </div>
                            <div class="notification-content">
                                <div class="notification-time">
                                    <fmt:parseDate value="${notification.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                    <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm"/>
                                </div>
                                <div class="notification-title">${notification.title}</div>
                                <div class="notification-message">${notification.message}</div>
                                <div class="notification-item-actions">
                                    <c:if test="${!notification.read}">
                                        <button class="btn-text read-button" onclick="markAsRead(${notification.id})">
                                            <i class="fas fa-check"></i>
                                            읽음 표시
                                        </button>
                                    </c:if>
                                    <button class="btn-text" onclick="deleteNotification(${notification.id})">
                                        <i class="fas fa-trash"></i>
                                        삭제
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            const token = $("meta[name='_csrf']").attr("content");
            const header = $("meta[name='_csrf_header']").attr("content");

            // CSRF 토큰 설정
            $(document).ajaxSend(function(e, xhr, options) {
                xhr.setRequestHeader(header, token);
            });

            window.markAsRead = function(id) {
                if (confirm('이 알림을 읽음 처리하시겠습니까?')) {
                    $.ajax({
                        url: '/notifications/' + id + '/read',
                        type: 'POST',
                        success: function(response) {
                            location.reload();
                        },
                        error: function(xhr, status, error) {
                            console.error('Error:', error);
                            alert('알림 읽음 처리 중 오류가 발생했습니다.');
                        }
                    });
                }
            };

            window.deleteNotification = function(id) {
                if (confirm('이 알림을 삭제하시겠습니까?')) {
                    $.ajax({
                        url: '/notifications/' + id + '/delete',
                        type: 'POST',
                        success: function(response) {
                            location.reload();
                        },
                        error: function(xhr, status, error) {
                            console.error('Error:', error);
                            alert('알림 삭제 중 오류가 발생했습니다.');
                        }
                    });
                }
            };

            window.markAllAsRead = function() {
                if (confirm('모든 알림을 읽음 처리하시겠습니까?')) {
                    $.ajax({
                        url: '/notifications/read-all',
                        type: 'POST',
                        success: function(response) {
                            location.reload();
                        },
                        error: function(xhr, status, error) {
                            console.error('Error:', error);
                            alert('모든 알림 읽음 처리 중 오류가 발생했습니다.');
                        }
                    });
                }
            };

            window.deleteAllNotifications = function() {
                if (confirm('모든 알림을 삭제하시겠습니까?')) {
                    $.ajax({
                        url: '/notifications/delete-all',
                        type: 'POST',
                        success: function(response) {
                            location.reload();
                        },
                        error: function(xhr, status, error) {
                            console.error('Error:', error);
                            alert('모든 알림 삭제 중 오류가 발생했습니다.');
                        }
                    });
                }
            };

            function updateNotificationCount() {
                $.ajax({
                    url: '/notifications/count',
                    type: 'GET',
                    success: function(response) {
                        const count = response.count;
                        const badge = $('#notification-count');
                        if (count > 0) {
                            badge.text(count).show();
                        } else {
                            badge.hide();
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('Error:', error);
                    }
                });
            }

            // 초기 알림 개수 업데이트
            updateNotificationCount();
            // 30초마다 알림 개수 업데이트
            setInterval(updateNotificationCount, 30000);
        });
    </script>
</body>
</html> 