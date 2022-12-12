-- RFM 분석
-- 고객가치를 분석할 때 사용되는 고객가치 평가모형

-- Recency : 최근성
-- Frequency : 구매빈도
-- Monetary : 구매금액

-- RFM 분석용 데이터 마트 생성

CREATE TABLE RFM AS
SELECT  A.*
		,B.구매금액
        ,B.구매횟수
  FROM  CUSTOMER AS A
  LEFT
  JOIN  (
		SELECT  A.MEM_NO
				,SUM(A.SALES_QTY * B.PRICE) AS 구매금액 /* Monetary: 구매 금액 */
				,COUNT(A.ORDER_NO) AS 구매횟수 /* Frequency: 구매 빈도 */
		  FROM  SALES AS A
		  LEFT
		  JOIN  PRODUCT AS B
			ON  A.PRODUCT_CODE = B.PRODUCT_CODE
		 WHERE  YEAR(A.ORDER_DATE) = '2020' /* Recency: 최근성 */
		 GROUP
			BY  A.MEM_NO
		)AS B
    ON  A.MEM_NO = B.MEM_NO;
    
-- check
   
select *
from RFM;

-- RFM 세분화별 회원 수 

select  *,
		case when 구매금액 > 5000000 then 'vip'
			 when 구매금액 > 1000000 or 구매횟수 > 3 then '우수회원'
			 when 구매금액 > 0 then '일반회원'
			 else '잠재회원'
			 end as 회원세분화
from RFM;

-- from절 서브쿼리를 통해 회원세분화별 회원수를 확인
select  회원세분화,
		count(mem_no) as 회원수
from (
		select  *,
				case when 구매금액 > 5000000 then 'vip'
					 when 구매금액 > 1000000 or 구매횟수 > 3 then '우수회원'
					 when 구매금액 > 0 then '일반회원'
					 else '잠재회원'
					 end as 회원세분화
from RFM
) as a
group by 회원세분화
order by 회원수 desc;

-- RFM 세분화별 매출액
select  회원세분화,
		sum(구매금액) as 구매금액
from (
		select  *,
				case when 구매금액 > 5000000 then 'vip'
					 when 구매금액 > 1000000 or 구매횟수 > 3 then '우수회원'
					 when 구매금액 > 0 then '일반회원'
					 else '잠재회원'
					 end as 회원세분화
from RFM
) as a
group by 회원세분화
order by 구매금액 desc;

-- RFM 세분화별 인당 구매금액

select  회원세분화,
		sum(구매금액) / count(mem_no) as 구매금액
from (
		select  *,
				case when 구매금액 > 5000000 then 'vip'
					 when 구매금액 > 1000000 or 구매횟수 > 3 then '우수회원'
					 when 구매금액 > 0 then '일반회원'
					 else '잠재회원'
					 end as 회원세분화
from RFM
) as a
group by 회원세분화
order by 구매금액 desc;

