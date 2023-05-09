select * from all_users;

-- create the user
create user c##vinod 
    identified by topsecret;

-- grant the user a privilege to connect (create a session on the server)
GRANT CREATE SESSION TO c##vinod;


-- grant other permissions
GRANT CREATE TABLE TO c##vinod;


alter user c##vinod
    quota unlimited on users; -- here 'users' is the name of the tablespace (default)

-- grant permission to access tables from another user account
GRANT SELECT ANY TABLE TO c##vinod;

REVOKE SELECT ANY TABLE FROM c##vinod;

GRANT SELECT on c##u50.employees TO c##vinod;

REVOKE SELECT on c##u50.employees FROM c##vinod;

-----------------------
-- 1. CREATE A TABLESPACE
-- 2. CREATE A USER AND ASSOCIATE THE USER WITH THE DATABASE

CREATE TABLESPACE TBS_VINOD
    DATAFILE 'tbs_vinod.dbf'
    SIZE 1m;

CREATE USER C##VINODKUMAR
    IDENTIFIED BY TOPSECRET
    DEFAULT TABLESPACE TBS_VINOD;
    
GRANT CREATE SESSION TO C##VINODKUMAR;

GRANT CREATE TABLE TO C##VINODKUMAR;

-- url     : jdbc:oracle:thin:@localhost:1521:orcl
-- username: c##vinodkumar
-- password: topsecret
--



