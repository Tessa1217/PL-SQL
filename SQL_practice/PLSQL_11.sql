-- EXCEPTION

-- 예외이름과 발생 환경 모두 오라클이 정의한 경우 
DECLARE
    v_lname VARCHAR2(15);
BEGIN
    SELECT last_name 
    INTO v_lname
    FROM employees
    WHERE first_name = '&name';
    DBMS_OUTPUT.PUT_LINE('John''s last name is :' || v_lname);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Your select statement retrieved multiple rows. Consider using a cursor.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data has been selected');
END;
/

-- 발생 환경만 오라클이 정의한 경우
/* 
ORA-01400: cannot insert NULL into (string)
Cause: An attempt was made to insert NULL into previously listed objects.
Action: These objects cannot accept NULL values.
*/
DECLARE
    -- 예외 이름 정의 부분
    e_insert_excep EXCEPTION;
    -- 오라클 오류와 연결해주는 함수 => PRAGMA EXCEPTION_INIT(defined exception name, exception code);
    PRAGMA EXCEPTION_INIT(e_insert_excep, -01400);
BEGIN
    INSERT INTO departments (department_id, department_name) VALUES (280, NULL);
EXCEPTION
    -- 예외 Handling
    WHEN e_insert_excep THEN
        DBMS_OUTPUT.PUT_LINE('INSERT OPERATION FAILED');
        -- ORACLE 오류 메세지 출력 (SQL Error Message)
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        -- 오류 코드의 숫자 값 반환 -1400
        DBMS_OUTPUT.PUT_LINE(SQLCODE);
END;
/

-- 사용자 정의 예외 트랩
-- 이름과 발생 환경 모두 사용자가 정의한 경우 
DECLARE
    -- 예외 이름 부분 정의
    e_invalid_department EXCEPTION;
    v_deptno NUMBER :=500;
    v_name VARCHAR2(20) :='Testing';
BEGIN
    UPDATE departments
    SET department_name = v_name
    WHERE department_id = v_deptno;
    -- RAISE 문을 통하여 예외 발생 환경 정의 => 업데이트된 행이 없을 경우 
    IF SQL%NOTFOUND THEN
        RAISE e_invalid_department;
    END IF;
EXCEPTION
    -- 예외 Handling
    WHEN e_invalid_department THEN
        DBMS_OUTPUT.PUT_LINE('There''s no such department id');
END;
/


-- 에러 처리할 로그 테이블 생성 
CREATE TABLE log_table(
    code NUMBER(10),
    message VARCHAR2(200),
    info VARCHAR2(200)
);


DECLARE
    e_toomanycomm EXCEPTION;
    v_empsal NUMBER(7);
    v_empcomm NUMBER(7);
    v_errorcode NUMBER;
    v_errortext VARCHAR2(200);
BEGIN
    SELECT salary, commission_pct * 100000
    INTO v_empsal, v_empcomm
    FROM employees
    WHERE employee_id = 114;
    IF v_empcomm > v_empsal THEN
        RAISE e_toomanycomm;
    END IF;
EXCEPTION
    WHEN e_toomanycomm THEN
        INSERT INTO log_table(info)
        VALUES ('이 사원은 보너스가 '||v_empcomm||'으로 월급여 '||v_empsal||' 보다 많습니다.');
    WHEN OTHERS THEN
        v_errorcode := SQLCODE;
        v_errortext := SUBSTR(SQLERRM, 1, 200);
        INSERT INTO log_table
        VALUES (v_errorcode, v_errortext, 'Oracle error occurred');
END;
/

SELECT * FROM log_table;

-- RAISE_APPLICATION_ERROR
-- 사용 가능한 오류 코드 범위: 20000~20999
DECLARE
    v_num NUMBER :=&num;
    v_positive_integer EXCEPTION;
    PRAGMA EXCEPTION_INIT(v_positive_integer, -20100);
BEGIN
    IF v_num <= 0 THEN
        RAISE_APPLICATION_ERROR(-20100, '양수만 입력받을 수 있습니다.');
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_num);
EXCEPTION
    WHEN v_positive_integer THEN
        DBMS_OUTPUT.PUT_LINE(SQLCODE);
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

DECLARE
    v_num NUMBER :=&num;
BEGIN
    IF v_num <= 0 THEN
        RAISE_APPLICATION_ERROR(-20100, '양수만 입력받을 수 있습니다.');
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_num);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(SQLCODE);
    WHEN OTHERS THEN
        IF SQLCODE = -20100 THEN
            DBMS_OUTPUT.PUT_LINE(SQLCODE);
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
        ELSE
            DBMS_OUTPUT.PUT_LINE('의도하지 않은 예외사항입니다.');
        END IF;
END;
/                                                                                                                                                                                                                  
