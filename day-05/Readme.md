## Parameterized Cursors

- The cursor declaration can have variable, which can be used in the SQL SELECT statement
- When the cursor is open, we have to pass values to the parameter list

```sql
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
```

## Default values

- Cursor parameters may have default values
- While opening the cursor, we may omit passing parameters
- Default values must be given from right-to-left

```sql
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
```

## Using `for` loops with cursors

- When you use a for loop with the cursors,
  - we do not have to OPEN the cursor
  - we do not have to FETCH the cursor
  - we do not have to use the `exit when c1%notfound` statement
  - we do not have to CLOSE the cursor
  - we do not have to declare the loop variable

```sql

declare
    cursor c1 is ....
begin
    for emp in c1 -- cursor is `open` for the first iteration, and the `fetch into emp` happens for all iterations
    loop

    end loop
end;

```

For example,

```sql
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
```

- pass the parameters in the `for emp in c1` statement

```sql
-- DOING THE SAME AS ABOVE BUT WITH cursor parameters
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

```

## Nested cursors

```sql
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
```

## Few more things about `exception handling`

```sql
declare
    -- variable declaration
begin
    -- logic
exception
    -- exception handling
end;

```

### `RAISE` statement

- used for raising (throwing in Java) a user defined exception
- `RAISE exception_name`

What is a user defined exception?

- It is just a name that indicates an erroneous situation
- Declared just like any other variable
- A user defined exception variable must be associated with an `error_code`
- Use the PRAGMA EXCEPTION_INIT statement to assign an error code with a user defined exception
```sql
declare
    my_custom_exception EXCEPTION;
    PRAGMA EXCEPTION_INIT(my_custom_exception, -22001);
begin
    -- program logic
    -- conditionally raise the exception
    if condition then
        RAISE my_custom_exception
    end if;

exception
    WHEN my_custom_exception then
        -- handle exception
end;

```
