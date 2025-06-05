class NotificationManager {
    constructor() {
        this.hasPermission = false;
        this.init();
    }

    async init() {
        // 브라우저가 알림을 지원하는지 확인
        if (!("Notification" in window)) {
            console.log("이 브라우저는 알림을 지원하지 않습니다.");
            return;
        }

        // 알림 권한 확인
        if (Notification.permission === "granted") {
            this.hasPermission = true;
        } else if (Notification.permission !== "denied") {
            const permission = await Notification.requestPermission();
            this.hasPermission = permission === "granted";
        }
    }

    showNotification(title, options = {}) {
        if (!this.hasPermission) {
            console.log("알림 권한이 없습니다.");
            return;
        }

        // 기본 옵션과 사용자 옵션 병합
        const defaultOptions = {
            icon: '/images/eth-icon.png',
            badge: '/images/eth-icon.png',
            vibrate: [200, 100, 200],
            silent: false
        };

        const notification = new Notification(title, { ...defaultOptions, ...options });

        // 알림 클릭 이벤트 처리
        notification.onclick = function(event) {
            event.preventDefault();
            window.focus();
            notification.close();
        };

        // 5초 후 자동으로 알림 닫기
        setTimeout(() => notification.close(), 5000);
    }

    // 입금 알림
    showDepositNotification(amount) {
        this.showNotification("입금 완료", {
            body: `${amount} ETH가 입금되었습니다.`,
            icon: '/images/deposit-icon.png'
        });
    }

    // 출금 알림
    showWithdrawNotification(amount) {
        this.showNotification("출금 완료", {
            body: `${amount} ETH가 출금되었습니다.`,
            icon: '/images/withdraw-icon.png'
        });
    }
}

// 전역 NotificationManager 인스턴스 생성
window.notificationManager = new NotificationManager(); 