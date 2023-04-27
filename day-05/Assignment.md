#Assignment

### Topics:

1. Using cursors
2. Parameterized cursors
3. Cursors for update
4. User defined exceptions

**Assignment 1:**

Write a PL/SQL block that uses a cursor to display the first name, last name, and salary of all employees in the `employees` table in the HR database who have a salary that is greater than the average salary for their department. Order the results by department ID and salary.

**Assignment 2:**

Write a PL/SQL block that uses a parameterized cursor to display the first name, last name, and salary of all employees in the `employees` table in the HR database who have a salary greater than or equal to a specified value. Use a bind variable to specify the minimum salary value. If the bind variable is not specified or is null, use a default value of 5000.

**Assignment 3:**

Write a PL/SQL block that uses a cursor for update to increase the salary of all employees in the `employees` table in the HR database who have a job ID of 'SA_REP' by 10 percent. Use a user-defined exception to handle any errors that may occur during the update process.

**Assignment 4:**

Write a PL/SQL block that uses a cursor to display the first name, last name, and hire date of all employees in the `employees` table in the HR database who have been hired for more than 10 years. If no employees are found, raise a user-defined exception with the error message 'No employees found with hire date greater than 10 years ago'.

**Assignment 5:**

Write a PL/SQL block that uses a cursor to display the first name, last name, and commission percentage of all employees in the `employees` table in the HR database who have a commission percentage greater than or equal to the average commission percentage for their job. Use a nested cursor to calculate the average commission percentage for each job. Order the results by job ID and commission percentage.

**Assignment 6:**

Write a PL/SQL block that uses a cursor to display the first name, last name, and salary of the top three highest-paid employees in each department of the `employees` table in the HR database. Order the results by department ID and salary.

**Assignment 7:**

Write a PL/SQL block that uses a parameterized cursor to display the first name, last name, and salary of all employees in the `employees` table in the HR database who have a salary greater than or equal to a specified value, and who work in a department with a specified manager ID. Prompt the user to enter the minimum salary value and the manager ID.

**Assignment 8:**

Write a PL/SQL block that uses a cursor for update to increase the salary of all employees in the `employees` table in the HR database who have a salary less than the average salary for their job by 5 percent. Use a user-defined exception to handle any errors that may occur during the update process.

**Assignment 9:**

Write a PL/SQL block that uses a cursor to display the first name, last name, and department name of all employees in the `employees` table in the HR database who have a department ID that is not present in the `departments` table. If no employees are found, raise a user-defined exception with the error message 'No employees found with invalid department ID'.

**Assignment 10:**

Write a PL/SQL block that uses a cursor to display the first name, last name, and job title of all employees in the `employees` table in the HR database who have a job ID that is not present in the `jobs` table. Use a nested cursor to retrieve the job title for each employee's job ID. Order the results by job ID.
