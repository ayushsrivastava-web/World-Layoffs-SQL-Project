-- Data Cleaning

SELECT *
FROM layoff;

-- 1.REMOVE DUPLICATES
-- 2.STANDARDIZE THE DATA
-- 3.NULL VALUES OR BLANK VALUES
-- 4.REMOVE ANY COLUMNS

CREATE TABLE layoff_staging
LIKE layoff;

SELECT *
FROM layoff_staging;

INSERT INTO layoff_staging
SELECT *
FROM layoff;


SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoff_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoff_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoff_staging
WHERE company = 'Casper';

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoff_staging
)
DELETE 
FROM duplicate_cte
WHERE row_num > 1;  


SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoff_staging;

CREATE TABLE `layoff_staging2`  
(
`company` text,
`location` text, 
`industry` text, 
`total_laid_off` int DEFAULT NULL, 
`percentage_laid_off` text, 
`date` text, 
`stage` text, 
`country` text, 
`funds_raised_millions` int DEFAULT NULL,
`row_num` INT
);

INSERT INTO layoff_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoff_staging;

SELECT *
FROM layoff_staging2
WHERE row_num > 1;

DELETE
FROM layoff_staging2
WHERE row_num > 1;

SELECT *
FROM layoff_staging2;


SELECT company, TRIM(company)
FROM layoff_staging2;

UPDATE layoff_staging2
SET company = TRIM(company);

SELECT industry
FROM layoff_staging2;

SELECT DISTINCT industry
FROM layoff_staging2
ORDER BY 1;

SELECT *
FROM layoff_staging2
WHERE industry LIKE 'Crypto%'; 

UPDATE layoff_staging2
SET industry = 'crypto'
WHERE industry LIKE 'Crypto%';

SELECT *
FROM layoff_staging2;

SELECT DISTINCT location
FROM layoff_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoff_staging2
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoff_staging2
ORDER BY 1;

UPDATE layoff_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT *
FROM layoff_staging2;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoff_staging;

UPDATE layoff_staging2
set `date` =STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoff_staging2;

ALTER TABLE layoff_staging2
MODIFY COLUMN `date` date;

SELECT *
FROM layoff_staging2;

-- remove null & blank line
SELECT *
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


UPDATE layoff_staging2 
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoff_staging2
WHERE industry IS NULL
OR industry = '';

SELECT * 
FROM layoff_staging2
WHERE company = 'Airbnb';

SELECT * 
FROM layoff_staging2
WHERE industry = ''
OR industry IS NULL ;

SELECT *
FROM layoff_staging2 t1
JOIN layoff_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

SELECT t1.industry, t2.industry
FROM layoff_staging2 t1
JOIN layoff_staging2 t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE layoff_staging2 t1
JOIN layoff_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

SELECT *
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoff_staging2;

SELECT *
FROM layoff_staging2;

ALTER TABLE layoff_staging2
DROP COLUMN row_num;

SELECT stage
FROM layoff_staging2
WHERE stage IS NULL;