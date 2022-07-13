CREATE TABLE EMP_TEST
AS SELECT employee_id, last_name
FROM employees
WHERE employee_id < 200;

SELECT * FROM emp_test;

/* �����ȣ�� ����Ͽ� ����� ����, ����� ������ 
 ����� ���� ���ܻ��� ����Ͽ� �ش� ����� �����ϴ�  ��� ���� �޽��� �߻� */
DECLARE
    v_no_employee EXCEPTION;
BEGIN
    DELETE FROM emp_test
    WHERE employee_id = &empId; 
    IF SQL%NOTFOUND THEN
        RAISE v_no_employee;
    ELSE 
        DBMS_OUTPUT.PUT_LINE('��� ������ �����߽��ϴ�.');
    END IF;
EXCEPTION
    WHEN v_no_employee THEN
        DBMS_OUTPUT.PUT_LINE('�ش� ����� �����ϴ�');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLCODE);
END;
/

/* 
��� ���̺��� �����ȣ�� �Է� �޾� 10% �λ�� �޿��� ����
�� 2000�� ���� �Ի��� ����� �������� �ʰ� �޼��� ���
*/
DECLARE
    v_hire_late EXCEPTION;
    v_emp_id employees.employee_id%TYPE :=&empId;
    v_hire_date employees.hire_date%TYPE;
BEGIN
    SELECT hire_date
    INTO v_hire_date
    FROM employees
    WHERE employee_id = v_emp_id;
    IF v_hire_date > '2000/12/31' THEN
        RAISE v_hire_late;
    ELSE 
        UPDATE employees
        SET salary = salary * 1.1
        WHERE employee_id = v_emp_id;
        IF SQL%FOUND THEN
            DBMS_OUTPUT.PUT_LINE(v_emp_id ||'�� ����� �޿��� �����Ǿ����ϴ�.');
        END IF;
    END IF;
EXCEPTION
    WHEN v_hire_late THEN
        DBMS_OUTPUT.PUT_LINE('2000�� ���� �Ի��� ����Դϴ�.');
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE(v_emp_id ||'�� ���� �����ȣ�Դϴ�.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

DECLARE
    v_hire_late EXCEPTION;
    v_emp_id employees.employee_id%TYPE :=&empId;
    v_hire_date employees.hire_date%TYPE;
BEGIN
    -- �Է¹��� �����ȣ�� �̿��ؼ� �Ի��� ��ȸ
    SELECT hire_date
    INTO v_hire_date
    FROM employees
    WHERE employee_id = v_emp_id;
    IF v_hire_date > '2000/12/31' THEN
        RAISE v_hire_late;
    END IF;
    -- ��� �Ի����� 2000�� ������ ��쿡 ����� ���� ����
    UPDATE employees
    SET salary = salary * 1.1
    WHERE employee_id = v_emp_id;
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE(v_emp_id ||'�� ����� �޿��� �����Ǿ����ϴ�.');   
    END IF;
EXCEPTION
    WHEN v_hire_late THEN
        DBMS_OUTPUT.PUT_LINE('2000�� ���� �Ի��� ����Դϴ�.');
    WHEN no_data_found THEN
        DBMS_OUTPUT.PUT_LINE(v_emp_id ||'�� ���� �����ȣ�Դϴ�.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- CURSOR
DECLARE
    CURSOR emp_cursor IS
        SELECT *
        FROM employees
        WHERE department_id = &deptid
        FOR UPDATE OF salary;
    emp_hiredate EXCEPTION;
BEGIN
    FOR emp_record IN emp_cursor LOOP
        IF emp_record.hire_date > '2000/12/31' THEN
            RAISE emp_hiredate;
        ELSE
            UPDATE employees
            SET salary = salary * 1.1
            WHERE CURRENT OF emp_cursor;
            IF emp_cursor%FOUND THEN
                DBMS_OUTPUT.PUT_LINE('������Ʈ �Ǿ����ϴ�.');
            END IF;
        END IF;
    END LOOP; 
EXCEPTION
    WHEN emp_hiredate THEN
        DBMS_OUTPUT.PUT_LINE('2000�� ���� �Ի��� ����� ���ŵ��� �ʽ��ϴ�.');
END;
/

SELECT * FROM employees WHERE department_id = 100;