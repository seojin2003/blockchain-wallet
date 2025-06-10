-- 거래 테이블에 가스 정보 컬럼 추가
ALTER TABLE transactions
ADD COLUMN gas_price VARCHAR(255) AFTER created_at,
ADD COLUMN gas_used VARCHAR(255) AFTER gas_price,
ADD COLUMN block_number VARCHAR(255) AFTER gas_used;

-- 거래 테이블에 거래 후 잔액 컬럼 추가
ALTER TABLE transactions
ADD COLUMN balance_after DECIMAL(40,18) AFTER status; 