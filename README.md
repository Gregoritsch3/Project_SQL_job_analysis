# Project - SQL (Data Science Job Data Analysis)
## Abstract
An SQL project that draws useful insights from existing job data. It provides information regarding top-paying Data Scientist jobs and skills (both job-opportunity-based and salary-based), the most in-demand skills for Data Scientist roles, as well as a list of optimal Data Science skills to learn (skills high in demand and market value). The results are satisfying. 


## Introduction

As an aspiring Data Scientist/Analyst, I am naturally interested in the steps necessary to achieve my desired goal: a Data Science job from which one can make a living. Luckily, it turns out there exists an abundance of high-quality data regarding job postings from all around the world. This data is made available by the well-known [Luke Barrouse](https://www.lukebarousse.com/) through his [DataNerd](https://datanerd.tech/) web-application. The database contains job postings information such as: job title, location, work type (remote or on-site), average yearly or hourly salary, salary rate, health insurance provision, skills associated with a particular job posting, company name, and much more. This data pertains to the year 2023.

Being ultimately motivated towards the Data Scientist role, this data is handled in such a way as to provide answers specifically for the Data Scientist role. The questions to be answered are the following:

1. Out of all job postings in 2023 that are related to the Data Scientist role, which are the top-paying remote opportunities?
2. Based on these top-paying job listings, what are the skills associated with them?
3. Which skills that pertain to the Data Scientist role are the most demanded? 
4. Similarly to Question 2., but not based on individual job listings, but rather on the more general average yearly salary, which Data Science skills turn out to be the best-paying ones?
5. What are the most optimal skills for the Data Scientist role? That is, which skills are in high demand, but are also well paid?

<br>*Made upon the completion of Luke Barrouse's [SQL course](https://www.lukebarousse.com/sql). The project is helped by his material, but is not a direct or identical copy. Additionally, all data used is provided as part of his free course material.*

## Tools, files and methods 

The **tools** used in this project include:

- **SQL**: The most popular programming language used for launching specified queries into the IT job market data and drawing useful conclusions.

- **PostreSQL**: The database management system chosen for this project based on its extensive use in the Data Analytics sector. 

- **Visual Studio Code (VSCode)**: The most popular code editor; used not only for writing and executing SQL queries, but also for database management tasks.

- **GitHub & Git**: The standard for version control, project collaboration and tracking.

- **ChatGPT**: the well-known AI assistant. Used for final data visualization.

Coincidently, the **files** uploaded to GitHub associated with this project include: 

- [**SQL code**](/sql_code/): five distinct queries that give insight into relevant job data related to the Data Scientist role.

- [**SQL load**](/sql_load/): three SQL files whose purpose is the creation and modification of the database and tables.

- [**Results**](/sql_export/): in the form of .CSV files, they include the results associated with a particular SQL query.

Additionally, the initial project data is provided in four seperate .CSV files that are not pushed to GitHub, mainly because of their relatively large size.

The **methodology** of the whole project is quite straight-forward: 
- Use PostgreSQL to host the initial database, and VSCode as the code editor of choice.
- Load the job postings data and create the associated tables.
- Write SQL queries to answer the questions of interest.
- Export the particular query results as .CSV files.
- If possible, visualize these results using ChatGPT.

## Results and analysis
Following the methodology laid out in the previous section, an effort was made to answer the questions pertaining to the Data Scientist role.

### 1. Top-paying jobs
To identify the job opportunities that offer the highest yearly salary, an appropriate SQL query was made. The query draws most of the relevant data from the ```job_postings_fact``` table. The company name, however, is joined from the ```company_dim``` table on the basis of an unique ```company_id```. Through the use of the ```WHERE``` statement, jobs that aren't of a remote work type, that don't pertain to the Data Scientist role, as well as those with an undefined yearly average salary, are all filtered out. The results are ordered by the average yearly salary in a descending manner. For compactness' sake, we limit ourselves to the first 10 entries.

```sql
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
    job_title_short LIKE '%Data_Scientist%' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
```
Running this query, we come up with results shown in Table 1.
|job_id |job_title_short      |job_country  |salary_year_avg|job_posted_date    |company_name       |
|-------|---------------------|-------------|---------------|-------------------|-------------------|
|40145  |Data Scientist       |United States|550000.0       |2023-08-16 16:05:16|Selby Jennings     |
|1714768|Data Scientist       |United States|525000.0       |2023-09-01 19:24:02|Selby Jennings     |
|327496 |Senior Data Scientist|United States|475000.0       |2023-01-31 16:03:46|Glocomms           |
|627602 |Senior Data Scientist|United States|375000.0       |2023-08-30 10:06:34|Algo Capital Group |
|1131472|Data Scientist       |United States|375000.0       |2023-07-31 14:05:21|Algo Capital Group |
|1742633|Data Scientist       |United States|351500.0       |2023-07-12 03:07:31|Demandbase         |
|551497 |Data Scientist       |United States|324000.0       |2023-05-26 22:04:44|Demandbase         |
|126218 |Data Scientist       |Sudan        |320000.0       |2023-03-26 23:46:39|Teramind           |
|488169 |Senior Data Scientist|Sudan        |315000.0       |2023-01-26 17:51:50|Life Science People|
|1161630|Data Scientist       |United States|313000.0       |2023-08-23 22:03:48|Reddit             |
***Table 1.** Query results for the first 10 top-paying job postings.*

Out of all the information contained in this table, one reasonable conclusion is that most of the remote highest paying job postings are from companies located inside the Unites States.
### 2. Top-paying skills (based on job listings)
Based on these top-paying job opportunities, we are to identify the skills associated with them. To do this, we can reuse the query from **1.**, but apply necessary modifications. Specifically, to include the skills that are associated with a particular job posting, we need to join the ```skills_dim``` table to the ```job_postings_fact``` table. However, this ```JOIN``` must be achieved through the intermediation of the ```skills_job_dim``` table, all based on the unique ```skill_id```. To achieve greater clarity but simultaneously not omit crucial top-paying listings, for job postings whose associated skill is equal to ```NULL```, we wish to display `'Not listed'`, as shown in the SQL code below.
```sql
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
```
The results of this query are shown in Table 2.
|job_id |job_title_short      |skills_required|job_country  |salary_year_avg|job_posted_date    |company_name      |
|-------|---------------------|---------------|-------------|---------------|-------------------|------------------|
|40145  |Data Scientist       |sql            |United States|550000.0       |2023-08-16 16:05:16|Selby Jennings    |
|40145  |Data Scientist       |python         |United States|550000.0       |2023-08-16 16:05:16|Selby Jennings    |
|1714768|Data Scientist       |sql            |United States|525000.0       |2023-09-01 19:24:02|Selby Jennings    |
|327496 |Senior Data Scientist|Not listed     |United States|475000.0       |2023-01-31 16:03:46|Glocomms          |
|1131472|Data Scientist       |java           |United States|375000.0       |2023-07-31 14:05:21|Algo Capital Group|
|1131472|Data Scientist       |python         |United States|375000.0       |2023-07-31 14:05:21|Algo Capital Group|
|1131472|Data Scientist       |sql            |United States|375000.0       |2023-07-31 14:05:21|Algo Capital Group|
|1131472|Data Scientist       |tableau        |United States|375000.0       |2023-07-31 14:05:21|Algo Capital Group|
|1131472|Data Scientist       |spark          |United States|375000.0       |2023-07-31 14:05:21|Algo Capital Group|
|1131472|Data Scientist       |cassandra      |United States|375000.0       |2023-07-31 14:05:21|Algo Capital Group|

***Table 2.** Top-paying skills associated with the formerly queried top-paying job postings.*

Inside the top ten highest paying postings, we see SQL mentioned 3 times, followed by Python (2), with all the other skills represented only once. This already shows the importance of the knowledge of SQL and Python for Data Science positions.
### 3. Most demanded skills
Regarding the skills most in demand for the Data Scientist role, the structure of the associated query is not complicated. We start by calling an aggregation function ```COUNT``` by which we count all the different job opportunities defined by an unique ```job_id```. To group this job posting count by skill, an ```INNER JOIN``` must be carried out two times. This allows us to display the ```skill``` column as well. As stated earlier, we filter only for Data Scientist roles.

```sql
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
```
Using this SQL query, we are able to unearth interesting results in the job market.
|Skills (Data Science)|Demand Count|
|---------------------|------------|
|Python|140012|
|SQL|97835|
|R|72526|
|SAS|35934|
|Tableau|35472|
|AWS|33779|
|Spark|30991|
|Azure|27227|
|TensorFlow|24261|
|Excel|20886|
***Table 3.** Most in-demand skills associated with Data Science roles.*

As is shown in Table 1., Python outperforms other skills by a large margin and is thus the most in-demand skill for Data Science. Next follows SQL, which is somewhat expected, which is then followed by R, the two likewise being separated by a large demand count. After yet another big jump in numbers, skills such as SAS, Tableau, AWS follow, all being distributed relatively similarly.
### 4. Top-paying skills (based on salary)
To identify the top-grossing skills related to the Data Scientist role, we need to start our SQL query by performing ```INNER JOIN```s between the relevant tables, the same way we did before. Filtering for Data Scientist roles and properly defined average yearly salaries, we perform a ```ROUND```ed aggregation function ```AVG``` of the same salaries with the goal of grouping them based on different skills. Finally, we order results by salary, highest to lowest.
```sql
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
```
Focusing on the first 10 entries only, we arrive at the following results.
| Place | Skill         | Average Yearly Salary |
|-------|---------------|----------------------|
| 1     | Asana         | 200284               |
| 2     | Airtable      | 189600               |
| 3     | Redhat        | 189500               |
| 4     | Watson        | 183460               |
| 5     | Ringcentral   | 182500               |
| 6     | Neo4j         | 170861               |
| 7     | Elixir        | 170824               |
| 8     | Lua           | 170500               | 
| 9     | Solidity      | 166980               |
| 10    | Ruby on Rails | 166500               |

***Table 4.** Average yearly salaries for skills associated with Data Science roles.*

These results are interesting insofar as they show that skills requiring high degrees of specialization (Asana, Airtable, Redhat) also pay the most. It stands to reason that these are skills associated with specialized Data Science roles that take time to learn and fully grasp. They are not representative of entry-level jobs, but are indicative of well-established, long-term employee positions.

### 5. Most optimal skills
Finally, we concentrate on searching for the skills that are the most optimal. This means that they are both in high-demand and well-paying. This is arguably the most interesting part of the whole analysis.

We start the query by defining two CTEs (Common Table Expressions), which are simply temporary result sets that will help us achieve our ultimate goal: the most optimal skills. The two CTEs return to us the top-paying and most demanded skills, respectively. They are constructed in a similar manner. After performing ```JOIN```s in between all the relevant tables, based on the unique ```job_id``` and ```skill_id```, we filter, as before, by the Data Scientist role and well-defined yearly salaries. We then perform the appropriate aggregate functions, averaging the salary and counting the open job positions, respectively. After all of this, we group results based on unique the ```skill_id```. In practice, results could be grouped by merely the ```skill``` column. However, owing to the fact that by design or mistake similar or identical skills may possess the same ```skill_id```, it is best-practice to sort in a stricter manner, that is, by the ```skill_id```.


```sql
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
```
After the definition of the two auxiliary CTEs and their ```INNER JOIN```ing, the final query can be written. We display relevant columns from the ```top_demanded_skills``` CTE, namely the ```skill```, ```average_skill_salary``` and ```skill_demand_count```. Now comes the interesting part. To find the skills that are the most optimal (high in count and salary), we define a quantity called the ```salary_demand_coefficient``` that is simply a product of the two columns ```average_skill_salary``` and ```skill_demand_count```, and serves as a measure of the optimality of the skill. The larger the value of this coefficient, the more optimal the skill. Looking at this coefficent in the context of dimensional analysis, it is a value whose unit is the dollar. It represents the total (potential) market value of a specific skill (average skill salary times the number of job positions where the skill is demanded). Thus, dividing this value by the ```SUM``` total of all the ratios combined, we are able to determine the percentage market share of this particular skill. This is by far the most interesting finding of the whole analysis. Code-wise, this value is ```ROUND```ed, ```CAST``` to a ```VARCHAR(4)``` data type and then ```CONCAT```etaned to a string percentage sign.
```sql
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
```
The first 10 results of this query are displayed firstly in Table 5., and then graphically on Chart 1.

| skill      | average_skill_salary | skill_demand_count | salary_demand_coefficient | monetary_market_share |
|------------|----------------------|--------------------|---------------------------|-----------------------|
| Python     | 141976               | 5616               | 797337216                 | 14.70%                 |
| SQL        | 142319               | 4175               | 594181825                 | 11.00%                 |
| R          | 138714               | 3177               | 440694378                 | 8.17%                 |
| Tableau    | 134753 | 1607               | 216548071                 | 4.02%                 |
| Spark      | 149662               | 1291               | 193213642                 | 3.58%                 |
| AWS        | 141748               | 1349               | 191218052                 | 3.55%                 |
| TensorFlow | 146920               | 880                | 129289600                 | 2.40%                 |
| PyTorch    | 149663               | 772                | 115539836                 | 2.14%                 |
| Azure      | 135560               | 823                | 111565880                 | 2.00%                 |
| Hadoop      | 141181               | 767                | 108285827                 | 2.01%                 |

***Table 5.** Query of top ten most optimal Data Science skills.*

<br>

![Market share of skills](/assets/Skills_market_share.png)

***Chart 1.** Monetary market share of Data Science skills.*

These results are quite valuable. They show that Python outperforms the Data Science skill market by a serious margin and makes up for almost 15% of its total value. In fact, owing to a such a large difference in the market share, we can say that **it is approximately twice as better to learn Python over R**. This especially applies to people who are beginning in their Data Science journey, because often only the knowledge of one of the two programming languages is required. Therefore, if you can only have one, and can't decide which one to choose - the chart is clear - pick Python!

## Conclusion
To end our analysis, we can state our findings in a few compact and digestible bullet-points:

- Out of all the 2023 job postings related to the Data Scientist role, the majority of the high-paying ones are located in the USA, with the yearly salary of the top-paying posting coming in at the $550,000 mark.
- The most demanded Data Science skills are: Python, SQL and R, in that order.
- The skills associated with the highest yearly salaries are highly specialized languages used by well-established Data Scientist with large amounts of experience in their particular role. They are not representative of most Data Science roles, especially entry-level ones. Top picks include Asana, Airtable, Redhat. 
- Even though SQL outperforms Python in the number of occurences in the top-paying postings, Python is overall the most optimal skill to learn based on pay and demand. In fact, it makes up for almost 15% of the total market value and learning it is almost twice as worthwile as R, especially when only one has to be chosen. It is followed by SQL, and then by R.  


<br>
<br>  
<br>                 <div style="text-align: right"> ~ Gregoritsch3 </div>  
