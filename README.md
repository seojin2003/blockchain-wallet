# 이더리움 지갑 웹 애플리케이션

이 프로젝트는 블록체인 기반 암호화폐(이더리움) 지갑 웹 애플리케이션입니다.

## 주요 기능

- 회원 관리 (회원가입, 로그인)
- 지갑 관리 (잔액 조회, 입금, 출금)
- 실시간 시세 차트
- 알림 시스템 (알림 숫자 표시, 읽음 표시, '모두 읽음', '모두 삭제' 기능)

## 기술 스택

- Backend: Spring Boot 2.7.14
- Frontend: Thymeleaf, JavaScript
- Database: MySQL
- Security: Spring Security
- Build Tool: Maven

## 시작하기

### 필수 조건

- JDK 17 이상
- Maven
- MySQL

### 설치 및 실행

1. 저장소 클론
```bash
git clone [repository-url]
```

2. MySQL 데이터베이스 생성
```sql
CREATE DATABASE wallet;
```

3. `application.properties` 설정
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/wallet
spring.datasource.username=your-username
spring.datasource.password=your-password
```

4. 애플리케이션 실행
```bash
mvn spring-boot:run
```

## 보안 설정

- CSRF 보호
- 비밀번호 암호화 (BCrypt)
- 세션 관리
- 보안 헤더 설정

## 최근 업데이트

- 알림 기능 개선
- 로그인 예외 처리 개선
- 사용자 인터페이스 개선
- 보안 설정 강화 