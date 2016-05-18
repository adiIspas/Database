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

/*
21. Creaþi un script prin intermediul caruia sa fie posibilã actualizarea în mod
interactiv de înregistrãri ale tabelului dept_pnu. Se va cere codul 
departamentului care urmeazã a fi actualizat, se va afiºa linia respectivã, 
iar apoi se vor cere valori pentru celelalte câmpuri.
*/

UPDATE departments_isp
SET department_id = &&cod, manager_id = &cod1, department_name = &nume,
location_id=&locatie
WHERE department_id = &cod;

SELECT * from departments_isp
WHERE department_id = &cod;

/*
22. ªtergeþi toate înregistrãrile din tabelul DEPT_PNU. Ce înregistrãri se pot ºterge? Anulaþi modificãrile.
*/

--- test :)
delete from departments_isp;
rollback;
select*from departments_isp;

delete from employees_isp
where commission_pct is null;

rollback;

/*
24. Suprimaþi departamentele care un au nici un angajat. Anulaþi modificãrile.
*/

select department_id 
from departments minus
(select department_id from employees_isp);

delete from departments_isp
where department_id = (select department_id from departments_isp minus(select department_id from employees_isp));

/*
29. Sã se ºteargã tot conþinutul tabelului. Listaþi conþinutul tabelului.
*/

delete departments_isp;
rollback;


truncate table departments_isp;
select * from departments_isp;
rollback;

/*
31. Listaþi conþinutul tabelului. Determinaþi ca modificãrile sã devinã permanente.
*/

select * from employees_isp;

/*
32. Sã se ºteargã din tabelul EMP_PNU toþi angajaþii care câºtigã comision. 
Sã se introducã sau sã se actualizeze datele din tabelul EMP_PNU pe baza tabelului employees.
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