use practice;

-- RFM analysis

-- 분석용 데이터 마트 생성		

CREATE TABLE RFM AS 
SELECT 
  A.*, 
  B.구매금액, 
  B.구매횟수 
FROM 
  CUSTOMER AS A 
  LEFT JOIN (
    SELECT 
      A.MEM_NO 
      ,SUM(A.SALES_QTY * B.PRICE) AS 구매금액 /* Monetary: 구매 금액 */ 
      ,COUNT(A.ORDER_NO) AS 구매횟수 /* Frequency: 구매 빈도 */ 
    FROM 
      SALES AS A 
      LEFT JOIN PRODUCT AS B ON A.PRODUCT_CODE = B.PRODUCT_CODE 
    WHERE 
      YEAR(A.ORDER_DATE) = '2020' /* Recency: 최근성 */ 
    GROUP BY 
      A.MEM_NO
  ) AS B
 ON A.MEM_NO = B.MEM_NO;
   
-- 데이터마트 생성확인   
   select * from RFM;
  
-- 1. RFM 세분화별 회원수
  
-- 1-1. 회원세분화 진행(vip, 우수회원, 일반회원, 잠재회원)
  select *,
  	case when 구매금액 > 5000000 then 'vip'
  		 when 구매금액 > 1000000 or 구매횟수 > 3 then '우수회원'
  		 when 구매금액 > 0 then '일반회원'
  		 else '잠재회원' end 
  		 as 회원세분화
  from RFM;

 
 -- 1-2. 세분화된 회원과 회원수를 파악
 select 회원세분화
 		,count(mem_no) as 회원수
 from (
 		select *,
 			   case when 구매금액 > 5000000 then 'vip'
 			   		when 구매금액 > 1000000 or 구매횟수 > 3 then '우수회원'
 			   		when 구매금액 > 0 then '일반회원'
 			   		else '잠재회원' end
 			   		as 회원세분화
 		from RFM
 	  ) as A
-- (group by 회원세분화 한 줄로 적으니 오류가 계속해서 발생했다.)
group
	by 회원세분화
order
	by 회원수;

-- 1-2. 선생님 코드 
SELECT  회원세분화
		,COUNT(MEM_NO) AS 회원수
  FROM  (
		SELECT  *
				,CASE WHEN 구매금액 >  5000000 THEN 'VIP'
					  WHEN 구매금액 >  1000000 OR 구매횟수 > 3 THEN '우수회원'
					  WHEN 구매금액 >        0 THEN '일반회원'
					  ELSE '잠재회원' END AS 회원세분화
		  FROM  RFM
		)AS A
 GROUP
    BY  회원세분화
 ORDER
    BY  회원수 ASC;
   
   
-- 2. RFM 세분화별 매출액

select 회원세분화, 
	   sum(구매금액) as 구매금액
from (
	 select *,
	 		 case when 구매금액 > 5000000 then 'vip'
	 		 	  when 구매금액 > 1000000 or 구매횟수 > 3 then '우수회원'
	 		 	  when 구매금액 > 0 then '일반회원'
	 		 	  else '잠재회원' end as 회원세분화
	 from RFM
) as A
group
	by 회원세분화
order
	by 구매금액 desc;

-- 3. RFM 세분화별 인당 구매금액
select 회원세분화,
	   sum(구매금액) / count(mem_no) as 인당_구매금액
from (
	 select *,
	 		 case when 구매금액 > 5000000 then 'vip'
	 		 	  when 구매금액 > 1000000 or 구매횟수 > 3 then '우수회원'
	 		 	  when 구매금액 > 0 then '일반회원'
	 		 	  else '잠재회원' end as 회원세분화
	 from RFM
) as A
group
	by 회원세분화
order
	by 구매금액 desc;

-- 선생님코드

SELECT  회원세분화
		,SUM(구매금액) / COUNT(MEM_NO) AS 인당_구매금액
  FROM  (
		SELECT  *
				,CASE WHEN 구매금액 >  5000000 THEN 'VIP'
					  WHEN 구매금액 >  1000000 OR 구매횟수 > 3 THEN '우수회원'
					  WHEN 구매금액 >        0 THEN '일반회원'
					  ELSE '잠재회원' END AS 회원세분화
		  FROM  RFM
		)AS A
 GROUP
    BY  회원세분화
 order
 	by 구매금액;

   
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));





 