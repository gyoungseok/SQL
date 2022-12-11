-- data mart

-- 데이터 마트는 분석에 필요한 데이터를 가공한 분석용 데이터
-- 
-- 일반적으로 데이터는 관계형DB에 저장되고, 분석목적으로 데이터 마트를 생성한다.
-- 다음 분석보고서를 만들고, 의사결정을 내린다.
-- 
-- 요약변수 - 데이터를 분석목적에 맞게 종합한 변수(ex. 기간별 구매금액, 구매횟수, 수량)
-- 파생변수 - 사용자가 특정 조건 또는 함수로 의미를 부여한 변수(ex. 연령대, 선호 카테고리)



-- 회원 분석용 데이터 마트

-- 회원 구매 정보
-- customer 테이블을 기준으로, sales(주문)테이블과 product(상품) 테이블을 결합

select a.mem_no , a.gender , a.birthday , a.addr , a.join_date ,
		sum(b.sales_qty * c.price) as 구매금액,
		count(b.order_no) as 구매횟수,
		sum(b.sales_qty) as 구매수량
from customer as a
left join sales as b
on a.mem_no = b.mem_no 
left join product as c
on b.product_code = c.product_code 
group by a.mem_no , a.gender , a.birthday , a.addr , a.join_date ;

-- 회원 구매정보 임시테이블을 생성

create temporary table customer_pur_info as
select a.mem_no , a.gender , a.birthday , a.addr , a.join_date,
		sum(b.sales_qty * c.price) as 구매금액,
		count(b.order_no) as 구매횟수,
		sum(b.sales_qty) as 구매수량
from customer as a
left join sales as b 
on a.mem_no = b.mem_no 
left join product as c
on b.product_code = c.product_code 
group by a.mem_no , a.gender , a.birthday , a.addr , a.join_date ;

-- check
select *
from customer_pur_info;

-- 회원연령대를 추가

-- 생년월일 컬럼을 변환하여 나이 컬럼을 생성

select *, 2021 - year(birthday) + 1 as 나이
from customer;

-- 나이 -> 연령대
-- from절 서브쿼리

select *, 
		case when 나이 < 10 then '10대 미만'
			 when 나이 < 20 then '10대'
			 when 나이 < 30 then '20대'
			 when 나이 < 40 then '30대'
			 when 나이 < 50 then '40대'
			 else '50대 이상'
		end as 연령대
from (
	select *, 
			2021 - year(birthday) + 1 as 나이
	from customer 	
) as a;


-- case when 함수 사용시 주의점
-- 순차적으로 실행되기 때문에, 실행 순서에 유의해서 쿼리를 작성해야 한다

select *,
		case when 나이 < 50 then '40대'
			 when 나이 < 10 then '10대 미만'
			 when 나이 < 20 then '10대'
			 when 나이 < 30 then '20대'
			 when 나이 < 40 then '30대'
			 else '50대 이상'
			 end as 연령대
from (
	select *,
			2021 - year(birthday) + 1 as 나이 
	from customer 
) as a;


-- 회원 연령대별 임시테이블 생성
create temporary table customer_ageband as
select *, 
		case when 나이 < 10 then '10대 미만'
			 when 나이 < 20 then '10대'
			 when 나이 < 30 then '20대'
			 when 나이 < 40 then '30대'
			 when 나이 < 50 then '40대'
			 else '50대 이상'
		end as 연령대
from (
	select *, 
			2021 - year(birthday) + 1 as 나이
	from customer 	
) as a;

-- check

select *
from customer_ageband;

-- 회원 구매정보 + 연령대 임시테이블 생성

create temporary table customer_pur_info_ageband as
select a.*,
		b.연령대
from customer_pur_info as a
left join customer_ageband as b
on a.mem_no = b.mem_no;

-- check

select *
from customer_pur_info_ageband;

-- 회원선호 카테고리를 추가하는 쿼리

-- 회원 및 카테고리별 구매횟수 순위
select a.mem_no , 
		b.category ,
		count(a.order_no) as 구매횟수,
		ROW_NUMBER () over (partition by a.mem_no order by count(a.order_no) desc ) as 구매횟수_순위
from sales as a
left join product as b
on a.product_code = b.product_code 
group by a.mem_no , b.category ;

-- ROW_NUMBER () , 동일한 값이여도 고유 순위를 부여하는 함수	 

-- 회원 및 카테고리별 구매횟수 순위 + 구매횟수 순위가 1위만 필터링

select *
from (
	select a.mem_no , 
			b.category ,
			count(a.order_no) as 구매횟수,
			ROW_NUMBER () over (partition by a.mem_no order by count(a.order_no) desc ) as 구매횟수_순위
	from sales as a
	left join product as b
	on a.product_code = b.product_code 
	group by a.mem_no , b.category 
	) as a
where 구매횟수_순위 = 1;


-- 회원선호 카테고리 임시테이블 생성

create temporary table customer_pre_category as
select * 
from (
	select a.mem_no, 
		   b.category,
		   count(a.order_no) as 구매횟수,
		   ROW_NUMBER() over(PARTITION by a.mem_no order by count(a.order_no) desc ) as 구매횟수_순위
	from sales as a
	left join product as b
	on a.product_code = b.product_code 
	group by a.mem_no , b.category 
	) as a 
where 구매횟수_순위 = 1;

-- check

select *
from customer_pre_category;

-- 회원 구매정보 + 연령대 + 선호 카테고리 임시 테이블 생성

create temporary table customer_pur_info_ageband_pre_category as
select a.*,
		b.category as pre_category
from customer_pur_info_ageband as a
left join customer_pre_category as b
on a.mem_no = b.mem_no;

-- check

select *
from customer_pur_info_ageband_pre_category;

-- 회원분석용 데이터 마트를 생성 ( 회원 구매정보 + 연령대 + 선호 카테고리 임시 테이블)

create table customer_mart as
select *
from customer_pur_info_ageband_pre_category;

-- check

select * 
from customer_mart;

-- 데이터 정합성
-- 정합성은 데이터가 모순없이 일관되게 일치하는 것을 의미한다

-- 데이터 마트 회원수의 중복은 없는가
select *
from customer_mart;

select count(mem_no),
		count(DISTINCT(mem_no))
from customer_mart;

-- 데이터 마트의 요약/파생변수의 오류는 없는지 확인

select *
from customer_mart;

-- 회원('1000005')의 구매정보
-- 구매금액 408000, 구매횟수 3, 구매수량 14

select sum(a.sales_qty * b.price) as 구매금액,
		count(a.order_no) as 구매횟수,
		sum(a.sales_qty) as  구매수량
from sales as a
left join product as b
on a.product_code = b.product_code 
where mem_no = '1000005'; 

-- 회원('1000005')의 선호카테고리, 'home'
select *
from sales as a
left join product as b
on a.product_code = b.product_code 
where mem_no = '1000005'; 

-- 데이터 마트 구매자 비중(%)의 오류는 없는지 확인

-- customer(회원) 테이블 기준, sales(주문) 테이블 구매 회원번호 left join 결합
select *
from customer as a
left join ( 
		  select distinct mem_no
		  from sales
) as b 
on a.mem_no = b.mem_no ;

-- 구매여부 추가

select *,
		case when b.mem_no is not null then '구매'
		else '미구매' 
		end as 구매여부 
from customer as a
left join ( 
		  select distinct mem_no
		  from sales
) as b 
on a.mem_no = b.mem_no ;

-- 구매여부별 회원수
select 구매여부, 
		count(mem_no) as 회원수
from (
	select a.*,
		case when b.mem_no is not null then '구매'
		else '미구매' 
			end as 구매여부 
	from customer as a
	left join ( 
			  select distinct mem_no
			  from sales
	) as b 
	on a.mem_no = b.mem_no
	) as a
group by 구매여부;

-- check 미구매 1459, 구매 1202
select count(*) as 미구매
from customer_mart
where 구매금액 is null;

select count(*) as 구매
from customer_mart
where 구매금액 is not null;






















