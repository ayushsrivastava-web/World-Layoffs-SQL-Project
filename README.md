# World Layoffs Data Cleaning & Exploratory Data Analysis (SQL)

## 📌 Project Overview
This repository contains a comprehensive SQL project analyzing worldwide tech layoffs from 2020 to 2023. The project is divided into two major phases:
1. **Data Cleaning:** Transforming raw, messy data into a structured and standardized format using MySQL.
2. **Exploratory Data Analysis (EDA):** Extracting deep business insights, trends, patterns, and top company rankings using advanced SQL queries (CTEs, Window Functions, Aggregations).

---

## 📊 Dataset Source
- **Dataset Origin:** Sourced from Alex The Analyst's SQL Portfolio Project repository.
- **Data File:** `layoffs.csv`
- **Link:** [Download Raw Dataset](https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv)

---

## 🛠️ Repository File Structure

```text
world-layoffs-sql-project/
├── data/
│   ├── raw_data.csv                  
│   └── cleaned_data.csv              
├── sql_scripts/
│   ├── 01_data_cleaning.sql          
│   └── 02_exploratory_data_analysis.sql 
├── screenshots/                      
│   ├── cleaned_data_preview.png
│   ├── top_companies_layoffs.png
│   └── top_companies_by_year.png
└── README.md
```

---

## 🧹 Part 1: Data Cleaning Workflow (01_data_cleaning.sql)
-The raw dataset was cleaned and structured through the following steps:
- **Removing Duplicates:**  Utilized ROW_NUMBER() partitioned across columns to identify duplicate entries (row_num > 1) and deleted them via staging tables.
- **Standardizing Data:**  Used TRIM() for white spaces, standardized Crypto variations, and converted text dates to SQL DATE type via STR_TO_DATE().
- **Handling Null/Blank Values:** Converted blank spaces to NULL and used SQL Self-Joins to populate missing industry data.
### 📸 Data Cleaning Output Snapshot
[Cleaned Data Preview](screenshots/cleaned_data_preview.png)
---

## 🔍 Part 2: Exploratory Data Analysis (EDA) (02_exploratory_data_analysis.sql)
## 📊 Key Insights & Query Output Snapshots
## 1. Top Companies by Total Layoffs
```SQL
SELECT company, SUM(total_laid_off) AS total_layoffs
FROM layoff_staging2
GROUP BY company
ORDER BY total_layoffs DESC
LIMIT 5;
```
### 📸 Query Output Snapshot
[Top Companies by Total Layoffs Preview](screenshots/top_companies_layoffs.png)
- **Key Insight:** Tech giants like Amazon, Google, and Meta recorded the highest aggregate layoffs during the peak contraction phase.

---

## 2. Monthly Rolling Total of Layoffs:
```SQL
WITH Rolling_Total AS (
    SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
    FROM layoff_staging2
    WHERE SUBSTRING(`date`,1,7) IS NOT NULL
    GROUP BY `MONTH`
    ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;
```
### 📸 Query Output Snapshot
[Monthly Rolling Total of Layoffs Preview](screenshots/monthly_rolling_total_layoff.png)
- **Key Insight:** The cumulative sum highlights aggressive spikes in layoffs heading into late 2022 and early 2023.

---

## 3. Top 5 Layoff Companies Per Year (Using DENSE_RANK):
```SQL
WITH Company_Year (company, years, total_laid_off) AS (
    SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM layoff_staging2
    GROUP BY company, YEAR(`date`)
),
Company_Year_Rank AS (
    SELECT *,
    DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking 
    FROM Company_Year
    WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;
```
### 📸 Query Output Snapshot
[Top 5 Layoff Companies Per Year Preview](screenshots/top_companies_by_year.png)
- **Key Insight:** Allows a granular view of which specific companies dominated layoff sheets year-over-year.

---

## 🚀 How to Run This Project
Clone or download this repository.

Execute 01_data_cleaning.sql in MySQL Workbench.

Execute 02_exploratory_data_analysis.sql for analytical insights.
---
