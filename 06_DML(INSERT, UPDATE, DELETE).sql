/*
 * < DML : DATA MANIPULATION LANGUAGE >
 *         데이터     조작         언어
 * 
 * 논외) SELECT : DML(클래식) / DQL(모던)
 * 
 * INSERT / UPDATE / DELETE
 * 
 * 테이블에 새로운 데이터를 삽입(INSERT)하거나,
 * 테이블에 존재하는 데이터를 수정(UPDATE)하거나,
 * 테이블에 존재하는 데이터를 삭제(DELETE)하는 구문
 */
/*
 * 1. INSERT : 테이블에 새로운 행을 추가해주는 구문
 * 
 * [ 표현법 ]
 * 
 * 1) INSERT INTO 테이블명 VALUES (값, 값, 값,....);
 * 
 * => 해당 테이블에 모든 컬럼에 추가하고자 하는 값을 직접 입력해서 한 행을 INSERT할 때 사용
 * ※ 주의할 점 : 값의 순서를 컬럼의 순서와 동일하게 작성해야 함
 */
SELECT * FROM EMPLOYEE;

INSERT 
  INTO 
       EMPLOYEE 
VALUES 
       (
       223
     , '김태호'
     , '991231-1234567'
     , 'kth04@kh.or.kr'
     , '01064349564'
     , 'D9'
     , 'J5'
     , 'S4'
     , 5000000
     , NULL
     , NULL
     , SYSDATE
     , NULL
     , 'N'
       );

SELECT * FROM EMPLOYEE WHERE EMP_ID = 223;

/*
 * 2) INSERT INTO 테이블명(컬럼명, 컬럼명, 컬럼명) VALUES(값, 값, 값);
 * => 테이블 특정 컬럼만 선택해서 컬럼에 값을 추가하면서 행을 추가할 때 사용
 * INSERT는 무조건 행 단위로 추가가 되기 때문에 작성하지 않은 컬럼은 NULL값이 들어감
 * 
 * 주의할 점 ) NOT NULL이 달려있는 컬럼은 반드시 테이블 명 뒤에 컬럼명을 적어야함
 * 예외사항 ) NOT NULL 제약조건이 달려있는데 기본값이 있는 경우는 DEFAULT VAUE가 들어감
 */
INSERT 
  INTO 
       EMPLOYEE
       (
       EMP_ID
     , EMP_NAME
     , EMP_NO
     , JOB_CODE
     , SAL_LEVEL
       )
VALUES
       (
       900
     , '고길동'
     , '580630-1212123'
     , 'J5'
     , 'S1'
       );

SELECT * FROM EMPLOYEE;
---------------------------------------------------------------------
/*
 * 3) INSERT INTO 테이블명 (서브쿼리);
 * => VALUES 대신에 서브쿼리를 작성해서 INSERT 할 수 있음
 */
-- 새 테이블 하나 만들기
CREATE TABLE EMP_01(
  EMP_NAME VARCHAR2(20),
  DEPT_TITLE VARCHAR2(20)
);
SELECT * FROM EMP_01;

-- EMPLOYEE 테이블에 존재하는 모든 사원 사원명과, 부서명을 새로 만든 EMP_01에 INSERT

INSERT
  INTO
       EMP_01
       (
       SELECT
              EMP_NAME
            , DEPT_TITLE
         FROM
              EMPLOYEE
            , DEPARTMENT
        WHERE
              DEPT_CODE = DEPT_ID(+)
       );

SELECT * FROM EMP_01;
-----------------------------------------------------------------------
/*
 * 4) INSERT ALL ☆★☆
 * 
 * 하나의 테이블에 여러 행을 한꺼번에 INSERT할 때 사용
 * 
 * INSERT 
 *    ALL
 *        INTO 테이블명 VAUES(값, 값, 값, ...)
 *        INTO 테이블명 VAUES(값, 값, 값, ...)
 * SELECT *
 *   FROM DUAL;
 */
INSERT 
  INTO 
       EMP_01
VALUES
       ('사원1', '부서1');

INSERT 
  INTO 
       EMP_01
VALUES
       ('사원2', '부서2');

INSERT 
  INTO 
       EMP_01
VALUES
       ('사원3', '부서3');
SELECT * FROM EMP_01;

------------
INSERT 
   ALL
       INTO EMP_01 VALUES('사원4', '부서4')
       INTO EMP_01 VALUES('사원5', '부서5')
       INTO EMP_01 VALUES('사원6', '부서6')
SELECT
       *
  FROM
       DUAL;

--------------------------------------------------------------------------
/*
 * 2. UPDATE
 * 테이블에 기록된 기존의 데이터를 수정하는 구문
 * 
 * [ 표현법 ]
 * UPDATE
 *        테이블명
 *    SET
 *        컬럼명 = 바꿀값
 *      , 컬럼명 = 바꿀값
 *      , 컬럼명 = 바꿀값 (, 써야함! AND 아님)
 *  WHERE
 *        조건식; => 생략가능
 */
 
-- 테이블 복사하기
CREATE TABLE DEPT_COPY
   AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

-- DEPT_COPY 테이블에서 총무부 부서명을 미래사업부로 변경
UPDATE
       DEPT_COPY
   SET
       DEPT_TITLE = '미래사업부'; -- 9행 전부 다 미래사업부로 변경됨
       
SELECT * FROM DEPT_COPY;

-- 다시 해보자
CREATE TABLE DEPT_COPY2
   AS SELECT * FROM DEPARTMENT;

UPDATE
       DEPT_COPY2
   SET
       DEPT_TITLE = '미래사업부'
 WHERE
       DEPT_TITLE = '총무부'; -- 총무부만 미래사업부로 바꾸게 조건

SELECT * FROM DEPT_COPY2;

UPDATE
       EMPLOYEE
   SET
       SALARY = 100
 WHERE
       EMP_ID = 204;

SELECT * FROM EMPLOYEE;

-- 전체 사원들 급여를 5%인상
UPDATE
       EMPLOYEE
   SET
       SALARY = SALARY * 1.05;

SELECT * FROM EMPLOYEE;
----------------------------------------------------------------------------------------
/*
 * UPDATE 사용시 서브쿼리 사용해보기
 * 
 * UPDATE
 *        테이블명
 *    SET
 *        컬럼명 = (서브쿼리)
 *  WHERE
 *        조건;
 */
-- 안예성 사원의 급여를 김하늘 사원의 급여만큼으로 갱신
UPDATE
       EMPLOYEE
   SET
       SALARY = ( -- 여기선 대입의 기능
                 SELECT
                        SALARY
                   FROM
                        EMPLOYEE
                  WHERE
                        EMP_NAME = '김하늘')
WHERE
      EMP_ID = (SELECT -- 여기선 비교의 기능, 안예성이라는 이름이 2명 이상이라면 대입이 불가해서 돌지 않음
                       EMP_ID
                  FROM
                       EMPLOYEE
                 WHERE
                       EMP_NAME = '안예성');

SELECT * FROM EMPLOYEE;
--------------------------------------------------------------------------------------
/*
 * 3. DELETE
 * 테이블에 기록된 행을 삭제하는 구문
 * 
 * [ 표현법 ]
 * DELETE
 *   FROM
 *        테이블명
 *  WHERE
 *        조건; => 생략가능, 생략하면 모든 행 삭제
 */

DELETE
  FROM
       DEPT_COPY2
 WHERE
       DEPT_TITLE = '미래사업부';

SELECT * FROM DEPT_COPY2;

-------------------------------------------------------
/*
 * TRUNCATE : 테이블의 전체 행을 삭제하는데 사용하는 구문
 *            DELETE보다 빠름(이론적으로)
 *            별도의 조건을 부여할 수 없음, ROLLBACK 불가능
 */
DELETE
  FROM
       DEPT_COPY;
TRUNCATE TABLE DEPT_COPY;









































