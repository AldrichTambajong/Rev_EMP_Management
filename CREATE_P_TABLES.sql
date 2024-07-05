set serveroutput on;
-- Create tables and populate with random objects
CREATE TABLE P_DEPARTMENTS(
    ID NUMBER NOT NULL PRIMARY KEY,
    DEPT_NAME VARCHAR(25) NOT NULL,
    DEPT_HEAD VARCHAR2(36) 
);

CREATE TABLE P_POSITIONS(
    ID NUMBER NOT NULL PRIMARY KEY,
    TITLE VARCHAR(25) NOT NULL,
    DESCRIPION VARCHAR(150)
);

CREATE TABLE P_EMPLOYEES(
    ID VARCHAR2(36) NOT NULL PRIMARY KEY,
    FIRST_NAME VARCHAR(20) NOT NULL,
    LAST_NAME VARCHAR(20) NOT NULL,
    EMAIL VARCHAR(20) UNIQUE NOT NULL,
    DEPT_ID NUMBER,
    POSITION_ID NUMBER,
    CONSTRAINT fk_departments FOREIGN KEY (DEPT_ID) REFERENCES P_DEPARTMENTS(ID)
    ON DELETE CASCADE,
    CONSTRAINT fk_positions FOREIGN KEY (POSITION_ID) REFERENCES P_POSITIONS(ID)
    ON DELETE CASCADE
);

-- Sequences to create PRIMARY KEYS for P_POSITIONS and P_DEPARTMENTS tables
CREATE SEQUENCE dept_id_seq 
    INCREMENT BY 10
    START WITH 10
    MAXVALUE 9999
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE positions_id_seq 
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 9999
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE unique_email_seq 
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 9999
    NOCACHE
    NOCYCLE;

-- Inserts P_POSITIONS and P_DEPARTMENTS tables with objects  
INSERT INTO P_DEPARTMENTS VALUES (dept_id_seq.NEXTVAL,'Marketing', NULL);
INSERT INTO P_DEPARTMENTS VALUES (dept_id_seq.NEXTVAL,'IT',NULL);
INSERT INTO P_DEPARTMENTS VALUES (dept_id_seq.NEXTVAL,'Finance', NULL);
INSERT INTO P_DEPARTMENTS VALUES (dept_id_seq.NEXTVAL,'Operations', NULL);
INSERT INTO P_DEPARTMENTS VALUES (dept_id_seq.NEXTVAL,'Research And Development', NULL);
INSERT INTO P_POSITIONS VALUES (positions_id_seq.NEXTVAL,'Manager',NULL);
INSERT INTO P_POSITIONS VALUES (positions_id_seq.NEXTVAL,'Software Engineer',NULL);
INSERT INTO P_POSITIONS VALUES (positions_id_seq.NEXTVAL,'Data Analyst',NULL);
INSERT INTO P_POSITIONS VALUES (positions_id_seq.NEXTVAL,'Training Coordinator',NULL);
INSERT INTO P_POSITIONS VALUES (positions_id_seq.NEXTVAL,'Embedded Systems Engineer',NULL);
INSERT INTO P_POSITIONS VALUES (positions_id_seq.NEXTVAL,'Janitor',NULL);


--Anonymous block to populate P_EMPLOYEES with random values
DECLARE
    V_random_first_name P_RANDOM_NAMES.FIRST_NAME%TYPE;
    V_random_last_name P_RANDOM_NAMES.LAST_NAME%TYPE;
    v_assign_dept_id P_DEPARTMENTS%ROWTYPE;
    v_assign_position_id P_POSITIONS%ROWTYPE;
    v_assign_salary P_EMPLOYEES.SALARY%TYPE;
    v_counter NUMBER := 0;
    
BEGIN
    WHILE v_counter < 2 LOOP
        
        --Assigning a random first name
        SELECT * INTO v_random_first_name 
        FROM (SELECT FIRST_NAME FROM P_RANDOM_NAMES ORDER BY DBMS_RANDOM.VALUE) 
        WHERE ROWNUM = 1;
        
        --Assigning random last name
        SELECT * INTO v_random_last_name 
        FROM (SELECT LAST_NAME FROM P_RANDOM_NAMES ORDER BY DBMS_RANDOM.VALUE) 
        WHERE ROWNUM = 1;
        
        --Assigning random department to v_assign_dept_id
        SELECT * INTO v_assign_dept_id 
        FROM (SELECT * FROM P_DEPARTMENTS ORDER BY DBMS_RANDOM.VALUE) 
        WHERE ROWNUM = 1;
        
        --Assigning random position to v_assign_position_id
        SELECT * INTO v_assign_position_id 
        FROM (SELECT * FROM P_POSITIONS ORDER BY DBMS_RANDOM.VALUE) 
        WHERE ROWNUM = 1;
        
        --Assigning random salary to v_assign_salary
        v_assign_salary := ROUND(DBMS_RANDOM.VALUE(20000,90000),0);
        
        --Procedure to add new P_EMPLOYEES object
        p_emp_pkg.add_emp(V_random_first_name, V_random_last_name, 
                v_assign_dept_id.ID,v_assign_position_id.ID,v_assign_salary);
                
        v_counter := v_counter + 1;
        
    END LOOP;
END;
/
select count(*) from p_employees;
/* Block to populate salary of each object with random values.
 Any obj that has a manager title (POSITION_ID = 1) will have 9000, not a 
 random salary value*/
BEGIN
    FOR obj in (SELECT * FROM P_EMPLOYEES) LOOP
        IF OBJ.POSITION_ID = 1
        THEN
            UPDATE P_EMPLOYEES SET SALARY = 90000 WHERE ID = OBJ.ID;
        ELSE
            UPDATE P_EMPLOYEES SET SALARY = ROUND(DBMS_RANDOM.VALUE(30000,75000)) WHERE ID = OBJ.ID;
        END IF;
    END LOOP;
END;





