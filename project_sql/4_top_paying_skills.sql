/*
GOAL: Identifying High-Value Skills for Data Analysts
PURPOSE: Reveal which technical skills correlate with highest salaries
Business Value: Helps professionals prioritize skill development for maximum earning potential
*/

SELECT
    skills_dim.skills AS skill_name,  -- Clean naming for readability
    ROUND(AVG(salary_year_avg), 0) AS average_salary  -- Rounded to whole dollars
FROM 
    job_postings_fact
/* Connection Path:
   1. Jobs → Skills (through bridge table)
   2. Skills IDs → Skill Names */
INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'  -- Focused role filter
    AND salary_year_avg IS NOT NULL   -- Only positions with salary data
    AND salary_year_avg > 0           -- Additional data quality check
GROUP BY 
    skills_dim.skills
ORDER BY 
    average_salary DESC               -- Show highest-paying skills first
LIMIT 25;                            -- Top 25 results