CREATE PROCEDURE GetCustomLayoffReport
    @TargetIndustry NVARCHAR(100),
    @MinLayoffs INT
AS
BEGIN
    SELECT 
        [company], 
        [industry], 
        [number_laid_off],
        [source]
    FROM tech_layoffs
    WHERE [industry] = @TargetIndustry
      AND [number_laid_off] >= @MinLayoffs
    ORDER BY [number_laid_off] DESC;
END;
GO