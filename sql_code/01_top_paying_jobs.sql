/*
QUESTION TO ANSWER: What are the 10 top-paying Data Analyst jobs that 
are available remotely? Remove results containing NULLS in the column associated with the salary .
*/
SELECT *
FROM job_postings_fact
LIMIT 10

SELECT
    job_id,
    job_title_short,
    job_country,
    salary_year_avg,
    job_posted_date,
    company_dim.name AS company_name
FROM
   job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_location = 'Anywhere' AND
    job_title_short LIKE '%Data_Analyst%' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10