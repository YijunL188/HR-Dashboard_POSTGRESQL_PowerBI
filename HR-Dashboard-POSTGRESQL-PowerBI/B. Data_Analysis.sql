SELECT *
FROM hr_info;

-- 1. What is the gender breakdown of employees in the company
SELECT gender,
       COUNT(*) AS total_number
FROM hr_info
WHERE age >= 18
GROUP BY 1;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race,
       COUNT(*) AS total_number
FROM hr_info
WHERE age >= 18
GROUP BY 1
ORDER BY total_number DESC;

-- 3. What is the age distribution of employees in the company?
SELECT 
	CASE
        WHEN age >=18 AND age <= 24 THEN '18-24'
		WHEN age >=25 AND age <= 34 THEN '25-34'
		WHEN age >=35 AND age <= 44 THEN '35-44'
		WHEN age >=45 AND age <= 54 THEN '45-54'
		WHEN age >=55 AND age <= 64 THEN '55-64'
		ELSE '65+' END AS age_group,
	COUNT(*) AS count
FROM hr_info
WHERE age >=18
GROUP BY 1;

-- 4. How many employees work at headquarters versus remote locations?
SELECT location,
       COUNT(*) AS count
FROM hr_info
GROUP BY 1;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT ROUND(AVG(EXTRACT(YEAR FROM age(termdate, hire_date))), 0) AS avg_length_of_employment
FROM hr_info
WHERE termdate IS NOT NULL AND termdate <= CURRENT_DATE AND age >= 18;

-- 6. How does the gender distribution vary across departments?
SELECT gender,
       department
FROM hr_info
WHERE age >=18
GROUP BY 1,2
ORDER BY department;
       

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle,
       COUNT(*) AS  count
FROM hr_info
WHERE age >=18
GROUP BY 1
ORDER BY count DESC;

-- 8. Which department has the highest turnover rate?
WITH turnover_rate_cte AS(
		SELECT department, 
		COUNT(*) AS total_count, 
		SUM(CASE WHEN termdate <= CURRENT_DATE AND termdate IS NOT NULL THEN 1 ELSE 0 END) AS terminated_count, 
		SUM(CASE WHEN termdate IS NULL THEN 1 ELSE 0 END) AS active_count    
	FROM hr_info
	WHERE age >= 18
	GROUP BY department)
SELECT department,
	   total_count,
	   terminated_count,
	   active_count,
       ROUND(terminated_count * 100/ SUM(total_count),2) AS turnover_rate
FROM turnover_rate_cte
GROUP BY 1,2,3,4
ORDER BY turnover_rate DESC;

-- 9. How has the company's employee count changed over time based on hire and term dates?
WITH employee_count_changed AS (
	SELECT 
		EXTRACT(YEAR FROM hire_date) AS year, 
		COUNT(*) AS hires, 
		SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURRENT_DATE THEN 1 ELSE 0 END) AS terminations, 
		COUNT(*) - SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURRENT_DATE THEN 1 ELSE 0 END) AS net_change    
	FROM hr_info
	WHERE age >= 18 AND termdate IS NOT NULL  
	GROUP BY EXTRACT(YEAR FROM hire_date)  
	ORDER BY EXTRACT(YEAR FROM hire_date) ASC)

SELECT year,
       hires,
	   terminations,
	   net_change,
	   ROUND(((hires - terminations) * 100 / hires),2) AS net_change_percent
FROM employee_count_changed
GROUP BY 1,2,3,4
ORDER BY 1;    

-- 10. What is the tenure distribution for each department?
SELECT department, 
       ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, termdate))), 0) AS avg_tenure
FROM hr_info
WHERE termdate <= CURRENT_DATE AND termdate IS NOT NULL AND age >= 18
GROUP BY department
ORDER BY avg_tenure DESC;


-- 11. What is the distribution of employees across locations by city and state?
SELECT location_state,
	   location_city,
	   COUNT(*) AS total_employees_across_location
FROM hr_info
GROUP BY 1,2
ORDER BY total_employees_across_location DESC;



