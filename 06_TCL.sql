-- TCL (Transaction Control Language) : 트랜젝션 제어 언어
-- COMMIT, ROLLBACK, SAVEPOINT 가 있음

-- DML (Data Manipulation Language) : 데이터 조작언어로 데어트의 삽입 / 삭제 / 수정
--> 트랜젝션은 DML과 관련되어 있음...

/* TRANSACTION 이란?
 * - 데이터베이스의 논리적 연산 단위
 * - 데이터 변경 사항을 묶어서 하나의 트랜잭션에 담아 처리함.
 * - 트랜잭션의 대상이 되는 데이터 변경 사항 : INSERT, UPDATE, DELETE, MERGE
 *
 * INSERT 수행 ------------------------------------------------> DB 반영 (X)
 *
 * INSERT 수행 -----> 트랜잭션에 추가 ---> COMMIT -------------> DB 반영 (O)
 *
 * INSERT 10번 수행 --> 1개 트랜잭션에 10개 추가 --> ROLLBACK --> DB 반영 (X)
 *
 *
 * 1 ) COMMIT : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 DB에 반영
 *
 * 2 ) ROLLBACK : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 삭제하고
 *                마지막 COMMIT 상태로 돌아감 (DB에 변경 내용 반영 X)
 *
 * 3 ) SAVEPOINT : 메모리 버퍼(트랜잭션)에 저장 지점을 정의하여
 *                ROLLBACK 수행 시 전체 작업을 삭제하는 것이 아닌
 *                저장 지점까지만 일부 ROLLBACK
 *
 * [SAVEPOINT 사용법]
 *
 * ...
 * SAVEPOINT "포인트명1";
 *
 * ...
 * SAVEPOINT "포인트명2";
 *
 * ...
 * ROLLBACK TO "포인트명1"; -- 포인트1 지점까지 데이터 변경사항 삭제
 *
 *
 * ** SAVEPOINT 지정 및 호출 시 이름에 ""(쌍따옴표) 붙여야함 !!! **
 *
 * */

-- 새로운 데이터 INSERT (DML 중 하나임!)
SELECT * FROM DEPARTMENT2;

INSERT INTO DEPARTMENT2 VALUES('T1', '개발1팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T2', '개발2팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T3', '개발3팀', 'L2');

-- INSERT 확인
SELECT * FROM DEPARTMENT2;

--> DB에 반영된 것처럼 보이지만 실제로 아직 DB에 반영된것 아님
-- 트랜젝션에 INSERT 3개 있음

ROLLBACK;

-- 이전 수업시간에 바꾼걸 다시 바꾸기
UPDATE DEPARTMENT2 SET DEPT_ID = 'D9', DEPT_TITLE ='총무부'
WHERE DEPT_ID ='D0' AND DEPT_TITLE = '전력기획팀';
COMMIT;
-- 여기까지 다시 원상복구 한것!

-- COMMIT 후 ROLLBACK 이 되는지 확인
INSERT INTO DEPARTMENT2 VALUES('T1', '개발1팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T2', '개발2팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T3', '개발3팀', 'L2');

-- INSERT 확인
SELECT * FROM DEPARTMENT2;

-- DB에 반영
COMMIT;

-- ROLLBACK 하기
ROLLBACK;

-- 다시 DEPARTMENT2 확인 -> 개발1~3팀 삭제되지 않고 남아 있음!
SELECT * FROM DEPARTMENT2;

-----------------------------------------------------------------------

-- SAVEPOINT 확인

INSERT INTO DEPARTMENT2 VALUES('T4', '개발4팀', 'L2');
SAVEPOINT "SP1";	-- SAVEPOINT 지정

INSERT INTO DEPARTMENT2 VALUES('T5', '개발5팀', 'L2');
SAVEPOINT "SP2";	-- SAVEPOINT 지정

INSERT INTO DEPARTMENT2 VALUES('T6', '개발6팀', 'L2');
SAVEPOINT "SP3";	-- SAVEPOINT 지정

ROLLBACK TO "SP1";

SELECT * FROM DEPARTMENT2;	-- 개발4팀은 남음

-- ROLLBACK TO "SP1" 구문 수행 시 "SP2", "SP3" 라는 SAVEPOINT 도 삭제됨!
-- ROLLBACK TO "SP2";
-- SQL Error [1086] [72000]: ORA-01086: 'SP2' 저장점이 이 세션에 설정되지 않았거나 부적합합니다.

INSERT INTO DEPARTMENT2 VALUES('T5', '개발5팀', 'L2');
SAVEPOINT "SP2";

INSERT INTO DEPARTMENT2 VALUES('T6', '개발6팀', 'L2');
SAVEPOINT "SP3";

-- 개발팀 전체 삭제해보기
SELECT * FROM DEPARTMENT2;

DELETE FROM DEPARTMENT2
WHERE DEPT_ID LIKE 'T%';

-- 이 상태에서 SP2 지점까지 롤백
ROLLBACK TO "SP2";

-- SP2 지점까지 롤백한 후 DEPARRMENT2 확인하기 -> 개발5팀까지 살아남
SELECT * FROM DEPARTMENT2;

ROLLBACK TO "SP1";

-- SP1 지점까지 다시 롤백한 후 DEPARTMENT2 확인 -> 개발4팀까지 살아남
SELECT * FROM DEPARTMENT2;

-- 그냥 롤백 수행, 마지막 커밋시점
ROLLBACK;

-- 그냥 롤백 후 DEPARTMENT2 확인 - 마지막 커밋 시점인 개발3팀까지 남아있음
SELECT * FROM DEPARTMENT2;








