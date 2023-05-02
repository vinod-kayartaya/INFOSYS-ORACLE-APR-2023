set serveroutput on;

------------------------------------------------------------------------------
   
create or replace procedure get_dept_summary
is
    c_dept_summary sys_refcursor;
    c_dept_count sys_refcursor;
begin
    open c_dept_summary for 
        select 
            department_name, count(*) as employee_count, sum(salary) as total_salary
            from employees e join departments d on e.department_id=d.department_id
            group by department_name;
    dbms_sql.return_result(c_dept_summary); -- now client can access this
    
    open c_dept_count for select count(*) from departments;
    dbms_sql.return_result(c_dept_count);
end;
------------------------------------------------------------------------------
exec get_dept_summary;
------------------------------------------------------------------------------
create or replace function dept_emp_count(p_department_id number) 
return number is
    l_emp_count number;
begin
    select count(*) into l_emp_count
        from employees
        where department_id = p_department_id;
        
    return l_emp_count;
end;
------------------------------------------------------------------------------
select department_name, dept_emp_count(department_id) as emp_count
    from departments
    where dept_emp_count(department_id)>0
    order by emp_count;
------------------------------------------------------------------------------
select department_name
    from departments
    where dept_emp_count(department_id)=0;
------------------------------------------------------------------------------
declare
    l_emp_count number;
begin
    l_emp_count := dept_emp_count(20);
    dbms_output.put_line('employee count in dept 20 is ' || l_emp_count);
end;
------------------------------------------------------------------------------
select dept_emp_count(20) from dual;
------------------------------------------------------------------------------
-- suppose we want to increment the salary of an employee by certain %age,
-- and get the new salary, if updated successfully. The increase percent must
-- be between 1 and 30.
-- Handle exceptions as well.
create or replace function increment_emp_salary(
    p_employee_id number,
    p_incr_pct number) return number is
    
    l_new_salary number;
    e_salary_out_of_range exception;
begin
    if p_incr_pct not between 1 and 30 then
        raise e_salary_out_of_range;
    end if;

    select salary * (1 + p_incr_pct/100) into l_new_salary
        from employees
        where employee_id=p_employee_id;
    
    update employees
        set salary = l_new_salary
        where employee_id = p_employee_id;
        
    commit;
    
    return l_new_salary;
exception
    when no_data_found then
        raise_application_error(-20001, 'Invalid employee id supplied');
    when e_salary_out_of_range then
        raise_application_error(-20002, 'Increase percent must be between 1 and 30');
end;
------------------------------------------------------------------------------
declare
    l_employee_id number := 100; -- try with invalid employee id
    l_incr_pct number := 15; -- try a value outside of range 1 to 30
    l_new_salary number;
begin
    l_new_salary := increment_emp_salary(100, 15);
    dbms_output.put_line('new salary is ' || l_new_salary);
end;
------------------------------------------------------------------------------
-- suppose we need to estimate the total bonus to be given to all employees.
-- bonus percent is based on the current salary and a ranage table.
-- 0 to 2000 --> 15%
-- 2001 to 5000 --> 10%
-- 5001 to 15000 --> 7%
-- 15001 and above --> 3%
create or replace function estimate_bonus
return number is
    l_bonus_pct number;
    l_total_bonus number := 0;
begin
    for c1 in (select salary from employees)
    loop
        if c1.salary between 0 and 2000 then
            l_bonus_pct := 15;
        elsif c1.salary between 2001 and 5000 then
            l_bonus_pct := 10;
        elsif c1.salary between 5001 and 15000 then
            l_bonus_pct := 7;
        else
            l_bonus_pct :=3;
        end if;
        l_total_bonus := l_total_bonus + 12* c1.salary * l_bonus_pct / 100;
    end loop;
    return l_total_bonus;
end;
--------------------------------------------------------------------------------
select estimate_bonus() from dual;
--------------------------------------------------------------------------------





















