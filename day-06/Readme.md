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
    p_department_name varchar2,
    p_manager_id number,
    p_location_id number) is

    v_department_id departments.department_id%type;
    v_tmp number;
    e_value_too_big exception;
    pragma exception_init(e_value_too_big, -12899);
begin

    if p_department_name is null then
        raise_application_error(-20000, 'Department name cannot be null');
    end if;

    select max(department_id) + 10
        into v_department_id
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
        v_department_id, p_department_name, p_manager_id, p_location_id);
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
