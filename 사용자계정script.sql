-- 한 줄 주석
/*
 * 범위 주석
 * <sys> : <> 안에 계정명이 들어가있음!
 * */

-- 선택한 SQL 수행 : 구문에 커서 두고 ctrl + enter하여 각 줄마다 수행을 시켜야함!
-- 전체 SQL 수행 : ctrl + a (전체 선택) 하고 alt + x (전체 수행)
-- SQL(Structured Query Language, 구조적 질의 언어)
-- 데이터베이스와 상호작용을 하기 위해 사용하는 표준 언어(DB에서 사용하는 문법)
-- 데이터의 조회(R), 삽입(C), 수정(U), 삭제(D) 등

-- 새로운 사용자 계정 생성 (sys : 최고 관리자 계정) 이하 새로운 계정 생성을 도와주는 스크립트임!!
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
-- 11G 이전 문법 사용 허용을 위해 작성

CREATE USER kh_jwj IDENTIFIED BY kh1234;
-- 계정 생성 구문 (ID : kh_jwj / PW : kh1234) (★)

GRANT RESOURCE, CONNECT TO kh_jwj;
-- 사용자 계정 권한 부여 설정 (★)
-- RESOURCE : 테이블이나 인덱스 같은 DB 객체를 생성할 권한
-- CONNECT : DB에 연결하고 로그인 할 수 있는 권한

ALTER USER kh_jwj DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;
-- 객체가 생성될 수 있는 공간 할당량 무제한 지정, 구문 맨 끝에 세미콜론 1개 있어야함!

/* 시험 범위 문제 범위
 * -----------------------------------------------
 * <SYS> 사용자 계정 SCRIPT!!!
 * 맨처음 사용자 계정 생성
 * SYS : 최고관리자 계정 으로 접속해야함!
 * 권한부여했었음
 * GRAND RESOUCE 와 CONNECT 있어야
 * 테이블을 생성할 수 있는 권한이 생김
 * -----------------------------------------------------
 * <kh_jwj> 01_SELECT
 * 비교연산자 사용방법
 * 논리연산자 유의할 점 : 우선순위(AND > OR)
 * ESCAPE 문자(# 또는 ^) LIKE '___#_%'
 * IS NULL, IS NOT NULL
 * ------------------------------------------------------
 * */

/* workbook 문제 해결을 위한 할 것들*/
CREATE USER workbook IDENTIFIED BY workbook;
GRANT RESOURCE, CONNECT TO workbook;
ALTER USER workbook DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;
/* 이후 플러그 모양 클릭 후 오라클, xe,  id=workbook, pw=workbook*/



