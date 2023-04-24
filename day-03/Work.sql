select * from employees order by salary desc;
set serveroutput on;

declare
    emp employees%rowtype;
    v_group varchar2(20);
begin
    select * into emp
        from employees
        where employee_id = &employee_id; -- 100, 101, 102, 200, 103
        
    case emp.job_id
        when 'AD_PRES' then
            v_group := 'Group 1';
        when 'AD_VP' then
            v_group := 'Group 2';
        when 'AD_ASST' then
            v_group := 'Group 3';
        else
            v_group := 'Group 4';
    end case;
    dbms_output.put_line('Name   : ' || emp.first_name || ' ' || emp.last_name);
    dbms_output.put_line('Job id : ' || emp.job_id);
    dbms_output.put_line('Group  : ' || v_group);
    
end;

-----
-- find the employee's grade based on salary
declare
    emp employees%rowtype;
    v_grade char;
begin
    select * into emp
        from employees
        where employee_id = &employee_id;
        
    case
        when emp.salary >= 15000 then   
            v_grade := 'A';
        when emp.salary >= 10000 then
            v_grade := 'B';
        when emp.salary >= 5000 then
            v_grade := 'C';
        when emp.salary >= 3000 then
            v_grade := 'D';
        else
            v_grade := 'E';
    end case;
    
    dbms_output.put_line('Name   : ' || emp.first_name || ' ' || emp.last_name);
    dbms_output.put_line('Salary : ' || emp.salary);
    dbms_output.put_line('Grade  : ' || v_grade);
end;

----
select distinct department_id from employees order by department_id;
----

declare
    emp employees%rowtype;
    v_group char;
begin
    select * into emp
        from employees
        where employee_id = &employee_id;
        
    case
        when emp.department_id = 10 then
            v_group := 'A';
        when emp.department_id in (20, 30, 40) then -- a bunch of values
            v_group := 'B';
        when emp.department_id between 50 and 90 then -- a range of values
            v_group := 'C';
        else
            v_group := 'D';
    end case;
    dbms_output.put_line('Name    : ' || emp.first_name || ' ' || emp.last_name);
    dbms_output.put_line('Dept id : ' || emp.department_id);
    dbms_output.put_line('Group   : ' || v_group);
end;


----- use of labels
begin
    goto second_message;
    <<first_message>>
    dbms_output.put_line('This is the first output');
    goto third_message;
    
    <<second_message>>
    dbms_output.put_line('This is the second output');
    goto first_message;
    
    <<third_message>>
    dbms_output.put_line('This is the third output');
end;


---- using goto and label to execute a loop
declare
    counter number := 1;
begin
    
    << prg_start >>
    dbms_output.put_line('counter = ' || counter);
    counter := counter + 1;
    
    if counter>10 then
        goto prg_end;
    end if;
    
    goto prg_start;
    
    << prg_end >>
    null;
end;


-----

declare
    num number default 123;
begin
    goto else_block; 
    -- PLS-00375: illegal GOTO statement; this GOTO cannot branch to label 'ELSE_BLOCK'
    
    if num>100 then
        dbms_output.put_line('num is greater than 100');
    else
        <<else_block>>
        dbms_output.put_line('num is <= 100');
    end if;
end;

-----
declare
    i number := 1;
begin
    loop
        dbms_output.put_line('i is ' || i);
        i := i+1;
        if i>10 then
            goto the_end;
        end if;
    end loop;
    
    <<the_end>>
    null;
end;
-----
declare
    i number := 1;
begin
    loop
        dbms_output.put_line('i is ' || i);
        i := i+1;
        if i>10 then
            exit;
        end if;
    end loop;
end;

---

declare
    i number := 1;
begin
    loop
        dbms_output.put_line('i is ' || i);
        i := i+1;
        exit when i>10;
    end loop;
end;
----
--Check if the input number is a prime or not
declare
    num number := &number;
    d number := 2;
    limit number := num/2;
    is_prime boolean default true;
begin
    while d <= limit and is_prime loop
        if mod(num, d) = 0 then
            is_prime := false;
        end if;
        d := d+1;
    end loop;
    
    if is_prime then
        dbms_output.put_line(num || ' is a prime number');
    else
        dbms_output.put_line(num || ' is a composite number');
    end if;
end;

----
-- accept and print the factorial of a number

declare
    num number := &number;
    fact number := 1;
    i varchar2(20) := 'vinod';
begin
    for i in 2..num loop -- loop variable is newly declared here
        fact := fact * i;
    end loop;
    dbms_output.put_line('outside the loop, value of i is ' || i);
    dbms_output.put_line('factorial of ' || num || ' is ' || fact);
end;

---------------------------

begin
    for i in reverse 0..&number loop
        dbms_output.put_line('i = ' || i);
    end loop;
end;

select * from v$version;


--- USE OF CONTINUE keyword

begin
    for i in 1..50
    loop
        
        if mod(i, 5)=0 then 
            continue; -- skips the rest of the loop body and goes the beginning of the loop
        end if;
        
        dbms_output.put_line('i = ' || i);
    end loop;
end;












