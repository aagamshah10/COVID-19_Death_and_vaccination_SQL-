--SELECT * 
--FROM PortfolioProject..CovidDeaths
--ORDER BY 3,4

--SELECT * 
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4

-- Selecting data we are going to use  

--SELECT location,date,total_cases,new_cases,total_deaths,population
--FROM PortfolioProject..CovidDeaths
--ORDER BY 1,2

--Looking at total_cases vs total_deaths

--SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--FROM PortfolioProject..CovidDeaths
--Where location like '%states%'
--ORDER BY 1,2

--Looking at total_cases vs Population

--SELECT location,date,total_cases,population,(total_cases/population)*100 as PopulationPercentageInfected
--FROM PortfolioProject..CovidDeaths
--WHERE location like 'I%ia'
--ORDER BY 1,2


--Looking at countries with highest infection rate compare to population

--Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--Group by Location, Population
--order by PercentPopulationInfected desc

--Showing countries with the highest Death count per population

--Select Location,MAX(CAST(Total_deaths as int)) as TotalDeathCount
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--WHERE continent is not Null
--GROUP BY Location
--ORDER BY TotalDeathCount DESC

--Let's get the highest death count per population with continents

--Select continent,MAX(CAST(Total_deaths as int)) as TotalDeathCount
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--WHERE continent is not Null
--GROUP BY continent
--ORDER BY TotalDeathCount DESC


--Select location,MAX(CAST(Total_deaths as int)) as TotalDeathCount
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--WHERE continent is  Null
--GROUP BY location
--ORDER BY TotalDeathCount DESC
 
--GLObal Numbers per date

--SELECT date,SUM(new_cases) as TotalCasesperDate, SUM(cast(new_deaths as int)) as TotalDeathPerDate	, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
--FROM PortfolioProject..CovidDeaths
----Where location like '%states%'
--WHERE continent is not null 
--GROUP by date
--ORDER BY 1,2

--GLObal Numbers

--SELECT SUM(new_cases) as TotalCasesperDate, SUM(cast(new_deaths as int)) as TotalDeathPerDate	, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
--FROM PortfolioProject..CovidDeaths
----Where location like '%states%'
--WHERE continent is not null 
--ORDER BY 1,2

--Joining 2 table deaths and vaccination

--SELECT *
--FROM PortfolioProject..CovidDeaths deaths
--JOIN PortfolioProject..CovidVaccinations vac
--ON deaths.location=vac.location 
--and deaths.date=vac.date

--Looking at total populations vs vaccinations

--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
----, (RollingPeopleVaccinated/population)*100
--From PortfolioProject..CovidDeaths dea
--Join PortfolioProject..CovidVaccinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

-- Using CTE to perform Calculation on Partition By in previous query

--WITH PopvsVac(Continent,Location,date,population,New_vaccinations,RollingPeopleVaccinated)
--as
--(
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
----, (RollingPeopleVaccinated/population)*100
--From PortfolioProject..CovidDeaths dea
--Join PortfolioProject..CovidVaccinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null 
----order by 2,3
--)
--SELECT *,(RollingPeopleVaccinated/population)*100
--FROM PopvsVac

--TEMP TABLE

--DROP TABLE IF EXISTS #PercentPopulationVaccinated
--CREATE TABLE #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_vaccinations numeric,
--RollingPeopleVaccinated numeric
--)

--INSERT INTO #PercentPopulationVaccinated
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
----, (RollingPeopleVaccinated/population)*100
--From PortfolioProject..CovidDeaths dea
--Join PortfolioProject..CovidVaccinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
----where dea.continent is not null 
----order by 2,3

--SELECT *,(RollingPeopleVaccinated/population)*100
--FROM #PercentPopulationVaccinated


--Creating View to store data for late visualizations 

--CREATE VIEW PercentPopulationVaccinateds as
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
----, (RollingPeopleVaccinated/population)*100
--From PortfolioProject..CovidDeaths dea
--Join PortfolioProject..CovidVaccinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null 
----order by 2,3

SELECT * FROM PercentPopulationVaccinateds