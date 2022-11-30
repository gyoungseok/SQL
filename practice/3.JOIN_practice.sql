USE SQL_basic;

SHOW TABLES;

DESC customer;

DESC product;

SELECT * 
FROM product;

-- INNER JOIN
-- 두 테이블의 공통 값이 매칭되는 데이터를 결합


SELECT *
FROM customer AS A
INNER
JOIN sales AS B
  ON A.mem_no = B.mem_no;
  
-- customer 및 sales 테이블은 mem_no(회원번호) 기준으로 1:N 관계

SELECT * 
FROM customer AS A
INNER 
JOIN sales AS B 
  ON A.mem_no = B.mem_no
WHERE A.mem_no = '1000970';

-- left join, 두 테이블의 공통 값이 매칭되는 데이터만 결합하고, 왼쪽테이블의 매칭되지 않는 데이터는 NULL로 처리

SELECT *
FROM customer AS A
LEFT
JOIN sales AS B
  ON A.mem_no = B.mem_no;
  
  
-- right joi, 두 테이블의 공통 값이 매칭되는 데이터만 결합하고, 오른쪽 테이블의 매칭되지 않는 데이터는 NULL로 처리

SELECT *
FROM customer AS A
RIGHT
JOIN sales AS B
  ON A.mem_no = B.mem_no
WHERE A.mem_no IS NULL;

-- 테이블 결합과 데이터 조회, JOIN + SELECT

SELECT * 
FROM customer AS A
INNER 
JOIN sales AS B
  ON A.mem_no = B.mem_no;
  
  
-- 임시 테이블 생성

CREATE TEMPORARY TABLE customer_sales_inner_join
SELECT A.*
		,B.order_no
FROM customer AS A
INNER
JOIN sales AS B
  ON A.mem_no = B.mem_no;
  
-- 임시 테이블 조회
SELECT *
FROM customer_sales_inner_join;

-- 성별이 남성 조건으로 필터링

SELECT *
FROM customer_sales_inner_join
WHERE gender = 'MAN';

-- 거주지역별로 구매횟수를 집계

SELECT addr, count(order_no) AS 구매횟수
FROM customer_sales_inner_join
WHERE gender = 'MAN'
GROUP
   BY addr
ORDER
   BY 2 DESC;
   
-- 구매횟수가 100회 미만인 경우를 조회
SELECT addr, count(order_no) AS 구매횟수
FROM customer_sales_inner_join
WHERE gender = 'MAN'
GROUP
   BY addr
HAVING count(order_no) < 100;
  
  