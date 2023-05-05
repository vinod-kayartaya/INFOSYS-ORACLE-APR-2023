# Oracle Packages


- Group different database objects together and provide a namespace
- different objects in a package:
    - variable
    - constant
    - cursors
    - exception
    - procedures
    - functions
- By default, a package is created with a scope of the current schema, and accessible to any other executable with in the same schema
- A package has two parts
    1. package specification
        - declares the public objects that can be accessed from outside of the package
    1. package body
        - contains the implementations of the cursor or subprograms declared in the package specification


Syntax:

```sql
CREATE [OR REPLACE] PACKAGE [{schema_name}.]{package_name} IS | AS
    -- declaration of package members
END [{schema_name}.]{package_name}]

```

A package declaration just has member signatures. The actual implemtation should also be created. And that is done using the package body.

Syntax:

```sql
CREATE [OR REPLACE] PACKAGE BODY [{schema_name}.]{package_name} IS | AS
    -- declarations of private members
    -- implementations for the subprograms declared in the package specificatio
[BEGIN

EXCEPTION]
END;


```

### Oracle's built in packages (some of the most commonly used)

- DBMS_OUTPUT
- DBMS_SQL
- UTL_FILE
- DBMS_UTILITY
- DBMS_APPLICATION_INFO