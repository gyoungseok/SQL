-- Covid 19 DATA Exploration Project By Using MySQL

USE PortfolioProject;

SELECT *
FROM coviddeath
WHERE continent IS NOT NULL
ORDER BY 3;

/* 
한국의 총 확진자수, 신규확진자, 총사망자 조회
*/
SELECT location, DATE AS 날짜, total_cases AS 총확진자, new_cases AS 신규확진자, total_deaths AS 총사망자, population AS 인구
FROM coviddeath
WHERE location LIKE 'South Korea' 
ORDER BY 1, 2; 

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
ORDER BY 1,2;

/*
인구당 감염률이 높은 국가를 조회하기.
*/
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, Max((total_cases/Population)) * 100 AS PercentPopulationInfected
FROM coviddeath
WHERE population > 10000000 /* 인구 규모가 작은 국가들을 제외하기 위해서 인구를 천만명 초과로 기준을 정했다. */
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;

/*
총 사망자수가 높은 국가를 조회
cast(), convert() 함수를 통해 total_deaths 타입을 숫자형으로 변환
unsigned는 음수를 표현하지 않아도 될 때 사용함.
*/

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM coviddeath
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;


/*
아시아 대륙 총 사망자수 조회
*/
SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM coviddeath
WHERE continent = 'Asia'
GROUP BY continent
ORDER BY TotalDeathCount DESC;

/*
한국의 사망자 수 및 사망률
*/

SELECT sum(new_cases) AS total_cases,
	   sum(new_deaths ) AS total_deaths,
	   sum(new_deaths) / sum(new_cases) * 100 AS DeathPercentage
FROM coviddeath
WHERE location = 'South Korea'
;


/* 
한국의 백신 누적 접종자수
국가별 백신 누적접종자수 조회
*/
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) over(PARTITION BY dea.location ORDER BY dea.location, dea.DATE) AS CumulPeopleVaccinated
FROM coviddeath dea
JOIN covidvaccination vac
ON dea.location = vac.location 
AND dea.date = vac.date 
-- WHERE dea.continent IS NOT NULL
WHERE dea.location LIKE 'South Korea' /*한국의 백신접종자 2021-02-26부터 시작*/
ORDER BY 2,3;

/* 
한국의 백신 누적 접종자 비율
국가별 백신 누적접종자 비율
CTE, CommonTableExpression
*/

WITH PopvsVac (continent, loacation, DATE, population, new_vaccinations, CumulPeopleVaccinated)
AS (
SELECT dea.continent, dea.location, dea.DATE, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over (PARTITION BY dea.location ORDER BY dea.location, dea.DATE) AS CumulPeopleVaccinated
FROM coviddeath dea
JOIN covidvaccination vac
ON dea.location = vac.location
AND dea.date = vac.date
-- WHERE dea.continent IS NOT NULL
WHERE dea.location LIKE 'South Korea'
)
SELECT *, (CumulPeopleVaccinated/population)*100
FROM PopvsVac
;


/* 
데이터 저장 목적의 뷰를 생성
*/

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over(PARTITION BY dea.location ORDER BY dea.location, dea.DATE) AS CumulPeopleVaccinated
FROM coviddeath AS dea
JOIN covidvaccination vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;






