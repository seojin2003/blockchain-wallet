# 이더리움 지갑 웹 애플리케이션

이 프로젝트는 블록체인 기반 암호화폐(이더리움) 지갑 웹 애플리케이션입니다.

## 주요 기능

### 1. 회원 관리 시스템
- 회원가입/로그인
- 관리자 권한 관리
- 비밀번호 암호화 (BCrypt)
- 세션 관리

### 2. 지갑 기능
- 이더리움 지갑 주소 생성
- 개인키/공개키 관리
- 복구 코드 시스템
- 잔액 조회 (DECIMAL(40,18) 정밀도)

### 3. 거래 시스템
- 입금/출금 기능
- 거래 내역 관리
- 가스비 추적
- 블록 번호 추적
- 거래 후 잔액 기록

### 4. 알림 시스템
- 실시간 알림
- 알림 읽음 표시
- 알림 타입별 관리

### 5. 보안 기능
- CSRF 보호
- 세션 관리
- 보안 헤더 설정
- 로그인 실패 처리

## 기술 스택

### 백엔드
- Java 17
- Spring Boot 2.7.14
- Spring Security
- Spring Data JPA
- Web3j 4.9.4 (블록체인 연동)

### 프론트엔드
- JSP
- JavaScript
- JSTL
- Bootstrap

### 데이터베이스
- MySQL 8.0.33
- JPA/Hibernate
- 트랜잭션 관리

### 개발 도구
- Maven
- Lombok
- H2 Database (테스트용)

### 보안
- BCryptPasswordEncoder
- Spring Security
- CSRF 보호
- 세션 관리

## 개발 환경
- IDE: Eclipse/IntelliJ IDEA 지원
- 버전 관리: Git
- 빌드 도구: Maven
- 서버: Apache Tomcat (내장)
- Java 버전: JDK 17 이상

## 시작하기

### 필수 조건
- JDK 17 이상
- Maven
- MySQL 8.0.33

### 설치 및 실행

1. 저장소 클론
```bash
git clone [repository-url]
```

2. MySQL 데이터베이스 생성
```sql
CREATE DATABASE blockchain_wallet;
```

3. `application.properties` 설정
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/blockchain_wallet
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
- schema.sql 파일 통합 및 개선
- 데이터베이스 정밀도 향상 (DECIMAL(40,18))
- 거래 관련 필드 추가
- 보안 설정 강화 