/* 
���ڵ�(RECORD)
*/

SET SERVEROUTPUT ON;

DESC departments;
SELECT * FROM departments;


DECLARE
    -- ����
    TYPE dept_record_type IS RECORD 
    (
        -- �ʵ� Ÿ��
        -- ������ �ʵ� ���� �������� �׼���
        -- ���ڵ忡 �� �Ҵ��� SELECT, �Ǵ� FETCH ���� ����Ͽ� ���ڵ忡 �Ϲ� �� �Ҵ� ����
    deptid departments.department_id%TYPE,
    deptname departments.department_name%TYPE,
    loc departments.location_id%TYPE
    );
    -- ������ ������ �� ���
    dept_record dept_record_type;
BEGIN
    SELECT department_id, department_name, location_id
    INTO dept_record
    FROM departments
    WHERE department_id = &deptno;
    DBMS_OUTPUT.PUT_LINE(dept_record.deptid);
    DBMS_OUTPUT.PUT_LINE(dept_record.deptname);
    DBMS_OUTPUT.PUT_LINE(dept_record.loc);
END;
/

-- %ROWTYPE
-- �� ���� ������ ��, �����ͺ��̽� ���̺� �Ǵ� ���� �� ������ ���� ���� ����
-- ���ڵ� �ʵ��� �̸��� ������ ������ ���̺� �Ǵ� �信�� ������ ��
DECLARE
    dept_record departments%ROWTYPE;
BEGIN

--    ��ü ���� �� ��ȸ
--    SELECT *
--    INTO dept_record
--    FROM departments
--    WHERE department_id = &deptno;

    -- FIELD�� �̿��� ����
    SELECT department_id, department_name, location_id
    INTO dept_record.department_id, dept_record.department_name, dept_record.location_id
    FROM departments
    WHERE department_id = &deptno;
    DBMS_OUTPUT.PUT_LINE(dept_record.department_id);
    DBMS_OUTPUT.PUT_LINE(dept_record.department_name);
    DBMS_OUTPUT.PUT_LINE(dept_record.location_id);
    
END;
/

DESC departments;