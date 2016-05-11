update employees_isp
set salary = (select avg(salary) from employees)
where hire_date between '17-SEP-87' and '17-SEP-2000';  

/*
7. S� se mai introduc� un angajat corespunz�tor departamentului 300, 
preciz�nd dup� numele tabelului lista coloanelor �n care se introduc valori 
(metoda explicita de inserare). Se presupune c� data angaj�rii acestuia este 
cea curent� (SYSDATE). Salva�i �nregistrarea.
*/

insert into employees_isp (last_name,first_name,job_id,email,hire_date,employee_id,salary,department_id) values('No','Name','Barosan','nuavem@frate.tu','10-SEP-9999',19123,10,300);

select *
from user_constraints name
where lower(table_name) like '%employees_isp%';

select * from employees_isp where department_id = 300;

insert into
( select employee_id, department_id, last_name, job_id, hire_date, email
  from employees_isp
  )
  values(1,200,'ceva','barosan','17-SEP-1990','asd@asd.ads');
  
  rollback;
  
  select * from employees_isp
  where department_id = 200;
  
  /*
  10. Insera�i o nou� �nregistrare �n tabelul EMP_PNU care s� totalizeze
  salariile, s� fac� media comisioanelor, iar c�mpurile de tip dat� s� 
  con�in� data curent� �i c�mpurile de tip caracter s� con�in� textul 'TOTAL'. 
  Numele �i prenumele angajatului s� corespund� utilizatorului curent (USER).
  Pentru c�mpul employee_id se va introduce valoarea 0, iar pentru manager_id 
  �i department_id se va da valoarea null.
  */
  
INSERT INTO employees_isp
SELECT 0,USER,USER, 'TOTAL', 'TOTAL',SYSDATE,
'TOTAL', SUM(salary), ROUND(AVG(commission_pct)), null, null
FROM employees;

/*
11. S� se creeze un fi�ier (script file) care s� permit� introducerea de 
�nregistr�ri �n tabelul EMP_PNU �n mod interactiv. Se vor cere utilizatorului: 
codul, numele, prenumele si salariul angajatului. C�mpul email se va completa 
automat prin concatenarea primei litere din prenume �i a primelor 7 litere din nume.
*/

INSERT INTO employees_isp(employee_id, last_name, first_name, salary, job_id, email, hire_date, department_id)
VALUES
(
&cod, '&&nume', '&&prenume', &salariu, 'IT_PROG',
substr('&prenume',0,1) ||
substr('&nume',0,7),
SYSDATE,200
);

select * from employees_isp
where department_id = 200;

undefine nume;
undefine prenume;


select * 
from employees
where upper(last_name) = '&&naame';
undefine nume;

/*
Crea�i 2 tabele emp2_pnu �i emp3_pnu cu aceea�i structur� ca tabelul EMPLOYEES, 
dar f�r� �nregistr�ri (accept�m omiterea constr�ngerilor de integritate). 
Prin intermediul unei singure comenzi, copia�i din tabelul EMPLOYEES:
- �n tabelul EMP1_PNU salaria�ii care au salariul mai mic dec�t 5000;
- �n tabelul EMP2_PNU salaria�ii care au salariul cuprins �ntre 5000 �i 10000;
- �n tabelul EMP3_PNU salaria�ii care au salariul mai mare dec�t 10000.
Verifica�i rezultatele, apoi �terge�i toate �nregistr�rile din aceste tabele.
*/

CREATE TABLE employees3_isp
AS SELECT * FROM employees
WHERE 1 = 0;

INSERT 
WHEN salary < 5000 then into
employees1_isp
when salary between 5000 and 10000 then into employees2_isp
else
into
employees3_isp
select * from employees;

select * from
employees2_isp;
