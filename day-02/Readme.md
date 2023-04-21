# PL/SQL

### Oracle's PL/SQL Architecture

![](./arch.dio.png)

-   It is a code block
-   Generally saved in the database as
    -   Procedure
    -   Function
    -   Trigger
-   All the stored PL/SQL blocks can also be grouped under a `package`
-   Can also be written as an anonymous blocks
    - Not part of DB
    - Need to be saved in a file for future use


```sql
DECLARE
    -- declaring variables
BEGIN
    -- logic and SQL commands
[EXCEPTION
    -- logic to handle exceptions
]
END;
/
```

While learning PL/SQL, we often have to print out some  text. The DBMS_OUTPUT package has a procedure called PUT_LINE that can be used to log our output. In production environment, this has not meaning, and must be avoided.

```sql
BEGIN
    DBMS_OUTPUT.PUT_LINE('hello, world!');
END;
/
```

Depending on the client used, the environment variable SERVEROUTPUT may be ON or OFF. Only when it is ON, there will be an output.