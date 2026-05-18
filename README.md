# Global Tech Layoffs: End-to-End SQL Database Engineering
## 📌 Project Overview
This project transforms a messy, single-table flat CSV dataset into a structured, automated relational database environment using Microsoft SQL Server (T-SQL). The objective was to engineer advanced database objects (Views, Stored Procedures, and Window Functions) to optimize data retrieval and build an efficient data pipeline ready for Business Intelligence (BI) tools.

## 🏗️ Database Architecture
The raw data was imported into a dedicated database engine sandbox environment. The storage architecture is organized as follows:
Source Table: tech_layoffs (Contains raw multi-variable global layoff records)
Analytical Views: Permanent virtual tables pre-aggregating core business benchmarks.
Stored Procedures: Parametric automation scripts designed for dynamic dashboard filtering.

## 🛠️ Key Technical Implementations & Code Showcases

### 1. Complex Data Aggregation & Filter Logic (HAVING)
**The Objective:** Aggregate high-volume company records into macro industry benchmarks, eliminating missing variables and filtering out low-impact sectors.
```sql
SELECT 
    [industry], 
    SUM([number_laid_off]) AS [total_laid_off],
    COUNT([company]) AS [number_of_layoff_events]
FROM tech_layoffs
WHERE [industry] IS NOT NULL AND [number_laid_off] IS NOT NULL
GROUP BY [industry]
HAVING SUM([number_laid_off]) > 5000
ORDER BY [total_laid_off] DESC;
```

### 2. Segmenting Data via Conditional Logic & CTEs
**The Objective:** Categorize companies dynamically by operational impact scale using CASE WHEN expressions, cleanly structured inside a Common Table Expression (CTE) to honor SQL's strict logical Order of Execution.
```sql
WITH CategorizedLayoffs AS (
    SELECT 
        [event_id],
        CASE 
            WHEN [number_laid_off] <= 100 THEN 'Small (1-100)'
            WHEN [number_laid_off] > 100 AND [number_laid_off] <= 500 THEN 'Medium (101-500)'
            WHEN [number_laid_off] > 500 THEN 'Large (501+)'
            ELSE 'Unknown/Unreported'
        END AS [layoff_size_category]
    FROM tech_layoffs
)
SELECT 
    [layoff_size_category],
    COUNT([event_id]) AS [total_events]
FROM CategorizedLayoffs
GROUP BY [layoff_size_category]
ORDER BY [total_events] DESC;
```

### 3. Intra-Industry Benchmarking via Window Functions (DENSE_RANK)
**The Objective:** Extract the Top 3 hardest-hit organizational down-sizing events localized within each separate industry segment without collapsing row granularity.
```sql
WITH RankedLayoffs AS (
    SELECT 
        [company], [industry], [number_laid_off],
        DENSE_RANK() OVER (PARTITION BY [industry] ORDER BY [number_laid_off] DESC) AS [industry_rank]
    FROM tech_layoffs
    WHERE [industry] IS NOT NULL AND [number_laid_off] IS NOT NULL
)
SELECT [industry], [industry_rank], [company], [number_laid_off]
FROM RankedLayoffs
WHERE [industry_rank] <= 3
ORDER BY [industry] ASC, [industry_rank] ASC;
```

### 4. Database Automation via Parametric Stored Procedures
**The Objective:** Store operational querying logic permanently on the server side, exposing dual variables (@SelectedIndustry, @MinLayoffCount) to empower end-users to query custom database states seamlessly.
```sql
CREATE PROCEDURE sp_Custom_Layoff_Finder
    @SelectedIndustry NVARCHAR(100),
    @MinLayoffCount INT
AS
BEGIN
    SELECT [company], [industry], [number_laid_off], [source]
    FROM tech_layoffs
    WHERE [industry] = @SelectedIndustry
      AND [number_laid_off] >= @MinLayoffCount
    ORDER BY [number_laid_off] DESC;
END;
```

**Execution Command Example:**
EXEC sp_Custom_Layoff_Finder @SelectedIndustry = 'Fintech', @MinLayoffCount = 200;

### 5. Advanced View Joining for Market Share Analysis
**The Objective:** Establish a permanent analytical pipeline View (v_Industry_Totals) and execute an explicit LEFT JOIN back to the raw entity table. This architecture computes precise decimal percentages displaying exactly how much overall sector damage a single organization caused.

```sql
-- Step 1: Create the Permanent Aggregate View
CREATE VIEW v_Industry_Totals AS
SELECT 
    [industry], 
    SUM([number_laid_off]) AS [total_industry_layoffs]
FROM tech_layoffs
WHERE [industry] IS NOT NULL
GROUP BY [industry];
GO
-- Step 2: Join the Granular Table to the Aggregate View
SELECT 
    L.[company], L.[industry],
    L.[number_laid_off] AS [company_layoff_count],
    I.[total_industry_layoffs],
    ROUND((CAST(L.[number_laid_off] AS FLOAT) / I.[total_industry_layoffs]) * 100, 2) AS [percent_of_industry_damage]
FROM tech_layoffs AS L
LEFT JOIN v_Industry_Totals AS I 
    ON L.[industry] = I.[industry]
WHERE L.[industry] = 'Fintech' AND L.[number_laid_off] IS NOT NULL
ORDER BY L.[number_laid_off] DESC;
```

## 🧠 Key Data Competencies Demonstrated

*     **Database Pipeline Architecture:** Shifted intensive business computation out of reporting layers and optimized data payloads directly inside the engine via permanent Database Views.
*     **Logical Execution Mastery:** Overcame analytical engine syntax traps by implementing CTEs and Subqueries precisely according to internal compiler priority.
*     **Defensive Engineering & Debugging:** Developed server troubleshooting patterns to quickly resolve database connection mismatches (master routing) and visual caching discrepancies.
