/*
19. Pentru fiecare departament s� se m�reasc� salariul celor care au fost angaja�i 
primii astfel �nc�t s� devin� media salariilor din companie. 
�ine�i cont de liniile introduse anterior.
*/

UPDATE employees_isp
SET salary = (SELECT AVG(salary) FROM employees) 
WHERE hire_date = (SELECT MIN(hire_date) FROM employees_isp);

/*
20. S� se modifice jobul �i departamentul angajatului av�nd codul 114, 
astfel �nc�t s� fie la fel cu cele ale angajatului av�nd codul 205.
*/

/*
21. Crea�i un script prin intermediul caruia sa fie posibil� actualizarea �n mod
interactiv de �nregistr�ri ale tabelului dept_pnu. Se va cere codul 
departamentului care urmeaz� a fi actualizat, se va afi�a linia respectiv�, 
iar apoi se vor cere valori pentru celelalte c�mpuri.
*/

UPDATE departments_isp
SET department_id = &&cod, manager_id = &cod1, department_name = &nume,
location_id=&locatie
WHERE department_id = &cod;

SELECT * from departments_isp
WHERE department_id = &cod;

/*
22. �terge�i toate �nregistr�rile din tabelul DEPT_PNU. Ce �nregistr�ri se pot �terge? Anula�i modific�rile.
*/

--- test :)
delete from departments_isp;
rollback;
select*from departments_isp;

delete from employees_isp
where commission_pct is null;

rollback;

/*
24. Suprima�i departamentele care un au nici un angajat. Anula�i modific�rile.
*/

select department_id 
from departments minus
(select department_id from employees_isp);

delete from departments_isp
where department_id = (select department_id from departments_isp minus(select department_id from employees_isp));

/*
29. S� se �tearg� tot con�inutul tabelului. Lista�i con�inutul tabelului.
*/

delete departments_isp;
rollback;


truncate table departments_isp;
select * from departments_isp;
rollback;

/*
31. Lista�i con�inutul tabelului. Determina�i ca modific�rile s� devin� permanente.
*/

select * from employees_isp;

/*
32. S� se �tearg� din tabelul EMP_PNU to�i angaja�ii care c�tig� comision. 
S� se introduc� sau s� se actualizeze datele din tabelul EMP_PNU pe baza tabelului employees.
*/

MERGE INTO employees_isp x
USING employees e
ON (x.employee_id = e.employee_id)
WHEN MATCHED THEN
UPDATE SET
x.first_name=e. first_name,
x.last_name=e.last_name,
x.email=e.email,
x.phone_number=e.phone_number,
x.hire_date= e.hire_date,
x.job_id= e.job_id,
x.salary = e.salary,
x.commission_pct= e.commission_pct,
x.manager_id= e.manager_id,
x.department_id= e.department_id
WHEN NOT MATCHED THEN
INSERT VALUES (e.employee_id, e.first_name, e.last_name, e.email,
e.phone_number, e.hire_date, e.job_id, e.salary, e.commission_pct, e.manager_id,
e.department_id);