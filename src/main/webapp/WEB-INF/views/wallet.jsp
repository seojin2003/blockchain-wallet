<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>지갑</title>
    <script src="/static/js/theme.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/static/css/theme.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
            background-color: var(--bg-secondary);
            border-radius: 8px;
            box-shadow: var(--card-shadow);
            padding: 20px;
            margin-bottom: 20px;
        }
        .info-section {
            margin-bottom: 30px;
            padding: 20px;
            background-color: var(--bg-secondary);
            border-radius: 8px;
            border: 1px solid var(--border-color);
        }
        .info-item {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }
        .info-label {
            font-weight: bold;
            color: var(--text-secondary);
            width: 120px;
        }
        .info-value {
            flex: 1;
            word-break: break-all;
            color: var(--text-primary);
        }
        .button-group {
            margin-top: 20px;
            display: flex;
            gap: 10px;
        }
        .button {
            padding: 10px 20px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            display: inline-block;
        }
        .button-deposit {
            background-color: #2ecc71;
            color: white;
        }
        .button-withdraw {
            background-color: #e74c3c;
            color: white;
        }
        .button-create {
            background-color: #3498db;
            color: white;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: var(--bg-secondary);
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }
        th {
            background-color: var(--bg-primary);
            font-weight: bold;
            color: var(--text-secondary);
        }
        td {
            color: var(--text-primary);
        }
        tr:hover {
            background-color: var(--bg-hover);
        }
        tr:last-child td {
            border-bottom: none;
        }
        .type-deposit {
            color: #2ecc71 !important;
        }
        .type-withdraw {
            color: #e74c3c !important;
        }
        .status-tag {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-completed {
            background-color: var(--bg-success);
            color: var(--text-success);
        }
        .status-pending {
            background-color: var(--bg-warning);
            color: var(--text-warning);
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
        .form-label {
            color: var(--text-secondary);
        }
        .form-control {
            background-color: var(--bg-secondary);
            color: var(--text-primary);
            border-color: var(--border-color);
        }
        .alert-info {
            background-color: var(--alert-info-bg);
            color: var(--alert-info-text);
            border-color: var(--alert-info-border);
        }
        h1, h2 {
            color: var(--text-primary);
        }
        .notification-icon {
            position: relative;
            color: var(--nav-text);
            font-size: 20px;
            cursor: pointer;
            margin-right: 20px;
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
            font-weight: bold;
            z-index: 1;
        }
        .notification-link {
            position: relative;
            display: inline-block;
        }
        .notification-count {
            position: absolute;
            top: -8px;
            right: -8px;
            background-color: #e74c3c;
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 12px;
            min-width: 20px;
            text-align: center;
        }
        .notification-icon {
            position: relative;
        }
        .copy-button {
            background: none;
            border: none;
            color: #3498db;
            cursor: pointer;
            padding: 5px;
            margin-left: 8px;
            border-radius: 4px;
            transition: all 0.2s;
            position: relative;
        }
        .copy-button:hover {
            background-color: rgba(52, 152, 219, 0.1);
        }
        .copy-alert {
            display: inline-block;
            margin-left: 10px;
            color: #2ecc71;
            font-size: 14px;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        .copy-alert.show {
            opacity: 1;
        }
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1000;
        }
        
        .modal-content {
            position: relative;
            background-color: var(--bg-secondary);
            margin: 5% auto;
            padding: 30px;
            width: 90%;
            max-width: 500px;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            max-height: 90vh;
            overflow-y: auto;
        }
        
        .modal-close {
            position: absolute;
            right: 20px;
            top: 20px;
            font-size: 24px;
            cursor: pointer;
            color: var(--text-secondary);
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: all 0.2s;
            background-color: var(--bg-primary);
            z-index: 1;
        }
        
        .modal-close:hover {
            color: var(--text-primary);
            background-color: rgba(0, 0, 0, 0.1);
        }
        
        .transaction-detail {
            margin-top: 20px;
        }
        
        .detail-group {
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
        }
        
        .detail-group:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }
        
        .detail-label {
            color: var(--text-secondary);
            font-size: 14px;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .detail-value {
            color: var(--text-primary);
            font-size: 15px;
            word-break: break-all;
            line-height: 1.5;
        }
        
        .detail-value.hash {
            font-family: monospace;
            font-size: 13px;
            background-color: var(--bg-primary);
            padding: 10px;
            border-radius: 6px;
            border: 1px solid var(--border-color);
            white-space: pre-wrap;
            word-break: break-all;
        }
        
        .detail-status {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
        }
        
        .detail-status.completed {
            background-color: var(--bg-success);
            color: var(--text-success);
        }
        
        .detail-status.pending {
            background-color: var(--bg-warning);
            color: var(--text-warning);
        }
        
        .modal h2 {
            margin: 0 0 20px 0;
            font-size: 20px;
            font-weight: 600;
            color: var(--text-primary);
        }
        
        .transaction-item {
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .transaction-item:hover {
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp" />
    
    <div class="container">
        <div class="card">
            <h1>내 지갑 정보</h1>
            
            <div class="info-section">
                <div class="info-item">
                    <span class="info-label">이름:</span>
                    <span class="info-value">${member.name}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">지갑 주소:</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${empty member.walletAddress}">
                                <span style="color: #e74c3c;">지갑이 아직 생성되지 않았습니다.</span>
                                <form action="/api/wallet/create" method="post" style="display: inline;">
                                    <button type="submit" class="button button-create">지갑 생성하기</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <span id="wallet-address">${member.walletAddress}</span>
                                <button onclick="copyToClipboard('wallet-address')" class="copy-button">
                                    <i class="fas fa-copy"></i>
                                </button>
                                <span class="copy-alert" id="copy-alert">
                                    <i class="fas fa-check"></i> 복사됨
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="info-item">
                    <span class="info-label">잔액:</span>
                    <span class="info-value">${balance} ETH</span>
                </div>
                <div class="button-group">
                    <c:if test="${not empty member.walletAddress}">
                        <a href="/deposit" class="button button-deposit">입금</a>
                        <a href="/withdraw" class="button button-withdraw">출금</a>
                    </c:if>
                </div>
            </div>

            <h2>거래 내역</h2>
            <c:choose>
                <c:when test="${empty transactions}">
                    <div style="text-align: center; padding: 40px; background-color: var(--bg-secondary); border-radius: 8px; margin: 20px 0; border: 1px solid var(--border-color);">
                        <div style="margin-bottom: 15px; font-size: 24px;">📝</div>
                        <p style="margin: 0; color: var(--text-primary); font-size: 16px;">아직 거래 내역이 없습니다.</p>
                        <p style="margin: 10px 0 0 0; color: var(--text-secondary); font-size: 14px;">입금 또는 출금을 진행하시면 이곳에 거래 내역이 표시됩니다.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>날짜</th>
                                <th>종류</th>
                                <th>금액</th>
                                <th>상태</th>
                                <th>거래 해시</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${transactions}" var="tx">
                                <tr class="transaction-item" onclick="showTransactionDetails('${tx.transactionHash}', '${tx.type}', '${tx.amount}', '${tx.status}', '${tx.createdAt}', '${tx.fromAddress}', '${tx.toAddress}', '${tx.gasPrice}', '${tx.gasUsed}', '${tx.blockNumber}', '${tx.balanceAfter}')">
                                    <td>${tx.createdAt}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${tx.type eq 'DEPOSIT'}">
                                                <span class="type-deposit">입금</span>
                                            </c:when>
                                            <c:when test="${tx.type eq 'WITHDRAW'}">
                                                <span class="type-withdraw">출금</span>
                                            </c:when>
                                            <c:otherwise>
                                                ${tx.type}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${tx.type eq 'DEPOSIT'}">
                                                <span class="type-deposit">+${tx.amount}</span>
                                            </c:when>
                                            <c:when test="${tx.type eq 'WITHDRAW'}">
                                                <span class="type-withdraw">-${tx.amount}</span>
                                            </c:when>
                                            <c:otherwise>
                                                ${tx.amount}
                                            </c:otherwise>
                                        </c:choose>
                                        ETH
                                    </td>
                                    <td>
                                        <span class="status-tag ${tx.status eq 'COMPLETED' ? 'status-completed' : 'status-pending'}">
                                            ${tx.status}
                                        </span>
                                    </td>
                                    <td style="font-family: monospace;">${tx.transactionHash}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
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

        // 페이지 로드 시 알림 개수 업데이트
        $(document).ready(function() {
            updateNotificationCount();
        });

        // 30초마다 알림 개수 업데이트
        setInterval(updateNotificationCount, 30000);

        document.addEventListener('DOMContentLoaded', function() {
            const createWalletForm = document.querySelector('form[action="/api/wallet/create"]');
            if (createWalletForm) {
                createWalletForm.addEventListener('submit', function(e) {
                    e.preventDefault();
                    
                    fetch('/api/wallet/create', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        }
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.error) {
                            alert(data.error);
                        } else {
                            // 성공적으로 지갑이 생성되면 페이지 새로고침
                            window.location.reload();
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('지갑 생성 중 오류가 발생했습니다.');
                    });
                });
            }
        });

        function copyToClipboard(elementId) {
            const text = document.getElementById(elementId).textContent;
            navigator.clipboard.writeText(text).then(() => {
                const alert = document.getElementById('copy-alert');
                alert.classList.add('show');
                setTimeout(() => {
                    alert.classList.remove('show');
                }, 2000);
            }).catch(err => {
                console.error('클립보드 복사 실패:', err);
                alert('클립보드 복사에 실패했습니다.');
            });
        }

        function showTransactionDetails(hash, type, amount, status, time, from, to, gasPrice, gasUsed, blockNumber, balanceAfter) {
            // 모달 내용 설정
            document.getElementById('txType').textContent = type == 'DEPOSIT' ? '입금' : '출금';
            document.getElementById('txStatus').textContent = status;
            document.getElementById('txStatus').className = `detail-status ${status.toLowerCase()}`;
            document.getElementById('txAmount').textContent = (type == 'DEPOSIT' ? '+' : '-') + amount + ' ETH';
            document.getElementById('txBalance').textContent = balanceAfter + ' ETH';
            document.getElementById('txTime').textContent = time;
            document.getElementById('txBlock').textContent = blockNumber || '정보 없음';
            document.getElementById('txHash').textContent = hash;
            document.getElementById('txFrom').textContent = from || '정보 없음';
            document.getElementById('txTo').textContent = to || '정보 없음';
            document.getElementById('txGasPrice').textContent = gasPrice ? (gasPrice + ' Gwei') : '정보 없음';
            document.getElementById('txGasUsed').textContent = gasUsed ? (gasUsed + ' Gas') : '정보 없음';
            
            // 거래 수수료 계산 (gasPrice * gasUsed)
            let fee = '정보 없음';
            if (gasPrice && gasUsed) {
                // Gwei를 ETH로 변환 (1 ETH = 10^9 Gwei)
                const feeInGwei = BigInt(gasPrice) * BigInt(gasUsed);
                const feeInEth = Number(feeInGwei) / 1000000000;
                fee = feeInEth.toFixed(8) + ' ETH';
            }
            document.getElementById('txFee').textContent = fee;
            
            // 모달 표시
            document.getElementById('transactionModal').style.display = 'block';
        }
        
        function closeTransactionModal() {
            document.getElementById('transactionModal').style.display = 'none';
        }
        
        // 모달 외부 클릭 시 닫기
        window.onclick = function(event) {
            const modal = document.getElementById('transactionModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }
    </script>

    <!-- 거래 상세 정보 모달 -->
    <div id="transactionModal" class="modal">
        <div class="modal-content">
            <span class="modal-close" onclick="closeTransactionModal()">&times;</span>
            <h2>거래 상세 정보</h2>
            <div class="transaction-detail">
                <div class="detail-group">
                    <div class="detail-label">거래 유형</div>
                    <div class="detail-value" id="txType"></div>
                </div>
                <div class="detail-group">
                    <div class="detail-label">거래 상태</div>
                    <div class="detail-value">
                        <span class="detail-status" id="txStatus"></span>
                    </div>
                </div>
                <div class="detail-group">
                    <div class="detail-label">거래 금액</div>
                    <div class="detail-value" id="txAmount"></div>
                </div>
                <div class="detail-group">
                    <div class="detail-label">거래 후 잔액</div>
                    <div class="detail-value" id="txBalance"></div>
                </div>
                <div class="detail-group">
                    <div class="detail-label">거래 시간</div>
                    <div class="detail-value" id="txTime"></div>
                </div>
                <div class="detail-group">
                    <div class="detail-label">블록 번호</div>
                    <div class="detail-value" id="txBlock"></div>
                </div>
                <div class="detail-group">
                    <div class="detail-label">거래 해시</div>
                    <div class="detail-value hash" id="txHash"></div>
                </div>
                <div class="detail-group">
                    <div class="detail-label">보내는 주소</div>
                    <div class="detail-value hash" id="txFrom"></div>
                </div>
                <div class="detail-group">
                    <div class="detail-label">받는 주소</div>
                    <div class="detail-value hash" id="txTo"></div>
                </div>
                <div class="detail-group">
                    <div class="detail-label">가스 가격</div>
                    <div class="detail-value" id="txGasPrice"></div>
                </div>
                <div class="detail-group">
                    <div class="detail-label">가스 사용량</div>
                    <div class="detail-value" id="txGasUsed"></div>
                </div>
                <div class="detail-group">
                    <div class="detail-label">거래 수수료</div>
                    <div class="detail-value" id="txFee"></div>
                </div>
            </div>
        </div>
    </div>
</body>
</html> 