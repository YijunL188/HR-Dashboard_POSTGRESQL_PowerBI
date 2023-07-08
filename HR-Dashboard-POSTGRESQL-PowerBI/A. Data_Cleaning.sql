-- DROP TABLE IF EXISTS hr_info; 
SELECT *
FROM hr_info;

-------Data Cleaning---------
ALTER TABLE hr_info
RENAME COLUMN id TO emp_id;

ALTER TABLE hr_info
ALTER COLUMN emp_id SET DATA TYPE VARCHAR(20),
ALTER COLUMN emp_id DROP NOT NULL;

-- See the datayps of all the columns in our table
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'hr_info';

UPDATE hr_info
SET birthdate = CASE
    WHEN birthdate LIKE '%/%' THEN to_date(birthdate, 'MM/DD/YYYY')
    WHEN birthdate LIKE '%-%' THEN to_date(birthdate, 'MM-DD-YYYY')
    ELSE NULL
END;

ALTER TABLE hr_info
ALTER COLUMN birthdate TYPE DATE USING birthdate::DATE;

-- convert hire_date to date format
UPDATE hr_info
SET hire_date = CASE 
     WHEN hire_date LIKE '%/%' THEN to_date(hire_date, 'MM/DD/YYYY')
	 WHEN hire_date LIKE '%-%' THEN to_date(hire_date, 'MM-DD-YYYY')
	 ELSE NULL
END;

ALTER TABLE hr_info
ALTER COLUMN hire_date TYPE DATE USING hire_date::Date;


-- Convert termdate from string format to date format
DELETE FROM hr_info
WHERE emp_id = 'id' AND first_name = 'first_name' AND last_name = 'last_name' AND gender = 'gender' AND race = 'race' 
AND department = 'department' AND jobtitle = 'jobtitle' AND location = 'location' AND termdate = 'termdate' 
AND location_city = 'location_city' AND location_state = 'location_state';

UPDATE hr_info
SET termdate = DATE(TO_TIMESTAMP(termdate, 'YYYY-MM-DD HH24:MI:SS UTC'))
WHERE termdate IS NOT NULL AND termdate != ' ';


ALTER TABLE hr_info
ALTER COLUMN termdate TYPE DATE USING termdate::Date;


-- Add new column age (INT)
ALTER TABLE hr_info
ADD COLUMN age INT;

UPDATE hr_info
SET age = EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate));

-- select the youngest and oldest ages from the "age" column in the hr table
SELECT MIN(age) AS youngest,
       MAX(age) AS oldest
FROM hr_info;

-- Select the count of all rows in the hr table where the age is less than 18.
SELECT COUNT(*)
FROM hr_info
WHERE age < 18;


-- Select  the count of all rows in the hr table where the termdate is in the future, 
-- #meaning the employee has not yet been terminated.
SELECT COUNT(*) AS employees_not_terminated
FROM hr_info
WHERE termdate > CURRENT_DATE;


SELECT COUNT(*) AS not_terminated
FROM hr_info
WHERE termdate IS NULL;


