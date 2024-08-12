/*
QUESTION TO BE ANSWERED: What are the top ten most in-demand skills for Data Scientists?
*/

SELECT
    skills_dim.skills AS skill,
    COUNT(job_postings_fact.job_id) AS Data_Scientist_job_count
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    job_postings_fact.job_title_short LIKE '%Data_Scientist%'
GROUP BY
    skill
ORDER BY
    Data_Scientist_job_count DESC
LIMIT 10