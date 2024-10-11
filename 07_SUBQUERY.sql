/*
 * SUBQUERY (서브쿼리 == 내부쿼리)
 * - 하나의 SQL 문 안에 포함된 또 다른 SQL(SELECT)문
 * - 메인쿼리(== 외부쿼리, 기존쿼리)를 위해 보조역할을 하는 쿼리문 
 * - 서브쿼리문은 소괄호로 묶어서 써주기!!
 * 
 * - 메인쿼리가 SELECT 문일 때 
 * - SELECT, FROM, WHERE, HAVING 절에서 사용 가능
 * */

-- 서브쿼리 예시1.
-- 부서코드가 노옹철 사원과 같은 소속의 직원의
-- 이름, 부서코드 조회

-- 1) 노옹철의 부서코드 조회 : 'D9'
SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME='노옹철';

-- 2) 부서코드가 'D9'인 직원의 이름, 부서코드 조회(메인쿼리)
SELECT EMP_NAME, DEPT_CODE FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME='노옹철');
--AND EMP_NAME != '노옹철';

-- 서브쿼리 예시2.
-- 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의
-- 사번, 이름, 직급코드, 급여 조회
-- 1) 전 직원의 평균 급여 조회하기 (서브쿼리) : 3,047,663원
SELECT CEIL(AVG(SALARY)) FROM EMPLOYEE;

-- 2) 직원 중 급여가 위 평균급여 이상인 사원들의 
-- 사번, 이름, 직급코드, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE
WHERE SALARY >= (SELECT CEIL(AVG(SALARY)) FROM EMPLOYEE);

------------------------------------------------------------------------------------

/* 서브쿼리 유형
 *
 * - 단일행 (단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 1개일 때
 *
 * - 다중행 (단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 여러개일 때
 *
 * - 다중열 서브쿼리 : 서브쿼리의 SELECT 절에 나열된 항목수가 여러개일 때
 *
 * - 다중행 다중열 서브쿼리 : 조회 결과 행 수와 열 수가 여러개일 때
 *
 * - 상(호연)관 서브쿼리 : 서브쿼리가 만든 결과 값을 메인쿼리가 비교 연산할 때
 *                        메인쿼리 테이블의 값이 변경되면 서브쿼리의 결과값도 바뀌는 서브쿼리
 *
 * - 스칼라 서브쿼리 : 상관 쿼리이면서 결과 값이 하나인 서브쿼리
 *
 * ** 서브쿼리 유형에 따라 서브쿼리 앞에 붙는 연산자가 다름 **
 *
 * */

-- 1. 단일행 서브쿼리 (SINGLE ROW SUBQUERY)
-- 서브 쿼리에 조회결과 값의 개수가 1개인 서브쿼리로서, 
-- 단일행 서브쿼리 앞에는 비교 연산자(<, >, <=, >=, =, !=, <> 등)를 사용

-- 전 직원의 급여 평균보다 많은(초과) 급여를 받는 직원의
-- 이름, 직급명, 부서명, 급여를 직급 순으로 정렬하여 조회
-- 1) 서브쿼리
SELECT AVG(SALARY) FROM EMPLOYEE;

-- 2) 문제해결
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE SALARY >(SELECT AVG(SALARY) FROM EMPLOYEE)
ORDER BY JOB_CODE;
-- SELECT 절에서 명시되지 않은 컬럼이더라도 FROM, JOIN으로 인해 테이블상
-- 존재하는 컬럼이면 ORDER BY 절에서 사용 가능!

-- 가장 적은 급여를 받는 직원의
-- 사번 이름, 직급명, 부서코드 ,급여, 입사일 조회
-- 1) 서브쿼리문
SELECT MIN(SALARY) FROM EMPLOYEE;

-- 2) 문제 해결
SELECT EMP_ID "사번", EMP_NAME "이름", JOB_NAME "직급명", DEPT_CODE "부서코드", SALARY "급여", HIRE_DATE "입사일"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE);


-- 노옹철 사원의 급여보다 많이(초과) 받는 직원의 사번, 이름, 부서명, 직급명, 급여 조회
-- 1) 서브쿼리
SELECT SALARY FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';

-- 2) 문제 해결
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, SALARY
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE SALARY > (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '노옹철');


-- 부서별(부서가 없는 사람 포함) 급여의 합계 중
-- 가장 큰 부서의 부서명, 급여 합계를 조회

-- 1) 서브쿼리 : 부서의 급여 합 중 가장 큰 값
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 2) 문제해결
SELECT DEPT_TITLE "급여를 가장 많이 받는 부서", SUM(SALARY) "급여 합계"
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY)) FROM EMPLOYEE GROUP BY DEPT_CODE);

------------------------------------------------------------------------------------
-- 2. 다중행 서브쿼리 (MULTI ROW SUBQUERY)
-- 서브쿼리의 조회 결과 값의 개수가 여러 행일 때

/*
 * >> 다중행 서브쿼리 앞에는 일반 비교연산자 사용 X
 *
 * - IN / NOT IN : 여러 개의 결과값 중에서 한 개라도 일치하는 값이 있다면
 *                 혹은 없다면 이라는 의미 (가장 많이 사용!)
 *
 * - > ANY, < ANY : 여러개의 결과값 중에서 한 개라도 큰 / 작은 경우
 *                  가장 작은 값 보다 큰가? / 가장 큰 값 보다 작은가?
 *
 * - > ALL, < ALL : 여러개의 결과값의 모든 값 보다 큰 / 작은 경우
 *                  가장 큰 값 보다 큰가? / 가장 작은 값 보다 작은가?
 *
 * - EXISTS / NOT EXISTS : 값이 존재하는가? / 존재하지 않는가?
 *
 * */  

-- 부서별 최고 급여를 받는 직원의
-- 이름, 직급, 부서, 급여를 부서 순으로 정렬하여 조회

-- 1) 서브쿼리 : 부서벌 최고급여 -> 7행 1열(다중행)
SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 2) 메인쿼리 + 서브쿼리
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE;


-- 사수에 해당하는 직원에 대해 조회
-- 사번, 이름, 부서명, 직급명, 구분(사수/사원)

-- 1) 서브쿼리 : 사수에 해당하는 EMP_ID
SELECT DISTINCT MANAGER_ID 
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;

-- 2) 메인쿼리 : 직원의 사번, 이름, 부서명, 직급명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE);

-- 3) 사수에 해당하는 직원에 대한 정보 추출 조회(구분 '사수'로)
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사수' "구분"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID FROM EMPLOYEE WHERE MANAGER_ID IS NOT NULL);

-- 4) 일반 직원에 해당하는 사원들 정보 조회(구분 '사원'으로)
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사원' "구분"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID FROM EMPLOYEE WHERE MANAGER_ID IS NOT NULL);

-- 5) 위의 조회 결과를 하나로 합치기
-- 5-1) 집합연산자 (UNIOIN 합집합) 사용
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사수' "구분"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID FROM EMPLOYEE WHERE MANAGER_ID IS NOT NULL)
UNION
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사원' "구분"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID FROM EMPLOYEE WHERE MANAGER_ID IS NOT NULL);

-- 5-2) 선택함수 사용 + SELECT절에도 서브쿼리 사용하여 나타냄!
--> DECODE(컬럼명, 값1, 출력값1, 값2, 출력값2, ..., 일치하지 않는 경우)
--> CASE WHEN 조건1 THEN 값1
-- 		WHEN 조건2 THEN 값2
--		ELSE 값
--	END 별칭
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME,
	CASE WHEN EMP_ID IN (SELECT DISTINCT MANAGER_ID FROM EMPLOYEE WHERE MANAGER_ID IS NOT NULL) THEN '사수'
		ELSE '사원'
	END "구분"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
ORDER BY EMP_ID;


-- 대리 직급의 직원들 중에서 과장 직급의 최소급여보다 많이 받는 직원의
-- 사번, 이름, 직급명, 급여 조회

--  > ANY : 가장 작은 값보다 큰 가? (맨 앞 > 도 포함!)

-- 1) 직급이 대리인 직원들의 사번, 이름, 직급, 급여 조회 (메인쿼리)
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME= '대리';

-- 2) 직급이 과장인 직원들의 급여 조회(서브쿼리)
SELECT SALARY FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장';

-- 3) 메인쿼리 + 서브쿼리
-- 3-1) MIN을 이용해서 단일행 서브쿼리로 만드는 방법
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME= '대리'
AND SALARY > (SELECT MIN(SALARY) FROM EMPLOYEE JOIN JOB USING(JOB_CODE) WHERE JOB_NAME = '과장');

-- 3-2) ANY(다중행 서브쿼리)를 이용하는 방법
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME= '대리'
AND SALARY > ANY(SELECT SALARY FROM EMPLOYEE JOIN JOB USING(JOB_CODE) WHERE JOB_NAME = '과장');


-- 차장 직급의 급여 중 가장 큰 값보다 더 많이 받는 과장 직급의 직원의
-- 사번, 이름, 직급, 급여 조회

-- > ALL : 가장 큰 값보다 큰가?
-- < ALL : 가장 작은 값보다 작은가?

-- 서브쿼리 문
SELECT SALARY FROM EMPLOYEE JOIN JOB USING(JOB_CODE) WHERE JOB_NAME='차장';

-- 메인쿼리 + 서브쿼리
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
AND SALARY > ALL(SELECT SALARY FROM EMPLOYEE JOIN JOB USING(JOB_CODE) WHERE JOB_NAME='차장');


-- 서브쿼리 중첩 사용(응용편...?)
-- LOCATION 테이블에서 NATIONAL_CODE가 KO인 경우의 LOCAL_CODE와
-- DEPARTMENT 테이블의 LOCATION_ID와 동일한 DEPT_ID가
-- EMPLOYEE테이블의 DEPT_CODE와 동일한 사원을 구하시오.   

-- 1) LOCATION 테이블에서 NATIONAL_CODE가 KO인 경우의 LOCAL_CODE와
SELECT LOCAL_CODE
FROM LOCATION 
WHERE NATIONAL_CODE = 'KO';

-- 2) DEPARTMENT 테이블의 LOCATION_ID와 동일한 DEPT_ID가
SELECT DEPT_ID 
FROM DEPARTMENT
WHERE LOCATION_ID = (SELECT LOCAL_CODE FROM LOCATION WHERE NATIONAL_CODE = 'KO');

-- 3) EMPLOYEE테이블의 DEPT_CODE와 동일한 사원을 구하시오. 
-- 최종적으로 EMPLOYEE 테이블에서 위의 결과들과 동일한 DEPT_CODE를 가진 사원을 조회
SELECT EMP_NAME, DEPT_CODE 
FROM EMPLOYEE
WHERE DEPT_CODE IN (
	SELECT DEPT_ID 
	FROM DEPARTMENT
	WHERE LOCATION_ID = (SELECT LOCAL_CODE FROM LOCATION WHERE NATIONAL_CODE = 'KO')
);

---------------------------------------------------------------------------------------------------
-- 3. (단일행) 다중열 서브쿼리
-- 서브쿼리 SELECT 절에 나열된 컬럼 수가 여러개 일 때

-- 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는 사원의 
-- 이름, 직급코드, 부서코드, 입사일 조회

-- 1) 퇴사한 여직원 조회
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE ENT_YN = 'Y'
AND SUBSTR(EMP_NO, 8, 1) = '2';

-- 2) 퇴사한 여직원과 같은 부서, 같은 직급 조회
-- 2-1) 단일행 단일열 서브쿼리 2개를 사용해서 조회
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE ENT_YN = 'Y' AND SUBSTR(EMP_NO, 8, 1) = '2')
AND JOB_CODE = (SELECT JOB_CODE FROM EMPLOYEE WHERE ENT_YN = 'Y' AND SUBSTR(EMP_NO, 8, 1) = '2');

-- 2-2) 다중열 서브쿼리 사용
--> WHERE 절에 작성된 컬럼 순서에 맞게
-- 서브쿼리의 조회된 컬럼과 비교하여 일치하는 행만 조회
-- 컬럼 순서가 중요!!!

SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE FROM EMPLOYEE WHERE ENT_YN = 'Y' AND SUBSTR(EMP_NO, 8, 1) = '2');

-------------------------------------------------------------------------------------------------------
-- 연습문제 다중열 서브쿼리 활용

-- 1. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회(단, 노옹철 제외)
-- 사번, 이름, 부서코드, 직급코드, 부서명, 직급명

-- 서브쿼리
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';

-- 해결코드
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE FROM EMPLOYEE WHERE EMP_NAME = '노옹철')
AND EMP_NAME != '노옹철';


-- 2. 2000년도에 입사한 사원의 부서와 직급이 같은 사원을 조회
--    사번, 이름, 부서코드, 직급코드, 입사일

-- 서브쿼리
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE TO_CHAR(HIRE_DATE,'YYYY') = 2000; 

-- 해결코드
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE FROM EMPLOYEE WHERE TO_CHAR(HIRE_DATE,'YYYY') = 2000);
																	--  WHERE EXTRACT(YEAR FROM HIRE_DATE) = 2000);

-- 3. 77년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원 조회
--    사번, 이름, 부서코드, 사수번호, 주민번호, 입사일  

-- 서브쿼리
SELECT DEPT_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 1, 2) = '77'
AND SUBSTR(EMP_NO, 8, 1) = '2';

-- 해결코드
SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID, EMP_NO, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID) = (SELECT DEPT_CODE, MANAGER_ID
	FROM EMPLOYEE
	WHERE SUBSTR(EMP_NO, 1, 2) = '77'
--	WHERE EMP_NO LIKE '77%'
	AND SUBSTR(EMP_NO, 8, 1) = '2'
);

---------------------------------------------------------------------------------------------------------------
-- 4. 다중행 다중열 서브쿼리
-- 서브쿼리 조회 결과 행의 수와 열의 수가 여러개 일 때

-- 본인이 소속된 직급의 평균 급여를 받고 있는 직원의
-- 사번, 이름, 직급코드, 급여 조회
-- 단, 급여와 급여 평균은 만원 단위로 계산, TRUNC(컬럼명, -4)

-- 1) 직급별 평균 급여 (서브쿼리)
SELECT JOB_CODE, TRUNC(AVG(SALARY), -4)
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- 2) 메인쿼리 + 서브쿼리
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, TRUNC(AVG(SALARY), -4)
	FROM EMPLOYEE
	GROUP BY JOB_CODE
);


