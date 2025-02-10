use hospital_admissions

-- 6.Show all the staff who have a salary equal to 25000. List their first name and last name.
select fname AS 'First Name', lname AS 'Last Name'  from staff where salary = 25000

-- 7.Show all the staff who have a salary greater than 40k, list their first and last names as NAME.
select CONCAT(fname,' ', lname) AS 'NAME'  from staff where salary >= 40000

-- 8.Identify all staff who do not have a salary equal to 25k.
select fname AS 'First Name', lname AS 'Last Name'  from staff where salary != 25000

--9.Identify all staff who have a salary less than 60k.
select fname AS 'First Name', lname AS 'Last Name'  from staff where salary < 60000

--10.Identify all staff who have a salary between 40k and 60k
select fname AS 'First Name', lname AS 'Last Name'  from staff where salary BETWEEN 40000 AND 60000

--11.Identify all staff who have a salary of either 25k or 20k.
select fname AS 'First Name', lname AS 'Last Name'  from staff where salary = 25000 OR salary = 20000

--12.How many employees are there?
select COUNT(*) from staff

-- 13.	What is the max salary?
select MAX(salary) from staff

-- 14.	What is the min salary?
select MIN(salary) from staff

-- 15.	What is the average salary?
select AVG(salary) from staff

-- 16.	Who has the max salary? List the first and last names as NAME
select CONCAT(fname,' ', lname) AS 'NAME'  from staff where salary = (select MAX(salary) from staff)

-- 17.	Who has the min salary? List the first and last names as NAME and their city and county as ADDRESS.
select CONCAT(fname,' ', lname) AS 'NAME', CONCAT(city_desc,' ',county_desc) AS 'ADDRESS'  from staff 
inner join staff_add 
On staff.staff_id = staff_add.staff_id
inner join city
On staff_add.city_id = city.city_id
inner join county
on staff_add.co_id = county.co_id
where salary = (select MAX(salary) from staff)

select * from staff_add
select * from staff
select * from city
select * from county

-- 18.	Who is in the Accident and Emergency Department? List the first name, last name, department name.
select * from staff
select * from dept

select fname, lname, dname from staff 
inner join dept
on staff.dept_id = dept.dept_id
where dname = 'Accident and Emergency'


-- 19.	Who in the General Medical department earns more than 50k? List the first name, last name, department name and salary.
select fname, lname, dname, salary from staff 
inner join dept
on staff.dept_id = dept.dept_id
where dname = 'General Medical Department' and salary > 50000


-- 20.	Who is born before 1.1.1970 in the general medical department? Name, department name and age.
select fname, lname, dname, DATEDIFF(year, dob, getdate()) as 'AGE' from staff 
inner join dept
on staff.dept_id = dept.dept_id
where dname = 'General Medical Department' and dob < '1970-01-01'
order by age

-- 21.	Who does not work in the General Medical Department? Show the names.
select fname, lname, dname, salary from staff 
inner join dept
on staff.dept_id = dept.dept_id
where dname != 'General Medical Department' 

-- 22.	What are the total wages paid for each department? Show dept name and the amount.
select * from dept
select * from staff

select sum(salary) AS 'Total Wages', dname from staff 
inner join dept
on staff.dept_id = dept.dept_id
group by dname


-- 25.	Now show the total expenses for each employees. List name, address and total expenses.
select * from staff
select * from staff_add
select * from city
select * from county
select * from expenses

select fname, lname, city_desc, county_desc, sum(Amount) as 'Total Expenses' from staff 
inner join staff_add 
On staff.staff_id = staff_add.staff_id
inner join city
On staff_add.city_id = city.city_id
inner join county
on staff_add.co_id = county.co_id
inner join expenses
on staff.staff_id = expenses.staff_id
group by fname, lname, city_desc, county_desc

 
-- 26.	Sum the expenses by department 
select * from staff
select * from dept
select * from expenses

select sum(Amount) AS 'Total Expenses', dname from staff 
inner join dept
on staff.dept_id = dept.dept_id
inner join expenses
on staff.staff_id = expenses.staff_id
where dname in('General Medical Department', 'Accident and Emergency', 'Administration') group by dname

-- 27.	Show the expense for all employees who earn 60k or more. List name, dept name, expenses and salary.
-- ( ps: expense table has data only till staff id 10)
select CONCAT(fname,' ', lname) AS 'Name', dname as 'Department name', sum(Amount) AS 'Total Expenses', salary from staff 
inner join dept
on staff.dept_id = dept.dept_id
inner join expenses
on staff.staff_id = expenses.staff_id 
group by fname, lname, dname, salary
having salary > 60000

-- 28.	Show the details for anyone who got expenses in December and is born before 1.1.1975 Name, Address, age, dept and expenses.

select CONCAT(fname,' ', lname) AS 'NAME', CONCAT(city_desc,' ',county_desc) AS 'ADDRESS', dob AS 'Age', dname AS 'Department Name', amount from staff 
inner join staff_add 
On staff.staff_id = staff_add.staff_id
inner join city
On staff_add.city_id = city.city_id
inner join county
on staff_add.co_id = county.co_id
inner join expenses
on staff.staff_id = expenses.staff_id
inner join dept
on staff.dept_id = dept.dept_id
where dob < '1975-01-01' and Month(Months) = 12


-- 29.	Who has the max amount of expenses in the year? List the name and amount.

select CONCAT(fname,' ', lname) AS 'NAME', sum(Amount) AS 'Total Expenses' from staff 
inner join expenses
on staff.staff_id = expenses.staff_id
where amount = (select max(amount) from expenses)
group by fname, lname

-- 30.	Who has the min amount of expenses in the year? List the name and amount.
select * from expenses

select CONCAT(fname,' ', lname) AS 'NAME', sum(Amount) AS 'Total Expenses' from staff 
inner join expenses
on staff.staff_id = expenses.staff_id
where amount = (select min(amount) from expenses)
group by fname, lname

-- 31.	What is the average amount of expenses?
select avg(amount) from expenses

-- 32.	How many expenses cheques were written?
select count(*) from expenses

-- 33.	Show the December expenses for each employee. Name, expenses and Date paid in the following format December 31st, 2011.
select CONCAT(fname,' ', lname) AS 'NAME', Amount as 'Expenses', FORMAT(months, 'MMMM d, yyyy') AS 'Date' from staff 
inner join expenses
on staff.staff_id = expenses.staff_id
where Month(Months) = 12

-- 34.	Which employees did not get any expenses in March? Name, dept.
select * from staff
select * from expenses
select * from dept

select CONCAT(fname,' ', lname) AS 'NAME', dname from staff 
inner join expenses
on staff.staff_id = expenses.staff_id
inner join dept
on staff.dept_id = dept.dept_id 
where Month(Months) != 03
group by fname, lname, dname

-- 35.	List any staff whose last name is Williams – name, address, dept and salary.
select * from staff
select * from city
selct * from county
select * from dept

select CONCAT(fname,' ', lname) AS 'NAME', CONCAT(city_desc,' ',county_desc) AS 'ADDRESS', dname AS 'Department Name', salary from staff 
inner join staff_add 
On staff.staff_id = staff_add.staff_id
inner join city
On staff_add.city_id = city.city_id
inner join county
on staff_add.co_id = county.co_id
inner join expenses
on staff.staff_id = expenses.staff_id
inner join dept
on staff.dept_id = dept.dept_id
where lname = 'Williams'


-- 36.	List all the staff from a city beginning with K. Name, city and salary. Order by salary and then name.
select CONCAT(fname,' ', lname) AS 'NAME', city_desc AS 'City', salary from staff 
inner join staff_add 
On staff.staff_id = staff_add.staff_id
inner join city
On staff_add.city_id = city.city_id
where city_desc like 'K%'
order by 3,1


-- 37.	Who is the oldest staff member who has less than 30k? List their Name, dept and salary. Order by salary.
select * from staff
select * from dept

select CONCAT(fname,' ', lname) AS 'NAME', dname AS 'Department Name', salary from staff
inner join dept
on staff.dept_id = dept.dept_id 
where DOB = ( select min(dob) from staff where salary < 30000) AND salary < 30000
order by salary


-- 38.	Sum the expenses for all those who are from Kilkenny county
select * from staff
select * from staff_add
select * from county
select * from expenses

select CONCAT(fname,' ', lname) AS 'NAME', sum(amount) as 'Total' from staff
inner join staff_add
on staff.staff_id = staff_add.staff_id
inner join county
on staff_add.co_id = county.co_id
inner join expenses
on staff.staff_id = expenses.staff_id
where county_desc = 'Kilkenny'
group by fname, lname, staff_add.co_id



-- 39.	List all the staff and their qualifications. Show staff first and last name as Name and the qualification description. 
select * from staff
select * from staff_qual
select * from qualifications

select CONCAT(fname,' ', lname) AS 'Name', qual_desc AS 'Qualification description' from staff
inner join staff_qual
on staff.staff_id = staff_qual.Staff_id
inner join qualifications
on staff_qual.qual_id = qualifications.qual_id

-- 40.	List all the staff names (first and last as Name), their roles descriptions, their department description.
select * from staff
select * from job_titles
select * from dept

select CONCAT(fname,' ', lname) AS 'Name', job_title_desc AS 'Roles description', dname AS 'Department description' from staff
inner join job_titles
on staff.job_title_id = job_titles.job_title_id
inner join dept
on staff.dept_id = dept.dept_id


-- 41.	The manager wants to create an address book. Show the first and last names and each of the address lines of both staff and patients.
select * from staff
select * from staff_add
select * from patient
select * from patient_address
select * from city
select * from county

select staff.fname AS 'First Name', staff.lname As 'Last Name'  from staff
union
select patient.p_fname  from patient


-- 42.	What rooms were never occupied by any patient? Name the rooms.

-- 43.	What rooms had the most patients?

-- 44.	Show all the patients who are smokers list first and last names as Patient Name, their gender, DOB and their blood pressure.


-- 45.	Show the patient first and last name as Patient name, their gender, their admission date and medical condition, 
-- the room they were located in and the fee that they paid along with the date.

-- 46.	What patients are not yet assigned to a room?

-- 47. If employees were to get an increase of 10% next year then show the employee first and last name as Employee Name, 
-- the current salary and the increased salary as Proposed Salary. Also show the difference between both salary columns as Salary Difference.

-- 48.	Everyone paid under 40k is going to get a 15% increase and all others will get a 10% increase. Show the employee 
-- first and last name as Employee Name, the current salary and the increased salary as Proposed Salary.
-- Also show the difference between both salary columns as Salary Difference.

