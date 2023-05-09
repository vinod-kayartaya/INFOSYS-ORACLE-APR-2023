select job_id, first_name from employees order by job_id, first_name;

select job_id, 
    count(first_name) 
    from employees 
    group by job_id 
    order by count(first_name) desc, job_id;
    
select job_id,
    listagg(first_name) within group (order by first_name) as employee_names
    from employees
    group by job_id
    order by job_id;
        
select job_id,
    listagg(first_name, ', ') within group (order by first_name) as employee_names
    from employees
    group by job_id
    order by job_id;
    
    
select job_title,
    listagg(first_name, ', ') within group (order by first_name) as employee_names
    from employees join jobs using (job_id)
    group by job_title
    order by job_title;
    
    
select job_title,
    listagg(first_name || ' ' || last_name, ', ' ON OVERFLOW ERROR) within group (order by first_name) as employee_names
    from employees join jobs using (job_id)
    group by job_title
    order by job_title;    
    
--------------------------------------------------------------------------------

select department_name, job_title, count(*) as num_emps
    from employees join departments using (department_id)
    join jobs using (job_id)
    group by department_name, job_title
    having count(*)>1
    order by department_name, job_title;
    
-- not working in the current version
select * from stats_crosstab('select department_name, job_title, count(*) as num_emps
    from employees join departments using (department_id)
    join jobs using (job_id)
    group by department_name, job_title
    having count(*)>1
    order by department_name, job_title');


select first_name, salary from employees    
    order by salary desc;

select 
    employee_id, first_name, last_name, salary,
    dense_rank() over (order by salary desc) as rank
    from employees
    order by salary desc;

select * from (select 
    employee_id, first_name, last_name, salary,
    dense_rank() over (order by salary desc) as rank
    from employees)
    where rank <= 3;


--------------------------------------------------------------------------------
select first_name, hire_date,
    to_char(hire_date, 'month dd yyyy'),
    add_months(hire_date, 15) after_15_months,
    months_between(sysdate, hire_date),
    extract(year from sysdate) -
    extract(year from hire_date)  experience1,
    trunc(months_between(sysdate, hire_date)/12) experience2
    from employees;

select last_day(sysdate), last_day('12-02-1900') from dual;


desc dual;
select * from dual;

--------------------------------------------------------------------------------

select * from employees where salary>=13000
union
select * from employees where commission_pct>=.3;
--------------------------------------------------------------------------------
select * from employees where salary>=13000
intersect
select * from employees where commission_pct>=.3;
--------------------------------------------------------------------------------
select * from employees where salary>=13000
minus
select * from employees where commission_pct>=.3;
-- rows in set A which are not in set B
--------------------------------------------------------------------------------
select * from employees where commission_pct>=.3
minus
select * from employees where salary>=13000;
--------------------------------------------------------------------------------

























    
    
    
    
    
    
    
    