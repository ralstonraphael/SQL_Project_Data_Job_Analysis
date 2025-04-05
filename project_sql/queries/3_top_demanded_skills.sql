/*
 GOAL: Identify the most in-demand skills for Data Analysts
 PURPOSE: Reveals which skills are most sought-after by employers,
 helping professionals focus their learning on market-relevant competencies
 */
-- Count how many job postings require each specific skill
WITH raw_counts AS (
    SELECT skills_dim.skills AS skill_name,
        -- Clean naming for readability
        COUNT(skills_job_dim.job_id) AS demand_count -- Total jobs requiring each skill
    FROM job_postings_fact
        /* Connection Path:
         1. Link job postings to skills through bridge table (skills_job_dim)
         2. Map skill IDs to actual skill names (skills_dim) */
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id -- Connect jobs to their skills
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id -- Get readable skill names
    WHERE job_title_short = 'Data Analyst' -- Focus specifically on Data Analyst roles
    GROUP BY skills_dim.skills -- Aggregate counts by each unique skill
),
total_jobs AS(
    -- Second CTE: Calculate total number of Data Analyst jobs for normalization
    SELECT COUNT(DISTINCT job_id) AS total
    FROM job_postings_fact
    WHERE job_title_short = 'Data Analyst'
)
SELECT -- Main query: Combine raw counts with standardized metrics
    skill_name,
    demand_count,
    -- Percentage of all Data Analyst jobs that require this skill
    -- (Count of jobs with skill / Total jobs) * 100
    ROUND(
        demand_count * 100.0 / (
            SELECT total
            FROM total_jobs
        ),
        2
    ) AS frequency_percent,
    -- Standardized frequency (0-1 scale) where 1 = most demanded skill
    -- Current skill count / Count of most demanded skill
    ROUND(
        demand_count * 1.0 / (
            SELECT MAX(demand_count)
            FROM raw_counts
        ),
        3
    ) AS standardized_frequency
FROM raw_counts
ORDER BY demand_count DESC
LIMIT 7;