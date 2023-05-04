select * from departments order by department_id desc;


insert into departments(department_id, department_name, location_id)
values(320, 'dept2', 3300);

-- the above transanctional statement was cancelled, and an automatic
-- rollback takes place.

-- so, from now on it is a new transaction

insert into departments(department_id, department_name, location_id)
values(340, 'dept4a', 3300);

commit;

set autocommit on; -- not a good idea

insert into departments(department_id, department_name, location_id)
values(350, 'dept5a', 3300);

