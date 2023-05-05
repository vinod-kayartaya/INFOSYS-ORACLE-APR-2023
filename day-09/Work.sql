set serveroutput on;
-------------------------------------------------------------------
create or replace package utils is
    -- members declaration
    procedure print(message varchar2);
end;

-------------------------------------------------------------------

-- try calling the utils.print() procedure
-- fails, because we do not have package body for 'utils' yet

exec utils.print('Hello, world!');

-------------------------------------------------------------------

create or replace package body utils is
    
    procedure print(message varchar2) is
    begin
        dbms_output.put_line(message);
    end;
    
end;
-------------------------------------------------------------------

-- try calling the utils.print() procedure
-- succeeds, because we now have package body for 'utils'

exec utils.print('Hello, world!');

-------------------------------------------------------------------


create or replace package hr_mgmt is
    procedure add_new_dept(
        p_department_name IN varchar2,
        p_manager_id IN number,
        p_location_id IN number,
        p_department_id OUT number);
        
    procedure get_dept_summary;
    
    procedure get_emp_details(
        p_employee_id IN number,
        p_employee_name OUT varchar2,
        p_department_name OUT varchar2,
        p_job_title OUT varchar2,
        p_manager_name OUT varchar2,
        p_salary OUT number,
        p_department_address OUT varchar2);
        
    function dept_emp_count(
        p_department_id number)
        return number;
    
    function estimate_bonus 
        return number;
    
    function increment_emp_salary(
        p_employee_id number,
        p_incr_pct number) return number;
end;
-------------------------------------------------------------------
create or replace package body hr_mgmt is
    procedure add_new_dept(
        p_department_name IN varchar2,
        p_manager_id IN number,
        p_location_id IN number,
        p_department_id OUT number) is
        -- v_department_id departments.department_id%type;
        v_tmp number;
        e_value_too_big exception;
        pragma exception_init(e_value_too_big, -12899);
    begin
    
        if p_department_name is null then
            raise_application_error(-20000, 'Department name cannot be null');
        end if;
    
        select max(department_id) + 10
            into p_department_id
            from departments;
    
        if p_manager_id is not null then
            select count(*) 
                into v_tmp
                from employees
                where employee_id = p_manager_id;
    
            if v_tmp=0 then
                raise_application_error(-20001, 'Manger id is not a valid employee id');
            end if;
    
            select count(*)
                into v_tmp
                from departments
                where manager_id = p_manager_id;
    
            if v_tmp=1 then
                raise_application_error(-20002, 'Manager id given already is a manager of a department');
            end if;
        end if;
    
        if p_location_id is null then
            raise_application_error(-20003, 'Location id cannot be null');
        end if;
    
        select count(*) 
            into v_tmp
            from locations
            where location_id = p_location_id;
    
        if v_tmp=0 then
            raise_application_error(-20004, 'Location id is not a valid location id');
        end if;
    
        insert into departments values (
            p_department_id, p_department_name, p_manager_id, p_location_id);
        commit;
    
        -- p_department_id := v_department_id;
    
    exception
        when e_value_too_big then
            raise_application_error(-20005, 'Department name is too big');
    end;
    ------- end add_new_dept
        
    procedure get_dept_summary is
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
    ------- end of get_dept_summary
    
    procedure get_emp_details(
        p_employee_id IN number,
        p_employee_name OUT varchar2,
        p_department_name OUT varchar2,
        p_job_title OUT varchar2,
        p_manager_name OUT varchar2,
        p_salary OUT number,
        p_department_address OUT varchar2)  is
        
        emp employees%rowtype;
        mgr employees%rowtype;
        dept departments%rowtype;
        loc locations%rowtype;
    begin
        select * into emp from employees where employee_id=p_employee_id;
        p_employee_name := emp.first_name || ' ' || emp.last_name;
        p_salary := emp.salary;
    
        select * into dept from departments where department_id = emp.department_id;
        p_department_name := dept.department_name;
    
        select * into loc from locations where location_id=dept.location_id;
        p_department_address := loc.street_address || ' '
            || loc.city || ' '
            || loc.state_province || ' - '
            || loc.postal_code || ' '
            || loc.country_id;
    
        select * into mgr from employees where employee_id=emp.manager_id;
        p_manager_name :=  mgr.first_name || ' ' || mgr.last_name;
    
        select job_title into p_job_title from jobs where job_id=emp.job_id;
    
    exception
        when NO_DATA_FOUND then
            raise_application_error(-20000, 'Invalid employee id ' || p_employee_id);
    end;
    
    --- end of get_emp_details
        
    function dept_emp_count(
        p_department_id number)
        return number is
            l_emp_count number;
    begin
        select count(*) into l_emp_count
            from employees
            where department_id = p_department_id;
    
        return l_emp_count;
    
    end;
    --------- end of dept_emp_count
    
    function estimate_bonus 
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
    --------- end of estimate_bonus
    
    function increment_emp_salary(
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
    ------- end of increment_emp_salary
end;
-------------------------------------------------------------------



exec hr.get_dept_summary;

declare
    l_dept_no number;
begin
    hr.add_new_dept('Test Dept 100', 131, 3300, l_dept_no);
    utils.print('new department was added with id ' || l_dept_no);
end;

select * from departments order by department_id desc;


select department_id, department_name, dept_emp_count(department_id)
    from departments
    where rownum<=5;
    
select hr.estimate_bonus() from dual;

declare
    l_bonus number;
begin
    l_bonus := hr.estimate_bonus();
    utils.print('Bonus estimated is $' || l_bonus);
end;

---------------------------------------------------------------
select * from all_procedures;
select *
    from all_procedures
    where object_name = 'DBMS_APPLICATION_INFO';

---------------------------------------------------------------


DECLARE
    l_file UTL_FILE.FILE_TYPE;
    CURSOR C1 is select * from employees where salary>=10000;
BEGIN
    l_file := UTL_FILE.FOPEN('.', 'emps.txt', 'W');
    for e in c1
    loop
        UTL_FILE.PUT_LINE(l_file, e.first_name || ' ' || e.last_name ||
            ' earns $' || e.salary);
    end loop;
    UTL_FILE.FCLOSE(l_file);
    dbms_output.put_line('Information saved to file');
END;

---------------------------------------------------------------
--- share common resources like variables, exceptions and cursors 
--- with members of a package
create or replace package emp_pkg is
    cursor cur_emps(p_department_id number) is
        select * from employees
        where department_id = p_department_id;
    
    procedure get_dept_info(p_department_id number);
end;

create or replace package body emp_pkg is
    -- delcare all private subprograms before using them in other subprograms
    -- private procedure; the signature is not in the specification
    procedure print_emps_in_dept(p_department_id number) is
        l_index number:=1;
    begin
        for emp in cur_emps(p_department_id) -- sql is executed here
        loop
            utils.print(l_index || '. ' || emp.first_name || ' ' || emp.last_name || ' earns $' || emp.salary);
            l_index := l_index+1;
        end loop;
    end print_emps_in_dept;
    
    function get_employee_name(p_employee_id number) return varchar2 is
        emp employees%rowtype;
    begin
        select * into emp
            from employees where employee_id = p_employee_id;
        return emp.first_name || ' ' || emp.last_name;
    exception
        when no_data_found then
            return 'Nobody';
    end get_employee_name;

    procedure print_emps_with_managers(p_department_id number) is
        l_index number:=1;
    begin
        for emp in cur_emps(p_department_id)
        loop
            utils.print('Manager for ' || emp.first_name || ' '
                || emp.last_name || ' is ' ||
                get_employee_name(emp.manager_id));
        end loop;
    end print_emps_with_managers; 
    
    -- publicly accessible procedure
    procedure get_dept_info(p_department_id number) is
        l_emp_count number;
        l_department_name varchar2(50);
    begin
        select department_name into l_department_name from departments where department_id=p_department_id;
            
        l_emp_count := hr_mgmt.dept_emp_count(p_department_id);
        
        utils.print('In department "' || l_department_name || '" there are ' || l_emp_count || ' employees');
        utils.print('Employees in this department are: ');
        print_emps_in_dept(p_department_id);
        utils.print('Employees along with their managers');
        print_emps_with_managers(p_department_id);
    end;
end;

---------------------------------------------------------------
exec emp_pkg.get_dept_info(100);
---------------------------------------------------------------





































