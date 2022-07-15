/* 
��Ű��: ����, Ŀ��, ���ν��� ���� �������� ���� 
1. ��Ű�� ��: ����
2. ��Ű�� �ٵ�: ���� => �ʼ������� ��Ű�� ���� �䱸
*/

SET SERVEROUTPUT ON;

-- Package Specification
CREATE OR REPLACE PACKAGE comm_package
    IS 
        -- Global Variable
        g_comm NUMBER;
        -- Constant Variable
        g_num CONSTANT NUMBER := 100;
        -- PROCEDURE procedure_name(parameter)
        PROCEDURE reset_comm(v_comm IN NUMBER);
    END;
/
-- ���ν����� ���ǵǾ� ���� �ʱ� ������ ������ ���� ����, �� �κ��� �ܼ��� ����ϴ� �κ�
-- EXECUTE comm_package.reset_comm(5);

-- Package Body
CREATE OR REPLACE PACKAGE BODY comm_package
    IS
        -- Private Function - �ٵ𿡼��� ��� 
        FUNCTION validate_comm
            (v_comm IN NUMBER)
            RETURN BOOLEAN
        IS 
            v_max_comm NUMBER;
        BEGIN
            SELECT MAX(commission_pct)
            INTO v_max_comm
            FROM employees;
            IF v_comm > v_max_comm THEN
                RETURN FALSE;
            ELSE 
                RETURN TRUE;
            END IF;
        END validate_comm;
        PROCEDURE reset_comm
            (v_comm IN NUMBER)
        IS
            v_valid BOOLEAN;
        BEGIN
            v_valid := validate_comm(v_comm);
            IF v_valid THEN
                g_comm := v_comm;
            ELSE
                RAISE_APPLICATION_ERROR(-20211, 'Invalid commission');
            END IF;
        END reset_comm;
    END comm_package;
    /

SELECT MAX(commission_pct) FROM employees;
EXECUTE comm_package.reset_comm(0.5);

-- Data Dictionary: USER_SOUCE, ALL_SOURCE
-- USER_SOURCE: ���� ������ ��Ű��, ��Ű�� ��, ���ν���, �Լ� ���� Ȯ��
-- ALL_SOURCE: ���� ������ ������ �� �ִ� ������ ���� ��Ű��, ��Ű�� ��, ���ν��� �Լ� �� Ȯ��
SELECT name, type, text FROM user_source WHERE TYPE = 'PACKAGE';
SELECT * FROM all_source;

CREATE OR REPLACE PACKAGE global_consts
IS
    mile_2_kilo CONSTANT NUMBER := 1.6093;
    kilo_2_mile CONSTANT NUMBER := 0.6214;
    yard_2_meter CONSTANT NUMBER :=0.9144;
    meter_2_yard CONSTANT NUMBER :=1.0936;
END global_consts;
/

EXECUTE DBMS_OUTPUT.PUT_LINE('20 miles = ' || 20 * global_consts.mile_2_kilo || 'km');
    
CREATE OR REPLACE PROCEDURE meter_to_yard
    (p_meter IN NUMBER,
    p_yard OUT NUMBER)
    IS 
BEGIN
    p_yard := global_consts.meter_2_yard * p_meter;
END;
/

VARIABLE g_yard NUMBER;
EXECUTE meter_to_yard(20, :g_yard);
PRINT g_yard;

-- Overload
CREATE OR REPLACE PACKAGE over_pack
    IS
    -- �Ű����� ���� �ٸ� 
    PROCEDURE add_dept(
        v_deptno IN departments.department_id%TYPE,
        v_dname IN departments.department_name%TYPE,
        v_loc IN departments.location_id%TYPE
    );
    PROCEDURE add_dept(
        v_name IN departments.department_name%TYPE,
        v_loc IN departments.location_id%TYPE
    );
END over_pack;
/

CREATE OR REPLACE PACKAGE BODY over_pack
    IS
    PROCEDURE add_dept(
        v_deptno IN departments.department_id%TYPE,
        v_dname IN departments.department_name%TYPE,
        v_loc IN departments.location_id%TYPE
    )
    IS
    BEGIN
        INSERT INTO dept VALUES (v_deptno, v_dname, v_loc);
    END add_dept;
    PROCEDURE add_dept(
        v_name IN departments.department_name%TYPE,
        v_loc IN departments.location_id%TYPE
    )
    IS
        v_max_no departments.department_id%TYPE;
    BEGIN
        SELECT MAX(department_id) + 1
        INTO v_max_no
        FROM dept;
        INSERT INTO dept VALUES (v_max_no, v_name, v_loc);
    END add_dept;
END over_pack;
/

EXECUTE over_pack.add_dept(10, 'Accounting', 1700);
EXECUTE over_pack.add_dept('Finance', 1700);

SELECT * FROM dept;

CREATE OR REPLACE PACKAGE taxes_pack
IS
    FUNCTION tax
        (p_value IN NUMBER) 
        RETURN NUMBER;
END taxes_pack;
/

CREATE OR REPLACE PACKAGE BODY taxes_pack
IS
    FUNCTION tax
        (p_value IN NUMBER)
        RETURN NUMBER
        IS
        v_rate NUMBER := 0.1;
    BEGIN
        RETURN (p_value * v_rate);
    END tax;
END taxes_pack;
/

SELECT taxes_pack.tax(10000) AS tax FROM dual;
SELECT last_name, salary, taxes_pack.tax(salary) AS tax 
FROM employees;

-- CURSOR
-- ��Ű�� �� CURSOR ��� �� CURSOR�� ��������� CLOSE ����� ��
-- ���ο����� ��� ������ ���� ������ �ݵ�� ���Ǳ�� Ȯ���� �� ��� �ʿ�
CREATE OR REPLACE PACKAGE pack_cur
    IS
    CURSOR emp_id_cur IS 
        SELECT employee_id
        FROM employees
        ORDER BY 1 DESC;
    PROCEDURE proc1_3rows;
    PROCEDURE proc4_6rows;
END pack_cur;
/

CREATE OR REPLACE PACKAGE BODY pack_cur
    IS
    v_empid NUMBER;
    PROCEDURE proc1_3rows
    IS 
    BEGIN
        OPEN emp_id_cur;
        LOOP
            FETCH emp_id_cur INTO v_empid;
            DBMS_OUTPUT.PUT_LINE(v_empid);
            EXIT WHEN emp_id_cur%ROWCOUNT > 2;
        END LOOP;
    END proc1_3rows;
    PROCEDURE proc4_6rows
    IS
    BEGIN
        LOOP
            FETCH emp_id_cur INTO v_empid;
            DBMS_OUTPUT.PUT_LINE(v_empid);
            EXIT WHEN emp_id_cur%ROWCOUNT > 5;
        END LOOP;
        CLOSE emp_id_cur;
    END proc4_6rows;
END pack_cur;
/

-- proc4_6rows ���� ������ �� OPEN �Ǿ����� �ʱ� ������ ���� �߻� 
EXECUTE pack_cur.proc1_3rows;
EXECUTE pack_cur.proc4_6rows;

-- TABLE, RECORD ���
CREATE OR REPLACE PACKAGE emp_package
IS
    TYPE emp_table_type IS TABLE OF employees%ROWTYPE
        INDEX BY BINARY_INTEGER;
    PROCEDURE read_emp_table
        (emp_table OUT emp_table_type);
END emp_package;
/

CREATE OR REPLACE PACKAGE BODY emp_package
IS
    PROCEDURE read_emp_table
        (emp_table OUT emp_table_type)
        IS
        i BINARY_INTEGER := 0;
        BEGIN
            FOR emp_record IN (SELECT * FROM employees) LOOP
                emp_table(i) := emp_record;
                i := i+1;
            END LOOP;
        END read_emp_table;
END emp_package;
/

DECLARE
    emp_table emp_package.emp_table_type;
BEGIN
    emp_package.read_emp_table(emp_table);
    DBMS_OUTPUT.PUT_LINE('An example : ' || emp_table(4).last_name);
END;
/