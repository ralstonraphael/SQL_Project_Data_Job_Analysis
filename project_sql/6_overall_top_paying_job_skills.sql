/*
 Question: What skills are required for the top-paying overall tech jobs?
 - Use the top 10 highest-paying jobs from first query
 but do not include the data analyst filter
 - Add the specific skills required for these roles
 - Why? It provides detaild look at which skills to develop that alighn with top salaries
 */
--Create CTE
WITH ranked_jobs AS (
    SELECT 
        job_title,
        salary_year_avg,
        company_dim.name AS company_name,
        -- Rank jobs by salary within each job title group
        ROW_NUMBER() OVER (PARTITION BY job_title ORDER BY salary_year_avg DESC) as rank
    FROM 
        job_postings_fact
    LEFT JOIN 
        company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
)

SELECT 
    job_title,
    salary_year_avg,
    company_name
FROM 
    ranked_jobs
WHERE 
    rank = 1  -- Only select the highest paying for each job title
ORDER BY 
    salary_year_avg DESC
LIMIT 10;