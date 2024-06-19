use PortfolioProject;

--select * from dbo.[Covid.Death];

----select data that we are gping to be using 

select location, date, total_cases, new_cases, total_deaths, population
from [Covid.Death]
order by 1,2

---total cases vs total deaths
----sows the likelihood of dying if you cpntract covid in your country

Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from [Covid.Death]
where location like '%States%'
order by 1,2

----looking at total cases vs population
----shows the percentage of population got covid
Select location, date, population, total_cases,
(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPopulationInfected
from [Covid.Death]
where location like '%States%'
order by 1,2

----looking at countries with highest infection rate compared to population
Select location, population, MAX(total_cases) as HighestInfectionCount,
(CONVERT(float, max(total_cases)) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPopulationInfected
from [Covid.Death]
group by location, population 
order by PercentPopulationInfected desc

---showing countries with highest death count per population
select location ,max(cast(total_deaths as int)) as TotalDeathCount
from [Covid.Death]
where continent is  not null
group by location
order by TotalDeathCount desc

---lets break things down by continent
---showing continents with highest death count per population

select location ,max(cast(total_deaths as int)) as TotalDeathCount
from [Covid.Death]
where continent is null
group by location
order by TotalDeathCount desc

---GLOBAL NUMBERS 

Select date ,sum(cast(new_cases as int)) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/ nullif (sum (new_cases),0) * 100 as DeathPercentage
from [Covid.Death]
where continent is not null
group by date 
order by 1,2 

Select sum(cast(new_cases as int)) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/ nullif (sum (new_cases),0) * 100 as DeathPercentage
from [Covid.Death]
where continent is not null
order by 1,2 

----------------------------------------------------------------------
---drop table covid.vaccinations

----looking at Total Populations vs Vaccinations

select dea.continent , dea.location , dea.date , dea.population, vac.new_vaccinations , 
sum(convert(int,vac.new_vaccinations)) over (partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
from [Covid.Death] dea 
join CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3


-----use cte
with PopvsVac (continent,Location, Date , Population, New_Vaccinations , RollingPeopleVaccinated)
as
(
select dea.continent , dea.location , dea.date , dea.population, vac.new_vaccinations , 
sum(convert(int,vac.new_vaccinations)) over (partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
from [Covid.Death] dea 
join CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null)
---order by 2,3
select *, (RollingPeopleVaccinated/Population) * 100
from PopvsVac 


----- Temp Table 

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric)

insert into #PercentPopulationVaccinated
select dea.continent , dea.location , dea.date , dea.population, vac.new_vaccinations , 
sum(convert(int,vac.new_vaccinations)) over (partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
from [Covid.Death] dea 
join CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null

---order by 2,3
select *, (RollingPeopleVaccinated/Population) * 100
from #PercentPopulationVaccinated


-----------------------------------
----Creating view to store data for later visualizations

Create View PercentPopulationVaccinated as
select dea.continent , dea.location , dea.date , dea.population, vac.new_vaccinations , 
sum(convert(int,vac.new_vaccinations)) over (partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
from [Covid.Death] dea 
join CovidVaccinations vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
------------------------------------------------
select * from PercentPopulationVaccinated

















