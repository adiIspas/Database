update employees_isp
set salary = (select avg(salary) from employees)
where hire_date between '17-SEP-87' and '17-SEP-2000';  

/*
7. Sã se mai introducã un angajat corespunzãtor departamentului 300, 
precizând dupã numele tabelului lista coloanelor în care se introduc valori 
(metoda explicita de inserare). Se presupune cã data angajãrii acestuia este 
cea curentã (SYSDATE). Salvaþi înregistrarea.
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
  10. Inseraþi o nouã înregistrare în tabelul EMP_PNU care sã totalizeze
  salariile, sã facã media comisioanelor, iar câmpurile de tip datã sã 
  conþinã data curentã ºi câmpurile de tip caracter sã conþinã textul 'TOTAL'. 
  Numele ºi prenumele angajatului sã corespundã utilizatorului curent (USER).
  Pentru câmpul employee_id se va introduce valoarea 0, iar pentru manager_id 
  ºi department_id se va da valoarea null.
  */
  
INSERT INTO employees_isp
SELECT 0,USER,USER, 'TOTAL', 'TOTAL',SYSDATE,
'TOTAL', SUM(salary), ROUND(AVG(commission_pct)), null, null
FROM employees;

/*
11. Sã se creeze un fiºier (script file) care sã permitã introducerea de 
înregistrãri în tabelul EMP_PNU în mod interactiv. Se vor cere utilizatorului: 
codul, numele, prenumele si salariul angajatului. Câmpul email se va completa 
automat prin concatenarea primei litere din prenume ºi a primelor 7 litere din nume.
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
Creaþi 2 tabele emp2_pnu ºi emp3_pnu cu aceeaºi structurã ca tabelul EMPLOYEES, 
dar fãrã înregistrãri (acceptãm omiterea constrângerilor de integritate). 
Prin intermediul unei singure comenzi, copiaþi din tabelul EMPLOYEES:
- în tabelul EMP1_PNU salariaþii care au salariul mai mic decât 5000;
- în tabelul EMP2_PNU salariaþii care au salariul cuprins între 5000 ºi 10000;
- în tabelul EMP3_PNU salariaþii care au salariul mai mare decât 10000.
Verificaþi rezultatele, apoi ºtergeþi toate înregistrãrile din aceste tabele.
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
