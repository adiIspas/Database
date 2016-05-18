/*
14. M�ri�i salariul tuturor angaja�ilor din tabelul EMP_PNU cu 5%. Vizualizati, iar apoi anula�i modific�rile.
*/

UPDATE employees_isp
SET salary = salary * 1.05;
SELECT * FROM employees_isp;
ROLLBACK;

/*
15. Schimba�i jobul tuturor salaria�ilor din departamentul 80 care au
comision �n 'SA_REP'. Anula�i modific�rile.
*/

UPDATE employees_isp
SET job_id = 'SA_REP'
WHERE department_id = 80 AND commission_pct is not null;
ROLLBACK;

/*
16. S� se promoveze Douglas Grant la manager �n departamentul 20, av�nd o 
cre�tere de salariu cu 1000$. Se poate realiza modificarea prin intermediul unei singure comenzi?
*/

UPDATE departments_isp
set manager_id = (select employees_id from employees where lower(first_name) like '%douglas%' and lower(last_name) like '%grant%')
where department_id = 20;

UPDATE employees_isp
set salary = salary + 1000
where lower(first_name) like '%douglas%' and lower(last_name) like '%grant$';

/*
17. Schimba�i salariul �i comisionul celui mai prost pl�tit salariat din firm�, 
astfel �nc�t s� fie egale cu salariul si comisionul �efului s�u.
*/

UPDATE employees_isp ang
SET(salary,commission_pct) = (SELECT salary, commission_pct
FROM employees_isp
WHERE employee_id = ang.manager_id
);

/*
18. S� se modifice adresa de e-mail pentru angaja�ii care c�tig� cel mai mult
�n departamentul �n care lucreaz� astfel �nc�t acesta s� devin� ini�iala numelui 
concatenat� cu prenumele. Dac� nu are prenume atunci �n loc de acesta apare 
caracterul �.�. Anula�i modific�rile.
*/

UPDATE employees_isp ang
SET email = SUBSTR(last_name,0,1) || NVL(first_name,'.')
WHERE salary = (SELECT MAX(salary) FROM employees_isp WHERE department_id = ang.department_id);
ROLLBACK;

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

UPDATE employees_isp