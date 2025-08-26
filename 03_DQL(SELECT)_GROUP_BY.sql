-- EMPLOYEE 테이블에 존재하는 전체 사원의 총 급여의 합 조회
SELECT
       SUM(SALARY)
  FROM
       EMPLOYEE; --> EMPLOYEE 테이블에 존재하는 모든 사원들을 하나의 그룹으로 묶어서
                 --  합계를 구한 결과
       
-- EMPLOYEE 테이블에서 각 부서별로 급여의 합계를 조회
SELECT * FROM EMPLOYEE;

SELECT
       SUM(SALARY)
  FROM
       EMPLOYEE
 WHERE
       DEPT_CODE = 'D9';

/*
 * < GROUP BY 절 >
 * 
 * 그룹을 묶어줄 기준을 제시할 수 있는 구문
 * 
 * 여러 개의 컬럼값을 특정 그룹으로 묶어서 처리할 목적으로 사용
 */

SELECT
       SUM(SALARY)
     , DEPT_CODE
  FROM 
       EMPLOYEE
 GROUP
    BY
       DEPT_CODE;

-- 전체 사원 수
SELECT
       COUNT(*)
  FROM
       EMPLOYEE;

-- 부서별 사원수
SELECT
       COUNT(*) AS "인원수"
     , DEPT_CODE   
  FROM
       EMPLOYEE
 GROUP
    BY
       DEPT_CODE;

-- 각 사원의 성(이름)별 사원의 수
SELECT
       COUNT(*)
     , SUBSTR(EMP_NAME, 1, 1)
  FROM
       EMPLOYEE
 GROUP
    BY
       SUBSTR(EMP_NAME, 1, 1);

-- 각 부서별로 급여 합계를 오름 차순으로 정렬
SELECT
       SUM(SALARY)   --> 3
     , DEPT_CODE
  FROM 
       EMPLOYEE      --> 1
 GROUP
    BY
       DEPT_CODE     --> 2
 ORDER
    BY
       DEPT_CODE;    --> 4

--------------------------------------------------------------------------
SELECT
       EMP_NAME
  FROM
       EMPLOYEE
 GROUP
    BY
       DEPT_CODE;
-- 주의할 점 : GROUP BY절 사용 시 GROUP으로 나누지 않은 컬럼은 SELECT 할 수 없다.

-- 부서코드, 각 부서별 평균 급여
-- 부서 코드중에서 평균급여가 300만원 이상인 부서만 조회
SELECT
       DEPT_CODE
     , FLOOR(AVG(SALARY))
  FROM
       EMPLOYEE
 WHERE
       --(AVG(SALARY)) >= 3000000 WHERE절에서 그룹함수 사용불가
       DEPT_CODE IS NOT NULL
 GROUP
    BY
       DEPT_CODE;

/*
 * < HAVING 절 >
 * 
 * 그룹에 대한 조건을 제시할 때 사용하는 구문
 * (그룹함수를 아주 잘 사용할 수 있음)
 */
SELECT --> 4
       DEPT_CODE
     , FLOOR(AVG(SALARY))
  FROM --> 1
       EMPLOYEE                 
 GROUP --> 2
    BY
       DEPT_CODE
HAVING --> 3
       AVG(SALARY) >= 3000000;

/*
 * < 실행순서 >
 * 5. SELECT   : 조회하고자하는 컬럼명 / 함수식 / 산술연산식 / 리터럴값 / * AS "별칭"
 * 1. FROM     : 조회하고자 하는 테이블 명
 * 2. WHERE    : 조건식
 * 3. GROUP BY : 그룹기준에 해당하는 컬럼명 / 함수식
 * 4. HAVING   : 그룹함수로 만들어줄 조건식
 * 6. ORDER BY : 정렬기준으로 사용할 컬럼명 / 함수식 / 별칭 / 컬럼 순번
 * 
 * 1.FROM -> 2.WHERE -> 3.GROUP BY -> 4.HAVING -> 5. SELECT -> 6.ORDER BY
 */

-- EMPLOYEE 테이블로부터 각 직급별(JOB_CODE)별 총 급여합이 1000만원 이상인 직급의 
-- 직급코드, 급여합을 조회 / 단, 직급코드가 J6인 그룹은 제외
SELECT 
       SUM(SALARY)
     , JOB_CODE
  FROM
       EMPLOYEE
 WHERE 
       JOB_CODE != 'J6'
 GROUP
    BY
       JOB_CODE
HAVING
       SUM(SALARY) >= 10000000;

-- 보너스를 받는 사원이 없는 부서코드만 조회
SELECT 
       DEPT_CODE
  FROM
       EMPLOYEE
 GROUP
    BY
       DEPT_CODE
HAVING
       COUNT(BONUS) = 0;

-- 



