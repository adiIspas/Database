/*
18.
Sa se afiseze codul, numele departamentului si numarul de angajati care 
lucreaza in acel departament pentru:
a) departamentele in care lucreaza mai putin de 4 angajati;
b) departamentul care are numarul maxim de angajati.
*/

SELECT e.department_id, d.department_name, COUNT(*)
FROM employees e JOIN departments d ON (d.department_id = e.department_id )
GROUP BY e.department_id, d.department_name
HAVING COUNT(*)<4;

/*
19. Sa se afiseze salariatii care au fost angajati în aceeaºi zi a lunii 
în care cei mai multi dintre salariati au fost angajati.
*/

SELECT employee_id, last_name, TO_CHAR(hire_date, 'dd')
FROM employees
WHERE TO_CHAR(hire_date,'dd') IN 
      (SELECT TO_CHAR(hire_date,'dd')
       FROM employees
       GROUP BY TO_CHAR(hire_date,'dd')
       HAVING COUNT(*)=(SELECT MAX(COUNT(*))
                        FROM employees
                        GROUP BY TO_CHAR(hire_date,'dd')));
                        
/*
20. Sã se obþinã numãrul departamentelor care au cel puþin 15 angajaþi.
*/

SELECT COUNT(department_id)
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 15;

/*
21. Sã se obþinã codul departamentelor ºi suma salariilor angajaþilor care lucreazã
în acestea, în ordine crescãtoare. Se considerã departamentele care au mai mult
de 10 angajaþi ºi al cãror cod este diferit de 30.
*/

SELECT department_id, SUM(salary)
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 10 AND department_id <> 30;

/*
22. Sa se afiseze codul, numele departamentului, numarul de angajati si salariul 
mediu din departamentul respectiv, impreuna cu numele, salariul si jobul 
angajatilor din acel departament. Se vor afiºa ºi departamentele fãrã angajaþi.
*/

SELECT e.department_id, department_name, 
      (SELECT COUNT(employee_id) 
       FROM employees 
       WHERE e.department_id = department_id), 
      (SELECT round(AVG(salary)) 
       FROM employees 
       WHERE e.department_id = department_id), last_name, job_id, salary
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
GROUP BY e.department_id, department_name,last_name,job_id,salary;

/*
23. Scrieti o cerere pentru a afisa, pentru departamentele avand codul > 80, 
salariul total pentru fiecare job din cadrul departamentului. Se vor afisa 
orasul, numele departamentului, jobul si suma salariilor. Se vor eticheta 
coloanele corespunzator.
*/

SELECT city, department_name, job_id, SUM(salary)
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
JOIN locations l ON (d.location_id = l.location_id)
WHERE e.department_id > 80
GROUP BY e.department_id,city, department_name, job_id;

/*
24. Care sunt angajatii care au mai avut cel putin doua joburi?
*/

SELECT last_name 
FROM employees e, (SELECT employee_id, COUNT(employee_id)
FROM job_history 
GROUP BY employee_id
HAVING COUNT(*) > 1) e1
WHERE e.employee_id = e1.employee_id;