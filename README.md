# Covid-sql-analysis
COVID-19 Data Analysis using MySQL —deaths, vaccinations &amp; global trends
🦠 COVID-19 Data Analysis using SQL

📌 Project Overview
Analysed 85,000+ rows of global COVID-19 data across 
2 tables using MySQL to answer one core question —

**Did vaccination actually reduce COVID deaths?**

**Answer: Yes — hardest-hit countries saw an average 
40% reduction in deaths post-vaccination.**

---

## 📊 Dataset
- **Source:** [Our World in Data (OWID)](https://ourworldindata.org/covid-deaths)
- **Tables:** `coviddeath` + `covidvaccination`
- **Time Period:** January 2020 – April 2021
- **Countries:** 200+

---

## 🔑 Key Findings

**Finding-Value**

1) Total Cases (Jan 2020 – Apr 2021) | 150.5 Million 
2) Total Deaths | 3.18 Million 
3) Overall Global Death % | 2.11% 
4) Peak Death % | 6.46% (March 2020) 
5) Death % by Apr 2021 | 1.78% 
6) India's death reduction post-vaccination | 57.6% fewer deaths 
7) Iraq (highest reduction) | 79.3% fewer deaths 

---

## 🛠️ SQL Concepts Used

| Concept | Used For |
|---|---|
| `SUM()`, `MAX()`, `AVG()`, `ROUND()` - Global & country aggregations 
| `GROUP BY` + `HAVING` - Filtering meaningful groups 
| `NULLIF()` - Preventing division by zero 
| `DATE_FORMAT()`, `YEAR()`, `MONTH()` - Time-based analysis 
| `WHERE continent IS NULL/NOT NULL` - Dataset-specific quirk handling 
| `JOIN` - on 2 columns | Combining deaths + vaccinations 
| `SUM() OVER (PARTITION BY)` - Rolling vaccination totals 
| `WITH` -(CTE) | Cleaner multi-step queries 
| `CREATE TEMPORARY TABLE` - Temp table approach 
| `CASE WHEN` - Pre vs post-vaccination comparison 
| `DENSE_RANK()` Ranking countries by vaccinations 

---

❓ Questions Answered

1. What is the total number of COVID cases and deaths globally?
2. What is the death percentage per country?
3. What % of each country's population got infected?
4. Which continent had the highest death count?
5. Which country has the highest total death count?
6. How did global death % trend month by month?
7. India-specific death % over time
8. Did wealthy countries (GDP) have lower death rates?
9. Deaths vs vaccinations per country — did vaccination help?
10. Rolling cumulative vaccinations per country (Window Function)
11. % of population vaccinated using CTE
12. Countries with high 2020 deaths but lower post-vaccination deaths
13. Rank countries by vaccinations per million (DENSE_RANK)

---

## 💻 Tools Used
- **MySQL Workbench** — Query writing & execution
- **Dataset:** Our World in Data

---

## 👤 Author
**Ankit Topia**
Aspiring Data Analyst | Delhi, India
[www.linkedin.com/in/ankit-topia]


