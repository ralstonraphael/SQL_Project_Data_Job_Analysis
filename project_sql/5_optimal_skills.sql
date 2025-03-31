/*
GOAL: Identify the most valuable skills for Data Analysts
- Combines two key metrics: high demand (job security) and high salaries (financial benefit)
- Helps professionals prioritize which skills to learn next
- Provides actionable market insights for career growth
*/

-- First CTE: Calculate demand count for each skill
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        -- Counts how many job postings require each skill
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    -- Connect jobs to their required skills:
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id  -- Links jobs to skill IDs
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id          -- Gets skill names
    WHERE
        job_title_short = 'Data Analyst'       -- Focuses on Data Analyst roles only
        AND salary_year_avg IS NOT NULL        -- Excludes jobs without salary data
    GROUP BY
        skills_dim.skill_id                    -- Groups results by skill
),

-- Second CTE: Calculate average salary for each skill
average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        -- Calculates the average salary (rounded for readability)
        ROUND(AVG(salary_year_avg), 2) AS avg_salary
    FROM job_postings_fact
    -- Same join pattern as above to connect jobs to skills
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
    GROUP BY
        skills_job_dim.skill_id
)

-- Final result combining both metrics
SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
-- Combine demand and salary information:
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE 
    demand_count > 10  -- Filters to only established skills (10+ job postings)
ORDER BY
    avg_salary DESC,   -- Prioritizes highest-paying skills first
    demand_count DESC  -- Then sorts by most in-demand
LIMIT 10;              -- Shows the top 10 most valuable skills