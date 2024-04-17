select *
from CovidDeaths

select *
from CovidVaccinations

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2

select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
from CovidDeaths
where location like '%Nigeria%'
order by 1,2


select location, date, total_cases, population, (cast(total_cases as float)/population)*100 as PercentPopulationInfected
from CovidDeaths
where location like '%Nigeria%'
order by 1,2

select location, total_cases, population, max(cast(total_cases as float)) as HighestInfectionCount, max((cast(total_cases as float))/population)*100 as PercentPopulationInfected
from CovidDeaths
--where location like '%Nigeria%'
group by location, population, total_cases
order by PercentPopulationInfected desc


select continent, max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%Nigeria%'
where continent is not null
group by continent
order by TotalDeathCount desc



select continent, max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%Nigeria%'
where continent is not null
group by continent
order by TotalDeathCount desc 
  



select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
--where location like '%Nigeria%'
where continent is not null
--group by date
order by 1,2


select *
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

set ansi_warnings off

with PopsvsVac (continent,location, date, population, new_vaccinations, RollinPeopleVaccinated )
as
(	
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.date) as RollinPeopleVaccinated												
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)
select *, (RollinPeopleVaccinated/population)*100
from PopsvsVac


--drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollinPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.date) as RollinPeopleVaccinated												
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3

select *, (RollinPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


create view PopsvsVacs as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.date) as RollinPeopleVaccinated												
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3

select *
from PopsvsVacs


