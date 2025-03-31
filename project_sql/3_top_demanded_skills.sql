/*
Question: What are the most in_demand skills for data analysis?
- join job postins to inner join table similar to query 2.
- identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
Why? Retirevs the top 5 skills with the highest demand on the job market providing insights
on the most valuble skills to learn.
*/
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 7