use SQL_basic;

show tables;

-- inner join

select *
from customer as a
inner join sales as b 
	on a.mem_no = b.mem_no ;

select b.*
from customer as a
inner join sales as b
	on a.mem_no = b.mem_no 
where a.mem_no = '1000021';

--  left join

select *
from customer as a
left join sales as b
	on a.mem_no = b.mem_no;
	
-- right join

select *
from customer as a
right join sales as b
	on a.mem_no = b.mem_no
where a.mem_no is null;
	
-- join + select

select *
from customer as a
inner join sales as b 
	on a.mem_no = b.mem_no;
	
-- create temp table 

create temporary table customer_sales_inner_join
select a.*, b.order_no
from customer as a
inner join sales as b
	on a.mem_no = b.mem_no ;
	
select * 
from customer_sales_inner_join;

-- 임시테이블은 서버 연결 종료시 자동으로 삭제됨.

-- 성별이 남성인 조건으로 필터링

select *
from customer_sales_inner_join
where gender = 'MAN';

-- 거주지역별로 구매횟수를 집계
select addr, count(order_no) as 구매횟수
from customer_sales_inner_join
where gender = 'MAN'
group by addr
order by 2 desc;

-- 구매횟수가 100회 미만인 조건으로 필터링
select addr, count(order_no) as 구매횟수
from customer_sales_inner_join
where gender = 'MAN'
group by addr
having count(order_no) < 100
order by 2 desc;

-- 3개 이상으 테이블을 결합하는 경우
-- 주문(sales)테이블 기준, 회원(customer) 및 상품(product) 테이블 left join 결합
select *
from sales as a 
left join customer as b 
	on a.mem_no = b.mem_no
left join product as c
	on a.product_code = c.product_code;
	


