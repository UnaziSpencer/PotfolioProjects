Select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4 

--Select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population 
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


Select Location, date, total_cases,total_deaths, (cast(total_deaths as decimal))/(cast(total_cases as decimal))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%Nigeria%'
order by 1,2

Select Location, date, population, total_cases, (cast(total_cases as decimal))/population*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%Nigeria%'
where continent is not null
order by 1,2

--looling at countries with highest infection rate compared to population

Select Location, population, max(total_cases) as HigestInfectionCount, (cast(max(total_cases) as decimal))/(population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%Nigeria%'
Group by Location, population
order by PercentPopulationInfected desc

--Showing countries with highest death count per population

Select Location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%Nigeria%'
where continent is not null
Group by Location
order by TotalDeathCount desc

-- Lets bring things down by continents

-- Showing continents with the highest death count per population

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%Nigeria%'
where continent is not null
Group by continent
order by TotalDeathCount desc

--Global numbers

Select date, Sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/Sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%Nigeria%'
Where continent is not null
Group by date
order by 1,2

--Looking at total population vs vaccinations

select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
order by 2,3
 

 --Use Cte

 with PopvsVac (Continent, Location, Date, Population, RollingPeopleVaccinated, new_vaccinations)
 as
 (
 select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac

--Temp Table

Drop Table if Exists  #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population Numeric,
New_Vaccination Numeric,
RollingPeopleVaccinated Numeric
)

insert into #PercentPopulationVaccinated
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3
select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

--Creating view to store Data for later visualizations  

Create view PercentPopulationVaccinated as
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
--select *, (RollingPeopleVaccinated/Population)*100
--from #PercentPopulationVaccinated