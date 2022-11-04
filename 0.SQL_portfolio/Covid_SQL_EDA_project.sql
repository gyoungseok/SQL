-- Covid 19 DATA Exploration Project By Using MySQL

-- 조회결과 약 23만건 정도의 자료가 나온다.
SELECT count(*) FROM coviddeath;

-- 'coviddeath'테이블에서 분석할 데이터를 지정하고, 널값이 없는 경우만 조회해서, 1번 컬럼(location)을 기준으로 오름차순 정렬 
SELECT location, DATE, total_cases, new_cases, total_deaths, population
FROM coviddeath
WHERE continent IS NOT NULL
ORDER BY 1; 

-- Total cases vs Deaths
SELECT location, DATE, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM coviddeath
WHERE location LIKE 'South Korea'
AND continent IS NOT NULL
ORDER BY DeathPercentage desc;









