--join practice 2

-- 고객명 Antonio Moreno이 1997년에 주문한 주문 정보를 주문 아이디, 주문일자, 배송일자, 배송 주소를 고객 주소와 함께 구할것.

select a.contact_name, a.address, b.order_id, b.order_date, b.shipped_date, b.ship_address 
from nw.customers a
join nw.orders b on a.customer_id = b.customer_id
where a.contact_name = 'Antonio Moreno'
and b.order_date  between to_date('19970101', 'yyyymmdd') and to_date('19971231', 'yyyymmdd');


-- Berlin에 살고 있는 고객이 주문한 주문 정보를 구할것
-- 고객명, 주문id, 주문일자, 주문접수 직원명, 배송업체명을 구할것. 

select a.customer_id , a.contact_name , b.order_id , b.order_date ,
		c.first_name||' '||c.last_name as employee_name, d.company_name as shipper_name 
from nw.customers a
	join nw.orders b on a.customer_id = b.customer_id
	join nw.employees c on b.employee_id = c.employee_id
	join nw.shippers d on b.ship_via = d.shipper_id
where a.city = 'Berlin'