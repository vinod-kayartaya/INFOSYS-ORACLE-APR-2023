set serverout on;

---- print the following information about employees earning more than $10000
--1. names and salries of all employees
--2. Total salary payout
--3. Average salary paid to all these employees
--4. No.of employees in this category
declare
    cursor c1 is 
        select first_name, last_name, salary 
            from employees where salary > 10000;
    fname employees.first_name%type;
    lname employees.last_name%type;
    salary employees.salary%type;
    v_total_payout number:=0;
    v_avg_payout number;
begin
    open c1; -- SQL of c1 is executed now
    
    loop
        fetch c1 into fname, lname, salary;
        exit when c1%notfound;
        
        v_total_payout := v_total_payout + salary;
        dbms_output.put_line(fname || ' ' || lname || ' earns $' || salary);
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

----- PARAMETERISED CURSORS

declare
    cursor c1(p_salary number) is 
        select first_name, last_name, salary 
            from employees where salary > p_salary;
    fname employees.first_name%type;
    lname employees.last_name%type;
    salary employees.salary%type;
    v_total_payout number:=0;
    v_avg_payout number;
begin
    open c1(&employee_salary); -- SQL of c1 is executed now
    
    loop
        fetch c1 into fname, lname, salary;
        exit when c1%notfound;
        
        v_total_payout := v_total_payout + salary;
        dbms_output.put_line(fname || ' ' || lname || ' earns $' || salary);
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


---- get the list of employees earning salary between MIN_SAL and MAX_SAL
-- information needed: employee name, salary, department name, job title
declare
    cursor c1(min_sal number default 0, max_sal number default 30000) is
        select first_name || ' ' || last_name, salary, department_name, job_title
        from employees e join departments d on e.department_id=d.department_id
        join jobs j on e.job_id = j.job_id
        where salary between min_sal and max_sal
        order by salary desc;
        
    type employee is record (
        name varchar2(200),
        salary employees.salary%type,
        dname departments.department_name%type,
        job jobs.job_title%type
    );
    
    emp employee;
begin
    -- open c1;
    -- open(15000); -- MIN_SAL:=15000, MAX_SAL:=DEFAULT
    open c1(5000, 10000);

    loop 
        fetch c1 into emp;
        exit when c1%notfound;
        dbms_output.put_line(emp.name || ' works in ' || emp.dname ||
            ' department as ' || emp.job || ' and earns $' || emp.salary);
    end loop;
    close c1;
end;

--- DOING THE SAME AS ABOVE BUT WITH A FOR LOOP
declare
    cursor c1 is
        select first_name || ' ' || last_name as name, salary, department_name, job_title
        from employees e join departments d on e.department_id=d.department_id
        join jobs j on e.job_id = j.job_id
        where salary between 5000 and 50000
        order by salary desc;
begin
    for emp in c1
    loop 
        dbms_output.put_line(emp.name || ' works in ' || emp.department_name ||
            ' department as ' || emp.job_title || ' and earns $' || emp.salary);
    end loop;
end;



--- DOING THE SAME AS ABOVE BUT WITH cursor parameters
declare
    cursor c1(min_sal number, max_sal number) is
        select first_name || ' ' || last_name as name, salary, department_name, job_title
        from employees e join departments d on e.department_id=d.department_id
        join jobs j on e.job_id = j.job_id
        where salary between min_sal and max_sal
        order by salary desc;
begin
    for emp in c1(10000, 30000)
    loop 
        dbms_output.put_line(emp.name || ' works in ' || emp.department_name ||
            ' department as ' || emp.job_title || ' and earns $' || emp.salary);
    end loop;
end;


select employee_id, first_name, last_name, 
   round(months_between(sysdate, hire_date)/12) as years_of_experience
    from employees
    order by years_of_experience;



-- We need to increment the salary of employees based on the no.of years of experiece, using the following slab:
-- >= 20 --> $500
-- >=17 --> $300
-- >=15 --> $150
-- others --> $50

-- We need to do this using a pl/sql code with cursor

declare
    cursor c1 is 
        select * from employees
        for update of salary;
    years_of_experience number;
    salary_incr number;
begin
    for emp in c1
    loop
        years_of_experience := round(months_between(sysdate, emp.hire_date));
        
        if years_of_experience>=20 then
            salary_incr := 500;
        elsif years_of_experience>=17 then
            salary_incr := 300;
        elsif years_of_experience>=15 then
            salary_incr := 150;
        else
            salary_incr := 50;
        end if;
        
        update employees
            set salary = salary + salary_incr
            where employee_id = emp.employee_id;
    end loop;
end;

--- nested cursors
-- fetch the employees for whom there are job_history records
-- and display a detailed report on the same.

declare
    cursor c1 is 
        select e.employee_id, first_name, last_name, salary, department_name, job_title
            from employees e join departments d on e.department_id=d.department_id
            join jobs j on e.job_id=j.job_id
            where employee_id in (select employee_id from job_history);
    cursor c2(p_employee_id number) is 
        select start_date, end_date, job_title, department_name
            from job_history jh join jobs j on jh.job_id=j.job_id
            join departments d on jh.department_id=d.department_id
            where employee_id = p_employee_id;
        
begin
    for emp in c1
    loop
        dbms_output.put_line('Name       : ' || emp.first_name || ' ' || emp.last_name);
        dbms_output.put_line('Department : ' || emp.department_name);
        dbms_output.put_line('Job title  : ' || emp.job_title);
        dbms_output.put_line('Salary     : $' || emp.salary);
        
        dbms_output.put_line('Job History for this employee: ');
        for rec in c2(emp.employee_id)
        loop
            dbms_output.put_line('Worked in ' || rec.department_name ||
                ' department as ' || rec.job_title || ' from ' || rec.start_date ||
                ' to ' || rec.end_date);
        end loop;
        dbms_output.put_line('--------------------------------------------');
    end loop;
end;

--- raise a user defined excepion while trying to decrease the salary of the employee
declare
    LESS_SALARY exception;
    v_emp_id employees.employee_id%type;
    v_new_salary employees.salary%type;
    v_curr_salary employees.salary%type;
begin
    v_emp_id := &employee_id;
    v_new_salary := &new_salary;
    
    select salary into v_curr_salary
        from employees
        where employee_id=v_emp_id;
        
    if v_new_salary <= v_curr_salary then
        raise LESS_SALARY;
    end if;
    
    -- code not reachable if the raise statement is encountered
    update employees
        set salary = v_new_salary
        where employee_id = v_emp_id;
    commit;
exception
    when LESS_SALARY then
        dbms_output.put_line('Salary cannot be less than the current salary');
end;


--- same as above with out user defined exception
declare
    v_emp_id employees.employee_id%type;
    v_new_salary employees.salary%type;
    v_curr_salary employees.salary%type;
begin
    v_emp_id := &employee_id;
    v_new_salary := &new_salary;
    
    select salary into v_curr_salary
        from employees
        where employee_id=v_emp_id;
        
    if v_new_salary <= v_curr_salary then
         raise_application_error(-20234, 'Salary cannot be less than the current salary while updating');
    end if;
    
    -- code not reachable if the raise statement is encountered
    update employees
        set salary = v_new_salary
        where employee_id = v_emp_id;
        
    commit;
end;



--- same as above with out user defined exception
declare
    INVALID_SALARY exception;
    PRAGMA EXCEPTION_INIT(INVALID_SALARY, -02290);
    
    -- code '-02290' corresponds to the check constraint
    -- and there is a check constraint for the salary column (>0)
    
    v_emp_id employees.employee_id%type;
    v_new_salary employees.salary%type;
begin
    v_emp_id := &employee_id;
    v_new_salary := &new_salary;
    
    -- fails if the new_salary <=0, by raising the error '-02290',
    -- which has been assigned to the custom exception
    update employees
        set salary = v_new_salary
        where employee_id = v_emp_id;
        
    commit;
exception
    when INVALID_SALARY then    
        dbms_output.put_line('Salary must be > 0');
end;

























