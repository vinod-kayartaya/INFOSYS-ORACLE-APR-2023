create table tbl_persons(
    fname char(20),
    lname varchar(20)
);

insert into tbl_persons values ('Vinod', 'Kumar');

select fname, length(fname), lname, length(lname) from tbl_persons;
select '**' || fname || '**', '**' || lname || '**' from tbl_persons;

desc tbl_persons;

drop table tbl_persons;

create table tbl_products(
    name varchar(40),
    price number(5, 2)
);

insert into tbl_products values('test', 123.45);
insert into tbl_products values('test3', 999.9999);



select * from tbl_products;
drop table tbl_products;

create table tbl_persons(
name varchar2(20),
dbo date
);

insert into tbl_persons values ('Shyam', '02-oct-1973');
insert into tbl_persons values ('Harish', '21/12/1975');
select * from tbl_persons;

select sysdate from dual;

select 10+20*474 from dual;
desc dual;
select * from dual;

SELECT SYSDATE FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MM') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MON') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MONTH') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MONTH DD, YYYY HH:MI:SS') FROM DUAL;

SELECT SYSDATE + INTERVAL '15' DAY FROM DUAL;
SELECT SYSDATE + INTERVAL '1' YEAR + INTERVAL '3' MONTH + INTERVAL '15' DAY FROM DUAL;

SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL;
SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'DD-MM-YYYY HH:MI:SS') FROM DUAL;

CREATE TABLE TBL_CUSTOMERS(
    CUSTOMER_ID NUMBER PRIMARY KEY,
    FIRST_NAME VARCHAR2(20) NOT NULL,
    LAST_NAME VARCHAR2(20),
    CITY VARCHAR2(30) DEFAULT 'Bangalore',
    RATING INT CHECK (RATING BETWEEN 1 AND 10),
    EMAIL VARCHAR2(200) UNIQUE
);

SELECT * FROM TAB;
DESC TBL_CUSTOMERS;

ALTER TABLE TBL_CUSTOMERS DROP PRIMARY KEY;
ALTER TABLE TBL_CUSTOMERS DROP CONSTRAINT SYS_C0014289;

ALTER TABLE TBL_CUSTOMERS 
ADD CONSTRAINT CHK_CUSTOMER_RATING CHECK (RATING BETWEEN 1 AND 10);

ALTER TABLE TBL_CUSTOMERS
ADD CONSTRAINT PK_CUSTOMER_ID PRIMARY KEY (CUSTOMER_ID);

ALTER TABLE TBL_CUSTOMERS
ADD PHONE VARCHAR(50);

ALTER TABLE TBL_CUSTOMERS
ADD CONSTRAINT UNIQ_PHONE UNIQUE (PHONE);

INSERT INTO TBL_CUSTOMERS (CUSTOMER_ID, FIRST_NAME) VALUES (1, 'VINOD');
INSERT INTO TBL_CUSTOMERS (CUSTOMER_ID, FIRST_NAME) VALUES (2, 'SHYAM');

CREATE SEQUENCE TBL_CUSTOMERS_SEQ
START WITH 3
INCREMENT BY 1;

-- IN ORDER TO USE THE CURRVAL, SEQUENCE NEEDS TO BE USED FIRST
SELECT TBL_CUSTOMERS_SEQ.NEXTVAL FROM DUAL;

SELECT TBL_CUSTOMERS_SEQ.CURRVAL FROM DUAL;

INSERT INTO TBL_CUSTOMERS (CUSTOMER_ID, FIRST_NAME) 
VALUES (TBL_CUSTOMERS_SEQ.NEXTVAL, 'KISHORE');


INSERT INTO TBL_CUSTOMERS (CUSTOMER_ID, FIRST_NAME, EMAIL) 
VALUES (TBL_CUSTOMERS_SEQ.NEXTVAL, 'KISHORE', 'kishore223@xmpl.com');
SELECT * FROM TBL_CUSTOMERS;

SELECT SYS_GUID() FROM EMPLOYEES;

SELECT * FROM EMPLOYEES WHERE ROWNUM<=5;
SELECT * FROM EMPLOYEES ORDER BY SALARY DESC;
SELECT * FROM EMPLOYEES WHERE ROWNUM<=10 ORDER BY HIRE_DATE ASC;


SELECT * FROM EMPLOYEES WHERE ROWNUM<=3 ORDER BY SALARY DESC;


SELECT * FROM EMPLOYEES E1
WHERE 3=(
    SELECT COUNT(DISTINCT SALARY)
    FROM EMPLOYEES E2
    WHERE E2.SALARY>=E1.SALARY
);


SELECT COUNT(DISTINCT SALARY) FROM EMPLOYEES WHERE SALARY>=10500;


SELECT * FROM EMPLOYEES E1
WHERE 5 > (SELECT COUNT(*) FROM EMPLOYEES E2 WHERE E2.EMPLOYEE_ID<=E1.EMPLOYEE_ID);




SELECT * FROM EMPLOYEES;

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY FROM 
(
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY,
    DENSE_RANK() OVER (ORDER BY SALARY DESC) AS SALARY_RANK
    FROM EMPLOYEES
)
WHERE  3 = SALARY_RANK;


SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY,
    DENSE_RANK() OVER (ORDER BY SALARY DESC) AS SALARY_RANK
    FROM EMPLOYEES;
