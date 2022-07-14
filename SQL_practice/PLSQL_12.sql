SET SERVEROUTPUT ON;

-- ���� ���ν��� 

-- IN parameter
CREATE PROCEDURE raise_salary
    -- �Ű�����: ������ ��� Ÿ��
    (v_id IN employees.employee_id%TYPE)
    IS 
    -- ����κ�
    v_result NUMBER;
BEGIN
    UPDATE employees SET salary = salary * 1.1
    WHERE employee_id = v_id;
    v_result := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE(v_result || ' ���� ����Ǿ����ϴ�.');
END;
/

EXECUTE raise_salary(100);

CREATE PROCEDURE sum_calculator(v_num IN NUMBER)
IS v_sum NUMBER:=0;
BEGIN
    FOR i in 1..v_num LOOP
        v_sum := v_sum + i;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('������ �� ���: ' || v_sum);
END;
/

EXECUTE sum_calculator(10);

-- OUT parameter
CREATE OR REPLACE PROCEDURE query_emp
    (v_id IN employees.employee_id%TYPE,
    v_name OUT employees.last_name%TYPE,
    v_salary OUT employees.salary%TYPE,
    v_commission_pct OUT employees.commission_pct%TYPE
    )
    IS
BEGIN
    SELECT last_name, salary, commission_pct
    INTO v_name, v_salary, v_commission_pct
    FROM employees
    WHERE employee_id = v_id;
END;
/

-- OUT �� �޾ƿ� ���� ����
VARIABLE g_name VARCHAR2(15);
VARIABLE g_salary NUMBER;
VARIABLE g_commission_pct NUMBER;

EXECUTE query_emp(149, :g_name, :g_salary, :g_commission_pct);

PRINT g_name;
PRINT g_salary;
PRINT g_commission_pct;

CREATE OR REPLACE PROCEDURE sum_calculator 
    (v_num IN NUMBER, v_sum OUT NUMBER)
    IS 
    v_temp NUMBER :=0;
BEGIN
    FOR i IN 1..v_num LOOP
        v_temp := v_temp + i;
    END LOOP;
    v_sum := v_temp;
END;
/

VARIABLE g_sum NUMBER;

EXECUTE sum_calculator(100, :g_sum);

PRINT g_sum;

-- IN OUT
CREATE OR REPLACE PROCEDURE format_phone
    (v_phone_no IN OUT VARCHAR2)
IS
BEGIN
    v_phone_no := REPLACE(v_phone_no, '.', '');
    v_phone_no := '(' || SUBSTR(v_phone_no, 1, 3) || ')' || '-' ||
                                SUBSTR(v_phone_no, 4, 4) || '-' ||
                                SUBSTR(v_phone_no, 7);
END;
/

-- �޴���ȭ ���� 
DECLARE
    phone_no VARCHAR2(100) :='0101111111';
BEGIN
    format_phone(phone_no);
    DBMS_OUTPUT.PUT_LINE(phone_no);
END;
/

DECLARE 
    CURSOR emp_cursor IS
        SELECT * FROM employees;
BEGIN
    DBMS_OUTPUT.PUT_LINE('���� ����ó ����Ʈ');
    FOR emp_record IN emp_cursor  
    LOOP    
        IF LENGTH(emp_record.phone_number) = 12 THEN
        format_phone(emp_record.phone_number);
        DBMS_OUTPUT.PUT_LINE(emp_record.last_name || ' ����� ����ó: ' || emp_record.phone_number);
        ELSE
        DBMS_OUTPUT.PUT_LINE(emp_record.last_name || ' ����� ����ó�� ���� ���İ� ���� �ʽ��ϴ�.');
        END IF;
    END LOOP;
END;
/

-- ����
CREATE OR REPLACE PROCEDURE raise_salary
    (v_id IN employees.employee_id%TYPE)
    IS 
BEGIN
    UPDATE employees
    SET salary = salary * 1.1
    WHERE employee_id = v_id;
END;
/

CREATE OR REPLACE PROCEDURE process_emps
IS
    CURSOR emp_cursor IS 
        SELECT employee_id
        FROM employees;
BEGIN
    FOR emp_record IN emp_cursor LOOP
        raise_salary(emp_record.employee_id);
    END LOOP;
END;
/

EXECUTE process_emps;

-- DELETE Procedure
DROP PROCEDURE raise_salary;
DROP PROCEDURE process_emps;
DROP PROCEDURE sum_calculator;

