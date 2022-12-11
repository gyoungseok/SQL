-- 서브쿼리 
-- select문에 또 다른 select문이 있는 경우

select *,
		(select gender from customer where a.mem_no = mem_no) as gender
from sales as a;

select *
from customer 
where mem_no = '1000970';

-- select절 서브쿼리는 속도가 다소 느리기 때문에 잘 사용하지 않음



-- from절 서브쿼리

select * 
from ( select mem_no, count(order_no) as 주문횟수
		from sales
		group by mem_no
		order by 주문횟수 desc
	 ) as a;

	
-- where절 서브쿼리

select count(order_no) as 주문횟수
from sales 
where mem_no in (select mem_no from customer where year(join_date) = 2019);


-- 서브쿼리 + 조인

-- create temp table
create temporary table sales_sub_query
select a.구매횟수, b.*
from ( select mem_no, count(order_no) as 구매횟수 
		from sales
		group by mem_no
	 ) as a
inner join customer as b 
	on a.mem_no = b.mem_no ;


-- check
select * from sales_sub_query;


-- 성별이 남성인 조건으로 필터링

select *
from sales_sub_query
where gender = 'MAN';

-- 거주지역별로 구매횟수를 집계
select addr, sum(구매횟수) as 구매횟수
from sales_sub_query
where gender = 'MAN'
group by addr
order by 2 desc;

-- 구매횟수가 100회 미만인 조건으로 필터링

select addr, sum(구매횟수) as 구매횟수
from sales_sub_query
where gender = 'MAN'
group by addr
having sum(구매횟수) < 100
order by sum(구매횟수) desc;
