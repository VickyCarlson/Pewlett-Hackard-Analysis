--retirement_titles table including former employees
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	tt.title,
	tt.from_date,
	tt.to_date

INTO retirement_titles

FROM employees e

INNER JOIN titles tt
on e.emp_no = tt.emp_no

WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')

ORDER BY e.emp_no ASC, tt.to_date DESC;
	

--EXTRA TABLE -- retirement_titles table filtering out former employees
SELECT DISTINCT ON(e.emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	tt.title,
	tt.from_date,
	tt.to_date

INTO retirement_titles2

FROM employees e

INNER JOIN	dept_emp de
ON e.emp_no = de.emp_no

INNER JOIN titles tt
on e.emp_no = tt.emp_no

WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND de.to_date = ('9999-01-01')
ORDER BY e.emp_no ASC, tt.to_date DESC;
	

-- Unique_Titles table -- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title,
to_date
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no ASC, to_date DESC;

--retiring_titles table
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT DESC;

--mentorship_eligibility table
SELECT DISTINCT ON(e.emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	tt.title
INTO mentorship_eligibility
FROM employees as e
INNER JOIN titles as tt
ON e.emp_no = tt.emp_no
INNER JOIN dept_emp as de
ON e.emp_no = de.emp_no
WHERE de.to_date = '9999-01-01'
AND	(e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no ASC, to_date DESC;

--mentorship_eligibility table 5 years
SELECT DISTINCT ON(e.emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	tt.title
INTO mentorship_eligibility_5yr
FROM employees as e
INNER JOIN titles as tt
ON e.emp_no = tt.emp_no
INNER JOIN dept_emp as de
ON e.emp_no = de.emp_no
WHERE de.to_date = '9999-01-01'
AND	(e.birth_date BETWEEN '1963-01-01' AND '1968-12-31')
ORDER BY e.emp_no ASC, to_date DESC;

--count of mentorship_eligibility_5yr
SELECT COUNT(emp_no), title
FROM mentorship_eligibility_5yr
GROUP BY titleORDER BY COUNT DESC;

--retirement by dept.
SELECT DISTINCT ON (ret.emp_no) 
	ret.emp_no,
	ret.first_name,
	ret.last_name,
	ret.title,
	d.dept_name
INTO dept_retiring
FROM retirement_titles as ret
INNER JOIN dept_emp as de
ON ret.emp_no = de.emp_no
INNER JOIN departments as d
ON d.dept_no = de.dept_no
ORDER BY ret.emp_no ASC, ret.to_date DESC;

--count of retirement by dept.
SELECT COUNT(emp_no),
	dept_name
FROM dept_retiring
GROUP BY dept_name
ORDER BY COUNT DESC;