CREATE VIEW v_Industry_Totals AS
SELECT 
    [industry], 
    SUM([number_laid_off]) AS [total_industry_layoffs]
FROM tech_layoffs
WHERE [industry] IS NOT NULL
GROUP BY [industry];
