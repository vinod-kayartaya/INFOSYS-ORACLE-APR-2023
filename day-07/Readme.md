# Stored functions in Oracle PL/SQL

- Similar to stored procedures with minor differences
- Unlike the stored procedure, you may not be able to us OUT or INOUT parameters
- Unlike the stored procedures, you MUST return a value
- May or may not have parameters
- Can be used in an expression of a SELECT statement

Syntax:

```sql

CREATE [OR REPLACE] FUNCTION {function_name}([{parametr_list}])
RETURN {return_type} IS
    -- local variable declaration
BEGIN
    -- logic
    return {value};
[EXCEPTION
    WHEN {condition} THEN
        {handler}
    ]
END;

```

## Important points to keep in mind when creating a stored function:

- Specify the return type: When creating a function, it is important to specify the data type of the return value using the RETURN keyword. This can be any valid SQL data type or user-defined type.
- Define the function parameters: If the function requires input parameters, they should be defined within parentheses after the function name. You can define one or more parameters, each with a name and data type.
- Use exception handling: Make sure to include exception handling in your function to handle errors and ensure proper functioning of the function.
- Minimize side effects: A stored function should generally not have any side effects, such as modifying data in the database. It should perform a specific task and return a value based on that task.
- Limit complexity: To make the function more readable and maintainable, it's important to limit the complexity of the code by breaking it into smaller, more manageable pieces.
- Test the function: Before deploying the function in a production environment, test it thoroughly to ensure that it works as expected.
- Use proper naming conventions: Use meaningful names for your function, parameters, and variables to make the code more understandable and maintainable.
- Document the function: Include comments in your function to explain its purpose, input parameters, return values, and any assumptions or limitations.
- Consider performance: When writing a function, consider the performance implications of the code, especially if it will be used frequently in a production environment.
- Follow coding standards: Adhere to any coding standards or guidelines provided by your organization or industry best practices to ensure consistency and maintainability of the code.
