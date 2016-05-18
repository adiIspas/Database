/*
14. Mãriþi salariul tuturor angajaþilor din tabelul EMP_PNU cu 5%. Vizualizati, iar apoi anulaþi modificãrile.
*/

UPDATE employees_isp
SET salary = salary * 1.05;
SELECT * FROM employees_isp;
ROLLBACK;

/*
15. Schimbaþi jobul tuturor salariaþilor din departamentul 80 care au
comision în 'SA_REP'. Anulaþi modificãrile.
*/

UPDATE employees_isp
SET job_id = 'SA_REP'
WHERE department_id = 80 AND commission_pct is not null;
ROLLBACK;

/*
16. Sã se promoveze Douglas Grant la manager în departamentul 20, având o 
creºtere de salariu cu 1000$. Se poate realiza modificarea prin intermediul unei singure comenzi?
*/

UPDATE departments_isp
set manager_id = (select employees_id from employees where lower(first_name) like '%douglas%' and lower(last_name) like '%grant%')
where department_id = 20;

UPDATE employees_isp
set salary = salary + 1000
where lower(first_name) like '%douglas%' and lower(last_name) like '%grant$';

/*
17. Schimbaþi salariul ºi comisionul celui mai prost plãtit salariat din firmã, 
astfel încât sã fie egale cu salariul si comisionul ºefului sãu.
*/

UPDATE employees_isp ang
SET(salary,commission_pct) = (SELECT salary, commission_pct
FROM employees_isp
WHERE employee_id = ang.manager_id
);

/*
18. Sã se modifice adresa de e-mail pentru angajaþii care câºtigã cel mai mult
în departamentul în care lucreazã astfel încât acesta sã devinã iniþiala numelui 
concatenatã cu prenumele. Dacã nu are prenume atunci în loc de acesta apare 
caracterul ‘.’. Anulaþi modificãrile.
*/

UPDATE employees_isp ang
SET email = SUBSTR(last_name,0,1) || NVL(first_name,'.')
WHERE salary = (SELECT MAX(salary) FROM employees_isp WHERE department_id = ang.department_id);
ROLLBACK;

/*
19. Pentru fiecare departament sã se mãreascã salariul celor care au fost angajaþi 
primii astfel încât sã devinã media salariilor din companie. 
Þineþi cont de liniile introduse anterior.
*/

UPDATE employees_isp
SET salary = (SELECT AVG(salary) FROM employees) 
WHERE hire_date = (SELECT MIN(hire_date) FROM employees_isp);

/*
20. Sã se modifice jobul ºi departamentul angajatului având codul 114, 
astfel încât sã fie la fel cu cele ale angajatului având codul 205.
*/

UPDATE employees_isp