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


