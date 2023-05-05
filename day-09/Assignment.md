# Assignment on Packages in Oracle

As part of a project to analyze employee data, your team has been tasked with creating a package in Oracle that contains procedures and functions to retrieve and manipulate employee data from the HR schema.

Your package should contain the following procedures and functions:

- __get_dept_emp__: A procedure that accepts a department ID as a parameter and retrieves all employees in the department. The procedure should use a cursor to retrieve the data and handle exceptions in case the department ID is invalid.
- __get_emp_salary__: A function that accepts an employee ID as a parameter and returns the employee's salary. The function should handle exceptions in case the employee ID is invalid.
- __update_emp_salary__: A procedure that accepts an employee ID and a new salary as parameters, and updates the employee's salary in the database. The procedure should handle exceptions in case the employee ID is invalid or the new salary is not valid.
- __get_top_earners__: A procedure that retrieves the top 10 highest-paid employees in the company. The procedure should use a cursor to retrieve the data and handle exceptions in case there are not enough employees in the database.

Your package should also include a private function called validate_dept_id that accepts a department ID as a parameter and returns true if the department ID is valid and false otherwise. This function should not be declared in the package specification and should only be accessible within the package body.

Your package should be called __hr_emp_pkg__.