-- 재구매율 및 구매주기 분석

-- 기준( 기업마다 상이한 기준을 적용한다)
-- 재구매자 : 최초 구매일 이후, +1일 이후 구매자
-- 구매주기 : 구매간격(최근구매일자 - 최초구매일자) / (구매횟수 - 1) 

-- 분석용 데이터마트 생성

create table RE_PUR_CYCLE as
select  *,
		case when date_add(최초구매일자, interval + 1 day) <= 최근구매일자 then 'Y'
		else 'N'
		end as 재구매여부,
		case when 구매횟수 - 1 = 0 or DATEDIFF(최근구매일자, 최초구매일자) = 0 then 0
		else DATEDIFF(최근구매일자, 최초구매일자) / (구매횟수 - 1) end as 구매주기
from  (
		select  mem_no,
				min(order_date) as 최초구매일자,
				max(order_date) as 최근구매일자,
				count(order_no) as 구매횟수
		from sales 
		where mem_no <> '9999999' /*비회원은 제외*/
		group by mem_no 
) as a;

-- check

select *
from RE_PUR_CYCLE;

-- 회원('1000021')의 구매정보
-- 1000021	2019-05-07	2019-05-21	3	Y	7.0000
select *
from RE_PUR_CYCLE 
where mem_no = '1000021';

select *
from sales
where mem_no = '1000021';

-- 재구매 회원수 비중

select  count(DISTINCT mem_no) as 구매회원수,
		count(distinct case when 재구매여부 = 'Y' then mem_no end) as 재구매회원수
from RE_PUR_CYCLE ;

-- 평균 구매주기 및 구매주기 구간별 회원수

select  avg(구매주기)
from RE_PUR_CYCLE 
where 구매주기 > 0;

select  *,
		case when 구매주기 <= 7 then '7일이내'
		     when 구매주기 <= 14 then '14일이내'
		     when 구매주기 <= 21 then '21일이내'
		     when 구매주기 <= 28 then '28일이내'
		else '29일이후'
		end as 구매주기_구간		
from RE_PUR_CYCLE 
where 구매주기 > 0;


select  구매주기_구간,
		count(mem_no) as 회원수
from (
		select  *,
				case when 구매주기 <= 7 then '7일이내'
				     when 구매주기 <= 14 then '14일이내'
				     when 구매주기 <= 21 then '21일이내'
				     when 구매주기 <= 28 then '28일이내'
				else '29일이후'
				end as 구매주기_구간		
		from RE_PUR_CYCLE 
		where 구매주기 > 0
) as a 
group by 구매주기_구간;
