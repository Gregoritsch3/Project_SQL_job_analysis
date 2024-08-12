/*
QUESTION TO BE ANSWERED: What are the most optimal skills to be learned, i.e. 
skills that are both high paying and in high demand?
*/

WITH top_paying_skills AS (
    SELECT
        skills_dim.skill_id AS skill_id,
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
        skills_dim.skill_id
), top_demanded_skills AS (
    SELECT
        skills_dim.skill_id AS skill_id,
        skills_dim.skills AS skill,
        COUNT(job_postings_fact.job_id) AS Data_Scientist_job_count
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE 
        job_postings_fact.job_title_short LIKE '%Data_Scientist%' AND
        salary_year_avg IS NOT NULL 
    GROUP BY
        skills_dim.skill_id
)

SELECT DISTINCT
    top_demanded_skills.skill AS skill,
    top_paying_skills.average_skill_salary AS average_skill_salary,
    top_demanded_skills.Data_Scientist_job_count AS skill_demand_count,
    top_paying_skills.average_skill_salary * top_demanded_skills.Data_Scientist_job_count AS salary_demand_coefficient,
    CONCAT(CAST(ROUND(top_paying_skills.average_skill_salary * top_demanded_skills.Data_Scientist_job_count / SUM(top_paying_skills.average_skill_salary * top_demanded_skills.Data_Scientist_job_count) OVER (), 4) * 100 AS VARCHAR(4)), '%') AS monetary_market_share
FROM 
    top_demanded_skills
INNER JOIN top_paying_skills ON top_paying_skills.skill_id = top_demanded_skills.skill_id
ORDER BY 
    salary_demand_coefficient DESC
LIMIT 100