SELECT 
    L.[company],
    L.[industry],
    L.[number_laid_off] AS [company_layoff_count],
    I.[total_industry_layoffs],
    -- Math: Find what % of the industry total this single company represents
    ROUND((CAST(L.[number_laid_off] AS FLOAT) / I.[total_industry_layoffs]) * 100, 2) AS [percent_of_industry_damage]
FROM tech_layoffs AS L
LEFT JOIN v_Industry_Totals AS I 
    ON L.[industry] = I.[industry]
WHERE L.[industry] = 'Fintech' 
  AND L.[number_laid_off] IS NOT NULL
ORDER BY L.[number_laid_off] DESC;
