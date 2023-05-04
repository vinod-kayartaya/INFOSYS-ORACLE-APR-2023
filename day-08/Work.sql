set serverout on;

exec get_dept_summary;

select department_id, department_name, dept_emp_count(department_id)
    from departments
    where dept_emp_count(department_id) =0;


---------------------------------------------------
delete from departments where department_id=380;
---------------------------------------------------

create or replace trigger trg_prevent_del_department
before delete on departments
--enable
begin
    raise_application_error(-20001, 'Cannot delete a department record');
end;
---------------------------------------------------

select distinct job_id from employees where commission_pct is not null;
---------------------------------------------------
-- Create a trigger to prevent the upation of commission_pct column
-- if the employee is not a 'SA_MAN', 'SA_REP'
create or replace trigger trg_prevent_comm_pct
before update of commission_pct on employees
for each row
begin
    dbms_output.put_line('old commission_pct is ' || :OLD.commission_pct);
    dbms_output.put_line('new commission_pct is ' || :NEW.commission_pct);
    
    
    if :OLD.job_id not in ('SA_MAN', 'SA_REP') then
        raise_application_error(-20001, 'Cannot UPDATE the commission_pct for '||:OLD.job_id);
    end if;
end;
---------------------------------------------------
-- no effect on the trigger (trigger not fired)
update employees set salary=salary+100 where employee_id=124;
commit;
---------------------------------------------------
-- now trigger is fired and update is prevented
update employees set commission_pct=0.3 where employee_id=124;
---------------------------------------------------
-- this time trigger is fired, but will not prevent the updation
update employees set commission_pct=0.3 where employee_id=152;
commit;
---------------------------------------------------

-- prevent the decrement of salary of an employee, while allowing the
-- increment of employee salary.

create or replace trigger trg_prevent_decr_salary
before update of salary on employees
for each row -- only if this is used, we have access to the :OLD and :NEW bind variables
begin
    if :old.salary > :new.salary then
        raise_application_error(-20001, 
            'Cannot decrement the salary from $' 
            || :old.salary 
            || ' to $'
            || :new.salary);
    end if;
end;
---------------------------------------------------
update employees set salary=salary+100 where employee_id=124;
-- works
---------------------------------------------------
update employees set salary=salary-100 where employee_id=124;
--fails
---------------------------------------------------

commit;

---------------------------------------------------
drop table logs_employees;

create table logs_employees(
    id number primary key,
    created_at timestamp,
    sql_cmd long,
    username varchar(15),
    ip_address varchar(15)
);

create sequence logs_employees_seq
start with 1 increment by 1;

---------------------------------------------------
-- create a trigger that records the DML activities on the employees table
create or replace trigger trg_record_dml_employees
after insert or update or delete on employees
declare
    l_sql_cmd logs_employees.sql_cmd%type;
    l_ip_address logs_employees.ip_address%type;
begin
    l_ip_address := sys_context('USERENV', 'IP_ADDRESS');
    l_sql_cmd := sys_context('USERENV', 'CURRENT_SQL');

    insert into logs_employees values
        (logs_employees_seq.nextval,
        sysdate,
        l_sql_cmd,
        user,
        l_ip_address);
end;
---------------------------------------------------

update employees set salary=salary+50;
delete from employees where employee_id=10000;
select * from logs_employees;

---------------------------------------------------
create table user_activity_logs(
    username varchar(15),
    event_name varchar(15),
    event_at timestamp,
    ip_address varchar(15)
);
---------------------------------------------------
create or replace trigger user_login_trigger
after logon on database
declare
    l_ip_address logs_employees.ip_address%type;
begin
    insert into user_activity_logs values
        (user, 'login', systimestamp, l_ip_address);
end;
---------------------------------------------------
create or replace trigger user_login_trigger
after disconnect on database
declare
    l_ip_address logs_employees.ip_address%type;
begin
    insert into user_activity_logs values
        (user, 'logout', systimestamp, l_ip_address);
end;
---------------------------------------------------













