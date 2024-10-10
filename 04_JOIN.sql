/*
[JOIN 용어 정리]
  오라클                                             SQL : 1999표준(ANSI)
--------------------------------------------------------------------------------------------------------
등가 조인                               내부 조인(INNER JOIN), JOIN USING / ON
                                            + 자연 조인(NATURAL JOIN, 등가 조인 방법 중 하나)
--------------------------------------------------------------------------------------------------------
포괄 조인                             왼쪽 외부 조인(LEFT OUTER), 오른쪽 외부 조인(RIGHT OUTER)
                                            + 전체 외부 조인(FULL OUTER, 오라클 구문으로는 사용 못함)
--------------------------------------------------------------------------------------------------------
자체 조인, 비등가 조인                             JOIN ON
--------------------------------------------------------------------------------------------------------
카테시안(카티션) 곱                        교차 조인(CROSS JOIN)
CARTESIAN PRODUCT

- 미국 국립 표준 협회(American National Standards Institute, ANSI) 미국의 산업 표준을 제정하는 민간단체.
- 국제표준화기구 ISO에 가입되어 있음.
*/

---------------------------------------------------------------------------------------------------------
-- JOIN
-- 하나 이상의 테이블에서 데이터를 조회하기 위해 사용.
-- 수행 결과는 하나의 Result Set으로 나옴.


-- (참고) JOIN은 서로 다른 테이블의 행을 하나씩 이어 붙이기 때문에
--       시간이 오래 걸리는 단점이 있다!


/*
- 관계형 데이터베이스에서 SQL을 이용해 테이블간 '관계'를 맺는 방법.

- 관계형 데이터베이스는 최소한의 데이터를 테이블에 담고 있어
  원하는 정보를 테이블에서 조회하려면 한 개 이상의 테이블에서
  데이터를 읽어와야 되는 경우가 많다.
  이 때, 테이블간 관계를 맺기 위한 연결고리 역할이 필요한데,
  두 테이블에서 같은 데이터를 저장하는 컬럼이 연결고리가됨.  
*/
------------------------------------------------------------------------------------
SELECT * FROM EMPLOYEE;			-- EMPLOYEE 테이블 전체 조회
SELECT * FROM DEPARTMENT;		-- DEPARTMENT 테이블 전체 조회

-- 사번, 이름, 부서코드, 부서명 조회
-- EMPLOYEE 테이블의 DEPT_CODE와 
-- DEPARTMENT 테이블의 DEPT_ID를 연결고리 지정
SELECT EMP_ID "사번", EMP_NAME "이름", DEPT_CODE "부서 코드", DEPT_TITLE "부서명"
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);		-- 내부 조인 중 하나


-- 1. 내부조인 (INNER JOIN) ( == 등가조인(EQUAL JOIN) BY ORACLE)
--> 연결되는 컬럼의 값이 일치하는 행들만 조인됨.
--> 일치하는 값이 없는 행은 조인에서 제외됨.

-- 작성방법은 크게 ANSI 구문과 오라클 구문으로 나뉘고
-- ANSI에서 USING 과 ON 을 사용하는 방법으로 나뉨!

-- 1) 연결에 사용할 두 컬럼명이 다른 경우

-- ANSI 표현법
-- 연결에 사용할 컬럼명이 다른 경우에 ON(테이블1의 컬럼명1 = 테이블2의 컬럼명2) 사용!
SELECT EMP_ID "사번", EMP_NAME "이름", DEPT_CODE "부서 코드", DEPT_TITLE "부서명"
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- 오라클 표현법 (등가조인)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

------------------------------------------------------------------
SELECT * FROM DEPARTMENT;		-- DEPARTMENT 테이블 전체 조회
SELECT * FROM LOCATION;			-- LOCATION 테이블 전체 조회

-- DEPARTMENT 테이블, LOCATION 테이블을 참조하여 부서명, 지역명 조회

-- ANSI 방식
SELECT DEPT_TITLE, LOCAL_NAME, NATIONAL_CODE
FROM DEPARTMENT
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);

-- 오라클 방식
SELECT DEPT_TITLE, LOCAL_NAME, NATIONAL_CODE
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

-- 2) 연결에 사용할 두 컬럼명이 같은 경우
-- EMPLOYEE 테이블, JOB 테이블을 참조하여
-- 사번, 이름, 직급코드, 직급명 조회

-- ANSI 방식
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

-- 오라클 -> 별칭 사용
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;
-- SQL Error [918] [42000]: ORA-00918: 열의 정의가 애매합니다
--> 해결방법 : FROM에서의 테이블에 별칭을 주고, SELECT절에도 겹치는 컬럼에 별칭 붙여야 함!

/*
 * INNER JOIN (내부 조인) 의 문제점!
 * -> 연결에 사용된 컬럼의 값이 일치하지 않으면 조회 결과에 포함되지 않는다!
 * */
--------------------------------------------------------------------------
-- 2. 외부 조인 (OUTER JOIN)
-- 두 테이블의 지정하는 컬럼 값이 일치하지 않는 행도 조인에 포함시킴
--> * 반드시 OUTER JOIN을 명시해야 함!

SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
/* INNER */JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);		-- 21행

-- JOIN 앞에 LEFT, RIGHT, FULL 을 쓰는 경우 무조건 OUTER JOIN으로 해석함!

-- 1) LEFT [OUTER] JOIN : 합치기에 사용한 두 테이블 중 "왼편"에 기술된 테이블의 컬럼수를 기준으로 JOIN
--> 왼편에 작성된 테이블의 모든 행이 결과에 포함되어야 한다! (JOIN이 안되는 행도 결과에 포함!)

-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE LEFT /*OUTER*/ JOIN DEPARTMENT
ON(DEPT_CODE = DEPT_ID);	-- 23행( DEPT_CODE 가 NULL 인 하동운, 이오리 포함)

-- 오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);
-- OUTER JOIN 하려는 경우 반대쪽 테이블 컬럼에 (+) 작성해야함..!

-- 2) RIGHT [OUTER] JOIN : 합치기에 사용한 두 테이블 중 "오른편"에 기술된 테이블의 컬럼수를 기준으로 JOIN

-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE RIGHT /*OUTER*/ JOIN DEPARTMENT
ON(DEPT_CODE = DEPT_ID);

-- 오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;

-- 3) FULL [OUTER] JOIN : 합치기에 사용한 두 테이블이 가진 모든 행을 결과에 포함!
-- ** 오라클 구문에서는 FULL OUTER JOIN을 사용할 수 없음! **

-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- 오라클 구문 (불가능!)
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID(+);
-- SQL Error [1468] [72000]: ORA-01468: outer-join된 테이블은 1개만 지정할 수 있습니다

---------------------------------------------------------------------------------------------

-- 3. 교차 조인 (CROSS JOIN, (오라클에서) CARTESIAN PRODUCT)
-- 조인되는 테이블의 각 행들이 모두 매핑된 데이터가 검색되는 방법(곱집합)
--> JOIN 구문을 잘못 작성하는 경우 CROSS JOIN의 결과가 조회됨
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT;		-- 23 * 9 행

-----------------------------------------------------------------------------------

-- 4. 비등가 조인 (NON EQUAL JOIN)
-- '= (등호)'를 사용하지 않는 조인문
-- 지정한 컬럼 값이 일치하는 경우 조인하는 것이 아닌,
-- 값의 범위에 포함되는 행들을 연결하는 방식
SELECT * FROM SAL_GRADE;

SELECT EMP_NAME, SAL_LEVEL FROM EMPLOYEE;

-- 사원의 급여에 따른 급여등급 파악하기
SELECT EMP_NAME, SALARY, SAL_GRADE.SAL_LEVEL
FROM EMPLOYEE
JOIN SAL_GRADE ON(SALARY BETWEEN MIN_SAL AND MAX_SAL);

-----------------------------------------------------------------------------------

-- 5. 자체 조인 (SELF JOIN) : 같은 테이블을 조인
-- 자기 자신과 조인을 맺음
-- TIP! 같은 테이블 2개가 있다고 생각하고 JOIN 진행
-- 테이블마다 별칭을 작성(미작성 시 열의 정의 애매하다는 오류 발생)

-- 사번, 이름, 사수의 사번, 사수 이름 조회
-- 단 사수가 없으면 '없음', '-' 조회  -> LEFT JOIN이 필요함!

-- ANSI 표준
SELECT E1.EMP_ID "사번", E1.EMP_NAME "사원 이름",
NVL(E1.MANAGER_ID, '없음') "사수의 사번",
NVL(E2.EMP_NAME, '-')  "사수의 이름"
FROM EMPLOYEE E1
LEFT JOIN EMPLOYEE E2 ON (E1.MANAGER_ID = E2.EMP_ID);
--ORDER BY E1.EMP_ID;

-- 오라클 구문
SELECT E1.EMP_ID "사번", E1.EMP_NAME "사원 이름",
NVL(E1.MANAGER_ID, '없음') "사수의 사번",
NVL(E2.EMP_NAME, '-')  "사수의 이름"
FROM EMPLOYEE E1, EMPLOYEE E2
WHERE E1.MANAGER_ID = E2.EMP_ID(+);

----------------------------------------------------------------------------------

-- 6. 자연 조인 (NATURAL JOIN)
-- 동일한 타입과 이름을 가진 컬럼이 있는 테이블 간의
-- 조인을 간단히 표현하는 방법

-- 반드시 두 테이블 간의 동일한 컬럼명, 타입을 가진 컬럼이 필요

--> 동일한 컬럼명, 타입이 없을 경우 교차 조인 됨

SELECT JOB_CODE FROM EMPLOYEE;
SELECT JOB_CODE FROM JOB;

SELECT EMP_NAME, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB;
--JOIN JOB USING(JOB_CODE);

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
NATURAL JOIN DEPARTMENT;
-- EMPLOYEE 테이블에는 DEPT_CODE
-- DEPARTMENT 테이블에는 DEPT_ID
--> 잘못 조인하면 CROSS JOIN 결과가 조회됨!

----------------------------------------------------------------------------------

-- 7. 다중 조인
-- N 개의 테이블을 조인할 때 사용 (순서가 매우 중요!!!!!)
-- 사원 이름, 부서명, 지역명 조회 (소괄호 안은 테이블 명)
-- EMP_NAME(EMPLOYEE), DEPT_TITLE(DEPARTMENT), LOCAL_NAME(LOCATION)
SELECT * FROM EMPLOYEE;		-- DEPT_CODE
SELECT * FROM DEPARTMENT;	-- DEPT_ID, DEPT_TITLE, LOCATION_ID
SELECT * FROM LOCATION;		-- 						LOCAL_CODE, LOCAL_NAME

-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);
-- CTRL SHIFT 위아래 방향키 : 위아래 줄바꿈
-- CTRL ALT 위아래 방향키 : 복사

-- 오라클
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID		-- (EMPLOYEE + DEPARTMENT) 조인
AND LOCATION_ID = LOCAL_CODE;	-- (EMPLOYEE + DEPARTMENT) + LOCATION 조인

-- [다중 조인 연습문제]
-- 직급이 대리이면서, 아시아 지역에 근무하는 직원 조회
-- 사번, 이름, 직급명, 부서명, 근무지역명, 급여

-- ANSI 표준
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME, SALARY
FROM EMPLOYEE				-- JOIN은 FROM절 내에 써야하는 거라서 WHERE보다 먼저 작성되어야 함!
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)	-- LOCATION이 DEPARTMENT 내부에 있으므로 맨 나중에 JOIN 해야함!
WHERE JOB_NAME = '대리'
AND LOCAL_NAME LIKE 'ASIA%';				-- LIKE 구문도 많이 사용할 거 같군...!
--AND LOCAL_NAME IN ('ASIA1', 'ASIA2', 'ASIA3');

-- 오라클
SELECT EMP_ID, EMP_NAME, J.JOB_NAME, DEPT_TITLE, LOCAL_NAME, SALARY
FROM EMPLOYEE E, JOB J, DEPARTMENT, LOCATION
WHERE E.JOB_CODE = J.JOB_CODE
AND DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE
AND JOB_NAME = '대리'
AND LOCAL_NAME LIKE 'ASIA%';

---------------------------------------------------------------------------------------------------------------

-- 연습문제

-- 1. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 '전'씨인 직원들의
-- 사원명, 주민번호, 부서명, 직급명을 조회하시오.
SELECT EMP_NAME "사원명", EMP_NO "주민번호", DEPT_TITLE "부서명", JOB_NAME "직급명"
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE SUBSTR(EMP_NO, 1, 1) = '7'
AND SUBSTR(EMP_NO, 8, 1) = '2'
AND SUBSTR(EMP_NAME, 1, 1) = '전';


-- 2. 이름에 '형'자가 들어가는 직원들의
-- 사번, 사원명, 직급명, 부서명을 조회하시오.
SELECT EMP_ID "사번", EMP_NAME "사원명", JOB_NAME "직급명", DEPT_TITLE "부서명"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE EMP_NAME LIKE '%형%';

-- 3. 해외영업 1부, 2부에 근무하는 사원의
-- 사원명, 직급명, 부서코드, 부서명을 조회하시오.
SELECT EMP_NAME "사원명", JOB_NAME "직급명", DEPT_CODE "부서코드", DEPT_TITLE "부서명"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE IN ('해외영업1부', '해외영업2부');

-- 4. 보너스포인트를 받는 직원들의
-- 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
SELECT EMP_NAME "사원명", BONUS "보너스포인트", DEPT_TITLE "부서명", LOCAL_NAME "근무지역명"
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
LEFT JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
WHERE BONUS IS NOT NULL;

-- 5. 부서가 있는 사원의 사원명, 직급명, 부서명, 지역명 조회
SELECT EMP_NAME "사원명", JOB_NAME "직급명", DEPT_TITLE "부서명", LOCAL_NAME "지역명"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);
--WHERE DEPT_CODE IS NOT NULL;  이거 안써도 INNER JOIN이라 NULL 안들어옴!

-- 6. 급여등급별 최소급여(MIN_SAL)를 초과해서 받는 직원들의
-- 사원명, 직급명,급여, 연봉(보너스포함)을 조회하시오.
-- (연봉에 보너스포인트를 적용하시오.)
SELECT EMP_NAME "사원명", JOB_NAME "직급명", SALARY "급여", (SALARY+ SALARY * NVL(BONUS, 0))*12 "연봉(보너스 포함)"
FROM EMPLOYEE 
JOIN JOB USING(JOB_CODE)
JOIN SAL_GRADE USING(SAL_LEVEL)
WHERE SALARY > MIN_SAL;

-- 7.한국(KO)과 일본(JP)에 근무하는 직원들의
-- 사원명, 부서명, 지역명, 국가명을 조회하시오.
SELECT EMP_NAME "사원명", DEPT_TITLE "부서명", LOCAL_NAME "지역명", NATIONAL_CODE "국가명"
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
WHERE NATIONAL_CODE IN('KO', 'JP');

-- 8. 같은 부서에 근무하는 직원들의
-- 사원명, 부서코드, 동료이름을 조회하시오.(SELF JOIN 사용)
SELECT E1.EMP_NAME "사원명", E1.DEPT_CODE "부서코드", E2.EMP_NAME "동료이름"
FROM EMPLOYEE E1
JOIN EMPLOYEE E2 ON(E1.DEPT_CODE = E2.DEPT_CODE)
WHERE E1.EMP_NAME != E2.EMP_NAME
ORDER BY E1.EMP_NAME;

-- 9. 보너스포인트가 없는 직원들 중에서
-- 직급코드가 J4와 J7인 직원들의
-- 사원명, 직급명, 급여를 조회하시오. (단, JOIN, IN 사용할 것)
SELECT EMP_ID "사번", EMP_NAME "사원명", JOB_NAME "직급명", SALARY "급여"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_CODE IN('J4', 'J7')
AND BONUS IS NULL;











