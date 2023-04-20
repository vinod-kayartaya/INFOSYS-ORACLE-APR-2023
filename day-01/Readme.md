# Oracle SQL and PL/SQL

Day 1: Introduction to Oracle

-   Oracle RDBMS server architecture
-   Database objects
-   Data types
-   Syntax for DDL/DML commands
-   Connecting to remote server using SQL Developer
-   Using the HR database

Day 2: Introduction to PL/SQL

-   Overview of PL/SQL
-   Advantages of using PL/SQL
-   PL/SQL Architecture
-   Basic syntax of PL/SQL
-   PL/SQL data types

Day 3: PL/SQL Program Structure

-   PL/SQL Blocks
-   PL/SQL Variables
-   PL/SQL Constants
-   PL/SQL Operators
-   Control Structures

Day 4: PL/SQL Stored Procedures and Functions

-   Introduction to stored procedures and functions
-   Creating stored procedures and functions
-   Using parameters in stored procedures and functions
-   Invoking stored procedures and functions

Day 5: PL/SQL Cursors and Collections

-   Introduction to cursors
-   Types of cursors
-   Cursor attributes
-   Cursor operations
-   Introduction to collections
-   Types of collections
-   Using collections in PL/SQL

Day 6: PL/SQL Exception Handling

-   Overview of PL/SQL exception handling
-   Types of exceptions
-   Handling exceptions using EXCEPTION block
-   Raising user-defined exceptions

Day 7: PL/SQL Triggers

-   Introduction to triggers
-   Types of triggers
-   Creating triggers
-   Trigger timing and events

Day 8: Advanced PL/SQL Concepts: Dynamic SQL

-   Introduction to dynamic SQL
-   Advantages and disadvantages of dynamic SQL
-   Executing dynamic SQL statements
-   Using bind variables with dynamic SQL

Day 9: Advanced PL/SQL Concepts: Packages

-   Introduction to packages
-   Creating and using packages
-   Advantages of using packages
-   Types of packages

Day 10: Advanced PL/SQL Concepts: Database Links

-   Introduction to database links
-   Creating database links
-   Types of database links
-   Using database links in PL/SQL

Day 11: Advanced PL/SQL Concepts: Debugging Techniques and Best Practices

-   Advanced PL/SQL debugging techniques
-   Best practices for writing efficient PL/SQL code
-   Conclusion and summary of the course

## Oracle data types

-   Oracle built-in data types
    -   charater data types
        -   CHAR
        -   VARCHAR2(size [BYTE|CHAR])
            -   Variable length character string
            -   maximum length is defined by the `size`
            -   `size` is mandatory for varchar2
            -   minimum size is 1 and maximum size is
                -   4000 if MAX_STRING_SIZE=STANDARD
                -   32767 if MAX_STRING_SIZE=EXTENDED
        -   NCHAR
        -   NVARCHAR2(size [BYTE|CHAR])
            -   supports the use of UNICODE characters
    -   number types
        -   NUMBER (precision, scale)
            -   precision can range from 1 to 38
            -   scale will consume the part of precision
        -   FLOAT (precision)
        -   BINARY FLOAT
        -   BINARY DOUBLE
    -   long and raw types
        -   LONG
            -   Character data tyep to store huge amount of data (more than that is handled by char/varchar2)
            -   up 2 gigabytes (2^31)-1 bytes
        -   LONG RAW
        -   RAW
    -   date/time types
        -   DATE
            -   Ranges from Jan 1st 4712 BC to Dec 31st 9999 AD
        -   TIMESTAMP
        -   INTERVAL
    -   large object types
        -   BLOB
        -   CLOB
        -   NCLOB
        -   BFILE
    -   row id types
        -   ROWID
        -   UROWID
-   ANSI SQL Data types
    -   CHARACTER(N) --> CHAR(N)
    -   CHAR(N) --> CHAR(N)
    -   CHARACTER VARYING(N) --> VARCHAR2(N)
    -   CHAR VARYING(N) --> VARCHAR2(N)
    -   NATIONAL CHARACTER(N) --> NCHAR(N)
    -   NATIONAL CHAR(N) --> NCHAR(N)
    -   NCHAR(N) --> NCHAR(N)
    -   NATIONAL CHARACTER VARYING(N) --> NVARCHAR2(N)
    -   NATIONAL CHAR VARYING(N) --> NVARCHAR2(N)
    -   NCHAR VARYING(N) --> NVARCHAR2(N)
    -   NUMERIC[(p, s)] --> NUMBER(p, s)
    -   DECIMAL[(p, s)] --> NUMBER(p, s)
    -   INTEGER --> NUMBER(p, 0)
    -   INT --> NUMBER(p, 0)
    -   SMALLINT --> NUMBER(p, 0)
    -   FLOAT --> FLOAT(126)
    -   DOUBLE PRECISION --> FLOAT(126)
    -   REAL --> FLOAT(63)
-   User defined types
    -   We can create our own data types using any of other types or other user defined types
    -   `CREATE TYPE`
-   Oracle supplied types
    -   ANYTYPE
    -   XML TYPE
    -   SPACIAL TYPES
    -   MEDIA TYPES

## Database objects

-   Tables
-   Views
-   Indexes
-   Sequence
-   Procedure
-   Function
-   Trigger
-   Package

### DDL (data definition language) can be used for creating/modifying/deleting any of the above objects

-   Whenever a DDL command is issued, an automatic COMMIT takes place
-   CREATE
-   ALTER
-   DROP

```sql
    CREATE TABLE table_name (
        column1_definition
        [,...]
    ) [AS query]
```

Column definition includes the following:

-   name of the column
-   data type and size of the column
-   optional constraints (such as not null, check, references, primary key, unique )
-   optional `default` value

```sql
column_name datatype [{default expr}|{auto increment} ][column_constraint]
```

An example:

```sql
CREATE TABLE TBL_CUSTOMERS(
    CUSTOMER_ID NUMBER AUTO INCREMENT,
    FIRST_NAME VARCHAR2(20) NOT NULL,
    LAST_NAME VARCHAR2(20),
    CITY VARCHAR2(30) DEFAULT 'Bangalore',
    RATING INT CHECK (RATING BETWEEN 1 AND 10),
    EMAIL VARCHAR2(200) UNIQUE
);
```

In Oracle, unlike MySQL or PostgreSQL, we cannot insert multiple records using a single INSERT command.

Syntax of UPDATE is same as that of MySQL or PostgreSQL:

```sql
UPDATE table_name
SET column1=value1 [, column2=value2, ...]
[WHERE condition]
```

## Sequences

-   A sequence is a database object that can be used as a seed value for primary keys

```sql
CREATE SEQUENCE seq_name
START WITH seed
INCREMENT BY inc_by
MAXVALUE max_val
MINVALUE min_val
```
