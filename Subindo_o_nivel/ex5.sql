-- Conte quantos funcionários existem por cargo (JobTitle).

SELECT
    JOBTITLE,
    COUNT(*) AS TOTAL_FUNCIONARIOS
FROM HUMANRESOURCES.EMPLOYEE
GROUP BY JOBTITLE;