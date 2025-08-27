SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM JOB;

-- 전체 사원들의 사번, 사원명, 부서코드, 부서명을 한꺼번에 조회하고 싶다.
SELECT
       EMP_ID
     , EMP_NAME
     , DEPT_CODE
  FROM
       EMPLOYEE;

SELECT
       DEPT_ID
     , DEPT_TITLE
  FROM
       DEPARTMENT;

-- 전체 사원들의 사번, 사원명, 직급코드, 직급명을 한 번에 조회
SELECT
       EMP_ID
     , EMP_NAME
     , DEPT_CODE
  FROM
       EMPLOYEE;

SELECT
       JOB_CODE
     , JOB_NAME
  FROM
       JOB;

----------------------------------------------------------------------

--> JOIN을 통해 연결고리에 해당하는 컬럼만 매칭시킨다면 마치 하나의 조회결과물처럼 조회가능

-- KH
-- 어떤 강의장에 어떤 강사가 수업을 하고 있는가??
CREATE TABLE CLASS_ROOM(
	CLASS_ID CHAR(1),
	LECTURE_NAME VARCHAR2(20)
);

INSERT INTO CLASS_ROOM VALUES('A', '이승철');
INSERT INTO CLASS_ROOM VALUES('B', '홍길동');
INSERT INTO CLASS_ROOM VALUES('C', '고길동');
SELECT * FROM CLASS_ROOM;


CREATE TABLE STUDENT(
	CLASS_ID CHAR(1),
	STUDENT_NAME VARCHAR2(20)
);

INSERT INTO STUDENT VALUES('A', '이승욱');
INSERT INTO STUDENT VALUES('A', '채정민');
INSERT INTO STUDENT VALUES('B', '김윤기');
INSERT INTO STUDENT VALUES('C', '김태호');
COMMIT;

SELECT
       CLASS_ID
     , LECTURE_NAME
  FROM
       CLASS_ROOM;

SELECT
       CLASS_ID
     , STUDENT_NAME
  FROM
       STUDENT;


SELECT
       LECTURE_NAME
     , CLASS_ROOM.CLASS_ID
     , STUDENT.CLASS_ID
     , STUDENT_NAME
  FROM
       CLASS_ROOM, STUDENT -- 1절 > 두개의 컬럼이 곱한수 만큼 행이 생성됨
 WHERE
       CLASS_ROOM.CLASS_ID = STUDENT.CLASS_ID; --> 값이 같은 것만 나오도록 조건
       
/*
 * < JOIN >
 * 
 * 두 개 이상의 테이블에서 데이터를 한 번에 조회하기 위해 사용하는 구문
 * 조회결과는 하나의 ResultSet으로 나옴
 * 
 * 관계형 데이터베이스에서는 최소한의 데이터로 각각의 데이터를 보관하고 있음 (중복방지)
 * -> JOIN 구문을 사용해서 여러 개의 테이블 간 "관계"를 맺어서 같이 조회 해야함
 * => 무작정 JOIN을 해서 조인하는 것이 아니고 테이블 간 매칭을 할 수 있는 컬럼이 존재해야함
 * 
 * JOIN은 크게 "오라클 전용구문"과 "ANSI(미국국립표준협회)구문"으로 나뉜다.
 * 
 * ===============================================================
 * 		오라클 전용 구문          |        ANSI(오라클 + 타 DBMS) 구문
 * ===============================================================
 *         등가조인             |               내부조인
 *      (EQUAL JOIN)         |            (INNER JOIN)
 * ----------------------------------------------------------------
 *         포괄조인             |  왼쪽 외부조인(LEFT OUTER JOIN)
 *      (LEFT OUTER)         |  오른쪽 외부조인(RIGHT OUTER JOIN)
 *     (RIGHT OUTER)         |  전체 외부조인(FULL OUTER JOIN) -> 오라클에선 X
 * -----------------------------------------------------------------
 *        카테시안 곱           |               교차조인
 *   (CARTESIAN PRODUCT)     |             (CROSS JOIN)
 * --------------------------------------------------------------------
 * 자체조인(SELF JOIN)
 * 비등가조인(NON EQUAL JOIN)
 * 자연조인(NATURAL JOIN)
 */
       
/*
 * 1. 등가조인(EQUAL JOIN) / 내부조인(INNER JOIN)
 * 
 * JOIN 시 연결시키는 컬럼의 값이 일치하는 행들만 조인되서 조회
 * ( == 일치하지 않는 값들을 조회에서 제외)
 */
  
--> 오라클 전용 구문
--> SELECT 절에는 조회하고 싶은 컬럼명을 각각 기술
-->   FROM 절에는 조회하고자 하는 테이블을 , 를 이용해서 전부다 나열
-->  WHERE 절에는 매칭을 시키고자 하는 컬럼명에 대한 조건을 제시함 ( = )

-- 전체 사원들의 사원명, 부서코드, 부서명을 한꺼번에 조회
SELECT * FROM EMPLOYEE; -- EMP_NAME, DEPT_CODE
SELECT * FROM DEPARTMENT; -- DEPT_ID, DEPT_TITLE

-- CASE 1. 연결할 두 칼럼의 칼럼명이 다른 경우(DEPT_CODE - DEPT_ID)
SELECT
       EMP_NAME
     , DEPT_CODE
     , DEPT_ID
     , DEPT_TITLE
  FROM 
       EMPLOYEE
     , DEPARTMENT
 WHERE
       DEPT_CODE = DEPT_ID;
-- 207개 행중에 21개행만 일치, 부서값이 없던 사원은 제외되었음
-- DEPT_ID가 D3, D4, D7인 부서데이터가 조회되지 않는다.

-- 전체 사원들의 사원명, 직급코드, 직급명
SELECT * FROM JOB; -- JOB_CODE, JOB_NAME
SELECT * FROM EMPLOYEE; -- EMP_NAME, JOB_CODE

SELECT
       EMP_NAME
     , JOB_CODE
     , JOB_CODE
     , JOB_NAME
  FROM 
       EMPLOYEE
     , JOB
 WHERE
       JOB_CODE = JOB_CODE; --> 실행 불가

-- 방법 1. 테이블명을 사용하는 방법
SELECT
       EMP_NAME
     , EMPLOYEE.JOB_CODE
     , JOB.JOB_CODE
     , JOB_NAME
  FROM 
       EMPLOYEE
     , JOB
 WHERE
       EMPLOYEE.JOB_CODE = JOB.JOB_CODE; 

-- 방법 2. 별칭 사용(각 테이블마다 별칭 부여 가능)
SELECT
       EMP_NAME
     , E.JOB_CODE
     , J.JOB_CODE
     , JOB_NAME
  FROM 
       EMPLOYEE E -- 실행순서 첫번째인 FROM에서 단 별칭이므로 이후 단계에서 모두 사용 가능
     , JOB J
 WHERE
       E.JOB_CODE = J.JOB_CODE;

--> ANSI 구문
-- FORM절에 기준테이블을 하나 기술한 뒤 
-- 그 뒤에 JOIN절에 같이 조회하고자하는 테이블을 기술(매칭시킬 컬럼에 대한 조건도 기술)
-- USING / ON 구문

-- EMP_NAME, DEPT_CODE, DEPT_TITLE
-- 사원명, 부서코드, 부서명
-- 연결컬럼이 컬럼명이 다름(EMPLOYEE - DEPT_CODE / DEPARTMENT - DEPT_ID)
-- 무조건 ON구문만 사용가능(USING은 사용불가)
SELECT
       EMP_NAME
     , DEPT_CODE
     , DEPT_TITLE
  FROM
       EMPLOYEE
--INNER(생략가능)
  JOIN
       DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- EMP_NAME, JOB_CODE, JOB_NAME
-- 사원명, 직급코드, 직급명
-- 연결할 두 컬럼명이 같을 경우(JOB_CODE)
-- ON 구문 이용 > 애매하다 발생할 수 있음, 어떤테이블의 컬럼인지 명시
SELECT
       EMP_NAME
     , E.JOB_CODE
     , JOB_NAME
  FROM
       EMPLOYEE E
  JOIN     
       JOB J ON (E.JOB_CODE = J.JOB_CODE);

-- USING 구문 이용 > 컬럼명이 동일할 경우 사용이 가능하며, 동등비교연산자를 기술하지 않음
SELECT
       EMP_NAME
     , JOB_CODE
     , JOB_NAME
  FROM
       EMPLOYEE
  JOIN 
       JOB USING (JOB_CODE);

-- [참고사항] NATURAL JOIN(자연조인)
SELECT
       EMP_NAME
     , JOB_CODE
     , JOB_NAME
  FROM
       EMPLOYEE
NATURAL       
  JOIN 
       JOB;
-- 두 개의 테이블을 조인하는데 운 좋케도 두 개의 테이블에 일치하는 컬럼이 딱 하나있었다.
-- 사실상 쓰일 일이 없다.


-- < Quiz >
-- 사원명과 직급명을 같이 조회해주세요. 단 직급명이 대리인 사원들만 조회.

-- ORACLE 문법
SELECT
       EMP_NAME
     , JOB_NAME
  FROM
       EMPLOYEE E
     , JOB J
 WHERE
       E.JOB_CODE = J.JOB_CODE
   AND
       J.JOB_NAME = '대리';

-- ANSI 문법
SELECT
       EMP_NAME
     , JOB_NAME
  FROM
       EMPLOYEE E
  JOIN
       JOB J ON (E.JOB_CODE = J.JOB_CODE)
 WHERE
       JOB_NAME = '대리';

-- EQUAL JOIN / INNER JOIN : 일치하지 않는 행은 애초에 ResultSet에 포함시키지 않음
----------------------------------------------------------------------









