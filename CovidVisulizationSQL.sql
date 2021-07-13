-- Total covid cases in the world as death
SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as float))/SUM(CAST(New_Cases as float))*100 as DeathPercentage
From covidDeaths where continent is not null;

-- continent wise deaths and include only the right continents data
Select location, SUM(cast(new_deaths as int)) as TotalDeath, SUM(cast(new_deaths as float))/SUM(CAST(New_Cases as float))*100 as DeathPercentage 
From covidDeaths Where continent is null and location not in ('World', 'European Union', 'International') 
Group by location order by TotalDeath desc;

-- country wise covid cases
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max(CAST(total_cases as Float)/CAST(population as float))*100 as PercentPopulationInfected
From covidDeaths Group by Location order by PercentPopulationInfected desc;

-- country wise people infected on each date
Select Location, Population,date, MAX(total_cases) as InfectionCount,  Max(CAST(total_cases as Float)/CAST(population as float))*100 as PercentPopulationInfected
From covidDeaths where continent is not NULL Group by Location, Population, date order by PercentPopulationInfected desc;

-- Query to check for population vaccinated in countries
With PopVac (Continent, Location, Date, Population, New_Vaccinations, PeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as INT)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as PeopleVaccinated
From covidDeaths dea Join covidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
Select *, (CAST(PeopleVaccinated as float)/CAST(Population as float))*100 as PercentPeopleVaccinated
From PopVac;

