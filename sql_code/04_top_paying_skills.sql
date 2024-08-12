/*
QUESTION TO BE ANSWERED: What are the hundred top-paying skills (based on average yearly salary) connected
with a Data Scientist role (excluding NULL values)?
*/
SELECT
    ROW_NUMBER() OVER(ORDER BY AVG(job_postings_fact.salary_year_avg) DESC) AS place,
    skills_dim.skills AS skill,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS average_skill_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short LIKE '%Data_Scientist%' AND
    salary_year_avg IS NOT NULL 
GROUP BY
    skill
ORDER BY
    average_skill_salary DESC
LIMIT 100