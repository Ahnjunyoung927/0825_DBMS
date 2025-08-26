/*
 * 함수 < FUNCTION >
 * 
 * 자바로 따지면 메소드
 * 전달된 값을 가지고 계산된 결과를 변환해준다
 * 
 * - 단일행 함수 : N개의 값을 읽어서 N개의 결과를 반환(매 행마다 함수 결과 반환)
 * - ☆★ 그룹 함수 ☆★ : N개의 값을 읽어서 1개의 결과를 반환(그룹별로 함수 결과 반환)
 * 
 * 단일행 함수와 그룹함수는 함께 사용 할 수 없음 : 결과 행의 개수가 다르기 때문
 */
-------------------< 단일행 함수 >------------------------
/*
 * < 문자열과 관련된 함수 >
 * LENGTH / LENGTHB
 * 
 * STR : '문자열' / 문자열이 들어가 있는 컬럼
 * equals.length(); <-- 얘랑 같다
 * - LENGTH(STR) : 전달된 문자열의 글자 수 반환
 * - LENGTHB(STR) : 전달된 문자열의 바이트 수 반환
 * 
 * 결과는 NUMBER타입
 * 한글 : 'ㄱ', 'ㅏ', '강' => 한 글자당 3Byte
 * 숫자, 영어, 특수문자 => 한글자당 1Byte
 */
SELECT 
       LENGTH('오라클!')
     , LENGTHB('오라클!')
  FROM 
       DUAL; --가상테이블(DUMMY TABLE)

SELECT
       EMAIL
     , LENGTH(EMAIL)
  FROM
       EMPLOYEE;
-------------------------------------------------------------------
/*
 * INSTR
 * 
 * - INSTR(STR) : 문자열로부터 특정 문자의 위치값 반환
 * 
 * INSTR(STR, '특정 문자', 찾을 위치의 시작값, 순번)
 * 
 * 결과값은 NUMBER타입으로 반환
 * 찾을 위치의 시작값과 순번은 생략이 가능
 * 
 * 찾을 위치의 시작값
 * 1 : 앞에서부터 찾겠다.(기본값)
 * -1 : 뒤에서부터 찾겠다.
 */
SELECT 
       INSTR('AABAACAABBAA', 'BAA')
  FROM 
       DUAL;

SELECT 
       INSTR('AABAACAABBAA', 'B', -1)
  FROM 
       DUAL; -- 뒤에서부터 첫번째 'B'가 앞에서부터 몇 번째인지

SELECT
       INSTR('AABAACAABBAA', 'B', 1, 3)
  FROM 
       DUAL; -- 앞에서부터 세번째 'B'가 앞에서부터 몇 번째인지

SELECT 
       INSTR(EMAIL, '@') AS "@의 위치"
  FROM 
       EMPLOYEE;
--------------------------------------------------------------
/*
 * SUBSTR
 * - SUBSTR(STR, POSITION, LENGH) : 문자열로부터 특정 문자열을 추출해서 반환
 * - STR : '문자열' 또는 문자타입 컬럼 값
 * - POSITION : 문자열 추출 시작위치값(POSITION번째 문자부터 추출) -> 음수도 가능
 * - LENGTH : 추출할 문자 개수 (생략 시 끝까지라는 의미)
 */
SELECT
       SUBSTR('KH정보교육원', 3) -- > 3번쨰 글자부터 끝까지
  FROM
       DUAL;

SELECT
       SUBSTR('KH정보교육원', 3, 2) --> 3번째 글자부터 시작해서 총 2글자만
  FROM
       DUAL;

SELECT 
       SUBSTR('KH정보교육원', -3, 2) --> 뒤에서 3번째 글자부터 시작해서 총 2글자만
  FROM
       DUAL;

-- EMPLOYEE 테이블로부터 사원명과 이메일컬럼과 EMAIL컬럼에서의 아이디값만 추출해서 조회
SELECT 
       EMP_NAME
     , SUBSTR(EMAIL, 1, (INSTR(EMAIL, '@') - 1)) "아이디"
  FROM
       EMPLOYEE;
 
SELECT 
       SUBSTR(SYSDATE - HIRE_DATE, 1, INSTR(SYSDATE - HIRE_DATE, '.') - 1) "근무일수"
  FROM
       EMPLOYEE;

SELECT
       EMP_NAME 
     , SUBSTR(EMP_NO, 8, 1)
  FROM
       EMPLOYEE;

-- 남성 사원들만 이름을 조회
SELECT
       EMP_NAME
  FROM 
       EMPLOYEE
 WHERE
       SUBSTR(EMP_NO, 8, 1) = 1
    OR 
       SUBSTR(EMP_NO, 8, 1) = 3;
------------------------------------------------------------------------
/*
 * LPAD / RPAD
 * LEFTPADDING / RIGHTPADDING
 * 
 * - LPAD / RPAD (STR, 최종적으로 반환할 문자의 길이(바이트), 패딩할 문자)
 * : 인자로 전달한 문자열에 임의의 문자를 왼쪽 또는 오른쪽에 덧붙여서 N길이 만큼의 문자열 반환
 * 
 * 결과값은 CHARACTER 타입으로 반환
 * 덧붙이고자하는 문자느 생략 가능
 * 
 */

SELECT
       EMAIL
  FROM
       EMPOLYEE;

SELECT
       LPAD(EMAIL, 25)
  FROM
       EMPLOYEE;

SELECT 
       LPAD(EMAIL, 25, '!')
  FROM
       EMPLOYEE;

SELECT  
       EMP_NAME
     , EMP_NO
  FROM 
       EMPLOYEE;

-- EMPLOYEE 테이블에서 모든 직원의 사원명과 주민등록번호 뒤 6자리를 마스킹 처리해서 조회하기
-- 예시 => 이** 621235-1******

SELECT
       RPAD(SUBSTR(EMP_NAME, 1, 1), 4, '*')
     , RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*')
  FROM
       EMPLOYEE;
-----------------------------------------------------------------------------
/*
 * LTRIM / RTRIM / TRIM
 * 
 * - LTRIM / RTRIM(STR, 제거하고자하는 문자)
 * : 문자열의 왼쪽, 오른쪽 또는 양쪽에서 제거하고자 하는 문자들을 찾아서 제거한 나머지 문자열을 반환
 * 
 * 결과값은 CHARACTER 타입으로 반환
 */
SELECT
       LTRIM('       K H')
  FROM
       DUAL;

SELECT  
       LTRIM('123123KH123', '123')
  FROM
       DUAL;
-------------------------------------------------------------------------
/*
 * TRIM
 * 
 * -TRIM(BOTH / LEADING / TRAILING '제거하고자 하는 문자' FROM STR)
 * : 문자열의 앞 / 뒤 / 양쪽에 있는 문자를 제거한 나머지 문자열을 반환
 * 
 * 결과값은 CHARACTER
 * BOTH / LEADING / TRAILING은 생략 가능 참고로 생략시 기본값은 BOTH
 */
SELECT 
       TRIM('   K   H    ')
  FROM
       DUAL; --BOTH 양쪽제거
       
SELECT 
       TRIM(LEADING 'Z' FROM 'ZZZKHZZZ') -- 앞쪽 제거
  FROM
       DUAL; 

SELECT
       TRIM(TRAILING 'Z' FROM 'ZZZKHZZZ') -- 뒤쪽제거
  FROM
       DUAL;

-----------------------------------------------------------------
/*
 * LOWER / UPPER / INITCAP
 * 
 * -LOWER(STR)
 * :다 소문자로
 * 
 * -UPPER(STR)
 * :다 대문자로
 * 
 * -INITCAP
 * : 각 단어마다 앞글자만 대문자로 변경
 * 
 * 결과값은 모두 CHARACTER 타입으로 반환
 */

SELECT
       LOWER('HELLO WORLD')
  FROM
       DUAL;
       
SELECT  
       UPPER('hello world')
  FROM
       DUAL;

SELECT
       INITCAP('hello world')
  FROM 
       DUAL;
---------------------------------------------------------------------
/*
 * CONCAT
 * 
 * - CONCAT(STR1, STR2)
 * : 전달될 두 개의 인자를 하나로 합친 결과를 반환
 * 
 * 반환타입은 CHARACTER
 */

SELECT
       CONCAT('경실련 하이텔', ' 정보교육원')
  FROM   
       DUAL;
----------------------------------------------------------------------
/*
 * REPLACE
 * 
 * - REPLACE(STR, 찾을 문자, 바꿀 문자)
 * : STR로부터 찾을 문자를 찾아서 바꿀 문자로 문자열를 반환
 * 결과값은 CHARACTER
 */
SELECT 
       REPLACE('서울시 중구 남대문로 120 대일빌딩', '대일빌딩', '그레이츠 청계')
  FROM
       DUAL;

SELECT
       EMAIL
     , REPLACE(EMAIL, 'kh.or.kr', 'iei.co.kr')
  FROM 
       EMPLOYEE;
 ------------------------------------------------------------------------
/*
 * MOD
 * 나머지 구하기
 */
SELECT 
       MOD(10, 3)    -- 1
     , MOD(-10, 3)   -- -1
     , MOD(10.8, 3)  -- 1.8
  FROM
       DUAL;
--------------------------------------------------------------------------
/*
 * ROUND
 * 
 * - ROUND(NUMBER, 위치) : 반올림 처리해주는 함수
 * 
 * 위치: 소수점 아래 N번째 위치까지 지정할수 있음
 * 생략도 가능, 생략시 기본값은 0
 */
SELECT 
       ROUND(123.456)
     , ROUND(123.456, 1)
     , ROUND(123.456, 2)
     , ROUND(123.456, -1) -- 정수부분에서 반올림
     , ROUND(123.456, -2) -- 정수부분에서 반올림
  FROM
       DUAL;
--------------------------------------------------------------
/*
 * FLOOR
 * 
 * - FLOOR(NUMBER) 소수점 아래의 수를 무조건 버림처리해주는 함수
 * 
 * CEIL
 * -CEIL(NUMBER) 소수점 아래의 수를 무조건 올림처리해주는 함수
 */
SELECT 
       FLOOR(123.45 * 10) / 10
  FROM
       DUAL;

SELECT 
       CEIL(123.45)
  FROM
       DUAL;

-- 각직원 별로 고용일로부터 오늘까지의 근무 일수 조회 + 이름조회
SELECT
       EMP_NAME
     , CONCAT(FLOOR(SYSDATE - HIRE_DATE), '일') "근무일수"
  FROM
       EMPLOYEE;

SELECT 
       EMP_NAME
     , CONCAT(FLOOR(SYSDATE - HIRE_DATE), '일') "근무일수"
  FROM
       EMPLOYEE
 WHERE
       FLOOR(SYSDATE - HIRE_DATE) > 365 * 17;

------------------------------------------------------------------
/*
 * TRUNC
 * - TRUNC(NUMBER, 위치) : 위치지정이 가능한 삭제처리 함수
 * 
 * 
 */
SELECT
       TRUNC(123.456, 2) -- 소수점 2번째 자리까지 남기고 뒤는 삭제
  FROM 
       DUAL;
-----------------------------------------------------------------
/*
 * < 날짜 관련 함수 >
 * DATE 타입 : 년, 월, 일, 시, 분, 초를 모두 포함한 자료형
 * TIMESTAMP <- 얘는 나중에
 */

SELECT 
       SYSDATE
     , SYSTIMESTAMP
  FROM
       DUAL;

-- MONTHS_BETWEEN(DATE1, DATE2) : 두 날짜사이의 개월 수 반환(NUMBER)
-- EMPLOYEE 테이블에서 각 사원의 사원명, 고용일로부터 근무일수

SELECT
       EMP_NAME
     , FLOOR(SYSDATE - HIRE_DATE) || '일' AS "근무일수"
     , FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월' AS "근무개월수"
  FROM
       EMPLOYEE;

--ADD_MONTHS(DATE, NUMBER) : 특정날짜에 해당 숫자만큼의 개월 수를 더한 날짜(DATE로 반환)
SELECT
       ADD_MONTHS(SYSDATE, 4)
  FROM
       DUAL;

-- NEXT_DAY(DATE, 요일) : 특정날짜에서 가장 가까운 요일을 찾아 그 날짜를 반환
SELECT 
       NEXT_DAY(SYSDATE, '금요일')
     , NEXT_DAY(SYSDATE, '금')
     , NEXT_DAY(SYSDATE, 6) -- 1 : 일요일, 2 : 월요일 ... 7 : 토요일
  FROM
       DUAL;

-- 언어변경 ALTER SESSION SET NLS_LANGUAGE = AMERICAN; // KOREAN

-- LAST_DAY(DATE) 날짜를 받아서 해당 날짜가 있는 달의 마지막 날짜를 반환
SELECT
       LAST_DAY(SYSDATE)
  FROM
       DUAL;

------------------------------------------------------------------
/*
 * ☆★EXTRACT : 년도 또는 월 또는 일 정보를 추출해서 반환(NUMBER 타입)
 * 
 * - EXTRACT(YEAR FROM DATE) : 년도만 추출
 * - EXTRACT(MONTH FROM DATE) : 월만 추출
 * - EXTRACT(DAY FROM DATE) : 일만 추출
 */
-- EMPLOYEE 테이블에서 사원명 입사년도 입사월 입사일
SELECT
       EMP_NAME
     , EXTRACT(YEAR FROM HIRE_DATE) AS "년도"
     , EXTRACT(MONTH FROM HIRE_DATE) AS "월"
     , EXTRACT(DAY FROM HIRE_DATE) AS "일"
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) AS "근속년수"
  FROM
       EMPLOYEE
 ORDER
    BY
       "년도", "월", "일";
--------------------------------------------------------------------------------
/*
 * < 형변환 함수>
 * 
 * NUMBER / DATE => CHARACTER
 * 
 * - TO_CHAR(NUMBER/DATE, 포맷) : 숫자 또는 날짜 데이터를 문자 데이터 타입으로 반환
 */

SELECT 
       1234
     , TO_CHAR(1234)
     , TO_CHAR(1234, '000000000') -- 자리수보다 큰 공간을 0으로 채움
     , TO_CHAR(1234, '999999999') -- 자리수보다 큰 공간을 공백문자로 채움
     , TO_CHAR(1234, 'L00000000') -- 설정된 나라(LOCAL)의 화폐단위
     , TO_CHAR(12341234, '$99999999')
     , TO_CHAR(12341234, 'L999,999,999,999')
  FROM
       DUAL;
-----------------------------------------------------------------------
--DATE(년월일시분초) => CHARACTER 

SELECT 
       SYSDATE
     , TO_CHAR(SYSDATE)
     , TO_CHAR(SYSDATE, 'YYYY-MM-DD')
     , TO_CHAR(SYSDATE, 'PM HH:MI:SS') -- AM/PM 오전 / 오후 출력
     , TO_CHAR(SYSDATE, 'HH24:MI:SS')  -- 24시간 표기형식
     , TO_CHAR(SYSDATE, 'MON DY, YYYY') -- 월, 요일, 년도
  FROM
       DUAL;
----------------------------------------------------------------------
-- 년도 쓸 수 있는 포맷
SELECT 
       TO_CHAR(SYSDATE, 'YYYY')
     , TO_CHAR(SYSDATE, 'RRRR')
     , TO_CHAR(TO_DATE('26-95', 'DD-YY'), 'YYYY')
     , TO_CHAR(TO_DATE('26-95', 'DD-RR'), 'YYYY')
     , TO_CHAR(SYSDATE, 'YEAR')
  FROM
       DUAL;

-- 월에 쓸 수 있는 포맷
SELECT
       TO_CHAR(SYSDATE, 'MM')
     , TO_CHAR(SYSDATE, 'MON')
     , TO_CHAR(SYSDATE, 'MONTH')
     , TO_CHAR(SYSDATE, 'RM') --로마숫자
  FROM
       DUAL;

-- 일에 쓸 수 있는 포멧
SELECT 
       TO_CHAR(SYSDATE, 'DD')
     , TO_CHAR(SYSDATE, 'D') -- 요일에 해당하는 숫자
     , TO_CHAR(SYSDATE, 'DDD') -- 1월1일로부터 몇일째인가
  FROM
       DUAL;
-- DD : 한달기준
-- D : 일주일기준(일요일부터)
-- DDD : 일년기준(1월1일부터)

SELECT
       TO_CHAR(SYSDATE, 'DAY')
     , TO_CHAR(SYSDATE, 'DY')
  FROM
       DUAL;

SELECT 
       EMP_NAME
     , TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일" (DY)')
  FROM
       EMPLOYEE;
-- 한글이 쓰고 싶다면 ""로 묶어주어야함

----------------------------------------------------------------
/*
 * NUMBER / CHARACTER => DATE
 * 
 * - TO_DATE(NUMBER, CHARACTER, 포맷) : 숫자/문자를 날짜로 변환(DATE로 반환)
 */
SELECT 
       TO_DATE(20250826)
     , TO_DATE('001212') AS D -- 0으로 시작하면 인식하지 못하므로 ''로 묶는다
     , TO_DATE('980607', 'YYMMDD') AS A -- 2000년대로 인식하게 하려면 YY포맷이 필요
  FROM
       DUAL;

-------------------------------------------------------------------
/*
 * CHARACTER => NUMBER
 * 
 * - TO_NUMBER(CHARACTER, 포맷) : 문자를 숫자형으로 변환(NUMBER로 반환)
 */
 SELECT
        TO_NUMBER('01234')
   FROM
        DUAL; 
        
SELECT 
       '123' + '456'
  FROM 
       DUAL;
        
SELECT 
       '11,000' + '20,000'
  FROM
       DUAL; -- 이건 불가능

SELECT 
       TO_NUMBER('44,000', '99,999') + TO_NUMBER('20,000', '99,999')
  FROM 
       DUAL;
------------------------------------------------------------------------------
/*
 * < NULL 처리 함수 >
 * 
 * NVL(컬럼명, 해당 컬럼명이 NULL값일 경우 반환할 결과값)
 */

-- EMPLOYEE 테이블로부터 사원명, 보너스
SELECT 
       EMP_NAME
     , BONUS 
     , NVL(BONUS, 0)
  FROM 
       EMPLOYEE;

-- 보너스를 포함한 연봉조회
SELECT 
       EMP_NAME
     , (SALARY + SALARY * NVL(BONUS, 0)) * 12
     , NVL(DEPT_CODE, '부서 없음')
  FROM
       EMPLOYEE;

-- NVL2(컬럼명, 결과값1, 결과값2)
-- 해당 컬럼에 값이 존재할 경우 결과값 1을 반환
-- 해당 컬럼에 값이 NULL값일 경우 결과값 2를 반환
SELECT 
       EMP_NAME
     , DEPT_CODE
     , NVL2(DEPT_CODE, '부서 배치 완료', '부서없음')
  FROM
       EMPLOYEE;

-- NULLIF(비교대상1, 비교대상2)
-- 두개의 값이 동일할 경우 NULL을 반환
-- 두개의 값이 동일하지 않을 경우 비교대상 1을 반환
SELECT
       NULLIF('1', '1')
     , NULLIF('1', '2')
  FROM
       DUAL;
------------------------------------------------------------
/*
 * < 선택함수 >
 * 
 * DECODE(비교대상(컬럼명/산술연산/함수식), 조건값1, 결과값1, 조건값2, 결과값2.....디폴트결과값(생략가능))
 * 
 * - 자바에서의 switch문과 유사
 * switch(비교대상){
 * case 조건값1 : 결과값1;
 * case 조건값2 : 결과값2;
 * dafault : 결과값;
 * }
 */
-- EMPLOYEE 테이블 사원명, 성별
SELECT
       EMP_NAME
     , DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남성', 2, '여성', '성별 선택 안함') AS "성별"
  FROM
       EMPLOYEE;

-- 직원들의 급여를 인상시켜서 조회
-- 직급코드(JOB_CODE)가 'J7'인 사원들의 급여는 15%인상해서 조회
-- 직급코드가 'J6'인 사원들의 급여는 20% 인상해서 조회
-- 직급코드가 'J5'인 사원들의 급여는 30% 인상해서 조회
-- 나머지 직급인 사원들의 급여는 5% 인상해서 조회

SELECT 
       EMP_NAME
     , SALARY
     , DECODE(JOB_CODE, 'J7', (SALARY + SALARY * 0.15), 'J6', (SALARY + SALARY * 0.2), 
     'J5', (SALARY + SALARY * 0.3), (SALARY + SALARY * 0.05)) AS "인상된 급여"
  FROM 
       EMPLOYEE;
------------------------------------------------------------------------
/*
 * CASE WHEN THEN 구문
 * 
 * - DECOD랑 비교했을 때 DECODE는 동등비교만 수행
 *   CASE WHEN THEN 다양항 조건식을 기술 가능
 * 
 * [ 표현법 ]
 * CASE
 *      WHEN 조건식1 THEN 결과값1
 *      WHEN 조건식2 THEN 결과값2
 *      ...
 *      ELSE 결과값
 * END
 */
SELECT
       EMP_NAME
     , CASE
	    WHEN SUBSTR(EMP_NO, 8, 1) = '1' THEN '남성'
     	WHEN SUBSTR(EMP_NO, 8, 1) = '2' THEN '여성'
     	ELSE '성별 미선택'
       END AS "성별"
  FROM   
       EMPLOYEE;

----------------------------------------------------------------------------

------------------------< ☆그룹 함수★ >----------------------------------
/*
 * N개의 값을 읽어서 1개의 결과를 반환(하나의 그룹별로 함수 실행결과를 반환)
 */
SELECT
       SALARY
  FROM 
       EMPLOYEE;
-- 1. SUM(숫자타입) : 해당 컬럼값들의 총 합계를 반환해주는 함수
-- 전체 사원의 총 급여 합계
SELECT
       SUM(SALARY)
  FROM 
       EMPLOYEE;

SELECT
       EMP_NAME
     , EMAIL
  FROM 
       EMPLOYEE;

-- 이메일에 0이 들어가는 사원들의 총 급여합
-- 부서코드가 D5인 친구들만

SELECT
       SUM(SALARY)
  FROM 
       EMPLOYEE
 WHERE
       EMAIL LIKE '%0%'
   AND
       DEPT_CODE = 'D5';

--------------------------------------------------------------------------------
-- 2. AVG(숫자타입) : 해당 컬럼값들의 평균값을 구해서 반환
-- 전체사원들의 급여 평균구하기
SELECT
       ROUND(AVG(SALARY))
  FROM
       EMPLOYEE;

-- 3. MIN(ANY) : 해당 컬럼값들 중 작은 값 반환
SELECT
       MIN(SALARY) "제일 작은 급여"
     , MIN(EMP_NAME) "이름순이 빠른 사람"
     , MIN(HIRE_DATE) "제일 빠른 입사일"
  FROM
       EMPLOYEE;

-- 4. MAX(ANY) : 해당 컬럼값들 중 큰 값 반환
SELECT
       MAX(SALARY) "가장 높은 급여"
     , MAX(EMP_NAME) "이름순이 느린 사람"
     , MAX(HIRE_DATE) "가장 늦은 입사일"
  FROM
       EMPLOYEE;

-- 5. COUNT(* / 컬럼명 / DISTINCT 컬럼명) : 행 개수 세서 반환
-- COUNT(*) : 조회 결과에 해당하는 모든 행개수르 다 세서 반환
SELECT 
       COUNT(*)
  FROM
       EMPLOYEE;

-- 보너스를 받는 사원의 수
-- COUNT(컬럼명) : 제시한 컬럼값이 NULL이 아닌 행만 개수를 세서 반환
SELECT 
       COUNT(BONUS)
  FROM
       EMPLOYEE;

SELECT
       COUNT(*)
  FROM
       EMPLOYEE
 WHERE 
       BONUS IS NOT NULL;

-- 현재 사원들이 속해있는 부서 개수
-- COUNT(DISTINCT 컬럼명) : 제시한 해당 컬럼값이 중복값이 존재할 경우 하나로만 세서 반환
SELECT 
       COUNT(DISTINCT DEPT_CODE)
  FROM 
       EMPLOYEE;





