use crowdfunding;
Select * from projects;
#Q1
SELECT FROM_UNIXTIME(created_at) AS natural_time
FROM projects;
ALTER TABLE projects ADD COLUMN launched_at_N DATETIME after successful_at;
ALTER TABLE projects ADD COLUMN Created_Date DATETIME after successful_at;

UPDATE projects SET launched_at_N = FROM_UNIXTIME(launched_at);
SET sql_mode = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION';
UPDATE projects SET Created_date = FROM_UNIXTIME(Created_at);
ALTER TABLE projects ADD COLUMN deadlineDate DATETIME after deadline;


UPDATE projects SET deadlineDate = FROM_UNIXTIME(deadline);

ALTER TABLE projects DROP COLUMN  launched_at;

ALTER TABLE projects DROP COLUMN  Successful_Date;
Select * From projects;

Select * from crowdfunding_location;

#Q2
CREATE TABLE  calendar_table2
 (calendar_date Date,
    year INT,
    month_no INT,
    month_fullname VARCHAR(20),
    quarter CHAR(2),
    year_month_ VARCHAR(10),
    weekday_no INT,
    weekday_name VARCHAR(20),
    financial_month VARCHAR(6),
    financial_quarter VARCHAR(6));


    
    
ALTER TABLE calendar_table2
MODIFY year_month_ VARCHAR(10);

    
    INSERT INTO calendar_table2 (calendar_date, year, month_no, month_fullname, quarter, year_month_, weekday_no, weekday_name, financial_month, financial_quarter)
SELECT 
    Created_date AS calendar_date,
    YEAR(Created_date) AS year,
    MONTH(Created_date) AS month_no,
    MONTHNAME(Created_date) AS month_fullname,
    CONCAT('Q', QUARTER(Created_date)) AS quarter,
    DATE_FORMAT(Created_date, '%Y-%b') AS year_month_,
    DAYOFWEEK(Created_date) AS weekday_no,
    DAYNAME(Created_date) AS weekday_name,
    CASE 
        WHEN MONTH(Created_date) = 4 THEN 'FM1' 
        WHEN MONTH(Created_date) = 5 THEN 'FM2' 
        WHEN MONTH(Created_date) = 6 THEN 'FM3' 
        WHEN MONTH(Created_date) = 7 THEN 'FM4' 
        WHEN MONTH(Created_date) = 8 THEN 'FM5' 
        WHEN MONTH(Created_date) = 9 THEN 'FM6' 
        WHEN MONTH(Created_date) = 10 THEN 'FM7' 
        WHEN MONTH(Created_date) = 11 THEN 'FM8' 
        WHEN MONTH(Created_date) = 12 THEN 'FM9' 
        WHEN MONTH(Created_date) = 1 THEN 'FM10' 
        WHEN MONTH(Created_date) = 2 THEN 'FM11' 
        WHEN MONTH(Created_date) = 3 THEN 'FM12' 
    END AS financial_month,
    CASE 
        WHEN MONTH(Created_date) IN (4, 5, 6) THEN 'FQ1'
        WHEN MONTH(Created_date) IN (7, 8, 9) THEN 'FQ2'
        WHEN MONTH(Created_date) IN (10, 11, 12) THEN 'FQ3'
        WHEN MONTH(Created_date) IN (1, 2, 3) THEN 'FQ4'
    END AS financial_quarter
FROM 	
    projects  
WHERE 
    Created_date IS NOT NULL
GROUP BY 
    Created_date;

Select * from calendar_table2;

#Q4
Alter table projects add column goal_amount_usd  decimal(20,2) after goal;

Update projects
Set goal_amount_usd = goal * static_usd_rate;
Select * from projects;

#5.1
Select State,
count(*) as total_projects
from projects 
group by state;

#5.2

SELECT 
    location_id, 
    COUNT(*) AS total_projects
FROM 
    projects
GROUP BY 
    location_id
ORDER BY 
    total_projects DESC; 
# 5.3
select
Category_id, 
    COUNT(*) AS total_projects
FROM 
    projects
GROUP BY 
    Category_id
ORDER BY 
    total_projects DESC; 

# 5,4 
SELECT 
    YEAR(created_date) AS year,
    QUARTER(created_date) AS quarter,
    MONTH(created_date) AS month,
    COUNT(*) AS total_projects
FROM 
    projects
GROUP BY 
    YEAR(created_date), 
    QUARTER(created_date), 
    MONTH(created_date)
ORDER BY 
    year, quarter, month;

# 6.1
SELECT 
    SUM(usd_pledged) AS total_amount_raised
FROM 
    projects
WHERE 
    state = 'successful';
    
    # Q6.2

SELECT 
    SUM(backers_count) AS total_Backers_count
FROM 
    projects
WHERE 
    state = 'successful';





#6.03



SELECT 
    COUNT(*) AS total_successful_projects,
      AVG(DATEDIFF(deadlineDate, created_Date)) AS avg_days_for_successful_projects
FROM projects
WHERE state = 'successful';


#7
SELECT name, state, backers_count
FROM projects
WHERE state = 'Successful'
ORDER BY backers_count DESC
LIMIT 1;  

SELECT name, state, usd_pledged
FROM projects
WHERE state = 'Successful'
ORDER BY   usd_pledged DESC
LIMIT 1;  

#8.01

    SELECT 
    (COUNT(CASE WHEN State = 'successful' THEN 1 END) / COUNT(*)) * 100 AS success_percentage
FROM 
    projects;

#8.2

  SELECT 
    category_id,
    (COUNT(CASE WHEN state = 'successful' THEN 1 END) * 100.0 / COUNT(*)) AS success_percentage
FROM 
    projects
GROUP BY 
    category_id;  

#8.2
SELECT 
    YEAR(created_Date) AS project_year,
    COUNT(CASE WHEN state = 'Successful' THEN 1 END) AS successful_count,
    COUNT(*) AS total_count,
    (COUNT(CASE WHEN state = 'Successful' THEN 1 END) * 100.0 / COUNT(*)) AS success_percentage
FROM 
    projects
GROUP BY 
    YEAR(created_Date);
    #88888.03
    SELECT 
    YEAR(created_date) AS year,
    MONTH(created_date) AS month,
    (COUNT(CASE WHEN State = 'successful' THEN 1 END) / COUNT(*)) * 100 AS year_monthsuccess_percentage
FROM 
    projects
GROUP BY 
    YEAR(created_date), 
    MONTH(created_date)
ORDER BY 
    year, month;
    
    
#8.4
WITH goal_ranges AS (
    SELECT 
        projectid,
        state,
        goal,
        CASE 
            WHEN goal BETWEEN 0 AND 100000 THEN '0.01-100000'
            WHEN goal BETWEEN 100001 AND 3000000 THEN '100001-3000000'
            WHEN goal BETWEEN 3000001 AND 6000000 THEN '3000001-6000000'
            WHEN goal BETWEEN 6000001 AND 10000000 THEN '6000001-10000000'
            WHEN goal BETWEEN 10000001 AND 30000000 THEN '10000001-30000000'
            WHEN goal BETWEEN 30000001 AND 60000000 THEN '30000001-60000000'
            WHEN goal BETWEEN 60000001 AND 100000000 THEN '60000001-100000000'
            ELSE 'Above 100000000'
        END AS goal_range
    FROM 
        projects
),
summary AS (
    SELECT 
        goal_range,
        COUNT(*) AS total_projects,
        SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) AS successful_projects
    FROM 
        goal_ranges
    GROUP BY 
        goal_range
)
SELECT 
    goal_range,
    total_projects,
    successful_projects,
    CASE 
        WHEN total_projects = 0 THEN 0.0
        ELSE (successful_projects * 100.0 / total_projects)
    END AS success_percentage
FROM 
    summary;


