
--TOTAL CASES VS POPULATION IN EAST AFRICA

SELECT
    Location,
    date,
    population,
    total_cases,
    (total_cases / population) * 100 AS DeathPercentage
FROM SQLport..CovidDeaths$
WHERE Location IN ('Uganda', 'Kenya', 'Tanzania', 'Rwanda', 'Burundi', 'South Sudan', 'Somalia', 'Ethiopia', 'Eritrea', 'Djibouti')
ORDER BY Location, date;


--LIKELYHOOD TO CONTRACT COVID AND DIE IN EAST AFRICA

SELECT
    Location,
    date,
    total_cases,
    total_deaths,
    CASE
        WHEN TRY_CAST(total_cases AS float) = 0 THEN NULL -- Avoid division by zero
        ELSE (TRY_CAST(total_deaths AS float) / TRY_CAST(total_cases AS float)) * 100
    END AS DeathPercentage
FROM SQLport..CovidDeaths$
WHERE Location IN ('Uganda', 'Kenya', 'Tanzania', 'Rwanda', 'Burundi', 'South Sudan', 'Somalia', 'Ethiopia', 'Eritrea', 'Djibouti')
ORDER BY Location, date;


--COUNTRIES IN EAST AFRICA WITH THE HIGHEST INFECTION	

SELECT
    location,
    population,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((CAST(total_cases AS DECIMAL) / CAST(population AS DECIMAL)) * 100.0) AS PercentPopulationInfected
FROM SQLport..CovidDeaths$
WHERE continent = 'Africa' AND
      location IN ('Kenya', 'Tanzania', 'Uganda', 'Rwanda', 'Burundi', 'South Sudan', 'Sudan', 'Somalia', 'Ethiopia', 'Djibouti', 'Eritrea')
GROUP BY location, population
ORDER BY PercentPopulationInfected ASC;



--TOTAL CONFIRMED CASES AND DEATHS 

SELECT
continent,
    location,
    SUM(new_cases) AS Total_Cases,
    SUM(CAST(new_deaths AS INT)) AS TotalNewDeaths,
    CASE
        WHEN SUM(new_cases) = 0 THEN NULL -- Avoid division by zero
        ELSE SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100
    END AS DeathPercentage
FROM SQLport..CovidDeaths$
WHERE continent = 'Africa' AND
      location IN ('Kenya', 'Tanzania', 'Uganda', 'Rwanda', 'Burundi', 'South Sudan', 'Sudan', 'Somalia', 'Ethiopia', 'Djibouti', 'Eritrea')
GROUP BY location, continent
ORDER BY 1,2

-- TOTAL NUMBER OF  VACCINATIONS


SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
	total_vaccinations
FROM SQLport..CovidDeaths$ dea
JOIN SQLport..CovidVaccinations$ vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.location IN ('Uganda', 'Kenya', 'Tanzania', 'Rwanda', 'Burundi', 'South Sudan', 'Somalia', 'Ethiopia', 'Eritrea', 'Djibouti')
ORDER BY dea.location, dea.date;


--ROLLINGPEOPLEVACCINATED IN EAST AFRICA


SELECT *
FROM PercentPopulationVaccinated
WHERE location IN ('Uganda', 'Kenya', 'Tanzania', 'Rwanda', 'Burundi', 'South Sudan', 'Somalia', 'Ethiopia', 'Eritrea', 'Djibouti')
ORDER BY location, date, population;









SELECT *
FROM SQLport..Sheet1$



-- HIGHEST SMOKER PERCENTAGE IN E.A COUNTRIES

	WITH SmokerData AS (
    SELECT
        location,
        MAX(CAST(female_smokers AS DECIMAL(10, 2))) AS highest_female_smokers_percentage,
        MAX(CAST(male_smokers AS DECIMAL(10, 2))) AS highest_male_smokers_percentage
    FROM
       SQLport..Sheet1$
    WHERE
        location IN ('Kenya', 'Tanzania', 'Uganda', 'Rwanda', 'Burundi', 'South Sudan', 'Somalia', 'Ethiopia', 'Eritrea', 'Djibouti')
        AND female_smokers IS NOT NULL
        AND male_smokers IS NOT NULL
    GROUP BY
        location
)

SELECT
    location,
    highest_female_smokers_percentage,
    highest_male_smokers_percentage
FROM
    SmokerData
ORDER BY
    highest_female_smokers_percentage DESC,
    highest_male_smokers_percentage DESC;





-- TOTAL DEATHS VS SMOKERS PERCENTAGE IN E.A COUNTRIES

	SELECT 
    location,
    total_deaths,
    CAST(female_smokers AS DECIMAL(10, 2)) AS female_smokers_percentage,
    CAST(male_smokers AS DECIMAL(10, 2)) AS male_smokers_percentage
FROM
   SQLport..Sheet1$
WHERE
    location IN ('Kenya', 'Tanzania', 'Uganda', 'Rwanda', 'Burundi', 'South Sudan', 'Somalia', 'Ethiopia', 'Eritrea', 'Djibouti')
    AND total_deaths IS NOT NULL
    AND female_smokers IS NOT NULL
    AND male_smokers IS NOT NULL;





--DEATH VS DIABETES PREVELENCE


	SELECT  
    location,
	population,
	total_deaths,
    MAX(diabetes_prevalence) AS highest_diabetes_prevalence
FROM
    SQLport..Sheet1$
WHERE
    location IN ('Kenya', 'Tanzania', 'Uganda', 'Rwanda', 'Burundi', 'South Sudan', 'Somalia', 'Ethiopia', 'Eritrea', 'Djibouti')

	GROUP BY location, population, total_deaths


	
