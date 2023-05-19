SELECT* FROM 
PortfolioProject1..CovidDeaths
ORDER BY 3,4

SELECT * FROM 
PortfolioProject1..CovidVaccinations
ORDER BY 3,4
--SELECT DATA THAT WE ARE GOING TO BE USING
SELECT location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject1..CovidDeaths
ORDER BY 1,2

-- Looking at Total Cases VS Total Deaths
-- show likelihood of daying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as "%of death"
from PortfolioProject1..CovidDeaths
where location like '%algeria%'
ORDER BY 1,2
-- Loooking at Total Cases vs population
-- show what percentage of population got covid
SELECT location, date,population, total_cases,  (total_cases/population)*100 as "%of cases"
from PortfolioProject1..CovidDeaths
where location like '%algeria%'
ORDER BY 1,2

--Looking at Countries with Highest Infection Rate comapred to Population 
SELECT location,population, Max(total_cases)as Highestinfectioncount, MAX(total_cases/population)*100 as "%of cases"
from PortfolioProject1..CovidDeaths
--where location like '%algeria%'
Group By location, population 
ORDER BY "%of cases" DESC
--SHOW cOUNTRIES WITH HIGHEST OF DEATH COUNT PER POPULATION 
SELECT location, Max(cast(total_deaths as int ))as TotalDeatheCount 
from PortfolioProject1..CovidDeaths
--where location like '%algeria%'
where continent is not null
Group By location  
ORDER BY TotalDeatheCount DESC
-- Let's  break things down by continet 
SELECT location, Max(cast(total_deaths as int ))as TotalDeatheCount 
from PortfolioProject1..CovidDeaths
--where location like '%algeria%'
where continent is null
Group By location
ORDER BY TotalDeatheCount DESC

--Showing content with the highest death count per population 
SELECT continent, Max(cast(total_deaths as int ))as TotalDeatheCount 
from PortfolioProject1..CovidDeaths
--where location like '%algeria%'
where continent is not null
Group By continent
ORDER BY TotalDeatheCount DESC

----GLOBAL NUMBERS 
SELECT  date, SUM(new_cases) as totalcases , 
sum(cast(new_deaths as int)) as totalde,sum(cast(new_deaths as int))/sum(new_Cases)*100 as deathpercentage
from PortfolioProject1..CovidDeaths
--where location like '%algeria%'
WHERE CONTINENT IS NOT NULL
group by date
ORDER BY 1,2
-- Looking total population vs Vaccinations
SELECT dea.continent, dea.location ,dea.date ,dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations )) over (Partition by dea.location order by dea.location, dea.date)
as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
FROm PortfolioProject1..CovidDeaths dea
join PortfolioProject1..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
order by  2,3
-- USE CTE
WITH POPVSVAC(Continent, location,  date, Population,new_vaccinations, rollingpeoplevaccinated)
as
(
SELECT dea.continent, dea.location ,dea.date ,dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations )) over (Partition by dea.location order by dea.location, dea.date)
as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
FROm PortfolioProject1..CovidDeaths dea
join PortfolioProject1..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
--order by  2,3
)
select *,(rollingpeoplevaccinated/population)*100 as percentageofrolling
from POPVSVAC

--Temp Table 
drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continet nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
rollingpeoplevaccinated numeric
)
insert #PercentPopulationVaccinated
SELECT dea.continent, dea.location ,dea.date ,dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations )) over (Partition by dea.location order by dea.location, dea.date)
as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
FROm PortfolioProject1..CovidDeaths dea
join PortfolioProject1..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
--where dea.continent is not null
--order by  2,3*
select *,(rollingpeoplevaccinated/population)*100 as percentageofrolling
from #PercentPopulationVaccinated


--creating view to store data for later visulatization 
create view PercentPopulationvacinated as
SELECT dea.continent, dea.location ,dea.date ,dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations )) over (Partition by dea.location order by dea.location, dea.date)
as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
FROm PortfolioProject1..CovidDeaths dea
join PortfolioProject1..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
--order by  2,3*
