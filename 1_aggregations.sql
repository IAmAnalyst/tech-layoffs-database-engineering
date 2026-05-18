SELECT 
    industry, 
    SUM([number_laid_off]) AS total_laid_off,
    COUNT(company) AS number_of_layoff_events
FROM tech_layoffs
WHERE industry IS NOT NULL AND [number_laid_off] IS NOT NULL
GROUP BY industry
HAVING SUM([number_laid_off]) > 5000
ORDER BY total_laid_off DESC;
