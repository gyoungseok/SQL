-- view

-- view는 하나 이상의 테이블을 활용하여 사용자가 정의한 가상테이블
-- view는 조인 사용을 최소화하여 편리하다
-- view 테이블은 가상 테이블이기 때문에, 중복되는 열이 저장될 수 없다


-- 테이블 결합
-- sales(주문) 테이블 기준, product(상품) 테이블 left join 결합

select a.*, a.sales_qty * b.price as 결제금액
from sales as a 
left join product as b
on a.product_code = b.product_code
order by a.order_date desc;

-- view 생성

create view sales_product as 
select a.*, a.sales_qty * b.price as 결제금액
from sales as a
left join product as b 
on a.product_code = b.product_code 
order by a.order_date desc;

-- view 실행
select *
from sales_product ;

-- view 수정

alter view sales_product as
select a.*,
	   a.sales_qty * b.price * 1.1 as 결제금액_수수료포함
from sales as a 
left join product as b
on a.product_code = b.product_code ;

-- view 실행
select *
from sales_product ;

-- view 삭제
drop view sales_product;

-- view 특징(중복되는 열은 저장되지 않음)

create view sales_product as 
select *  /* product_code가 중복되기 때문에 조회되지 않음 */
from sales as a
left join product as b 
on a.product_code = b.product_code ;













 