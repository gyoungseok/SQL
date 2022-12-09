USE practice;

-- 재구매율 및 구매주기 분석실습

-- 분석용 데이터마트를 생성
CREATE TABLE re_pur_cycle AS
SELECT *
		,CASE WHEN date_add(최초구매일자, INTERVAL + 1 DAY) <= 최근 구매일자 THEN 'Y' ELSE 'N' END AS 재구매 여부
		,DATEDIFF(최근구매일자, 최초구매일자) AS 구매간격
		,CASE WHEN 구매횟수 -1 = 0 OR DATEDIFF(최근구매일자, 최초구매일자) = 0 THEN 0
			  ELSE DATEDIFF(최근구매일자, 최초구매일자) / (구매횟수 - 1) END AS 구매주기
FROM (
	  SELECT mem_no
	  		 ,min(order_date) AS 최초구매일자
	  		 ,max(order_date) AS 최근구매일자
	  		 ,count(order_no) AS 구매횟수
	  FROM Sales
	  WHERE mem_no <> '9999999' /* 비회원은 제외한다 */
	  GROUP BY mem_no
) AS A;

/* -- techer code
CREATE TABLE RE_PUR_CYCLE AS
SELECT  *
		,CASE WHEN DATE_ADD(최초구매일자, INTERVAL +1 DAY) <= 최근구매일자 THEN 'Y' ELSE 'N' END AS 재구매여부
        
        ,DATEDIFF(최근구매일자, 최초구매일자) AS 구매간격
        ,CASE WHEN 구매횟수 -1 = 0 OR DATEDIFF(최근구매일자, 최초구매일자) = 0 THEN 0
              ELSE DATEDIFF(최근구매일자, 최초구매일자) / (구매횟수 -1) END AS 구매주기 
  FROM  (
		SELECT  MEM_NO
                ,MIN(ORDER_DATE) AS 최초구매일자        
				,MAX(ORDER_DATE) AS 최근구매일자
                ,COUNT(ORDER_NO) AS 구매횟수
          FROM  SALES
		 WHERE  MEM_NO <> '9999999' /* 비회원 제외 *\/
		 GROUP
            BY  MEM_NO
		)AS A; */



-- 확인
SELECT * FROM re_pur_cycle; 

-- 회원번호가 '1000021'인 데이터를 조회해보기
SELECT *
FROM re_pur_cycle
WHERE mem_no = '1000021';

SELECT *
FROM sales
WHERE mem_no = '1000021';

-- 1. 재구매 회원수 확인
SELECT count(DISTINCT mem_no) AS 구매회원수
	   ,count(DISTINCT CASE WHEN 재구매여부 ='Y' THEN mem_no END ) AS 재구매회원수
FROM re_pur_cycle;

-- 2-1. 평균 구매주기 
SELECT AVG(구매주기)
FROM re_pur_cycle
WHERE 구매주기 > 0;

-- 2-2 구매주기 구간별 회원수 나누기
SELECT *
	   ,CASE WHEN 구매주기 <= 7 THEN '7일이내'
	   		 WHEN 구매주기 <= 14 THEN '14일이내'
	   		 WHEN 구매주기 <= 21 THEN '21일이내'
	   		 WHEN 구매주기 <= 28 THEN '28일이내'
	   		 ELSE '29일 이후' END AS 구매주기_구간
FROM re_pur_cycle
WHERE 구매주기 > 0;

-- 2-3 구매주기별 회원수 확인
SELECT  구매주기_구간
		,COUNT(MEM_NO) AS 회원수
   FROM  (
		SELECT  *
				,CASE WHEN 구매주기 <= 7 THEN '7일 이내'
					  WHEN 구매주기 <= 14 THEN '14일 이내'
					  WHEN 구매주기 <= 21 THEN '21일 이내'
					  WHEN 구매주기 <= 28 THEN '28일 이내'
					  ELSE '29일 이후' END AS 구매주기_구간
		  FROM  RE_PUR_CYCLE
		 WHERE  구매주기 > 0
		 )AS A
  GROUP
     BY  구매주기_구간;
