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
            display: flex;
            gap: 10px;
        }
        .mark-read-btn, .delete-btn {
            background: none;
            border: none;
            cursor: pointer;
            padding: 5px;
            font-size: 14px;
        }
        .mark-read-btn {
            color: #3498db;
        }
        .delete-btn {
            color: #e74c3c;
        }
        .mark-read-btn:hover, .delete-btn:hover {
            text-decoration: underline;
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
        .mark-all-read-btn {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: opacity 0.3s;
        }
        .delete-all-btn {
            background-color: #e74c3c;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: opacity 0.3s;
        }
        .mark-all-read-btn:hover, .delete-all-btn:hover {
            opacity: 0.9;
        }
        .empty-notifications {
            text-align: center;
            padding: 40px;
            color: var(--text-secondary);
            background-color: var(--bg-secondary);
            border-radius: 8px;
            border: 1px solid var(--border-color);
        }
        .user-info {
            margin-left: auto;
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--nav-text);
            font-size: 14px;
        }
        .user-info button {
            color: var(--nav-text);
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
        h1 {
            color: var(--text-primary);
            font-size: 24px;
            font-weight: bold;
            margin: 0;
        }
        .notification-link {
            position: relative;
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
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="nav">
        <div class="nav-container">
            <a href="/wallet" class="nav-logo">블록체인 월렛</a>
            <div class="nav-menu">
                <a href="/wallet"><i class="fas fa-wallet"></i> 지갑</a>
                <a href="/chart"><i class="fas fa-chart-line"></i> 시세</a>
                <a href="/notifications" class="active notification-link">
                    <i class="fas fa-bell"></i>
                    <span id="notification-count" class="notification-badge" style="display: none;">0</span>
                </a>
            </div>
            <div class="user-info">
                ${member.name}님 | 
                <form action="/logout" method="post" style="display: inline;">
                    <sec:csrfInput />
                    <button type="submit" style="background: none; border: none; color: var(--nav-text); text-decoration: none; cursor: pointer;">로그아웃</button>
                </form>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="notification-list">
            <div class="notification-header">
                <h1>알림</h1>
                <c:if test="${not empty notifications}">
                    <div class="notification-actions">
                        <button class="mark-all-read-btn" onclick="markAllAsRead()">모두 읽음</button>
                        <button class="delete-all-btn" onclick="deleteAllNotifications()">모두 삭제</button>
                    </div>
                </c:if>
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
                                    <fmt:parseDate value="${notification.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                                    <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm:ss" />
                                </div>
                            </div>
                            <div class="notification-actions">
                                <c:if test="${!notification.read}">
                                    <button class="mark-read-btn" onclick="markAsRead(${notification.id})">읽음 표시</button>
                                </c:if>
                                <button class="delete-btn" onclick="deleteNotification(${notification.id})">삭제</button>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            // CSRF 토큰 가져오기
            const token = $("input[name='_csrf']").val();
            const header = "${_csrf.headerName}";

            // AJAX 요청 전에 CSRF 토큰 설정
            $.ajaxSetup({
                beforeSend: function(xhr) {
                    xhr.setRequestHeader(header, token);
                }
            });

            function markAsRead(id) {
                $.ajax({
                    url: '/notifications/' + id + '/read',
                    type: 'POST',
                    success: function() {
                        const notification = $('[data-id="' + id + '"]');
                        notification.removeClass('unread');
                        notification.find('.mark-read-btn').remove();
                        updateNotificationCount();
                    },
                    error: function(xhr, status, error) {
                        console.error('Error:', error);
                        handleError(xhr);
                    }
                });
            }

            function deleteNotification(id) {
                if (confirm('이 알림을 삭제하시겠습니까?')) {
                    $.ajax({
                        url: '/notifications/' + id,
                        type: 'DELETE',
                        success: function() {
                            const notification = $('[data-id="' + id + '"]');
                            notification.fadeOut(300, function() {
                                notification.remove();
                                checkEmptyNotifications();
                                updateNotificationCount();
                            });
                        },
                        error: function(xhr, status, error) {
                            console.error('Error:', error);
                            handleError(xhr);
                        }
                    });
                }
            }

            function markAllAsRead() {
                $.ajax({
                    url: '/notifications/read-all',
                    type: 'POST',
                    success: function() {
                        $('.notification-item').removeClass('unread');
                        $('.mark-read-btn').remove();
                        updateNotificationCount();
                    },
                    error: function(xhr, status, error) {
                        console.error('Error:', error);
                        handleError(xhr);
                    }
                });
            }

            function deleteAllNotifications() {
                if (confirm('모든 알림을 삭제하시겠습니까?')) {
                    $.ajax({
                        url: '/notifications/delete-all',
                        type: 'DELETE',
                        success: function() {
                            $('.notification-item').fadeOut(300, function() {
                                $(this).remove();
                                showEmptyNotifications();
                                updateNotificationCount();
                            });
                        },
                        error: function(xhr, status, error) {
                            console.error('Error:', error);
                            handleError(xhr);
                        }
                    });
                }
            }

            function handleError(xhr) {
                if (xhr.status === 401) {
                    window.location.href = '/login';
                } else if (xhr.status === 403) {
                    alert('세션이 만료되었습니다. 다시 로그인해주세요.');
                    window.location.href = '/login';
                } else {
                    alert('작업 중 오류가 발생했습니다. 다시 시도해주세요.');
                }
            }

            function showEmptyNotifications() {
                const emptyMessage = `
                    <div class="empty-notifications">
                        <p>알림이 없습니다.</p>
                    </div>
                `;
                $('.notification-list').html(
                    '<h1 class="text-2xl font-bold mb-6">알림</h1>' +
                    emptyMessage
                );
            }

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
                        handleError(xhr);
                    }
                });
            }

            // 전역 함수로 등록
            window.markAsRead = markAsRead;
            window.deleteNotification = deleteNotification;
            window.markAllAsRead = markAllAsRead;
            window.deleteAllNotifications = deleteAllNotifications;

            // 초기 알림 개수 업데이트
            updateNotificationCount();
            // 30초마다 알림 개수 업데이트
            setInterval(updateNotificationCount, 30000);
        });
    </script>
</body>
</html> 