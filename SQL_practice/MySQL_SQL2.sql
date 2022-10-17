-- JOIN

-- INNER JOIN, 두 테이블에서 일치하는 값을 가진 컬럼을 선택
SELECT orders.orderId, customers.companyName,orders.orderDate
FROM orders
INNER JOIN customers
ON orders.custId=customers.custId;

-- 3 TABLE INNER JOIN
SELECT orders.orderId, customers.companyName,
shippers.companyName
FROM ((orders
INNER JOIN customers ON orders.custId = customers.custId)
INNER JOIN shippers ON orders.shipperid = shippers.shipperID);

-- LEFT JOIN
-- 오른쪽 테이블에 일치하는 항목이 없더라도 왼쪽 테이블의 모든 레코드를 반환
SELECT customers.companyName, orders.orderId
FROM customers
LEFT JOIN orders ON customers.custId = orders.custId
ORDER BY customers.companyName;




