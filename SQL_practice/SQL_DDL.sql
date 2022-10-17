-- DDL, data definition language

-- 제약조건 생성, constraint
-- 테이블에 들어갈 수 있는 데이터 유형을 제한
-- NOT NULL , 컬럼이 NULL값을 가질 수 없도록 설정
-- UNIQUE, 열의 모든 값이 서로 다른지 확인
-- Primary key, 테이블의 각 행을 고유하게 식별
-- Foreign key, 테이블 간의 연결
-- CHECK, 컬럼 값이 특정 조건 만족 여부를 판정
-- DEFAULT, 값이 지정되지 않은 경우 기본값을 설정

-- 테이블 생성
CREATE TABLE Persons (
	ID INT NOT NULL,
	LastName VARCHAR(255) NOT NULL,
	FirstName VARCHAR(255) NOT NULL,
	Age INT
);

-- 테이블 생성 확인.
SHOW TABLES;
DESC Persons;

-- Age 컬럼에 대한 제약조건 생성
ALTER TABLE Persons
MODIFY Age INT NOT NULL;

/* DESC Persons;
DROP TABLE Persons; */

-- ID 컬럼에 UNIQUE 제약조건 
CREATE TABLE Persons (
	ID INT NOT NULL,
	LastName VARCHAR(255) NOT NULL,
	FirstName VARCHAR(255) NOT NULL,
	Age INT,
	UNIQUE(ID)
);

-- DROP TABLE Persons;

-- 제약조건 이름을 설정하고, 2개 이상의 컬럼에 제약조건을 정의
CREATE TABLE Persons (
	ID INT NOT NULL,
	LastName VARCHAR(255) NOT NULL,
	FirstName VARCHAR(255) NOT NULL,
	Age INT,
	CONSTRAINT UC_Person UNIQUE (ID, LastName)
);

DROP TABLE Persons;
DESC Persons;

-- 테이블이 이미 생성된 경우, 제약 조건 생성변경삭제
ALTER TABLE Persons
ADD UNIQUE (ID);

ALTER TABLE Persons
DROP INDEX UC_Person;


