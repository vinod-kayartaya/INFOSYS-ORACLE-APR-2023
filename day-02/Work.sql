set SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('hello, there!');
END;


----------

DECLARE
    v_message VARCHAR2(200);
BEGIN
    v_message := 'Hello, world!';
    DBMS_OUTPUT.PUT_LINE('The message is : ' || v_message);
END;

-----------

declare 
    v_num1 number := 12;
    v_num2 number := 222;
    v_result number;
begin
    v_result := v_num1 / v_num2;
    dbms_output.put_line(v_num1 || '/' || v_num2 || ' = ' || v_result);
end;












