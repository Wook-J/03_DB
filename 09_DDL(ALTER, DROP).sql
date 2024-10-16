-- DDL(Date Definition Language)
-- 객체를 만들고(CREATE), 바꾸고(ALTER), 삭제(DROP)하는 데이터 정의 언어

/*
 * ALTER(바꾸다, 수정하다, 변조하다)
 *
 * -- (객체 중) 테이블에서 수정할 수 있는 것
 * 1) 제약 조건(추가/삭제)
 * 2) 컬럼(추가/수정/삭제)
 * 3) 이름변경 (테이블명, 컬럼명..)
 *
 * */

-- 1. 제약조건(추가/삭제)--

-- [작성법]
-- 1-1) 추가 : ALTER TABLE 테이블명
--          ADD [CONSTRAINT 제약조건명] 제약조건(지정할컬럼명)
--          [REFERENCES 테이블명[(컬럼명)]]; <-- FK 인 경우 추가

-- 1-2) 삭제 : ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;

-- * 제약조건 자체를 수정하는 구문은 별도 존재하지 않음!
--> 삭제 후 추가를 해야함.


-- DEPARTMENT 테이블 복사(컬럼명, 데이터타입, NOT NULL 제약조건 만 복사됨)
CREATE TABLE DEPT_COPY AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;


-- DEPT_COPY의 DEPT_TITLE 컬럼에 UNIQUE 추가
ALTER TABLE DEPT_COPY ADD CONSTRAINT DEPT_COPY_TITLE_U UNIQUE(DEPT_TITLE);

-- DEPT_COPY의 DEPT_TITLE 컬럼에 UNIQUE 삭제
ALTER TABLE DEPT_COPY DROP CONSTRAINT DEPT_COPY_TITLE_U;


-- ** DEPT_COPY의 DEPT_TITLE 컬럼에 NOT NULL 제약조건 추가/삭제 **
ALTER TABLE DEPT_COPY ADD CONSTRAINT DEPT_COPY_TITLE_NN NOT NULL(DEPT_TITLE);
-- SQL Error [904] [42000]: ORA-00904: : 부적합한 식별자
--> NOT NULL 제약조건은 새로운 조건을 추가하는 것이 아닌
--  컬럼 자체에 NULL 허용/비허용을 제어하는 성질 변경의 형태로 인식됨

-- NOT NULL 제약조건은 MODIFY(수정하다) 구문을 사용해서 NULL 제어
--> DEPT_TITLE 컬럼에 NULL 비허용
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE NOT NULL;

--DEPT_TITLE 컬럼에 NULL을 허용하려는 경우
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE NULL;

-------------------------------------------------------------------------------------------

-- 2. 컬럼(추가/수정/삭제)

-- 컬럼 추가
-- ALTER TABLE 테이블명 ADD(컬럼명 데이터타입 [DEFAULT '값']);

-- 컬럼 수정
-- ALTER TABLE 테이블명 MODIFY 컬럼명 데이터타입; --> 데이터 타입 변경
-- ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT '값'; --> DEFAULT 값 변경

-- 컬럼 삭제
-- ALTER TABLE 테이블명 DROP (삭제할컬럼명);
-- ALTER TABLE 테이블명 DROP COLUMN 삭제할컬럼명;

SELECT * FROM DEPT_COPY;

-- CNAME 컬럼 추가
ALTER TABLE DEPT_COPY ADD(CNAME VARCHAR2(30)); 
SELECT * FROM DEPT_COPY;

-- LNAME 컬럼 추가 (기본값 '한국')
ALTER TABLE DEPT_COPY ADD(LNAME VARCHAR2(30) DEFAULT '한국');
SELECT * FROM DEPT_COPY;
-- 컬럼시 생성되면서 DEFAULT 값이 자동으로 삽입되었음!


-- D10 개발1팀 추가
INSERT INTO DEPT_COPY VALUES ('D10', '개발1팀', 'L1', DEFAULT, DEFAULT);
-- SQL Error [12899] [72000]: ORA-12899: "KH_JWJ"."DEPT_COPY"."DEPT_ID" 열에 대한 값이 너무 큼(실제: 3, 최대값: 2)
-- 현재 DEPT_ID의 데이터 타입 CHAR(2) -> 고정길이로 2BYTE까지만 저장 가능!
-- 넣으려고 했던 D10은 CHAR(3)에 들어올 수 있음
--> VARCHAR2(3)으로 변경해보기!! (남는 BYTE 매모리 반환을 위해)

-- DEPT_ID 컬럼의 데이터 타입 수정
ALTER TABLE DEPT_COPY MODIFY DEPT_ID VARCHAR2(3);

-- 수정 후 D10 개발1팀 추가
INSERT INTO DEPT_COPY VALUES ('D10', '개발1팀', 'L1', DEFAULT, DEFAULT);
SELECT * FROM DEPT_COPY;


-- LNAME의 DEFAULT 를 'KOREA'로 수정
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT 'KOREA';

SELECT * FROM DEPT_COPY;
-- 조회해도 LNAME에 있는 값은 여전히 한국
--> ** DEFAULT 를 변경했다고 해서 기존 데이터가 변하지는 않음!! **

-- LNAME '한국' -> 'KOREA' 변경/ DML 중 UPDATE 사용!!!!
UPDATE DEPT_COPY SET LNAME = DEFAULT 
WHERE LNAME = '한국';

SELECT * FROM DEPT_COPY;

COMMIT;


-- DEPT_COPY 테이블의 모든 컬럼 삭제
ALTER TABLE DEPT_COPY DROP(LNAME);
SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY DROP COLUMN CNAME;
SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID;
SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY DROP COLUMN DEPT_TITLE;
SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID;
-- SQL Error [12983] [72000]: ORA-12983: 테이블에 모든 열들을 삭제할 수 없습니다

-- 컬럼 삭제 시 유의사항!
-- 테이블이란? 행과 열로 이루어진 DB의 가장 기본적인 객체
--> 테이블에는 최소 1개 이상의 컬럼이 존재해야하므로, 모든 컬럼을 다 삭제할 수는 없음

-- 모든 컬럼을 없애려는 경우에는 테이블 자체를 삭제하면 됨!
DROP TABLE DEPT_COPY;


-- DEPARTMENT 테이블 복사해서 DEPT_COPY 생성
CREATE TABLE DEPT_COPY AS SELECT * FROM DEPARTMENT;
--> 컬럼명, 데이터타입, NOT NULL 여부만 복사


-- DEPT_COPY 테이블에 PK 추가(컬럼명 : DEPT_ID, 제약조건명 : D_COPY_PK)
ALTER TABLE DEPT_COPY ADD CONSTRAINT D_COPY_PK PRIMARY KEY(DEPT_ID);

----------------------------------------------------------------------------------

-- 3. 이름 변경(컬럼명, 테이블명, 제약조건명)

-- 1) 컬럼명 변경 (DEPT_TITLE -> DEPT_NAME)
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;
SELECT * FROM DEPT_COPY;

-- 2) 제약조건명 변경 (D_COPY_PK -> DEPT_COPY_PK)
ALTER TABLE DEPT_COPY RENAME CONSTRAINT D_COPY_PK TO DEPT_COPY_PK;

-- 3) 테이블명 변경 (DEPT_COPY -> DCOPY)
ALTER TABLE DEPT_COPY RENAME TO DCOPY;

-- SQL Error [942] [42000]: ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
SELECT * FROM DEPT_COPY;

-- 변경된 테이블명으로 조회!!
SELECT * FROM DCOPY;


--------------------------------------------------------------------------------------------------------------

-- 4. 테이블 삭제

-- DROP TABLE 테이블명 [CASCADE CONSTRAINTS];

-- 1) 다른 테이블과 관계가 형성되지 않은 테이블 삭제
DROP TABLE DCOPY;

-- 2) 다른 테이블과 관계가 형성된 테이블 삭제
CREATE TABLE TB1(
	TB1_PK NUMBER PRIMARY KEY,
	TB1_COL NUMBER
);	-- 부모 테이블

CREATE TABLE TB2(
	TB2_PK NUMBER PRIMARY KEY,
	TB2_COL NUMBER REFERENCES TB1
);	-- 자식 테이블

-- TB1에 샘플 데이터 삽입
INSERT INTO TB1 VALUES(1, 100);
INSERT INTO TB1 VALUES(2, 200);
INSERT INTO TB1 VALUES(3, 300);

-- TML(INSERT, UPDATE, DELETE, MERGE) 의 경우 COMMIT 해야 영구저장됨
COMMIT;

-- TB2에 샘플데이터 삽입(2열에는 부모테이블의 PRIMARY KEY만 넣을 수 있음!)
INSERT INTO TB2 VALUES(11, 1);
INSERT INTO TB2 VALUES(12, 2);
INSERT INTO TB2 VALUES(13, 3);

-- TB1 과 TB2 는 부모-자식 테이블 관계 형성
SELECT * FROM TB2;

-- 부모인 TB1 테이블을 삭제하려는 경우
DROP TABLE TB1;
-- SQL Error [2449] [72000]: ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다
-- 해결방법
-- 1) 자식 테이블을 먼저 삭제하고, 부모 테이블을 삭제
-- 2) ALTER 를 이용해서 FOREIGN KEY 제약조건 삭제 후, 부모 테이블을 삭제
-- 3) DROP TABLE 삭제옵션인 CASCADE CONSTRAINTS 사용!
      --> CASCADE CONSTRAINTS : 삭제하려는 테이블과 연결된 FK 제약조건을 모두 삭제

-- 테이블 삭제 시 FK 관계도 모두 삭제
DROP TABLE TB1 CASCADE CONSTRAINTS;

-- SQL Error [942] [42000]: ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
SELECT * FROM TB1;

-- TB2는 이제 다른 테이블과 아무런 관계 없이 남게 됨!!
SELECT * FROM TB2;

-----------------------------------------------------------------------------------------------------

/* DDL(CREATE, ALTER, DROP) 주의 사항 */

-- 1) DDL은 COMMIT/ROLLBACK 이 되지 않는다. 트랜젝션에 있지 않고 DB에 바로 반영됨

-- 2) DDL과 DML 구문을 섞어서 수행하면 안된다!
--  DDL (CREATE, ALTER, DROP) : 객체 생성/수정/삭제
--  DML (INSERT, UPDATE, DELETE) : 데이터(행) 추가/갱신/삭제

--> DDL은 수행 시 존재하고 있는 트랜젝션을 모두 DB에 강제 COMMIT 시키므로,
--  DDL이 종료된 후 DML 구문을 수행할 수 있도록 권장함!

SELECT * FROM TB2;
COMMIT;

-- DML
INSERT INTO TB2 VALUES(14, 4);
INSERT INTO TB2 VALUES(15, 5);

-- DML구문 COMMIT 안한 상태에서 DDL 수행
ALTER TABLE TB2 RENAME COLUMN TB2_COL TO TB2_COLUMN;

ROLLBACK;
SELECT * FROM TB2;
-- TB2에 ROLLBACK이 반영되지 않고 (14, 4), (15, 5)가 남아 있음!
-- 위에서 DDL 구문 중 하나인 ALTER를 사용해서 그 시점에 COMMIT이 됨!
















