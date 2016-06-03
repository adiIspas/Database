/*
1. S� se creeze tabelele EMP_pnu, DEPT_pnu (�n �irul de caractere �pnu�,
p reprezint� prima liter� a prenumelui, iar nu reprezint� primele dou� litere 
ale numelui dumneavoastr�), prin copierea structurii �i con�inutului 
tabelelor EMPLOYEES, respectiv DEPARTMENTS.
*/

CREATE TABLE EMP_ISP AS SELECT * FROM employees;
CREATE TABLE DEPT_ISP AS SELECT * FROM departments;

/*
4. Pentru introducerea constr�ngerilor de integritate, executa�i instruc�iunile 
LDD indicate �n continuare. Prezentarea detaliat� a LDD se va face �n cadrul laboratorului 4.
*/

ALTER TABLE emp_isp
ADD CONSTRAINT pk_emp_isp PRIMARY KEY(employee_id);
ALTER TABLE dept_isp
ADD CONSTRAINT pk_dept_isp PRIMARY KEY(department_id);
ALTER TABLE emp_isp
ADD CONSTRAINT fk_emp_dept_isp
FOREIGN KEY(department_id) REFERENCES dept_isp(department_id);

desc dept_isp;
desc departments;

desc emp_isp;
desc employees;

/*
5. S� se insereze departamentul 300, cu numele Programare �n DEPT_pnu.
*/

INSERT INTO dept_isp (department_id, department_name)
VALUES (300, 'Programare');

select * 
from dept_isp;

INSERT INTO dept_isp (department_id, department_name, location_id)
VALUES (301, 'Programare 2', null);

select * 
from dept_isp;

/*
6. S� se insereze un angajat corespunz�tor departamentului introdus anterior 
�n tabelul EMP_pnu, preciz�nd valoarea NULL pentru coloanele a c�ror valoare 
nu este cunoscut� la inserare (metoda implicit� de inserare). 
Determina�i ca efectele instruc�iunii s� devin� permanente.
*/

desc emp_isp;

insert into emp_isp (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (777, 'Adrian', 'Ispas', 'adi.ispas95@gmail.com', '0725790428', '01-IULIE-2016', 'IT_PROG', 1000, 0, null, 300);

commit;

select *
from emp_isp
where lower(last_name) like '%ispas%';

/*
7. S� se mai introduc� un angajat corespunz�tor departamentului 300, 
preciz�nd dup� numele tabelului lista coloanelor �n care se introduc valori 
(metoda explicita de inserare). Se presupune c� data angaj�rii acestuia este cea curent� (SYSDATE). Salva�i �nregistrarea.
*/

insert into emp_isp (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (778, 'Vasile', 'Georgescu', 'vasi.geo@gmail.com', null, sysdate, 'IT_PROG', 500, null, null, 300);

select *
from emp_isp
where lower(last_name) like '%georgescu%';

desc dept_isp;

insert into (select department_id, department_name, location_id from dept_isp)
values (302, 'Fotbal', 150);

/*
9. Crea�i un nou tabel, numit EMP1_PNU, care va avea aceea�i structur� ca 
�i EMPLOYEES, dar nici o �nregistrare. Copia�i �n tabelul EMP1_PNU 
salaria�ii (din tabelul EMPLOYEES) al c�ror comision dep�e�te 25% din salariu.
*/

create table emp1_isp as select * from employees;
delete from emp1_isp;

insert into emp1_isp 
       select * from employees where commission_pct > 0.25;

select * 
from emp1_isp;

/*
10. Insera�i o nou� �nregistrare �n tabelul EMP_PNU care s� totalizeze salariile, 
s� fac� media comisioanelor, iar c�mpurile de tip dat� s� con�in� data curent� �i 
c�mpurile de tip caracter s� con�in� textul 'TOTAL'. Numele �i prenumele angajatului 
s� corespund� utilizatorului curent (USER). Pentru c�mpul employee_id se va introduce 
valoarea 0, iar pentru manager_id �i department_id se va da valoarea null.
*/

desc emp_isp;

insert into emp_isp 
       select 0, user, user, 'TOTAL', 'TOTAL', sysdate, 'TOTAL', sum(salary), round(avg(commission_pct)), null, null
       from employees;
       
select *
from emp_isp;

/*
12. Crea�i 2 tabele emp2_pnu �i emp3_pnu cu aceea�i structur� ca tabelul EMPLOYEES, 
dar f�r� �nregistr�ri (accept�m omiterea constr�ngerilor de integritate). 
Prin intermediul unei singure comenzi, copia�i din tabelul EMPLOYEES:
- �n tabelul EMP1_PNU salaria�ii care au salariul mai mic dec�t 5000;
- �n tabelul EMP2_PNU salaria�ii care au salariul cuprins �ntre 5000 �i 10000;
- �n tabelul EMP3_PNU salaria�ii care au salariul mai mare dec�t 10000.
*/

create table emp2_isp as select * from employees;
delete from emp2_isp;

create table emp3_isp as select * from employees;
delete from emp3_isp;

insert all
  when salary < 5000 then
    into emp1_isp
  when salary >= 5000 and salary <= 10000 then
    into emp2_isp
  else
    into emp3_isp
select * from employees;

select * from emp1_isp;
select * from emp2_isp;
select * from emp3_isp;

delete from emp1_isp
where salary >= 5000;

/*
13. S� se creeze tabelul EMP0_PNU cu aceea�i structur� ca tabelul EMPLOYEES (f�r� constr�ngeri), dar f�r� nici o �nregistrare. Copia�i din tabelul EMPLOYEES:
- �n tabelul EMP0_PNU salaria�ii care lucreaz� �n departamentul 80;
- �n tabelul EMP1_PNU salaria�ii care au salariul mai mic dec�t 5000;
- �n tabelul EMP2_PNU salaria�ii care au salariul cuprins �ntre 5000 �i 10000;
- �n tabelul EMP3_PNU salaria�ii care au salariul mai mare dec�t 10000.
Dac� un salariat se �ncadreaz� �n tabelul emp0_pnu atunci acesta nu va mai fi inserat �i �n alt tabel (tabelul corespunz�tor salariului s�u).
*/

create table emp0_isp as select * from employees;
delete from emp0_isp;

insert first
  when department_id = 80 then
    into emp0_isp
  when salary < 5000 then
    into emp1_isp
  when salary >= 5000 and salary <= 10000 then
    into emp2_isp
  else
    into emp3_isp
select * from employees;

/*
14. M�ri�i salariul tuturor angaja�ilor din tabelul EMP_PNU cu 5%. Vizualizati, iar apoi anula�i modific�rile.
*/

update emp_isp
set salary = salary * 15/100;

/*
15. Schimba�i jobul tuturor salaria�ilor din departamentul 80 care au comision �n 'SA_REP'. Anula�i modific�rile.
*/

update emp_isp
set job_id = 'SA_REP'
where department_id = 80;

/*
16. S� se promoveze Douglas Grant la manager �n departamentul 20, 
av�nd o cre�tere de salariu cu 1000$. Se poate realiza modificarea prin 
intermediul unei singure comenzi?
*/

update dept_isp
set manager_id = (select employee_id from emp_isp where lower(last_name) like '%grant%' and lower(first_name) like '%douglas%')
where department_id = 20;
rollback;

update emp_isp
set salary = salary + 1000
where lower(last_name) like '%grant%' and lower(first_name) like '%douglas%';

/*
20. S� se modifice jobul �i departamentul angajatului av�nd codul 114, 
astfel �nc�t s� fie la fel cu cele ale angajatului av�nd codul 205.
*/

update emp_isp
set (job_id, department_id) = 
    (select job_id, department_id
     from emp_isp
     where employee_id = 205)
where employee_id = 114;

rollback;

select job_id, department_id
from emp_isp
where employee_id = 114;
