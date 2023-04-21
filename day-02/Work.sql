set SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('hello, there!');
END;


----------

DECLARE
    v_message VARCHAR2(200);
BEGIN
    v_message := 'Hello, world!';
    DBMS_OUTPUT.PUT_LINE('The message is : ' || v_message);
END;

-----------

declare 
    v_num1 number := 12;
    v_num2 number := 37;
    v_result number;
begin
    v_result := v_num1 / v_num2;
    dbms_output.put_line(v_num1 || '/' || v_num2 || ' = ' || v_result);
    
exception
    when ZERO_DIVIDE then
        dbms_output.put_line('Cannot divide a number by zero');
end;

----
declare 
    v_customer_name varchar2(200);
    v_customer_city varchar2(100) not null default 'Bangalore';
    v_credit_limit number(10, 2) := null;
    v_order_date date := sysdate;
begin
    v_customer_name := 'Vinod Kumar';
    v_credit_limit := 3200000;
    -- v_customer_city := null; -- error; because of not null
    -- v_customer_city := ''; -- error; because of not null
    dbms_output.put_line(v_customer_name);
    dbms_output.put_line(v_customer_city);
    dbms_output.put_line(v_credit_limit);
    dbms_output.put_line( v_order_date);
end;

----
declare
    v_first_name employees.first_name%type;
    v_last_name employees.last_name%type;
    v_hire_date employees.hire_date%type;
    v_salary employees.salary%type;
begin
    select first_name, last_name, hire_date, salary
        into v_first_name, v_last_name, v_hire_date, v_salary
        from employees
        where employee_id = &EmployeeNumber;
        
    dbms_output.put_line('Name : ' || v_first_name || ' ' || v_last_name);
    dbms_output.put_line('Date of join: ' || v_hire_date);
    dbms_output.put_line('Salary: $' || v_salary);
end;

----
-- for a given employee, we want to display a grade based on salary
-- if the salary > the average salary in their department, then the grade is "A"
-- else it is "B"

declare
    v_first_name employees.first_name%type;
    v_last_name employees.last_name%type;
    v_salary employees.salary%type;
    v_department_id employees.department_id%type;
    v_avg_salary v_salary%type;
    v_grade char(1) := 'B';
begin
    select first_name, last_name, salary, department_id
        into v_first_name, v_last_name, v_salary, v_department_id
        from employees where employee_id = &EmployeeNumber;
        
    select avg(salary) into v_avg_salary
        from employees where department_id = v_department_id;
        
    if v_salary > v_avg_salary then
        v_grade := 'A';
    end if;
    
    dbms_output.put_line('Salary is $' || v_salary);
    dbms_output.put_line('Avg salary is $' || v_avg_salary);
    dbms_output.put_line('Grade of ' || v_first_name || ' ' || 
        v_last_name || ' is ' || v_grade);
end;

--------

/*
Modify the above code to produce 4 grades: A, B, C and D such that

salary > avg_salary * 150% --> A
salary between avg_salary and 150% of avg_salary --> B
salary between 50% of avg_salry and avg_salary --> C
else --> D
*/


declare
    v_first_name employees.first_name%type;
    v_last_name employees.last_name%type;
    v_salary employees.salary%type;
    v_department_id employees.department_id%type;
    v_avg_salary v_salary%type;
    v_grade char(1) := 'B';
begin
    select first_name, last_name, salary, department_id
        into v_first_name, v_last_name, v_salary, v_department_id
        from employees where employee_id = &EmployeeNumber;
        
    select avg(salary) into v_avg_salary
        from employees where department_id = v_department_id;
        
    if v_salary > (v_avg_salary*1.5) then
        v_grade := 'A';
    elsif v_salary > v_avg_salary then
        v_grade := 'B';
    elsif v_salary > (v_avg_salary*.5) then
        v_grade := 'C';
    else
        v_grade := 'D';
    end if;
    
    dbms_output.put_line('Salary is $' || v_salary);
    dbms_output.put_line('Avg salary is $' || v_avg_salary);
    dbms_output.put_line('Grade of ' || v_first_name || ' ' || 
        v_last_name || ' is ' || v_grade);
end;

--------











