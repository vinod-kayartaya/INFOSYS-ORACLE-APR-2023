# Topics to be covered for today

1. Views
1. Indexes
1. Functions
    - Aggregate
    - Date/time
    - String
    - Analytical


## View

- a database object that represents a query (SELECT statements)
- it is name given to a complex SELECT statement, which then can be used as a source of data (like a table)
- it is also possible to store the result of a query in advance and can be refreshed automatically or manually
    - such views are called as MATERIALIZED views
- certain views can also be used for insert/update/delete operations
    - such views are called UPDATABLE views
- you can treat any view just like a table as far as SELECT statements are concerned
    - can be used in JOINS and SUB QUERIES
- for a front-end or middleware developer, it is very convenient to SELECT data from a view rather than executing a very complex SELECT statement that may include JOINS, SUB QUERIES, COMPLEX FUNCTIONS, GROUP BY/ HAVING, ORDER BY, NESTED QUERIES, etc.,

Syntax:

```sql
CREATE [OR REPLACE] VIEW {view_name}[(column_aliases)] AS
    {defining_query}
[WITH READ ONLY]
[WITH CHECK OPTION]
```

### Materialized views

- a database object that contains the result of a query, which is defined by the SELECT statement of a view
- precomputed and stored in the database (like a table)
- unlike a table, we do not perform DML operations on this, instead, we refresh and recompute the result whenever we want


Syntax:

```sql
CREATE MATERIALIZED VIEW {view_name}
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
{select_query}
```

# Indexes

- it is a database object that holds the values of the indexed column __(in ascending order)__ and reference/s to the address of the corresponding record/s in the data files (or in memory)
- Whenever a query is executed that includes the indexed column in the WHERE clause, then the index will be used for getting the corresponding data than the actual table.

Syntax to create an index:

```sql
CREATE INDEX {index_name}
ON {table_name}({column1}[, {column2}, ...])
```

Syntax to drop an index

```sql
DROP INDEX {index_name}
```

For example, before creating the index on `city` column of `customers` table, let us examine the execution plan involved in a query:

```sql
explain plan for 
    select * from customers where city='Beidu';

select plan_table_output
    from table(dbms_xplan.display);
```

Here is the sample output, that says, the full table has to be scanned.

```
Plan hash value: 2008213504
 
-------------------------------------------------------------------------------
| Id  | Operation         | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |           |     1 |   175 |     5   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| CUSTOMERS |     1 |   175 |     5   (0)| 00:00:01 |
-------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("CITY"='Beidu')
 
Note
-----
   - dynamic statistics used: dynamic sampling (level=2)
```

Let's create an index on the `city` column of `customers` table:

```sql
create index idx_customers_city
on customers(city);
```

And now the result of `explain` command would show something like this:

```
Plan hash value: 2611237006
 
----------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name               | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                    |     1 |   175 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| CUSTOMERS          |     1 |   175 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN                  | IDX_CUSTOMERS_CITY |     1 |       |     1   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("CITY"='Beidu')
 
Note
-----
   - dynamic statistics used: dynamic sampling (level=2)
```