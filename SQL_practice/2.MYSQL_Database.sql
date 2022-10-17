-- learning resource - https://www.w3schools.com/mysql

-- WHERE STATEMENT --
SELECT * FROM Customer
WHERE Country = 'Mexico';

SELECT * FROM Customer
WHERE CustID = 1;

-- ORDER BY, 오름차순 또는 내림차순으로 정렬
SELECT * FROM Customer
ORDER BY Country ASC;

SELECT * FROM Customer
ORDER BY Country DESC;

-- INSERT INTO 
INSERT INTO Customer (`companyName`, `contactName`, `address`, `city`, `postalCode`, `country`)
VALUES ('cardinal', 'Tom', 'Skagen 21', 'Stavanger', '4006', 'Norway');


INSERT INTO Customer (companyName, City, Country)
VALUES ('Cardinal', 'Stavanger', 'Norway');

SELECT * FROM Customer ORDER BY custid DESC LIMIT 3;

-- IS NULL, IS NOT NULL
SELECT companyName, contactName, address
FROM Customer
WHERE address IS NOT NULL;

-- UPDATE
UPDATE Customer
SET contactName = 'Alfred', city = 'KOREA'
WHERE custid = 1;

SELECT * FROM Customer
WHERE custid = 1;

-- 주의, WHERE 절을 생략하면 모든 레코드가 업데이트 됨
UPDATE Customer
SET postalCode = 0000
WHERE country = 'Mexico';

UPDATE Customer
SET city = 'Oslo',
country = 'Norway'
WHERE custid = 32;

SELECT * FROM Customer
WHERE custid = 32;

-- DELETE
DELETE FROM Customer
WHERE contactName = 'Alfred';

DELETE FROM Customer;

-- LIMIT
-- 국가가 독일인 고객테이블에서 처음 세 개 레코드만 출력. 
SELECT *
FROM Customer
WHERE country = 'Germany'
LIMIT 3;

-- MIN/MAX
-- DESC Product;

SELECT MIN(unitPrice) AS SmallestPrice
FROM Product;

SELECT MAX(unitPrice) AS largestPrice
FROM Product;

-- COUNT/AVG/SUM
SELECT COUNT(productId)
FROM Product;

SELECT AVG(unitPrice) AS MeanPrice
FROM Product;

SELECT SUM(quantity)
FROM OrderDetail;

-- LIKE
-- 지정된 패턴을 검색할 때
-- 와일드 카드 '%','_' 
-- and, or 
-- NOT LIKE

SELECT * FROM Customer
WHERE contactName LIKE 'a%';

SELECT * FROM Customer
WHERE contactName LIKE '%a';

SELECT * FROM Customer
WHERE contactName LIKE '%or%';

SELECT * FROM Customer
WHERE contactName LIKE '%or%';

SELECT * FROM Customer
WHERE contactName LIKE '_r%';

SELECT * FROM Customer
WHERE contactName LIKE 'a__%';

SELECT * FROM Customer
WHERE contactName LIKE 'a%n';

SELECT * FROM Customer
WHERE contactName NOT LIKE 'a%';

-- IN 연산자
-- 독일 프랑스 영국에있는 모든 고객을 선택
SELECT * FROM Customer
WHERE Country IN ('Germany', 'France', 'UK');
-- 독일 프랑스 영국에 없는 모든 고객의 수
SELECT Count(*) FROM Customer
WHERE Country NOT IN ('Germany', 'France', 'UK');

-- BETWEEN 연산자
-- 가격이 10~20 사이인 모든 제품을 선택
SELECT * FROM Product
WHERE unitprice BETWEEN 10 AND 20;
-- 가격이 10~20 사이가 아닌 모든 제품을 선택
SELECT * FROM Product
WHERE unitprice NOT BETWEEN 10 AND 20;
-- IN이 있는 BETWEEN
-- 가격이 10~20사이인 모든 제품을 선택 + categoryid가 1,2 또는 3인 제품을 표시하지 않는 경우.
SELECT * FROM Product
WHERE unitprice BETWEEN 10 AND 20
AND categoryid NOT IN (1,2,3);

-- ALIAS
-- cutid와 contactname 별칭부여 해보기.
SELECT custid AS id, contactname AS customer
FROM customer;
SELECT * FROM Customer;
-- 별칭에 공백이 들어가는 경우 "" 혹은 '' 필요.
SELECT contactname AS cutomer, contacttitle AS "NICE POSTION"
FROM Customer;
-- 3개의 컬럼을 결합해서 "ADDRESS"라는 별칭 부여 해보기
SELECT contactname, concat_ws(', ', address, postalcode, city )
AS address
FROM Customer;

