/*
1. Sã se creeze tabelele EMP_pnu, DEPT_pnu (în ºirul de caractere “pnu”,
p reprezintã prima literã a prenumelui, iar nu reprezintã primele douã litere 
ale numelui dumneavoastrã), prin copierea structurii ºi conþinutului 
tabelelor EMPLOYEES, respectiv DEPARTMENTS.
*/

CREATE TABLE EMP_ISP AS SELECT * FROM employees;
CREATE TABLE DEPT_ISP AS SELECT * FROM departments;

/*
4. Pentru introducerea constrângerilor de integritate, executaþi instrucþiunile 
LDD indicate în continuare. Prezentarea detaliatã a LDD se va face în cadrul laboratorului 4.
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
5. Sã se insereze departamentul 300, cu numele Programare în DEPT_pnu.
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
6. Sã se insereze un angajat corespunzãtor departamentului introdus anterior 
în tabelul EMP_pnu, precizând valoarea NULL pentru coloanele a cãror valoare 
nu este cunoscutã la inserare (metoda implicitã de inserare). 
Determinaþi ca efectele instrucþiunii sã devinã permanente.
*/

desc emp_isp;

insert into emp_isp (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values (777, 'Adrian', 'Ispas', 'adi.ispas95@gmail.com', '0725790428', '01-IULIE-2016', 'IT_PROG', 1000, 0, null, 300);

commit;

select *
from emp_isp
where lower(last_name) like '%ispas%';

/*
7. Sã se mai introducã un angajat corespunzãtor departamentului 300, 
precizând dupã numele tabelului lista coloanelor în care se introduc valori 
(metoda explicita de inserare). Se presupune cã data angajãrii acestuia este cea curentã (SYSDATE). Salvaþi înregistrarea.
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
9. Creaþi un nou tabel, numit EMP1_PNU, care va avea aceeaºi structurã ca 
ºi EMPLOYEES, dar nici o înregistrare. Copiaþi în tabelul EMP1_PNU 
salariaþii (din tabelul EMPLOYEES) al cãror comision depãºeºte 25% din salariu.
*/

create table emp1_isp as select * from employees;
delete from emp1_isp;

insert into emp1_isp 
       select * from employees where commission_pct > 0.25;

select * 
from emp1_isp;

/*
10. Inseraþi o nouã înregistrare în tabelul EMP_PNU care sã totalizeze salariile, 
sã facã media comisioanelor, iar câmpurile de tip datã sã conþinã data curentã ºi 
câmpurile de tip caracter sã conþinã textul 'TOTAL'. Numele ºi prenumele angajatului 
sã corespundã utilizatorului curent (USER). Pentru câmpul employee_id se va introduce 
valoarea 0, iar pentru manager_id ºi department_id se va da valoarea null.
*/

desc emp_isp;

insert into emp_isp 
       select 0, user, user, 'TOTAL', 'TOTAL', sysdate, 'TOTAL', sum(salary), round(avg(commission_pct)), null, null
       from employees;
       
select *
from emp_isp;

/*
12. Creaþi 2 tabele emp2_pnu ºi emp3_pnu cu aceeaºi structurã ca tabelul EMPLOYEES, 
dar fãrã înregistrãri (acceptãm omiterea constrângerilor de integritate). 
Prin intermediul unei singure comenzi, copiaþi din tabelul EMPLOYEES:
- în tabelul EMP1_PNU salariaþii care au salariul mai mic decât 5000;
- în tabelul EMP2_PNU salariaþii care au salariul cuprins între 5000 ºi 10000;
- în tabelul EMP3_PNU salariaþii care au salariul mai mare decât 10000.
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
13. Sã se creeze tabelul EMP0_PNU cu aceeaºi structurã ca tabelul EMPLOYEES (fãrã constrângeri), dar fãrã nici o înregistrare. Copiaþi din tabelul EMPLOYEES:
- în tabelul EMP0_PNU salariaþii care lucreazã în departamentul 80;
- în tabelul EMP1_PNU salariaþii care au salariul mai mic decât 5000;
- în tabelul EMP2_PNU salariaþii care au salariul cuprins între 5000 ºi 10000;
- în tabelul EMP3_PNU salariaþii care au salariul mai mare decât 10000.
Dacã un salariat se încadreazã în tabelul emp0_pnu atunci acesta nu va mai fi inserat ºi în alt tabel (tabelul corespunzãtor salariului sãu).
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
14. Mãriþi salariul tuturor angajaþilor din tabelul EMP_PNU cu 5%. Vizualizati, iar apoi anulaþi modificãrile.
*/

update emp_isp
set salary = salary * 15/100;

/*
15. Schimbaþi jobul tuturor salariaþilor din departamentul 80 care au comision în 'SA_REP'. Anulaþi modificãrile.
*/

update emp_isp
set job_id = 'SA_REP'
where department_id = 80;

/*
16. Sã se promoveze Douglas Grant la manager în departamentul 20, 
având o creºtere de salariu cu 1000$. Se poate realiza modificarea prin 
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
20. Sã se modifice jobul ºi departamentul angajatului având codul 114, 
astfel încât sã fie la fel cu cele ale angajatului având codul 205.
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
