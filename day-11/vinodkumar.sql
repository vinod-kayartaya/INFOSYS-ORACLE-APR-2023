create table persons(
    id number primary key,
    name varchar2(50) not null,
    email varchar2(100) unique,
    city varchar2(50) default 'Bangalore');
