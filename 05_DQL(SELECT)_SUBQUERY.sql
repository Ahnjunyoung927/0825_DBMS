/*
 * < SUB QUERY 서브쿼리 >
 * 
 * 하나의 메인 SQL(SELECT, INSERT, UPDATE, DELETE, CREATE,...)안에 포함된
 * 또 하나의 SELECT문
 * 
 * MAIN SQL문의 보조역할을 하는 쿼리문
 */

-- 간단 서브쿼리 예시
SELECT * FROM EMPLOYEE;
-- 박세혁 사원과 부서가 같은 사원들의 사원명 조회

-- 1) 먼저 박세혁 사원의 부서코드 조회
SELECT
       DEPT_CODE
  FROM
       EMPLOYEE
 WHERE
       '박세혁' = EMP_NAME;

-- 2) 부서코드가 D5인 사원들의 사원명 조회
SELECT
       EMP_NAME
  FROM
       EMPLOYEE
 WHERE
       DEPT_CODE = 'D5';

-- 위 두 단계를 하나의 쿼리문으로 합치기
SELECT
       EMP_NAME
  FROM
       EMPLOYEE
 WHERE
       DEPT_CODE = (SELECT -- 여기부터 서브쿼리
                           DEPT_CODE
                      FROM
                           EMPLOYEE
                     WHERE
                           '박세혁' = EMP_NAME);
------------------------------------------------------------------
-- 간단한 서브쿼리 예시 두번째
-- 전체 사원의 평균 급여보다 더 많은 급여를 받고 잇는 사원들의 사번, 사원명을 조회

-- 1. 전체사원의 평균급여
SELECT
       AVG(SALARY)
  FROM
       EMPLOYEE;

-- 2. 급여가 3131140원 이상인 사원들의 사번, 사원명
SELECT
       EMP_ID
     , EMP_NAME
  FROM
       EMPLOYEE
 WHERE
       SALARY >= 3131140;

-- 3. 위 두 쿼리문을 합치기
SELECT
       EMP_ID
     , EMP_NAME
  FROM
       EMPLOYEE
 WHERE
       SALARY >= (SELECT
                         AVG(SALARY)
                    FROM
                         EMPLOYEE);

-------------------------------------------------------------------------
/*
 * 서브쿼리의 분류
 * 
 * 서브쿼리를 수행한 결과가 몇 행 몇 열이냐에 따라서 분류됨
 * 
 * - 단일행 [단일열] 서브쿼리 : 서브쿼리 수행 결과가 딱 하나
 * - 다중행 [단일열] 서브쿼리 : 서브쿼리 수행 결과가 여러 행, 컬럼은 하나
 * - [단일행] 다중열 서브쿼리 : 서브쿼리 수행 결과가 여러 열
 * - 다중행 다중열 서브쿼리   : 서브쿼리 수행 결과가 여러 행, 여러 열
 * 
 * => 수행 결과가 몇 행 몇 열이냐에 따라서 사용할 수 있는 연산자가 다름
 */

/*
 * 1. 단일 행 서브쿼리(SINGLE ROQ SUBQUERY)
 * 
 * 서크워리의 조회 결과값이 오로지 1개 일 때
 * 
 * 일반 연산자 사용(=, !=, >, < ...)
 */
-- 전 직원의 평균 급여보다 적게 받는 사원들의 사원명, 전화번호 조회
SELECT
       AVG(SALARY)
  FROM
       EMPLOYEE; --> 결과값 : 오로지 1개의 값

SELECT
       EMP_NAME
     , PHONE
  FROM
       EMPLOYEE
 WHERE
       SALARY < (SELECT
                        AVG(SALARY)
                   FROM
                        EMPLOYEE);

-- 최저급여를 받는 사원의 사번, 사원명, 직급코드, 급여, 입사일 조회
SELECT
       MIN(SALARY)
  FROM
       EMPLOYEE;

SELECT
       EMP_ID
     , EMP_NAME
     , JOB_CODE
     , SALARY
     , HIRE_DATE
  FROM
       EMPLOYEE
 WHERE
       SALARY = (SELECT
                        MIN(SALARY)
                   FROM
                        EMPLOYEE);

-- 안준영 사원의 급여보다 더 많은 급여를 받는 사원들의 사원명, 급여 조회
SELECT
       SALARY
  FROM
       EMPLOYEE
 WHERE
       EMP_NAME = '안준영';

SELECT
       EMP_NAME
     , SALARY
  FROM
       EMPLOYEE
 WHERE
       SALARY > (SELECT
                        SALARY
                   FROM
                        EMPLOYEE
                  WHERE
                        EMP_NAME = '안준영');

-- JOIN 활용 실습
-- 박수현 사원과 같은 부서인 사원들의 사원명, 전화번호, 직급명을 조회하는데 박수현 사원은 제외
-- SQL(Structured Query Language) - 구조적 질의 언어
SELECT
       DEPT_CODE
  FROM
       EMPLOYEE
 WHERE
       EMP_NAME = '박수현';
--------------------------------
--ANSI
SELECT
       EMP_NAME
     , PHONE
     , JOB_NAME
  FROM
       EMPLOYEE
  JOIN
       JOB USING (JOB_CODE)
 WHERE
       DEPT_CODE = (SELECT
       		               DEPT_CODE
                      FROM
                           EMPLOYEE
                     WHERE
                           EMP_NAME = '박수현')
   AND
       EMP_NAME != '박수현';

--ORACLE
SELECT
       EMP_NAME
     , PHONE
     , JOB_NAME
  FROM
       EMPLOYEE E
     , JOB J
 WHERE
       E.JOB_CODE = J.JOB_CODE
   AND
       DEPT_CODE = (SELECT
       		               DEPT_CODE
                      FROM
                           EMPLOYEE
                     WHERE
                           EMP_NAME = '박수현')
   AND 
       EMP_NAME != '박수현';

-----------------------------------------------------------------------------------
-- 부서별 급여 합계가 가장 큰 부서의 부서명, 부서코드, 급여합계

-- 1_1. 각부서별 급여합계
SELECT
       SUM(SALARY)
  FROM
       EMPLOYEE
 GROUP
    BY
       DEPT_CODE;

-- 1_2. 부서별 급여합계중 가장 큰 급여합
SELECT
       MAX(SUM(SALARY))
  FROM
       EMPLOYEE
 GROUP
    BY
       DEPT_CODE;

-- 2.
SELECT
       SUM(SALARY)
     , DEPT_CODE
     , DEPT_TITLE
  FROM
       EMPLOYEE
  JOIN
       DEPARTMENT ON (DEPT_ID = DEPT_CODE)
 GROUP
    BY
       DEPT_CODE
     , DEPT_TITLE
HAVING
       SUM(SALARY) = 18000000;

-- 합치기
SELECT
       SUM(SALARY)
     , DEPT_CODE
     , DEPT_TITLE
  FROM
       EMPLOYEE
  JOIN
       DEPARTMENT ON (DEPT_ID = DEPT_CODE)
 GROUP
    BY
       DEPT_CODE
     , DEPT_TITLE
HAVING
       SUM(SALARY) = (SELECT
                             MAX(SUM(SALARY))
                        FROM
                             EMPLOYEE
                       GROUP
                          BY
                             DEPT_CODE);

-----------------------------------------------------------------------------------------
/* 
 * 2. 다중 행 서브쿼리
 * 서브쿼리의 조회 결과값이 여러 행일때
 * 
 * - IN(10, 20, 30) : 여러 개의 결과값 중 한 개라도 일치하는 값이 있다면
 */
-- 각 부서별 최고급여를 받는 사원의 이름, 급여
SELECT
       MAX(SALARY)
  FROM
       EMPLOYEE
 GROUP
    BY
       DEPT_CODE;
-- 
SELECT
       EMP_NAME
     , SALARY
  FROM
       EMPLOYEE
 WHERE
       SALARY IN (SELECT
                         MAX(SALARY)
                    FROM
                         EMPLOYEE
                   GROUP
                      BY
                         DEPT_CODE);
----------------------------------------------------------------

-- 이승철 사원 또는 선승제 사원과 같은 부서인 사원들의 사원명, 핸드폰번호 조회
SELECT
       DEPT_CODE
  FROM
       EMPLOYEE
 WHERE
       EMP_NAME IN ('이승철', '선승제' ); -- OR 절을 대체 가능
--
SELECT
       EMP_NAME
     , PHONE
  FROM
       EMPLOYEE
 WHERE
       DEPT_CODE IN ('D8', 'D9');
--
SELECT
       EMP_NAME
     , PHONE
  FROM
       EMPLOYEE
 WHERE
       DEPT_CODE IN (SELECT
                            DEPT_CODE
                       FROM
                            EMPLOYEE
                      WHERE
                            EMP_NAME IN ('이승철', '선승제' ));

SELECT * FROM JOB;
-- 인턴(수습사원) < 사원 < 주임 < 대리 < 과장 < 차장 < 부장
SELECT * FROM EMPLOYEE;
-- 대리직급임에도 불구하고 과장보다 급여를 많이 받는 대리가 존재한다..?

-- 1) 과장들은 얼마를 받고 있는가
-- '과장'
SELECT
       SALARY
  FROM
       EMPLOYEE
  JOIN
       JOB USING (JOB_CODE)
 WHERE
       JOB_NAME = '과장'; -- 220, 250, 232, 376, 750

-- 2) 위의 급여보다 높은 급여를 받고 있는 대리의 사원명, 직급명, 급여
SELECT
       EMP_NAME
     , JOB_NAME
     , SALARY
  FROM
       EMPLOYEE
  JOIN
       JOB USING (JOB_CODE)
 WHERE       -- ANY 앞의 대소비교 연산자를 사용하면 가능
       SALARY > ANY (SELECT
                            SALARY
                       FROM
                            EMPLOYEE
                       JOIN
                            JOB USING (JOB_CODE)
                      WHERE
                            JOB_NAME = '과장') 
   AND       
       JOB_NAME = '대리';
/*
 * X(컬럼) > ANY(값, 값, 값)
 * X의 값이 ANY괄호안의 값 중 하나라도 크면 참
 * 
 * > ANY(값, 값, 값) : 여러 개의 결과값중 하나라도 "클"경우 참을 반환
 * 
 * < ANY(값, 값, 값) : 여러 개의 결과값중 하나라도 "작을"경우 참을 반환
 */

-- 과장 직급인데 모든 차장직급의 급여보다 더 많이 받는 직원
SELECT
       EMP_NAME
     , JOB_NAME
     , SALARY
  FROM
       EMPLOYEE
  JOIN
       JOB USING (JOB_CODE)
 WHERE       -- ALL 앞의 대소비교 연산자를 사용하여 전체를 다뛰어넘거나 낮은 값 반환 가능
       SALARY > ALL (SELECT
                            SALARY
                       FROM
                            EMPLOYEE
                       JOIN
                            JOB USING (JOB_CODE)
                      WHERE
                            JOB_NAME = '차장') 
   AND       
       JOB_NAME = '과장';


-----------------------------------------------------------------------------
/*
 * 3. 다중열 서브쿼리
 * 
 * 조회결과는 한 행이지만 나열된 칼럼의 수가 다수 개일 때
 */

SELECT * FROM EMPLOYEE;

-- 박채형 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들의 사원명, 부서코드, 직급코드 조회
SELECT
       DEPT_CODE
     , JOB_CODE
  FROM
       EMPLOYEE
 WHERE
       EMP_NAME = '박채형';
--
SELECT
       EMP_NAME
     , DEPT_CODE
     , JOB_CODE
  FROM
       EMPLOYEE
 WHERE
       DEPT_CODE = 'D5'
   AND
       JOB_CODE = 'J5';
--

SELECT
       EMP_NAME
     , DEPT_CODE
     , JOB_CODE
  FROM
       EMPLOYEE
 WHERE -- 값을 받을 컬럼들을 괄호로 묶어서
       (DEPT_CODE, JOB_CODE) = (SELECT
                                       DEPT_CODE
                                     , JOB_CODE
                                  FROM
                                       EMPLOYEE
                                 WHERE
                                       EMP_NAME = '박채형');

-----------------------------------------------------------------------
/*
 * 4. 다중행 다중열 서브쿼리
 * 서브쿼리 수행 결과가 행도 많고 열도 많음
 * 위의 방식들을 모두 조합해서 사용
 */

-- 각 직급별로 최고 급여를 받는 사원들 조회(이름, 직급코드, 급여)
SELECT
       JOB_CODE
     , MAX(SALARY)
  FROM
       EMPLOYEE
 GROUP
    BY
       JOB_CODE;
--
SELECT
       EMP_NAME
     , JOB_CODE
     , SALARY
  FROM
       EMPLOYEE
 WHERE
       (JOB_CODE, SALARY) IN (SELECT
                                     JOB_CODE
                                   , MAX(SALARY)
                                FROM
                                     EMPLOYEE
                               GROUP
                                  BY
                                     JOB_CODE);

-----------------------------------------------------------
/*
 * 5. 인라인 뷰(INLINE-VIEW)
 * FROM 절에 서브쿼리를 작성
 * 
 * SELECT문의 수행결과(ResultSet)을 테이블 대신 사용
 * 
 * 6. 스칼라 서브쿼리(Scalar Subquery)
 * 주로 SELECT 절에 사용하는 쿼리를 의미
 * 메인쿼리 실행 마다 서브쿼리가 실행될 수 있으므로 성능이슈가 생길 수 있음
 * 그렇기 때문에 JOIN으로 대체하는 것이 일반적으로는 성능상 유리함
 * 단, 캐싱이 되기 때문에 동일한 결과에 대해선 성능상 JOIN보다 뛰어날 수도 있음
 * 스칼라 쿼리는 반드시 단 한개의 값만을 반환해야함
 */
-- 스칼라 예시
-- 사원의 사원명과 부서명을 조회
SELECT
       EMP_NAME
     , DEPT_TITLE
  FROM
       EMPLOYEE
  JOIN
       DEPARTMENT ON (DEPT_CODE = DEPT_ID);

SELECT
       EMP_NAME --NAME행마다 SELECT이 계속 수행되어서 성능저하
     , (SELECT DEPT_TITLE FROM DEPARTMENT WHERE E.DEPT_CODE = DEPT_ID)
  FROM
       EMPLOYEE E;

-- 간단하게 인라인뷰 써보기
-- 사원들의 이름, 보너스 포함 연봉 조회하고 싶음
-- 단, 보너스포함 연봉이 4000만원 이상인 사원만 조회
/*
SELECT
       EMP_NAME
     , (SALARY + SALARY * NVL(BONUS, 0)) * 12 AS "보너스 포함 연봉"
  FROM
       EMPLOYEE
 WHERE
       "보너스 포함 연봉" > 40000000; --
*/

SELECT
       "사원이름"
     , "보너스 포함 연봉"
  FROM
       (SELECT
               EMP_NAME AS "사원이름"
             , ((SALARY + SALARY * NVL(BONUS, 0)) * 12) AS "보너스 포함 연봉"
          FROM
               EMPLOYEE)
 WHERE
       "보너스 포함 연봉" > 40000000;

--> 인라인 뷰를 주로 사용하는 예(클래식)
--> TOP-N 분석 : DB상에 있는 값들 중 최상위 N개의 데이터를 보기 위해서 사용

SELECT * FROM EMPLOYEE;
-- 전직원들 중 급여가 가장 높은 상위 5명 줄 세우기위해서 조회

-- * ROWNUM : 오라클에서 자체적으로 제공해주는 컬럼, 조회된 순서대로 순번을 붙여줌
SELECT
       EMP_NAME
     , SALARY
     , ROWNUM
  FROM
       EMPLOYEE;

SELECT
       EMP_NAME
     , SALARY
     , ROWNUM
  FROM
       EMPLOYEE
 WHERE
       ROWNUM <= 5
 ORDER
    BY
       SALARY DESC; -- 줄세우기가 마지막이라 급여순으로 조회되지 않음
-------------------------------------------------------
SELECT
       EMP_NAME
     , SALARY
FROM
     (SELECT
             EMP_NAME
           , SALARY
        FROM 
             EMPLOYEE
       ORDER
          BY
             SALARY DESC) -- FROM 절안에서 줄세우기 마친 후 진행
WHERE 
      ROWNUM <= 5;
-------------------------------------------------------------------
-- 모던한 방법
SELECT
       EMP_NAME
     , SALARY
  FROM
       EMPLOYEE
 ORDER
    BY
       SALARY DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
    -- N 개를 건너뛴 후  다음 N 개를 반환받겠다.







