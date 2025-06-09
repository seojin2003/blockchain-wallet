<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="/js/notification.js"></script>
<script>
    // 알림 개수 업데이트 함수
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

    // 30초마다 알림 개수 업데이트
    setInterval(updateNotificationCount, 30000);

    // 초기 알림 개수 업데이트
    $(document).ready(function() {
        updateNotificationCount();
    });
</script>
</body>
</html> 