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




