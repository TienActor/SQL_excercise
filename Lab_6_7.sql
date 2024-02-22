select *
from employees

--- cau 1

select employee_id,first_name,last_name,salary,department_id 
from employees
where department_id=&maphong
order by &thuonTinhSapXep

--- cau 2

select*
from employees
where employee_id in
(
select *
FROM JOB_HISTORY
WHERE JOB_ID='&maCV')



SELECT * FROM job_history
select JOB_ID
from JOBS
where JOB_ID =&Macv


--- Cau 3

select
*from employees
where salary > &x and salary<&y
order by &thuocTinhSX

------ Bai 2
--- Cau 1


select *from job_history
create or replace view v_cau1
as 
    select *
    from countries
    where region_id in (
    select region_id
    from regions
    where region_name ='Asia'
    )

    select * from v_cau1
    
--- Cau 2

select *
from employees
where employee_id not in    
(
select manager_id
from employees
)



CREATE OR REPLACE VIEW v_cau2 AS
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE manager_id IS NULL;

select*from v_cau2

--- Cau 3
select * from departments
where department_id not in(
select department_id from employees
)

CREATE VIEW v_cau3
AS
SELECT d.department_id, d.department_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;


select*from v_cau3


--- Tao sequence
create sequence td_seq
    start with 1
    increment by 1
    max by 2400;
--- Tao bang
create table phieuxuat
(
id number,
mota varchar2(255));

insert into phieuxuat(id,mota) values(td_seq.nextval,'px xxx');

select *from phieuxuat


---- Lab 7
select*from employees

DECLARE
CURSOR c_emp IS
SELECT empo,salary
FROM emp
WHERE deptno=30;
BEGIN
FOR rec IN c_emp
LOOP
UPDATE emp
SET sal=rec.sal+(rec.sal * .05)
WHERE empno=rec.empno;
END LOOP;
COMMIT;
END;

