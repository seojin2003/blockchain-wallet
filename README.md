# 암호화폐 지갑 프로젝트

이 프로젝트는 Spring Boot를 사용하여 구현된 암호화폐 지갑 애플리케이션입니다.

## 주요 기능

- 회원가입 및 로그인
- 지갑 생성 및 관리
- 잔액 조회
- 입금/출금 기능
- 거래 내역 조회
- 실시간 시세 확인

## 기술 스택

- Java 11
- Spring Boot 2.7.0
- Spring Security
- Spring Data JPA
- Web3j
- MySQL
- JSP
- jQuery
- Tailwind CSS
- Chart.js

## 실행 방법

1. MySQL 데이터베이스 생성
```sql
CREATE DATABASE wallet CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. application.properties 파일의 데이터베이스 설정 수정
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/wallet?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=your_password
```

3. Web3j Infura 프로젝트 ID 설정
```properties
web3j.client-address=https://mainnet.infura.io/v3/YOUR-PROJECT-ID
```

4. Maven으로 프로젝트 빌드
```bash
./mvnw clean package
```

5. 애플리케이션 실행
```bash
java -jar target/crypto-wallet-0.0.1-SNAPSHOT.jar
```

6. 웹 브라우저에서 접속
```
http://localhost:8081
```

## API 엔드포인트

### 회원 관리
- POST /api/register: 회원가입
- POST /api/login: 로그인
- POST /api/logout: 로그아웃
- GET /api/check-username: 아이디 중복 확인

### 지갑 관리
- POST /api/wallet/create: 지갑 생성
- GET /api/wallet/balance: 잔액 조회
- POST /api/wallet/deposit: 입금
- POST /api/wallet/withdraw: 출금
- GET /api/wallet/transactions: 거래 내역 조회

## 보안 고려사항

- 개인키는 암호화하여 저장
- 모든 API 요청은 로그인 필요
- 출금 시 비밀번호 재확인
- HTTPS 사용 권장

## 라이선스

MIT License 