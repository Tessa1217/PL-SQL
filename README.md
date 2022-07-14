# SQL
## PL/SQL Basic Block Structure  
<p>DECLARE<p>
  <ul>
    <li>Declare variables, cursor, exceptions etc used within blocks</li>
  </ul>
<p>BEGIN <sub>(Required)</sub><p>
  <ul>
    <li>Actual query statements being processed</li>
  </ul>
<p>EXCEPTION<p>
  <ul>
    <li>Exceptions being processed</li>
  </ul>
<p>END; <sub>(Required)</sub><p>
<p>/</p>

## Types of PL/SQL Blocks
<table>
  <thead>
    <tr>
      <th>Anonymous</th>
      <th>Procedure</th>
      <th>Function</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>블록에 이름 지정하지 않은 익명의 프로시저, 재호출 불가</td>
      <td>Named procedure, 재호출 가능</td>
      <td>리턴되는 값이 있음</td>
    </tr>
  </tbody>
</table>

## Variables
<p><b>Declaring variables</b></p>
<code>IDENTIFIER [CONSTANT] DATATYPE [NOT NULL]
[:= | DEFUALT EXPRESSION];</code>
<br>
<p>Examples</p>
<ul>
  <li>v_hiredate DATE;</li>
  <li>v_deptno NUMBER(2) NOT NULL := 10;</li>
  <li>v_location VARCHAR(13) := 'Atlanta';</li>
  <li>v_comm CONSTANT NUMBER := 1400;</li>
</ul>

### Functions of Variables in PL/SQL
<ul>
  <li>데이터 임시 저장</li>
  <li>저장된 값 조작</li>
  <li>재사용</li>
  <li>유지 관리의 용이성</li>
</ul>

### Variable Types
<ol>
  <li>스칼라 데이터 유형</li>
    <ul>
      <li>내부 구성 요소 없이 숫자, 문자, 날짜, 불린 등 네 가지 범주로 분류하는 **단일 값** 형태의 데이터</li>
      <li>기본 데이터 유형은 ORACLE SERVER 테이블의 열 유형과 일치</li>
      <li><b>BOOLEAN(불린) 타입 지원</b> => TRUE, FALSE, NULL</li>
      <li><b>%TYPE</b> => 데이터베이스 열 정의 또는 이전에 선언한 다른 변수 사용</li>
  </ul>
  <li>조합 데이터 유형</li>
    <ul>
      <li>피드 그룹을 정의하고 조작 가능</li>
      <li><b>RECORD</b></li>
        <ul>
          <li>필드라고 불리는 PL/SQL 테이블, 레코드, 임의의 스칼라 데이터 유형 중 하나 이상의 구성 요소 포함하는 조합 데이터 유형</li>
          <li>레코드 생성하려면 레코드 유형 정의 후 해당 유형의 레코드 선언</li>
          <li><b>%ROWTYPE</b> => 한 행을 단위로 하여 데이터베이스 테이블 또는 뷰의 열 모음에 따라 변수를 선언</li>
      </ul>
  </ul>
  <li>참조 데이터 유형</li>
    <ul>
      <li>다른 프로그램 항목을 지정하는 값(포인트) 보유</li>
  </ul>
  <li>LOB(대형 객체) 데이터 유형</li>
  <ul>
    <li>한 행을 초과하여 저장되는 대형 객체의 위치 지정값 보유</li>
  </ul>
</ol>

## Cursor

### Types of Cursor
<h5>Implicit Cursor(암시적 커서)</h5>
<ul>
  <li>하나의 행만 반환하는 질의를 포함</li>
  <li>모든 DML, PL/SQL SELECT 문에 대해 PL/SQL에서 암시적으로 선언</li>
</ul>
<h5>Explicit Cursor(명시적 커서)</h5>
<ul>
  <li>둘 이상의 해을 반환하는 질의에 대해 선언</li>
  <li>직접 선언하여 이름 지정 필요(named)</li>
  <li>블록의 실행 가능한 작업에 있는 특정 명령문 통하여 조작</li>
  <li>다중행 SELECT 문에 의해 반환된 각 행을 개별적으로 처리할 때 사용 용이</li>
  <li>Active Set(활성 집합) => 다중 행 질의에 의해 반환되는 행 집합</li>
  <li>명시적 커서의 기능</li>
  <ul>
    <li>현재 처리되고 있는 행 추적</li>
    <li>PL/SQL 블록에서 수동 제어 가능</li>
  </ul>
</ul>

### Explicit Cursor
<pre>
수동 제어
  DECLARE  
    - 커서 선언, SQL 영역 생성
    - INTO 절 필요 없음 
  OPEN  
    - 활성 집합 식별
    - 반환되는 행 없어도 예외 사항 발생하지 않음
  FETCH  
    - 커서에서 데이터 인출
    - 현재 행을 변수에 로드
    - EMPTY? - 기존 행 테스트, 행이 있으면 FETCH로 돌아감
  CLOSE  
    - 활성 집합 해제
</pre>
<pre>
FOR LOOP
- 명시적 커서를 처리하기 위한 단축 방법으로 열기, 인출, 닫기가 암시적으로 발생
- 커서의 자동 조작
- 수동으로 조작이 필요한 경우에는 반드시 명시적으로 해당 과정을 제어하는 수동 제어 방식으로 사용 필요
FOR record_name IN cursor_name LOOP
  statement1;
  statement2;
END LOOP;
</pre>

### Cursor Attributes
<ul>
  <li><b>%ISOPEN</b>: Always has the value of FALSE</li>
  <li><b>%FOUND</b>: SELECT or DML statement returned a row then TRUE, if not returned then FALSE</li>
  <li><b>%NOTFOUND</b>: SELECT or DML statement returned a row then FALSE, if not returned then TRUE</li>
  <li><b>%ROWCOUNT</b>: SELECT or DML statement has run, the number of rows fetched so far</li>
</ul>

### Cursor Parameter
<code>
  CURSOR cursor_name[parameter_name, datatype, ...]
  IS
  SELECT_STATEMENT
    WHERE parameter_name
 </code>

### Exceptions

