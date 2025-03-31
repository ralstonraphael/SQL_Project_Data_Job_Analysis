/*
GOAL: Identify the most in-demand skills for Data Analysts
PURPOSE: Reveals which skills are most sought-after by employers,
helping professionals focus their learning on market-relevant competencies
*/

-- Count how many job postings require each specific skill
SELECT
    skills_dim.skills AS skill_name,  -- Clean naming for readability
    COUNT(skills_job_dim.job_id) AS demand_count  -- Total jobs requiring each skill
FROM 
    job_postings_fact
/* Connection Path:
   1. Link job postings to skills through bridge table (skills_job_dim)
   2. Map skill IDs to actual skill names (skills_dim) */
INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id  -- Connect jobs to their skills
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id  -- Get readable skill names
WHERE
    job_title_short = 'Data Analyst'  -- Focus specifically on Data Analyst roles
GROUP BY
    skills_dim.skills  -- Aggregate counts by each unique skill
ORDER BY
    demand_count DESC  -- Show most frequently demanded skills first
LIMIT 7;  -- Return the top 7 most in-demand skills