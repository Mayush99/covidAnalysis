SELECT location, date, total_cases, new_cases, total_deaths, population from covidDeaths order by 1;
-- Total cases vs Total Deaths

SELECT location, date, total_cases, new_cases, total_deaths, (total_deaths*100/total_cases) as DeathPercentage from covidDeaths order by 1;

--India death percentage
SELECT location, date, total_cases, new_cases, total_deaths, (total_deaths*100/total_cases) as DeathPercentage from covidDeaths where location like 'India';

--India total case, death vs population
SELECT location, date, total_cases, new_cases, total_deaths, population, (CAST(total_cases as Float)/CAST(population as Float))*100 as casesPercentagePopulation from covidDeaths where location like 'India';

--Total cases in each country with Percentage of population infected
Select location, population, max(total_cases) as Total_Cases_in_Country, (CAST(max(total_cases) as float)/CAST(avg(population) as Float))*100 as PercentPopulationInfected from covidDeaths group by location,population order by PercentPopulationInfected DESC; 

--country death count
Select location, population, max(CAST(total_deaths as int)) as Total_Deaths_in_Country FROM covidDeaths group by location,population order by Total_Deaths_in_Country DESC; 
-- some weird countries as well, scrolling through data we found that it is continent, and their continent column is NULL
Select location, population, max(CAST(total_deaths as int)) as Total_Deaths_in_Country FROM covidDeaths WHERE continent is not NULL group by location,population order by Total_Deaths_in_Country DESC; 

-- we can perform same analysis CONTINENT wise
Select location, Max(CAST(total_deaths as INT)) as total_Death_continent from covidDeaths where continent is NULL group by location order by total_Death_continent; 

--Population vaccinated in each day in each country
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From CovidDeaths dea
Join CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2;

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as INT)) OVER (Partition by dea.Location Order by dea.location, dea.date) as PeopleVaccinated
From CovidDeaths dea
Join CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2;

-- We can use views to use those tables for visualization
Create View PopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as INT)) OVER (Partition by dea.Location Order by dea.location, dea.date) as PeopleVaccinated
From CovidDeaths dea
Join CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null;


Select * from PopulationVaccinated;