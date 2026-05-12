
# Project Covid Data Analysis

use corona;

describe coviddeath;


# 1) What is the total number of COVID cases and deaths globally?

SELECT sum(new_cases) as Total_Cases,
sum(new_deaths) as Total_Deaths,
round(sum(new_deaths)/sum(new_cases)*100,2) as Global_Death_Percentage
from coviddeath
where continent is not null;




# 2) What is the death percentage per country — chance of dying if infected?

Select location,population, 
SUM(new_cases) as TotalCases,
SUM(new_deaths) as TotalDeaths,
round(Sum(new_deaths)/Sum(new_cases)*100,2) as Death_Percentage_Country_Wise
from coviddeath
where continent is not null
group by location,population
having sum(new_cases)>1000
order by Death_Percentage_Country_Wise desc;


# 3) What % of each country's population got infected?

Select location,population,
Max(total_cases),
round((Max(total_cases)/population)*100,2) as Percentage_Infected_Population
from coviddeath
where continent is not null
group by location,population
order by Percentage_Infected_Population desc;


#4) Which continent had the highest death count per population?

Select continent,
sum(new_deaths) as Total_DeathCount
from coviddeath
where continent is not null
group by continent
order by 2 desc;


# 5) Which country has the highest total death count?

Select location,
Max(total_deaths) as Total_DeathCount
from coviddeath
where continent is not null
group by location
order by Total_DeathCount desc;


# 6) Global death percentage over time day by day. 

Select 
Year(Date) as Year,
Month(Date) as Month_number,
DATE_FORMAT(date, '%b %Y') as Month,
max(total_cases) as Total_cases,
max(total_deaths) as Total_Deaths,
round(max(total_deaths)/NULLIF(max(total_cases),0)*100,2) as GlobalDeathPercentage
from coviddeath
where continent is not null
group by YEAR(date), MONTH(date),DATE_FORMAT(date, '%b %Y')
order by YEAR(date), MONTH(date) ;


# 7) India-specific death percentage over time 

Select location,Year(date),Month(date),
date_format(date, '%b %Y') as Month,
max(total_deaths) as Total_Death,
max(total_cases) as Total_Cases,
round(max(total_deaths)/max(total_cases)*100,4) as Death_Percentage
from coviddeath
where continent is not null and
location="India"
group by location,Year(date),Month(date),date_format(date, '%b %Y')
order by YEAR(date), MONTH(date) ;

# 8) how many people vaccinated per country over time?

Select location,Year(date),
date_format(date, '%b %Y') as Month,
max(total_vaccinations) as Total_People_Vaccinated
from covidvaccination
where continent is not null
group by location,Year(date), date_format(date, '%b %Y');

# 9) Deaths vs vaccinations per country -- did vaccination reduce deaths?
Select d.location,d.population,
nullif(max(d.total_cases),0) as Total_Cases,
nullif(max(d.total_deaths),0) as Total_Deaths,
round(max(d.total_deaths)/NULLIF(max(d.total_cases), 0) * 100, 2) as Death_Percentage,
max(v.total_vaccinations) as People_Vaccinated,
round(max(v.total_vaccinations)/d.population*100,2) as Vaccinated_population_Percentage
from coviddeath as d
join covidvaccination as v 
on d.location=v.location
AND d.date = v.date
WHERE d.continent IS NOT NULL
AND v.total_vaccinations IS NOT NULL
GROUP BY d.location,d.population
ORDER BY Vaccinated_population_Percentage DESC;


# 10) Show rolling cumulative vaccinations per country day by day

Select cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(cv.new_vaccinations)  
over(partition by location order by date) as rolling_vaccinations
from 
coviddeath as cd join
covidvaccination as cv
on cd.location=cv.location and
cd.date=cv.date
where cd.location="India";

# 11 ) Using Cte- People Vaccinated according to population
With total_rolling_vaccination(location,date,population,new_vaccination,rolling_vaccination)
as(
Select cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(cv.new_vaccinations)  
over(partition by location order by date) as rolling_vaccinations
from 
coviddeath as cd join
covidvaccination as cv
on cd.location=cv.location and
cd.date=cv.date
where cd.location="India")

select *,(rolling_vaccination/population)*100 as Percentage_Poulation_Vaccinated from total_rolling_vaccination;


# 12) Which countries had high early deaths (2020) but low deaths post-vaccination (2021–22)?

WITH Combined_Data AS (
SELECT 
d.location,
d.date,
d.new_deaths,
v.new_vaccinations,
v.total_vaccinations
FROM coviddeath d
JOIN covidvaccination v 
ON d.location = v.location 
AND d.date = v.date
WHERE d.continent IS NOT NULL
),
Yearly_Summaries AS (
SELECT 
location,
SUM(CASE WHEN YEAR(date) = 2020 THEN new_deaths ELSE 0 END) AS Deaths_2020,
SUM(CASE WHEN YEAR(date) IN (2021, 2022) THEN new_deaths ELSE 0 END) AS Deaths_Post_Vac,
MAX(total_vaccinations) AS Max_Vaccinations
FROM Combined_Data
GROUP BY location
)
SELECT *,(Deaths_Post_Vac / Deaths_2020) AS Death_Ratio
FROM Yearly_Summaries
WHERE Deaths_2020 > (SELECT AVG(Deaths_2020) FROM Yearly_Summaries)
AND Deaths_Post_Vac < Deaths_2020 
ORDER BY Deaths_2020 DESC;

# 13) Rank countries by vaccinations per million population

WITH Country_Max_Vac AS (
SELECT 
location, 
MAX(total_vaccinations_per_hundred) * 10000 AS Vac_Per_Million
FROM covidvaccination
WHERE continent IS NOT NULL
GROUP BY location)

SELECT 
location, 
Vac_Per_Million,
DENSE_RANK() OVER(ORDER BY Vac_Per_Million DESC) as Vaccination_Rank
FROM Country_Max_Vac
ORDER BY Vaccination_Rank ASC;















