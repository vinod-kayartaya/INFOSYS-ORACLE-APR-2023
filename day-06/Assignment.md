# Assignment on Stored Procedures in Oracle PL/SQL

1. Write a stored procedure that takes an employee ID as input and updates the salary of that employee by 10%. If the new salary is greater than $10,000, then raise an exception with an appropriate error message.
2. Write a stored procedure that takes a department ID as input and returns the following information using OUT parameters:
    - No.of employees in that department
    - Total salary payout for that department
    - Average, min and max salary earned by the employees in that department
      If the department does not exist, raise an exception with an appropriate error message.
3. Write a stored procedure that takes an employee ID as input and transfers that employee to a new department. If the employee has been with the company for more than 10 years, they must be transferred to a department with a higher salary grade. If the employee has been with the company for less than 10 years, they must be transferred to a department with a lower salary grade. Use cursors to retrieve the employee's current department and salary grade.
4. Write a stored procedure that takes an employee ID as input and calculates the total salary of that employee for the current year, including bonuses and benefits. If the employee is a manager, include the total salary of all their direct reports in the calculation. Use cursors to retrieve the employee's salary, bonus, and benefits information, and also to retrieve the direct reports of a manager.
5. Write a stored procedure that takes an employee ID as input and retrieves the details of all their past performance appraisals, including the scores for each category and the overall rating. If the employee has not had any performance appraisals, raise an exception with an appropriate error message. Use cursors to retrieve the employee's performance appraisal history.
