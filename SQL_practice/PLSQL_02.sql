-- ȣ��Ʈ ȯ�濡�� ���� ����

SET SERVEROUTPUT ON;

-- variable ��� 
VARIABLE g_monthly_sal NUMBER;

ACCEPT p_annual_sal PROMPT 'Please enter the annual salary:';

DECLARE
    v_sal NUMBER(9, 2) :=&p_annual_sal;
BEGIN
    -- �ܺο��� ������ ������ ��� : ��� �ʿ� 
    :g_monthly_sal := v_sal / 12;
    DBMS_OUTPUT.PUT_LINE(:g_monthly_sal);
END;
/

