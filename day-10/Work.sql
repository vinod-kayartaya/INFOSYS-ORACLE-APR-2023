create or replace view emp_full_details as
    select e.employee_id,
        e.first_name || ' ' || e.last_name as employee_name, -- virtual column
        e.email,
        e.phone_number,
        e.salary,
        e.commission_pct,
        j.job_title,
        d.department_name,
        l.street_address,
        l.city,
        l.state_province,
        l.postal_code,
        c.country_name,
        m.first_name || ' ' || m.last_name as manager_name
    from employees e
    left join jobs j on e.job_id=j.job_id
    left join departments d using (department_id) -- on e.department_id=d.department_id
    left join locations l using (location_id) -- on d.location_id=l.location_id
    left join countries c using (country_id) -- on l.country_id=c.country_id
    left join employees m on e.manager_id=m.employee_id
    order by employee_id
    with read only;
    
--------------------------------------------------------------------------------

select * from emp_full_details
    where salary>=10000;
--------------------------------------------------------------------------------

drop view emp_full_details;
--------------------------------------------------------------------------------
select count(*) from employees;
select * from employees where manager_id is null 
    or job_id is null 
    or department_id is null;
--------------------------------------------------------------------------------
select * from emp_full_details where employee_id=123;

update emp_full_details set salary=8100 where employee_id=123; -- success (to prevent, add the "with read only" to the create view command)
update emp_full_details set job_title = 'Stock Mgr' where employee_id=123; -- failed, since job_title comes from a different table thant employees
update emp_full_details set employee_name = 'Shanta Vollman K' where employee_id=123; -- failed, employee_name does not exist as a column of any table

select * from emp_full_details where job_title='Stock Manager';
--------------------------------------------------------------------------------
create or replace view emp_names as
select employee_id, first_name, last_name from employees;

select * from emp_names where first_name like 'A%';

-- resolved into this:
select first_name from 
    (select employee_id, first_name, last_name from employees) 
    where first_name like 'A%';


-- since the view emp_names include columns from single table, we can treat
-- this as an updatable view
-- can we perform INSERT? 
    -- can be done, if all not-null columns are part of the underlying query
    -- in this case, (email, job_id, hire_date) are not null columns, which have been omitted.
-- can we perform UPDATE?
    -- can be done only for the columns that have been included in the query
    -- employee_id, first_name, last_name


insert into emp_names values (999, 'Vinod', 'Kumar'); -- cannot be done; missing not-null columns
-- resolved into this:
insert into employees(employee_id, first_name, last_name) values (999, 'Vinod', 'Kumar');


update emp_names set last_name='Vollman K' where employee_id=123; -- no problem
update emp_names set salary = salary+100 where employee_id=123; -- cannot be done; salary is not a column in the view

--------------------------------------------------------------------------------
create materialized view mv_emp_full_details 
BUILD IMMEDIATE
as
    select e.employee_id,
        e.first_name || ' ' || e.last_name as employee_name, -- virtual column
        e.email,
        e.phone_number,
        e.salary,
        e.commission_pct,
        j.job_title,
        d.department_name,
        l.street_address,
        l.city,
        l.state_province,
        l.postal_code,
        c.country_name,
        m.first_name || ' ' || m.last_name as manager_name
    from employees e
    left join jobs j on e.job_id=j.job_id
    left join departments d using (department_id) -- on e.department_id=d.department_id
    left join locations l using (location_id) -- on d.location_id=l.location_id
    left join countries c using (country_id) -- on l.country_id=c.country_id
    left join employees m on e.manager_id=m.employee_id
    order by employee_id;
--------------------------------------------------------------------------------
drop materialized view mv_emp_full_details;
--------------------------------------------------------------------------------


create materialized view mv_emp_short_details 
BUILD IMMEDIATE
REFRESH COMPLETE ON COMMIT
as
    select employee_id, first_name, last_name, salary
    from employees;
    
SELECT * FROM mv_emp_short_details WHERE EMPLOYEE_ID=123;

UPDATE EMPLOYEES SET SALARY=8400 WHERE EMPLOYEE_ID=123;
SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID=123;
COMMIT;
SELECT * FROM mv_emp_short_details WHERE EMPLOYEE_ID=123;

DROP materialized view mv_emp_short_details;

ALTER materialized view mv_emp_short_details REFRESH FORCE;

--------------------------------------------------------------------------------
-- USING THE WITH CHECK OPTION

create or replace view 
    v_emp_commission_details as
    select employee_id, first_name, last_name,
        salary, commission_pct, 
        (1200000*commission_pct/100) as commission_amount
        from employees
        where commission_pct is not null
        with check option; -- while updating, cannot set comission_pct to NULL
    
    
select * from v_emp_commission_details order by employee_id asc;

update v_emp_commission_details 
set commission_pct = null
where employee_id=146; -- violation of WHERE condition of SELECT

update v_emp_commission_details 
set commission_pct = 0.375
where employee_id=146; -- no problem
--------------------------------------------------------------------------------
select count(*), count(distinct salary) from employees;

select distinct salary from employees order by salary;
select * from employees where salary=4150;

select * from employees where salary<=4000;

--------------------------------------------------------------------------------
select city, count(*) from customers 
group by city order by city;

select * from customers where city='Beidu';

explain plan for 
    select * from customers where city='Beidu';

select plan_table_output
    from table(dbms_xplan.display);


create index idx_customers_city
on customers(city);

-- when you create a UNIQUE constraint (either while CREATE TABLE command, or
-- the ALTER TABLE command), an index is created automatically, and such 
-- indexes are called unique indexes.

create unique index ui_customers_email 
    on customers(email);
    
drop index ui_customers_email;
    
insert into customers
    values(1003, 'Vinod', 'Khanna', 'vinod@example.com', '9731424000', 'M', 'Mysore');


update customers set email='vinod@example.com' where id = 1002;
commit;

select * from customers where email='vinod@example.com';













