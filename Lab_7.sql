---Câu 3

create or replace procedure cau3(maphong in number)
as
    cursor c_cau3
    is
        select (first_name || '' || last_name) as tennhanvien
        from employees
        where department_id =maphong;
        
begin 
    for r in c_cau3
    loop
        dbms_output.put_line('Ten nhnan vien:' || r.tennhanvien);
        end loop;
end;



set serveroutput on
exec cau3(10)


---Câu 4

create or replace procedure cau4(order_date in NUMBER)
as
    cursor c_cau4 is
                select first_name,last_name,department_id,hire_date
                from employees 
                where  extract(year from hire_date)=order_date;
                begin
                for r in c_cau4
                loop
                begin 
                dbms_output.put_line(r.first_name||' ' ||r.last_name||' '||r.department_id||' '||r.hire_date);
                end;
                end loop;
            end;

set serveroutput on
exec cau4(2003)

-- Câu 5

create or replace procedure cau5(maphong in int)
as
        v_id int;
        v_first_name varchar(40);
        v_last_name varchar(40);
begin 
        select employees.employee_id,first_name,last_name
        into v_id,v_first_name,v_last_name
        from employees join departments on employees.employee_id=departments.manager_id
        where departments.department_id=maphong;
        dbms_output.put_line(v_id || ' ' || v_first_name ||' ' ||v_last_name);
exception
    when no_data_found then
        dbms_output.put_line('Không tồn tại');
end;
        
set serveroutput on
exec cau5(30)  

-- Câu 6
create or replace procedure cau6(v_macv employees.JOB_ID%TYPE)
as
    v_slnv int;
begin
    select count(*)
    into v_slnv
    from employees
    where JOB_ID=v_macv;
    dbms_output.put_line(v_slnv);
exception
    when no_data_found then
    dbms_output.put_line('Không tồn tại');
end;

set serveroutput on
exec cau6('AD_VP') 


select*from employees
go
select*from JOB_HISTORY
go


--- Câu 7
CREATE OR REPLACE PROCEDURE cau7(manv IN NUMBER)
AS
CURSOR c_cau7 IS
    SELECT (e.first_name || ' ' || e.last_name) AS tennhanvien,
           j.start_date AS ngaybatdau,
           j.end_date AS ngayketthuc,
           j.job_id AS macongviec
    FROM employees e
    JOIN job_history j ON e.employee_id = j.employee_id
    WHERE e.employee_id = manv;
BEGIN
    FOR r IN c_cau7 LOOP
        dbms_output.put_line('Ten nhan vien: ' || r.tennhanvien ||
                             ', Ngay bat dau: ' || r.ngaybatdau ||
                             ', Ngay ket thuc: ' || r.ngayketthuc ||
                             ', Ma cong viec: ' || r.macongviec);
    END LOOP;
END;


--- Nhập vào giá trị lượng tối thiểu X và giá trị lương tối đa Y, cho biết thông tin các nhân viên có 
---lương từ X đến Y đó.

-- Câu 10_2

create or replace procedure cau10_2(v_employee_id job_history.employee_id%TYPE,
                                    v_start_date job_history.start_date%TYPE,
                                    v_end_date job_history.end_date%TYPE,
                                    v_job job_history.job_id%TYPE,
                                    v_department_id job_history-department_id%TYPE)
as
            check_khoachinh int;
            check_ngaydb int;
            check_khoangoai int;
            v_loi1 exception;
            v_loi2 exception;
            v_loi3 exception;
begin 
     select count(*) int check_khoachinh from job_history where employee_id and start_date=v_start_date;
     select count(*) int check_ngaydb from employees where employees.employee_id=v_employee_id and hire_date  <v_start_date;
     select count(*) int check_khoangoai from employees where employee_id and start_date=v_start_date;
     if check_khoachinh>0 then
     raise v_loi1;
     else if check_ngaydb=0 then
     raise v_loi2;
     else if check_khoangoai=0 then
     raise v_loi3;
     else 
        insert into job_history(employee_id,start_date,end_date,job_id,department_id)
        values(v_emploee_id,v_start_date,v_end_date,v_job,v_department_id);
        COMMIT;
    end if;
exception
    when v_loi1 then
        dbms_output.put_line('Trùng khóa chính');
    when v_loi2 then
        dbms_output.put_line('Ngày tham gia phải sau ngày thuế');
    when v_loi3 then
        dbms_output.put_line('Vi phạm khóa ngoại');
end;

--- FIx



CREATE OR REPLACE PROCEDURE cau10_2(v_employee_id job_history.employee_id%TYPE,
                                   v_start_date job_history.start_date%TYPE,
                                   v_end_date job_history.end_date%TYPE,
                                   v_job job_history.job_id%TYPE,
                                   v_department_id job_history.department_id%TYPE) AS
   check_khoachinh INT;
   check_ngaydb INT;
   check_khoangoai INT;
   v_loi1 EXCEPTION;
   v_loi2 EXCEPTION;
   v_loi3 EXCEPTION;
BEGIN
   SELECT COUNT(*) INTO check_khoachinh FROM job_history WHERE employee_id = v_employee_id AND start_date = v_start_date;
   SELECT COUNT(*) INTO check_ngaydb FROM employees WHERE employee_id = v_employee_id AND hire_date < v_start_date;
   SELECT COUNT(*) INTO check_khoangoai FROM departments WHERE department_id = v_department_id;
   IF check_khoachinh > 0 THEN
       RAISE v_loi1;
   ELSIF check_ngaydb = 0 THEN
       RAISE v_loi2;
   ELSIF check_khoangoai = 0 THEN
       RAISE v_loi3;
   ELSE
       INSERT INTO job_history(employee_id, start_date, end_date, job_id, department_id)
       VALUES (v_employee_id, v_start_date, v_end_date, v_job, v_department_id);
       -- COMMIT; -- Gỡ bỏ comment này nếu thực thi trong môi trường cần commit
   END IF;
EXCEPTION
   WHEN v_loi1 THEN
       dbms_output.put_line('Trùng khóa chính');
   WHEN v_loi2 THEN
       dbms_output.put_line('Ngày tham gia phải sau ngày thuế');
   WHEN v_loi3 THEN
       dbms_output.put_line('Vi phạm khóa ngoại');
END;

set serveroutput on
exec cau10_2('JOB_HISTORY')
        