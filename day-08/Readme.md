# Triggers in Oracle

- A Trigger is a named PL/SQL block stored in the server, like stored procs and functions.
- Unlike the procedures and functions, we cannot invoke/call these triggers
- They are automatically executed based on certain DB events - INSERT, UPDATE, DELETE
- Some triggers can be executed even for DDL (CREATE/ALTER/DROP)
- Some triggers can be executed even for system events (shutdown, startup)
- Events can also be user evnets - login/logout

Syntax:

```sql

CREATE [OR REPLACE] TRIGGER {trigger_name}
{BEFORE|AFTER} {INSERT|UPDATE [OF {column}]|DELETE} ON {table_name}
[FOR EACH ROW]
[FOLLOWS|PRECEDES {another_existing_trigger}]
[ENABLE|DISABLE]
[WHEN {condition}]
[DECLARE]
    -- local variables
BEGIN
    -- logic of your trigger job
[EXCEPTION]
    -- exception handling code
END;

```