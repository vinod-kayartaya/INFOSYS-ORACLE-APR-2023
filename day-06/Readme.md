# Stored Procedures in Oracle PL/SQL

- A Procedure is a PL/SQL block that is stored in the database with a name
- A procedure is meant to be invoked from a client application (like a Java program)
- A Procedure can be invoked by passing 0 or more IN, OUT and/or INOUT parameters
- This kind of storing a program in a DB improves the performance of a client/server app
  - since the no.of round trips from the client to the server can be reduced
- Improves maintainability
  - since the changes to the logic have to be updated only on one machine
    - this is not a real advantage in these days, since if not a stored procedure, then you may store the business logic in application servers

### Syntax:

```sql
CREATE [OR REPLACE] PROCEDURE {procedure_name} ([{parameter_list}])
IS
    -- local variable declaration
BEGIN
    -- logic
[EXCEPTION]
    -- exception handlers
END;

```

The parameter_list is defined as:

```sql
[IN|OUT|INOUT] {param_name} {param_type}
```

An example of a stored procedure:

```sql
-- Create a stored procedure to accept 3 parameters (department_name, manager_id and location_id)
-- and adds a new record to the departments table.
-- New department_id must be auto generated such that it is equals to max_department_id + 10.
-- manager_id must be a valid employee_id and it should be already manager_id of a department.
-- location_id must be a valid location_id in locations table.

create or replace procedure add_new_dept(
    p_department_name IN varchar2,
    p_manager_id IN number,
    p_location_id IN number,
    p_department_id OUT number) is

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
exception
    when e_value_too_big then
        raise_application_error(-20005, 'Department name is too big');
end;
```

- In order to call the procedure we have to use the EXEC (OR EXECUTE) command

```sql
exec add_new_dept(null, null, null);
exec add_new_dept('Risk assessment', null, null);
exec add_new_dept('Risk assessment', 777, null);
exec add_new_dept('Risk assessment', 200, null);
exec add_new_dept('Risk assessment', 127, 999);
exec add_new_dept('Risk assessment$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$', 127, 3300);
exec add_new_dept('Risk assessment', 127, 3300);
```

Another example of using OUT variables

```sql

---- get complete employee details for a given id
create or replace procedure get_emp_details(
    p_employee_id IN number,
    p_employee_name OUT varchar2,
    p_department_name OUT varchar2,
    p_job_title OUT varchar2,
    p_manager_name OUT varchar2,
    p_salary OUT number,
    p_department_address OUT varchar2) is

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
```

Call the stored procedure:

```sql
declare
    p_employee_name varchar2(50);
    p_department_name varchar2(50);
    p_job_title varchar2(50);
    p_manager_name varchar2(50);
    p_salary number;
    p_department_address varchar2(50);
begin
    get_emp_details(200, p_employee_name, p_department_name,
        p_job_title, p_manager_name, p_salary, p_department_address);

    dbms_output.put_line('Employee name : ' || p_employee_name);
    dbms_output.put_line('Department name : ' || p_department_name);
    dbms_output.put_line('Job title : ' || p_job_title);
    dbms_output.put_line('Manager name : ' || p_manager_name);
    dbms_output.put_line('Salary : ' || p_salary);
    dbms_output.put_line('Work address : ' || p_department_address);
end;

```
