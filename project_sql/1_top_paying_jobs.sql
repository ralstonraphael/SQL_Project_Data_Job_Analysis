/*
Question: What are the top paying jobs as a Data Analyst?
- Must identify the top 10 highest paying Data Analyst roles that are available remotley.
- Need to focus on specific salary postings. 
- Why? Highligt the top-paying opportunities for Data Analysts, offering insights as to where to apply.
*/

SELECT
    job_id,
    job_title,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;