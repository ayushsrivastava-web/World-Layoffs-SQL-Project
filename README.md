📌 Project Overview
This repository contains a comprehensive SQL project analyzing worldwide tech layoffs from 2020 to 2023. The project is divided into two major phases:

Data Cleaning: Transforming raw, messy data into a structured and standardized format using MySQL.

Exploratory Data Analysis (EDA): Extracting deep business insights, trends, patterns, and top company rankings using advanced SQL queries (CTEs, Window Functions, Aggregations).

📊 Dataset Source
Download Link: https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv

🧹 Part 1: Data Cleaning Workflow (01_data_cleaning.sql)
The raw dataset was cleaned and structured through the following steps:

Removing Duplicates:

Created a staging table (layoff_staging) and utilized the ROW_NUMBER() window function partitioned across all columns to identify duplicate entries (row_num > 1).

Filtered and deleted duplicate rows using a second clean staging table (layoff_staging2).

Standardizing Data:

Company Names: Trimmed extra white spaces using TRIM().

Industry Names: Fixed spelling discrepancies and grouped variations (e.g., standardizing variants like Crypto* to crypto).

Country Names: Cleaned trailing periods (e.g., standardizing 'United States.' to 'United States').

Date Formats: Converted text-based dates to proper SQL DATE format using STR_TO_DATE() and ALTER TABLE.

Handling Null and Blank Values:

Converted empty string industries ('') to NULL to enable proper self-joins.

Performed a SQL Self-Join (layoff_staging2 t1 JOIN layoff_staging2 t2) to populate missing industry values where another row for the same company had valid industry data.

Removed rows where both total_laid_off and percentage_laid_off were NULL as they lacked critical analytical metrics.

📸 Data Cleaning Output Snapshot
What to capture: Run SELECT * FROM layoff_staging2 LIMIT 10; to show the clean table output.

🔍 Part 2: Exploratory Data Analysis (EDA) (02_exploratory_data_analysis.sql)
After cleaning, advanced SQL queries were executed to explore trends and find key metrics:

Maximum Impact: Found the maximum layoffs in a single day and max percentage laid off (100% shutdown companies).

Company & Industry Aggregations: Grouped total layoffs by company and industry using SUM() and ordered them descending.

Timeline & Seasonality: Analyzed layoffs year-by-year and month-by-month using SUBSTRING() string extraction.

Rolling Total (Moving Sum): Calculated a cumulative sum of layoffs month over month using window functions.

Company Rankings: Used DENSE_RANK() partitioned by years via CTEs to find the Top 5 layoff companies per year.

📊 Key Insights & Query Output Snapshots
1. Top Companies by Total Layoffs
SQL
SELECT company, SUM(total_laid_off) AS total_layoffs
FROM layoff_staging2
GROUP BY company
ORDER BY total_layoffs DESC
LIMIT 5;
📸 Screenshot to attach: screenshots/top_companies_layoffs.png

Key Insight: Tech giants like Amazon, Google, and Meta recorded the highest aggregate layoffs during the peak contraction phase.

2. Monthly Rolling Total of Layoffs
SQL
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
📸 Screenshot to attach: screenshots/rolling_total_layoffs.png

Key Insight: The cumulative sum highlights aggressive spikes in layoffs heading into late 2022 and early 2023.

3. Top 5 Layoff Companies Per Year (Using DENSE_RANK)
SQL
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
📸 Screenshot to attach: screenshots/top_companies_by_year.png

Key Insight: Allows a granular view of which specific companies dominated layoff sheets year-over-year.

🚀 How to Run This Project
Clone or download this repository.

Open MySQL Workbench (or any SQL client).

Run 01_data_cleaning.sql step-by-step to set up staging tables, clean duplicates, format columns, and handle nulls.

Run 02_exploratory_data_analysis.sql to execute aggregations, window functions, and retrieve analytical insights.