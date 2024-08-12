/*
QUESTION TO BE ANSWERED: What skills are required for the top-paying Data Scientist jobs?
are available remotely? Remove results containing NULLS in the column associated with the salary .
*/

SELECT
    job_postings_fact.job_id,
    job_title_short,
    CASE
        WHEN skills_dim.skills IS NULL THEN 'Not listed'
        ELSE skills_dim.skills
    END AS skills_required,
    job_country,
    salary_year_avg,
    job_posted_date,
    company_dim.name AS company_name
FROM
   job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
LEFT JOIN skills_job_dim
    ON skills_job_dim.job_id = job_postings_fact.job_id
LEFT JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_location = 'Anywhere' AND
    job_title_short LIKE '%Data_Scientist%' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10