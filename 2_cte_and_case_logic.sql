WITH CategorizedLayoffs AS (
    SELECT 
        event_id,
        CASE 
            WHEN [number_laid_off] <= 100 THEN 'Small (1-100)'
            WHEN [number_laid_off] > 100 AND [number_laid_off] <= 500 THEN 'Medium (101-500)'
            WHEN [number_laid_off] > 500 THEN 'Large (501+)'
            ELSE 'Unknown/Unreported'
        END AS layoff_size_category
    FROM tech_layoffs
)
SELECT 
    layoff_size_category,
    COUNT(event_id) AS total_events
FROM CategorizedLayoffs
GROUP BY layoff_size_category
ORDER BY total_events DESC;
