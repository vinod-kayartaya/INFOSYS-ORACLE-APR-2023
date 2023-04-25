set serveroutput on;

declare
    emp employees%rowtype;
    v_employee_id employees.employee_id%type;
begin
    v_employee_id := &employee_id;
    select first_name, last_name into emp
        from employees 
        where employee_id = v_employee_id;
    -- raises error
    -- PL/SQL: ORA-00913: too many values
    -- Reason: number of columns retrieved is not equals to number of recepient variables
end;

------

declare
    TYPE employee_record IS RECORD (
        first_name employees.first_name%type,
        last_name employees.last_name%type,
        email employees.email%type,
        salary number
    );

    emp employee_record;
    v_employee_id employees.employee_id%type;
begin
    v_employee_id := &employee_id;
    select first_name, last_name, email, salary
        into emp
        from employees 
        where employee_id = v_employee_id;
    
    dbms_output.put_line('Name    : ' || emp.first_name || ' ' || emp.last_name);
    dbms_output.put_line('Email   : ' || emp.email);
    dbms_output.put_line('Salary  : $' || emp.salary);
end;

-- A record can also be used in DML statements (usually in INSERT)
declare
    loc locations%rowtype; -- or create a new data type by yourself
    -- loc is a composite variable that now contains 6 fields
    -- which are: location_id, street_address, postal_code, city, state_province and country_id
    -- The names and datatypes are picked from the table's columns.
begin
    select max(location_id)+100 
        into loc.location_id
        from locations;
        
    loc.street_address := '&street_address';
    loc.postal_code := '&postal_code';
    loc.city := '&city';
    loc.state_province := '&state';
    loc.country_id := 'IN'; 
    
    insert into locations values loc;
    dbms_output.put_line('New locations data added');
end;

---- exception handling

declare
    emp employees%rowtype;
begin
    emp.employee_id := &employee_id;
    select * into emp
        from employees
        where employee_id = emp.employee_id;

    dbms_output.put_line(emp.first_name || ' earns $' || emp.salary);
    
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('No data found for the employee id ' || emp.employee_id);
end;


SELECT COUNT(*), DEPARTMENT_ID
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY COUNT(*);





declare
    emp employees%rowtype;
begin
    emp.department_id := &department_id;
    select * into emp
        from employees
        where department_id = emp.department_id;

    dbms_output.put_line(emp.first_name || ' earns $' || emp.salary);
    
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('No data found for the department id ' || emp.department_id);
    when TOO_MANY_ROWS then
        dbms_output.put_line('More than one employees exist in department ' || emp.department_id);
end;

INSERT INTO DEPARTMENTS VALUES(70, 'ASD', 100, 3300);

-----


declare
    emp employees%rowtype;
    emp_count number;
begin
    emp.department_id := &department_id;
    
    begin
        select * into emp
            from employees
            where department_id = emp.department_id;
        dbms_output.put_line(emp.first_name || ' earns $' || emp.salary);
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('No data found for the department id ' || emp.department_id);
        when TOO_MANY_ROWS then
            dbms_output.put_line('More than one employees exist in department ' || emp.department_id);
        when OTHERS then
            dbms_output.put_line('Something went wrong!');
    end;
    
    select count(*) into emp_count from employees
        where department_id = emp.department_id;
    dbms_output.put_line('There are ' || emp_count || 
        ' employees in department ' || emp.department_id);
end;

--- TO CHECK THE USE OF IMPLICIT CURSOR INFORMATION
declare
    v_emp_id employees.employee_id%type;
    v_inc_amt number;
begin
    v_emp_id := &employee_number;
    v_inc_amt := &increment_amount;
    
    update employees
        set salary = salary + v_inc_amt
        where employee_id = v_emp_id;
    -- does not raise NO_DATA_FOUND exception if the employee id is not found!
    
    if SQL%NOTFOUND then -- affected any rows or not?
    -- if SQL%ROWCOUNT=0 then -- no.of rows affected by the last DML command
        dbms_output.put_line('No employee data found for id ' || v_emp_id);
    else
        dbms_output.put_line('Employee salary is incremented by $' || v_inc_amt);
    end if;
end;


---- print the following information about employees earning more than $10000
--1. names and salries of all employees
--2. Total salary payout
--3. Average salary paid to all these employees
--4. No.of employees in this category
declare
    type emp_basic_type is record(
        fname employees.first_name%type,
        lname employees.last_name%type,
        salary employees.salary%type
    );
    cursor c1 is 
        select first_name, last_name, salary 
            from employees where salary > 10000;
    emp emp_basic_type;
    v_total_payout number:=0;
    v_avg_payout number;
begin
    open c1;
    
    loop
        fetch c1 into emp;
        exit when c1%notfound;
        
        v_total_payout := v_total_payout + emp.salary;
        dbms_output.put_line(emp.fname || ' ' || emp.lname || ' earns $' || emp.salary);
    end loop;
    dbms_output.put_line('No.of employees is ' || c1%rowcount);

    v_avg_payout := v_total_payout / c1%rowcount;
    dbms_output.put_line('Total payout    = $' || v_total_payout);
    dbms_output.put_line('Average payout  = $' || v_avg_payout);
    
    close c1;
exception
    when ZERO_DIVIDE then
        dbms_output.put_line('Nobody earns more than 230000');
end;
















