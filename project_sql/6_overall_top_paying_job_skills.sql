/*
PURPOSE:Identify which technical skills are most valuable by linking them to top salaries
This helps professionals prioritize skill development for maximum earning potential
*/

-- First, create a list of jobs ranked by salary within each job title category
WITH ranked_jobs AS (
    SELECT 
        job_title,
        salary_year_avg,
        company_dim.name AS company_name,
        -- Critical Window Function:
        -- For each unique job title (PARTITION BY), rank all postings by salary
        -- Assigns rank=1 to the highest paying instance of each job title
        ROW_NUMBER() OVER (PARTITION BY job_title ORDER BY salary_year_avg DESC) as rank
    FROM 
        job_postings_fact
    -- Include company names for context (LEFT JOIN preserves all jobs even if company info missing)
    LEFT JOIN 
        company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        salary_year_avg IS NOT NULL  -- Only jobs with salary data
)

-- Final output showing only the highest-paying example of each job title
SELECT 
    job_title,
    salary_year_avg,
    company_name
FROM 
    ranked_jobs
WHERE 
    rank = 1  -- Filter to only keep the top-paying example for each job title
ORDER BY 
    salary_year_avg DESC  -- Show highest salaries first
LIMIT 10;  -- Return a manageable number of results for analysis