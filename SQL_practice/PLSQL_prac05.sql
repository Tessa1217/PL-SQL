/* 
1. �μ� ��ȣ �Է� �� �ش� �μ��� �ٹ��ϴ� ����� �����ȣ, �̸� ����ϴ� ���ν��� ���, 
��, ����� ���� ��쿡�� �޽��� ����ϴ� ���� ó��
*/

CREATE OR REPLACE PROCEDURE get_emp
    (v_dept_id IN NUMBER)
    IS
    CURSOR emp_check IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id = v_dept_id;
    no_emp EXCEPTION;
    emp_record emp_check%ROWTYPE;
BEGIN
    IF NOT emp_check%ISOPEN THEN
        OPEN emp_check;
   END IF;
   LOOP
        FETCH emp_check INTO emp_record;
        EXIT WHEN emp_check%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('��� ��ȣ: '|| emp_record.employee_id||' ��� �̸�: '||emp_record.last_name);
   END LOOP;
   IF emp_check%ROWCOUNT = 0 THEN
        RAISE no_emp;
    END IF;
    CLOSE emp_check;
EXCEPTION
    WHEN no_emp THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ����� ����� �����ϴ�.');
END;
/

EXECUTE get_emp(60);

/*
2. �������� ���, �޿� ����ġ�� �Է��ϸ� ���̺� ���� ����� �޿��� ������ �� �ִ� ���ν��� �ۼ�
�Է��� ��� ������ �޽��� ���
*/

CREATE OR REPLACE PROCEDURE sal_update
    (v_id IN NUMBER, 
    v_sal_percent IN NUMBER)
    IS
    no_emp EXCEPTION;
BEGIN
    UPDATE employees 
    SET salary = salary * (100 + v_sal_percent)/100
    WHERE employee_id = v_id;
    IF SQL%NOTFOUND THEN
        RAISE no_emp;
    END IF;
EXCEPTION
    WHEN no_emp THEN
        DBMS_OUTPUT.PUT_LINE('No searched employee!');
END;
/

EXECUTE sal_update(114, 10);

/* 
3. ���ڸ� �Է��� ��� �Էµ� ���ڱ����� ������ �հ踦 ����ϴ� �Լ� �ۼ�
*/
CREATE OR REPLACE FUNCTION sum_calculator
    (v_num IN NUMBER)
    RETURN NUMBER
    IS
    v_sum NUMBER :=0;
BEGIN
    FOR i IN 1..v_num LOOP
        v_sum := v_sum + i;
    END LOOP;
    RETURN v_sum;
END;
/

EXECUTE DBMS_OUTPUT.PUT_LINE(sum_calculator(10));

SELECT sum_calculator(10) FROM dual;


/* 
4.�����ȣ�� �Է��� ��� ���� ������ �����ϴ� ����� ��µǴ� �Լ� �ۼ�
*/
CREATE OR REPLACE FUNCTION income_calculator
    (v_emp_id IN employees.employee_id%TYPE)
    RETURN NUMBER
    IS
    v_inc_sal NUMBER;
BEGIN
    SELECT salary 
    INTO v_inc_sal
    FROM employees 
    WHERE employee_id = v_emp_id;
    IF v_inc_sal <= 5000 THEN
        v_inc_sal := v_inc_sal * 1.2;
    ELSIF v_inc_sal <= 10000 THEN
        v_inc_sal := v_inc_sal * 1.15;
    ELSIF v_inc_sal <= 20000 THEN
        v_inc_sal := v_inc_sal * 1.1;
    END IF;
    RETURN v_inc_sal;
END;
/
 
 SELECT last_name, salary, income_calculator(employee_id) AS increased_salary
 FROM employees;

/* 
5. ��� ��ȣ�� �Է��ϸ� �ش� ����� ������ ��µǴ� �Լ��� �����Ͻÿ�
*/
CREATE OR REPLACE FUNCTION annual_calc
    (v_id IN employees.employee_id%TYPE)
    RETURN NUMBER
    IS
    v_sal employees.salary%TYPE;
    v_comm employees.commission_pct%TYPE;
BEGIN
    SELECT salary, NVL(commission_pct, 0)
    INTO v_sal, v_comm
    FROM employees
    WHERE employee_id = v_id;
    RETURN (v_sal + (v_sal * v_comm)) * 12;
END;
/

SELECT last_name, salary, annual_calc(employee_id) AS annual_salary
FROM employees;

/* 
5. subname(last_name) �Լ�
*/

CREATE OR REPLACE FUNCTION subname
    (v_name employees.last_name%TYPE)
    RETURN VARCHAR2
    IS
    v_subname VARCHAR2(100);
BEGIN
    v_subname := RPAD(SUBSTR(v_name, 1, 1), LENGTH(v_name) , '*');
    RETURN v_subname;
END;
/

SELECT last_name, subname(last_name)
FROM employees;

