-- Covid 19 DATA Exploration Project By Using MySQL

USE PortfolioProject;

SELECT *
FROM coviddeath
WHERE continent IS NOT NULL
ORDER BY 3;

/* 
'coviddeath'테이블에서 분석 데이터를 지정하고, NULL값이 없는 경우만 조회해서, 1번 컬럼(location)을 기준으로 오름차순 정렬  
*/
SELECT location AS 위치, DATE AS 날짜, total_cases AS 총확진자, new_cases AS 신규확진자, total_deaths AS 총사망자, population AS 인구
FROM coviddeath
WHERE continent IS NOT NULL
ORDER BY 1; 

/*
 Total cases vs Deaths 
(한국의 총 확진자수, 사망자 수, 사망률 조회) 
*/
SELECT location, DATE, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM coviddeath
WHERE location LIKE 'South Korea'
AND continent IS NOT NULL
ORDER BY 2;

/* 
Total cases vs Population
한국의 (인구당) 감염비율 파악해보기. 
*/
SELECT location, DATE, population, total_cases, (total_cases/population) * 100 AS PercentPopulationInfected
FROM coviddeath
WHERE location LIKE 'South Korea'
ORDER BY 1;

/*
인구당 감염률이 높은 국가를 조회하기.
한국이 49.72%로 인구 천만이상 국가에서 4위를 차지했다.
*/
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, Max((total_cases/Population)) * 100 AS PercentPopulationInfected
FROM coviddeath
WHERE population > 10000000 /* 인구 규모가 작은 국가들을 제외하기 위해서 인구를 천만명 초과로 기준을 정했다. */
GROUP BY location, population2
ORDER BY PercentPopulationInfected DESC;

/*
총 사망자수가 높은 국가를 조회
cast(), convert() 함수를 통해 total_deaths 타입을 숫자형으로 변환
unsigned는 음수를 표현하지 않아도 될 때 사용함.
*/

/* 이 쿼리는 문제가 있다.이 쿼리는 문제가 있다.이 쿼리는 문제가 있다.이 쿼리는 문제가 있다.이 쿼리는 문제가 있다.이 쿼리는 문제가 있다.이 쿼리는 문제가 있다. */

SELECT location, MAX(cast(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM coviddeath
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;




