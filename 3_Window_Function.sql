WITH RankedLayoffs AS (
    SELECT 
        company,
        industry,
        [number_laid_off],
        DENSE_RANK() OVER (PARTITION BY industry ORDER BY [number_laid_off] DESC) AS industry_rank
    FROM tech_layoffs
    WHERE industry IS NOT NULL AND [number_laid_off] IS NOT NULL
)
SELECT 
    industry,
    industry_rank,
    company,
    [number_laid_off]
FROM RankedLayoffs
WHERE industry_rank <= 3
ORDER BY industry ASC, industry_rank ASC;
