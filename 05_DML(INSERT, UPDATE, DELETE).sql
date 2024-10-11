-- ** DML (Data Manipulation Language) : 데이터 조작 언어 **

-- 테이블에 값을 삽입(INSERT)하거나, 수정(UPDATE)하거나, 삭제(DELETE)하는 구문

-- 주의사항 : 혼자서 COMMIT, ROLLBACK을 하지 말 것!
-- 윈도우 - 설정 - 연결 - 연결유형 : Auto commit by dafault 체크 해제되었는지 확인!

-- 테스트용 테이블 생성
CREATE TABLE EMPLOYEE2 AS SELECT * FROM EMPLOYEE;
CREATE TABLE DEPARTMENT2 AS SELECT * FROM DEPARTMENT;	
-- 확인하려면 Database Navigator 부분 누르고 F5

SELECT * FROM EMPLOYEE2;
SELECT * FROM DEPARTMENT2;

------------------------------------------------------------------------
-- 1. INSERT : 테이블에 새로운 행을 추가하는 구문

-- 1) INSERT INTO 테이블명 VALUES(데이터, 데이터, 데이터, ...);
-- 테이블에 있는 모든 컬럼에 대한 값을 INSERT 할 때 사용
-- INSERT 하고자 하는 컬럼이 모든 컬림인 경우에 컬러명 생략 가능
-- 단, 컬럼의 순서를 지켜서 VALUES에 값을 기입해야 함!!

INSERT INTO EMPLOYEE2 VALUES('900', '홍길동', '900101-1234567', 'hong_gd@or.kr', '01012345678', 'D1', 'J7', 'S3', 4300000, 0.2, 200, SYSDATE, NULL, 'N');
-- 맨 마지막에 'N'대신 DEFAULT 넣어도 됨!(현재 마지막열의 DEFAULT값이 'N'임)

SELECT * FROM EMPLOYEE2
WHERE EMP_ID = '900';

ROLLBACK;


-- 2) INSERT INTO 테이블명(컬럼명1, 컬럼명2, 컬럼명3, ...)
--					VALUES(데이터1, 데이터2, 데이터3, ...);
-- 테이블에 내가 선택한 컬럼에 대한 값만 INSERT할 때 사용
-- 선택 안 된 컬럼은 값이 NULL로 들어감 (DEFAULT 존재 시 DEFAULT로 설정한 값으로 삽입)
-- 단 현재 복제본에는 ENT_YN에 관한 DEFAULT 값이 없으므로 값 작성 안하면 NULL로 들어감!
INSERT INTO EMPLOYEE2 (EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY)
VALUES ('900', '홍길동', '900101-1234567', 'hong_gd@or.kr', '01012345678', 'D1', 'J7', 'S3', 4300000);

SELECT * FROM EMPLOYEE2
WHERE EMP_ID = '900';

COMMIT;		-- 홍길동 데이터 영구저장함

ROLLBACK;	-- 되돌려보려고 ROLLBACK 수행

SELECT * FROM EMPLOYEE2;	-- 그리고 EMPLOYEE2 조회하면 홍길동 남아있음!
-- 영구저장 되어있으므로 롤백된다 하더라도 되돌리기 안됨!

--------------------------------------------------------------------------------
-- INSERT 시 VALUES 대신 서브쿼리 사용 가능(테이블 만드는 정석적인 방법)
CREATE TABLE EMP_01(
	EMP_ID NUMBER,
	EMP_NAME VARCHAR2(30),
	DEPT_TITLE VARCHAR2(20)
);

SELECT * FROM EMP_01;

SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE2
LEFT JOIN DEPARTMENT2 ON (DEPT_CODE = DEPT_ID);

-- 서브쿼리를 이용하여 데이터 추가하는 방법
-- 서브쿼리 결과(SELECT)를 EMP_01 테이블에 INSERT 시
--> SELECT한 조회 결과의 데이터 타입, 컬럼의 개수가 
--  INSERT 하려는 테이블의 컬럼과 일치해야함!
INSERT INTO EMP_01(
	SELECT EMP_ID, EMP_NAME, DEPT_TITLE
	FROM EMPLOYEE2
	LEFT JOIN DEPARTMENT2 ON (DEPT_CODE = DEPT_ID)
);

SELECT * FROM EMP_01;

--------------------------------------------------------------------------------
-- 2. UPDATE : 내용을 바꾸던가 추가해서 최신화하는 것
-- 테이블에 기록된 컬럼의 값을 수정하는 구문

-- [작성법]
/*
 * UPDATE 테이블명 SET 컬럼명 = 바꿀값
 * [WHERE 컬럼명 비교연산자 비교값];
 * --> WHERE 조건 중요!
 * */

------------------------------------------------------------------------------------
SELECT * FROM DEPARTMENT2;

-- DEPARTMENT2 테이블에서 DEPT_ID가 'D9'인 부서 정보 조회
SELECT * FROM DEPARTMENT2
WHERE DEPT_ID = 'D9';

-- DEPARTMENT2 테이블에서 DEPT_ID가 'D9'인 부서의 DEPT_TITLE을 '전략기획팀'으로 수정
UPDATE DEPARTMENT2 SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9';

-- DEPARTMENT2 테이블에서 DEPT_ID가 'D9'의 변경된 정보 확인
SELECT * FROM DEPARTMENT2
WHERE DEPT_ID = 'D9';


SELECT * FROM EMPLOYEE2;
-- EMPLOYEE2 테이블에서 BONUS를 받지않는 사원의 BONUS를 0.1로 변경
UPDATE EMPLOYEE2 SET BONUS = 0.1
WHERE BONUS IS NULL;	-- 15개 행 수정

SELECT EMP_ID, EMP_NAME, BONUS FROM EMPLOYEE2;

-----------------------------------------------------------
SELECT * FROM DEPARTMENT2;
-- * 조건절을 설정하지 않고 UPDATE 구문 실행 시, 모든 행의 컬럼값이 변경 *
UPDATE DEPARTMENT2 SET DEPT_TITLE = '기술연구팀';

ROLLBACK;
-------------------------------------------------------------------
-- * 여러 컬럼을 한 번에 수정할 시 콤마(,)로 컬럼을 구분하면 됨
-- D9 / 총무부 -> D0 / 전력기획팀 으로 수정하려는 경우
UPDATE DEPARTMENT2 
SET DEPT_ID ='D0', DEPT_TITLE = '전력기획팀'	-- WHERE절 직전 컬럼 작성시 콤마 X
WHERE DEPT_ID = 'D9' AND DEPT_TITLE ='총무부';

-----------------------------------------------------------------------------------------
SELECT EMP_NAME, SALARY, BONUS FROM EMPLOYEE2
WHERE EMP_NAME IN ('유재식', '방명수');
-- * UPDATE 시에도 서브쿼리 사용 가능

-- [작성법]
-- UPDATE 테이블명 SET
-- 컬럼명 = (서브쿼리)

-- EMPLOYEE2 테이블에서 방명수 사원의 급여와 보너스율을
-- 유재식 사원과 동일하게 변경하려는 경우

-- 유재식의 급여와 보너스율
SELECT SALARY, BONUS FROM EMPLOYEE2
WHERE EMP_NAME = '유재식';

-- 방명수 급여와 보너스율 수정
UPDATE EMPLOYEE2 
SET SALARY = (SELECT SALARY FROM EMPLOYEE2 WHERE EMP_NAME = '유재식'),
BONUS = (SELECT BONUS FROM EMPLOYEE2 WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

SELECT EMP_NAME, SALARY, BONUS FROM EMPLOYEE2
WHERE EMP_NAME IN ('유재식', '방명수');

------------------------------------------------------------------
-- 3. MERGE (병합)
-- 구조가 같은 2개의 테이블을 하나로 합치는 기능
-- 테이블에서 지정하는 조건의 값이 존재하면 UPDATE
-- 없으면 INSERT 됨

CREATE TABLE EMP_M01 AS SELECT * FROM EMPLOYEE;

CREATE TABLE EMP_M02 AS SELECT * FROM EMPLOYEE
WHERE JOB_CODE = 'J4';

SELECT * FROM EMP_M01;	-- 23명
SELECT * FROM EMP_M02;	-- 4명(EMP_M01에 있는 4명과 이름 동일)

INSERT INTO EMP_M02
VALUES(999, '곽두원', '561016-1234567', 'kwack_dw@kh.or.kr', '01011112222', 'D9', 'J4', 'S1', 9000000, 0.5, NULL, SYSDATE, NULL, DEFAULT);

SELECT * FROM EMP_M02;	-- 5명(1명 추가!!)

UPDATE EMP_M02 SET SALARY = 0;

SELECT * FROM EMP_M02;	-- 5명의 SALARY = 0

-- MERGE 구문.... EMP_ID가 같은 4명은 SALARY 컬럼 UPDATE, 새로 추가된 곽두원은 CREATE
MERGE INTO EMP_M01 USING EMP_M02 ON(EMP_M01.EMP_ID = EMP_M02.EMP_ID)
WHEN MATCHED THEN
UPDATE SET
  EMP_M01.EMP_NAME = EMP_M02.EMP_NAME,
  EMP_M01.EMP_NO = EMP_M02.EMP_NO,
  EMP_M01.EMAIL = EMP_M02.EMAIL,
  EMP_M01.PHONE = EMP_M02.PHONE,
  EMP_M01.DEPT_CODE = EMP_M02.DEPT_CODE,
  EMP_M01.JOB_CODE = EMP_M02.JOB_CODE,
  EMP_M01.SAL_LEVEL = EMP_M02.SAL_LEVEL,
  EMP_M01.SALARY = EMP_M02.SALARY,
  EMP_M01.BONUS = EMP_M02.BONUS,
  EMP_M01.MANAGER_ID = EMP_M02.MANAGER_ID,
  EMP_M01.HIRE_DATE = EMP_M02.HIRE_DATE,
  EMP_M01.ENT_DATE = EMP_M02.ENT_DATE,
  EMP_M01.ENT_YN = EMP_M02.ENT_YN
WHEN NOT MATCHED THEN
INSERT VALUES(EMP_M02.EMP_ID, EMP_M02.EMP_NAME, EMP_M02.EMP_NO, EMP_M02.EMAIL,
           EMP_M02.PHONE, EMP_M02.DEPT_CODE, EMP_M02.JOB_CODE, EMP_M02.SAL_LEVEL, EMP_M02.SALARY, EMP_M02.BONUS, EMP_M02.MANAGER_ID, EMP_M02.HIRE_DATE,
           EMP_M02.ENT_DATE, EMP_M02.ENT_YN);


SELECT * FROM EMP_M01;
----------------------------------------------------------------------------------------------
-- 4. DELETE : 테이블의 행을 삭제하는 구문
-- [작성법]
-- DELETE FROM 테이블명 WHERE 조건설정;
-- 만약에 WHERE 조건을 설정하지 않으면 모든행이 다 삭제됨

COMMIT;

SELECT * FROM EMPLOYEE2
WHERE EMP_NAME = '홍길동';

-- 홍길동 삭제해보기
DELETE FROM EMPLOYEE2 
WHERE EMP_NAME = '홍길동';

-- 삭제 확인, 아래 구문 실행하면 안나옴!
SELECT * FROM EMPLOYEE2
WHERE EMP_NAME = '홍길동';

-- 삭제구문 롤백해보기! 이후 다시 바로 위 구문 실행하면 홍길동 살아남!
ROLLBACK;	-- 마지막 커밋시점까지 돌아감

-- 다시 실행하면 홍길동에 관한 정보가 다시 나옴!
SELECT * FROM EMPLOYEE2
WHERE EMP_NAME = '홍길동';

-- EMPLOYEE2 테이블 전체 삭제, 실행 시 24개행 삭제!
DELETE FROM EMPLOYEE2;

-- EMPLOYEE2 전체 삭제되었는지 확인
SELECT * FROM EMPLOYEE2;

-- 다시 되돌리기
ROLLBACK;

-- EMPLOYEE2 돌아왔는지 확인
SELECT * FROM EMPLOYEE2;

-----------------------------------------------------------------------------
-- 5. TRUNCATE (DML이 아니라 DDL 임!)
-- 테이블의 전체 행을 삭제하는 DDL(Data Definition Language), 자동으로 커밋됨
-- DELETE 보다 수행속도가 더 빠르다!(WHERE 절 없음)
-- ROLLBACK 을 통해 복구할 수 없음!!!!

-- TRUNCATE 테스트용 테이블 생성
-- CREATE도 DDL 임!
CREATE TABLE EMPLOYEE3 AS SELECT * FROM EMPLOYEE2;

-- 생성확인
SELECT * FROM EMPLOYEE3;

-- TRUNCATE 로 삭제
TRUNCATE TABLE EMPLOYEE3;

-- 삭제되었는지 확인
SELECT * FROM EMPLOYEE3;

-- ROLLBACK으로 복구되는지 확인 -> 복구되지 않음!!!!
ROLLBACK;
SELECT * FROM EMPLOYEE3;

-- 컴퓨터에 비유하는 경우
-- DELETE : 휴지통에 버리기
-- TRUNCATE : 완전 삭제





