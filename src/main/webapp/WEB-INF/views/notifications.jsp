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
        /* 루트 레벨에서 트랜지션 적용 */
        :root {
            --transition-speed: 0.3s;
        }

        /* 모든 요소에 동일한 트랜지션 적용 */
        body, 
        .notification-item,
        .notification-icon,
        .notification-title,
        .notification-message,
        .notification-time,
        .btn-text,
        .page-title,
        .btn,
        .notification-content {
            transition: all var(--transition-speed) ease;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-color);
            animation: fadeIn 0.3s ease-in-out;
            margin: 0;
            padding: 0;
            font-family: 'Arial', sans-serif;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }

        /* 다크모드 전환 시 부드러운 전환 */
        body,
        .notification-item,
        .notification-icon,
        .notification-title,
        .notification-message,
        .notification-time,
        .btn-text,
        .page-title,
        .btn,
        .notification-content,
        .container,
        .notification-header,
        .notification-actions {
            transition: all 0.3s ease-in-out;
        }

        /* 다크모드 전환 시 배경 오버레이 효과 */
        .theme-transition-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: var(--bg-color);
            opacity: 0;
            pointer-events: none;
            z-index: 9999;
            transition: opacity 0.3s ease-in-out;
        }

        .theme-transition-overlay.active {
            opacity: 1;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .notification-wrapper {
            background-color: var(--box-bg);
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .notification-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 20px;
            margin-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
        }

        .notification-actions {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 8px 16px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            border: none;
            transition: all 0.3s ease;
        }

        .btn:hover {
            opacity: 0.9;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
        }

        .notification-list {
            background-color: var(--box-bg);
        }

        .notification-item {
            display: flex;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 8px;
            background-color: var(--bg-primary);
            transition: background-color 0.3s ease;
            border: 1px solid var(--border-color);
        }

        .notification-item:hover {
            background-color: var(--bg-secondary);
        }

        .notification-item.unread {
            border-left: 3px solid var(--primary-color);
        }

        /* 알림 아이템 사이 구분선 추가 */
        .notification-item:not(:last-child) {
            border-bottom: 1px solid var(--border-color);
        }

        .notification-icon {
            margin-right: 15px;
            font-size: 24px;
            color: var(--text-color);
        }

        .notification-content {
            flex: 1;
        }

        .notification-time {
            font-size: 12px;
            color: var(--text-secondary);
            margin-bottom: 5px;
        }

        .notification-title {
            font-size: 16px;
            font-weight: bold;
            color: var(--text-color);
            margin-bottom: 5px;
        }

        .notification-message {
            color: var(--text-secondary);
            margin-bottom: 10px;
        }

        .notification-item-actions {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }

        .btn-text {
            background: none;
            border: none;
            color: var(--text-color);
            cursor: pointer;
            padding: 5px 10px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
        }

        .btn-text:hover {
            color: var(--primary-color);
        }

        .btn-text i {
            font-size: 16px;
        }

        .read-button {
            color: var(--primary-color);
        }

        .no-notifications {
            text-align: center;
            padding: 40px;
            color: var(--text-secondary);
            background-color: var(--bg-secondary);
            border-radius: 8px;
            border: 1px solid var(--border-color);
        }

        .no-notifications i {
            font-size: 48px;
            margin-bottom: 20px;
        }

        .page-title {
            font-size: 24px;
            color: var(--text-color);
            margin: 0;
            margin-bottom: 20px;
        }

        /* 라이트/다크 모드 변수 */
        [data-theme="light"] {
            --text-color: #333;
            --text-secondary: #666;
            --bg-color: #f8f9fa;
            --bg-secondary: #ffffff;
            --bg-highlight: #f8f9fa;
            --primary-color: #1a73e8;
            --border-color: #e1e4e8;
            --box-bg: #ffffff;
        }

        [data-theme="dark"] {
            --text-color: #e1e1e1;
            --text-secondary: #a1a1a1;
            --bg-color: #0d1117;
            --bg-secondary: #0d1117;
            --bg-highlight: #1e3a5f;
            --primary-color: #7289da;
            --border-color: #30363d;
            --box-bg: #1b2838;
        }

        /* 다크 모드일 때는 테두리 제거 */
        [data-theme="dark"] .notification-header,
        [data-theme="dark"] .notification-list,
        [data-theme="dark"] .notification-item {
            border: none;
        }

        [data-theme="dark"] .notification-item.unread {
            border-left: 3px solid var(--primary-color);
        }

        /* 토스트 메시지 스타일 추가 */
        .toast-message {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: var(--primary-color);
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            display: none;
            z-index: 1000;
            animation: slideIn 0.3s ease-out;
            transition: background-color var(--transition-speed) ease;
        }

        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
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
                        전체 읽음
                    </button>
                    <button class="btn btn-danger" onclick="deleteAllNotifications()">
                        <i class="fas fa-trash"></i>
                        전체 삭제
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
                                <c:choose>
                                    <c:when test="${notification.type eq 'DEPOSIT'}">
                                        <i class="fas fa-arrow-down" style="color: #4CAF50;"></i>
                                    </c:when>
                                    <c:when test="${notification.type eq 'WITHDRAW'}">
                                        <i class="fas fa-arrow-up" style="color: #f44336;"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-bell"></i>
                                    </c:otherwise>
                                </c:choose>
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

    <!-- 토스트 메시지 컨테이너 추가 -->
    <div id="toastMessage" class="toast-message"></div>

    <!-- 테마 전환 오버레이 추가 -->
    <div class="theme-transition-overlay"></div>

    <script>
        $(document).ready(function() {
            const token = $("meta[name='_csrf']").attr("content");
            const header = $("meta[name='_csrf_header']").attr("content");

            // CSRF 토큰 설정
            $(document).ajaxSend(function(e, xhr, options) {
                xhr.setRequestHeader(header, token);
            });

            // 토스트 메시지 표시 함수
            function showToast(message) {
                const toast = $('#toastMessage');
                toast.text(message);
                toast.fadeIn();
                
                setTimeout(() => {
                    toast.fadeOut();
                }, 3000);
            }

            window.markAllAsRead = function() {
                $.ajax({
                    url: '/notifications/read-all',
                    type: 'POST',
                    success: function(response) {
                        location.reload();
                    },
                    error: function(xhr, status, error) {
                        console.error('Error:', error);
                        alert('전체 알림 읽음 처리 중 오류가 발생했습니다.');
                    }
                });
            };

            window.deleteAllNotifications = function() {
                $.ajax({
                    url: '/notifications/delete-all',
                    type: 'POST',
                    success: function(response) {
                        showToast('모든 알림이 삭제되었습니다.');
                        setTimeout(() => {
                            location.reload();
                        }, 1000);
                    },
                    error: function(xhr, status, error) {
                        console.error('Error:', error);
                        alert('전체 알림 삭제 중 오류가 발생했습니다.');
                    }
                });
            };

            window.markAsRead = function(id) {
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
            };

            window.deleteNotification = function(id) {
                $.ajax({
                    url: '/notifications/' + id + '/delete',
                    type: 'POST',
                    success: function(response) {
                        showToast('알림이 삭제되었습니다.');
                        setTimeout(() => {
                            location.reload();
                        }, 1000);
                    },
                    error: function(xhr, status, error) {
                        console.error('Error:', error);
                        alert('알림 삭제 중 오류가 발생했습니다.');
                    }
                });
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

            // 테마 전환 애니메이션
            function handleThemeTransition() {
                const overlay = $('.theme-transition-overlay');
                
                // 테마 변경 시 오버레이 표시
                document.addEventListener('theme-changing', function() {
                    overlay.addClass('active');
                    
                    setTimeout(() => {
                        overlay.removeClass('active');
                    }, 300);
                });
            }

            // 테마 전환 애니메이션 초기화
            handleThemeTransition();
        });
    </script>
</body>
</html> 