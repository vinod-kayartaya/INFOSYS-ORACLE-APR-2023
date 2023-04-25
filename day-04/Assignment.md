# Assignment on the following topics:

1. Using RECORD type variables
1. Exception handling
1. Cursors (implicit and explicit)

### Assignment 1:

Create a PL/SQL block that declares a record type variable to store information about an employee. The variable should include the following fields: employee ID, first name, last name, job title, and salary. Initialize the variable with values for employee ID 102.

Next, use a SELECT INTO statement to retrieve the first name, last name, job title, and salary for employee ID 102 from the HR.EMPLOYEES table. If the SELECT statement does not return any rows, display the message 'No data found'. If the SELECT statement returns multiple rows, display the message 'Too many rows'.

Finally, display the values of the record variable.

### Assignment 2:

Create a PL/SQL block that calculates the average salary for employees in the HR.DEPARTMENTS table. Use an implicit cursor to loop through the departments and calculate the total salary for each department. If the total salary for a department is less than 1000000, display the message 'Department salary too low'. Otherwise, display the department ID and the average salary for that department.

### Assignment 3:

Create a PL/SQL block that takes an employee ID as input and updates the salary of that employee in the HR.EMPLOYEES table. If the employee ID does not exist in the table, display the message 'Invalid employee ID'. If the new salary is less than the old salary, display the message 'Salary cannot be decreased'.

### Assignment 4:

Create a PL/SQL block that retrieves the department ID and name for all departments in the HR.DEPARTMENTS table using a cursor FOR LOOP. For each department, use an explicit cursor to retrieve the last name, job title, and salary for the highest paid employee in that department. Display the department ID, department name, employee last name, job title, and salary.

### Assignment 5:

Create a PL/SQL block that takes a job ID as input and returns a cursor that contains the employee ID, first name, last name, and salary for all employees in the HR.EMPLOYEES table with that job ID. If the job ID does not exist in the HR.JOBS table, display the message 'Invalid job ID'. Use an implicit cursor to retrieve the data and display it.
