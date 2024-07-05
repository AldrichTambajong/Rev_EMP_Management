--SQL procedures to perform operations on P_EMPLOYEES
set serveroutput on;

--Inserting procedure
ACCEPT v_first_name PROMPT 'Enter first name: ';
ACCEPT v_last_name PROMPT 'Enter last name: ';
ACCEPT v_DEPARTMENT_ID PROMPT 'Enter department id: ';
ACCEPT v_POSITION_ID PROMPT 'Enter position id: ';
ACCEPT v_SALARY PROMPT 'Enter salary: ';

EXECUTE p_emp_pkg.add_emp('&v_first_name','&v_last_name', &v_DEPARTMENT_ID, &v_POSITION_ID, &v_SALARY);
--------------------------------------------------------------------------------------------------------

--Updating procedure
ACCEPT v_id PROMPT 'Enter employee id: ';
ACCEPT v_DEPT_ID PROMPT 'Enter department id: ';
ACCEPT v_POSITION_ID PROMPT 'Enter position id: ';

EXECUTE P_EMP_PKG.update_emp_by_id('&v_id',&v_dept_id,&v_position_id);


ACCEPT v_email PROMPT 'Enter employee email: ';
ACCEPT v_DEPT_ID PROMPT 'Enter department id: ';
ACCEPT v_POSITION_ID PROMPT 'Enter position id: ';

EXECUTE P_EMP_PKG.update_emp_by_email('&v_email',&v_dept_id,&v_position_id);
--------------------------------------------------------------------------------------------------------

--Deleting procedures
--Deleting through email
ACCEPT v_email PROMPT 'Enter employee email: ';
EXECUTE p_emp_pkg.delete_emp_by_email('&v_email');

--Deleting through id
ACCEPT v_id PROMPT 'Enter employee id: ';
EXECUTE P_EMP_PKG.DELETE_EMP_BY_ID('&v_id');
--------------------------------------------------------------------------------------------------------

--VIEWING LIST OF EMPLOYEES
--Querying a list of all employees in P_EMPLOYEES ordered by departments
EXECUTE p_emp_pkg.list_emps_by_dept;

--Querying a list of all employees in P_EMPLOYEES ordered by positions
EXECUTE p_emp_pkg.list_emps_by_position;
--------------------------------------------------------------------------------------------------------

--REPORTS
--Number of employees in each department
SELECT D.DEPT_NAME, COUNT(E.DEPT_ID) NUMBER_OF_EMPLOYEES FROM P_EMPLOYEES E JOIN P_DEPARTMENTS D ON E.DEPT_ID = D.ID GROUP BY D.DEPT_NAME;

--Employees in a certain department
SELECT E.FIRST_NAME,E.LAST_NAME,D.DEPT_NAME,P.TITLE FROM P_EMPLOYEES E
JOIN P_DEPARTMENTS D ON E.DEPT_ID = D.ID
JOIN P_POSITIONS P ON E.POSITION_ID = P.ID
WHERE E.DEPT_ID = 10;

--Number of employees in each position
SELECT P.TITLE, COUNT(E.POSITION_ID) NUMBER_OF_EMPLOYEES FROM P_EMPLOYEES E JOIN P_POSITIONS P ON E.POSITION_ID = P.ID GROUP BY P.TITLE;
--BY DEPARTMENTS

--AVG salary of each position
SELECT P.TITLE, ROUND(AVG(E.SALARY),0) AVG_SALARY FROM P_EMPLOYEES E JOIN P_POSITIONS P ON E.POSITION_ID = P.ID GROUP BY P.TITLE;

--AVG salary of each department
SELECT D.DEPT_NAME, ROUND(AVG(E.SALARY),0)AVG_SALARY FROM P_EMPLOYEES E JOIN P_DEPARTMENTS D ON E.DEPT_ID = D.ID GROUP BY D.DEPT_NAME;


--------------------------------------------------------------------------------------------------------

/*
SELECT * FROM P_DEPARTMENTS;
SELECT * FROM P_EMPLOYEES WHERE DEPT_ID = 50 AND SALARY = (SELECT MAX(SALARY) FROM P_EMPLOYEES WHERE DEPT_ID = 50);
UPDATE P_DEPARTMENTS SET DEPT_HEAD = '1ADE95FA849360B4E0630100007F36BE' WHERE ID=50;
SELECT * FROM P_DEPARTMENTS;
rollback;
DELETE FROM P_EMPLOYEES WHERE ID = '1B0E796FE4B23DBCE0630100007F75E2';
UPDATE P_EMPLOYEES SET DEPT_ID = 40, POSITION_ID = 3 WHERE ID = '1B0E796FE4B13DBCE0630100007F75E2';*/
--test.object106@company.com 1ADE95FA84B760B4E0630100007F36BE

--test2.object2107@company.com