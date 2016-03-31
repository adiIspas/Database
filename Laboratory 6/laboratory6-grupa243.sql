/*
25. Sã se calculeze comisionul mediu din firmã, luând în considerare toate liniile din tabel.
*/

SELECT ROUND(AVG(NVL(commission_pct,0)),3)
FROM employees;

/*
27. Scrieþi o cerere pentru a afiºa job-ul, salariul total pentru job-ul respectiv 
pe departamente si salariul total pentru job-ul respectiv pe departamentele 
30, 50, 80. Se vor eticheta coloanele corespunzãtor.
*/

SELECT job_id "Job", department_id "Departament", SUM(salary) "Salariu total", 
       SUM(decode(department_id, 30, salary, 50, salary, 80, salary)) "Departament 30 | 50 | 80"
FROM employees
GROUP BY job_id, department_id;

/*
28. Sã se creeze o cerere prin care sã se afiºeze numãrul total de angajaþi ºi, 
din acest total, numãrul celor care au fost angajaþi în 1997, 1998, 1999 si 
2000. Denumiti capetele de tabel in mod corespunzator.
*/

SELECT COUNT(employee_id) "Nr angajati", 
       COUNT(decode(to_char(hire_date,'yyyy'),1997,employee_id)) "1997",
       COUNT(decode(to_char(hire_date,'yyyy'),1998,employee_id)) "1998",
       COUNT(decode(to_char(hire_date,'yyyy'),1999,employee_id)) "1999",
       COUNT(decode(to_char(hire_date,'yyyy'),2000,employee_id)) "2000"
FROM employees;

/*
30. Sã se afiºeze codul, numele departamentului ºi suma salariilor pe departamente.
*/

SELECT d.department_id, department_name, a.suma
FROM departments d, 
     (SELECT department_id, SUM(salary) suma
      FROM employees
      GROUP BY department_id) a
WHERE d.department_id = a.department_id;

/*
33. Pentru fiecare departament, sã se afiºeze numele acestuia, numele ºi salariul 
celor mai prost plãtiþi angajaþi din cadrul sãu.
*/

SELECT last_name, salary, department_name
FROM employees e, departments d,
     (SELECT department_id, MIN(salary) minim
      FROM employees
      GROUP BY department_id) x
WHERE x.department_id = e.department_id AND salary = minim 
      AND e.department_id = d.department_id;

/*
34. Rezolvaþi problema 22 cu ajutorul subcererilor specificate în clauza FROM.
*/

SELECT d.department_id, department_name, x.nr, x.medie, last_name, job_id, salary
FROM employees e, departments d,
     (SELECT department_id, COUNT(employee_id) nr, ROUND(AVG(salary)) medie
      FROM employees
      GROUP BY department_id) x
WHERE d.department_id = e.department_id AND e.department_id = x.department_id;

/*
1. a) Sã se afiºeze numele departamentelor, titlurile job-urilor ºi valoarea medie a salariilor, pentru:
- fiecare departament ºi, în cadrul sãu pentru fiecare job;
- fiecare departament (indiferent de job);
- întreg tabelul.
b) Analog cu a), afiºând ºi o coloanã care aratã intervenþia coloanelor department_name, job_title, în obþinerea rezultatului.
*/

SELECT department_name, job_title, round(AVG(salary))
FROM employees e JOIN departments d ON (e.department_id = d.department_id) 
     JOIN jobs j ON (e.job_id = j.job_id)
GROUP BY department_name, job_title, CUBE(e.department_id, e.job_id);

/*
2. a) Sã se afiºeze numele departamentelor, titlurile job-urilor ºi valoarea 
medie a salariilor, pentru:
- fiecare departament ºi, în cadrul sãu pentru fiecare job;
- fiecare departament (indiferent de job);
- fiecare job (indiferent de departament)
- întreg tabelul.
b) Cum intervin coloanele în obþinerea rezultatului? Sã se afiºeze ’Dep’, 
dacã departamentul a intervenit în agregare, ºi ‘Job’, dacã job-ul a 
intervenit în agregare.
*/

SELECT department_name, job_title, round(AVG(salary)), 
       decode(GROUPING(department_name),0, 'Dep'), 
       decode(GROUPING(job_title),0,'job')
FROM employees e JOIN departments d ON(e.department_id = d.department_id)
                 JOIN jobs j ON(e.job_id = j.job_id)
GROUP BY department_name, job_title, CUBE(department_name, job_title);
                 
/*
3. Sã se afiºeze numele departamentelor, numele job-urilor, codurile managerilor, maximul ºi suma salariilor pentru:
- fiecare departament ºi, în cadrul sãu, fiecare job;
- fiecare job ºi, în cadrul sãu, pentru fiecare manager;
- întreg tabelul.
*/

SELECT department_name, job_title, manager_id, MAX(salary), SUM(salary)
FROM employees e JOIN jobs j ON(e.job_id = j.job_id)
GROUP BY department_name, job_title, e.manager_id,
GROUPING SETS((department_id,e.job_id),(e.job_id,manager_id),());
                 
/*
4. Sã se afiºeze salariul maxim al angajatilor doar daca acesta este mai mare decât 15000.
*/

SELECT salary
FROM employees
GROUP BY salary
HAVING MAX(salary) > 15000;

/*
5. a) Sã se afiºeze informaþii despre angajaþii al cãror salariu depãºeºte 
valoarea medie a salariilor colegilor sãi de departament.
b) Analog cu cererea precedentã, afiºându-se ºi numele departamentului ºi media
salariilor acestuia ºi numãrul de angajaþi.
*/

SELECT last_name, salary
FROM employees e,
     (SELECT department_id, round(AVG(salary)) medie
      FROM employees
      GROUP BY department_id) x
WHERE e.salary > x.medie AND e.department_id = x.department_id;

SELECT last_name, salary, department_name, x.angajati
FROM employees e join departments d ON(e.department_id = d.department_id),
     (SELECT department_id, round(AVG(salary)) medie, COUNT(employee_id) angajati
      FROM employees
      GROUP BY department_id) x
WHERE e.salary > x.medie AND e.department_id = x.department_id;

/*
6. Sã se afiºeze numele ºi salariul angajaþilor al cãror salariu este mai mare 
decât salariile medii din toate departamentele. Se cer 2 variante de 
rezolvare: cu operatorul ALL sau cu funcþia MAX.
*/

SELECT last_name, salary
FROM employees 
WHERE salary > ALL(SELECT AVG(salary) 
                   FROM employees
                   GROUP BY department_id);
                   
SELECT last_name, salary
FROM employees 
WHERE salary > (SELECT MAX(AVG(salary)) 
                FROM employees
                GROUP BY department_id);
                
/*
7. Sa se afiseze numele si salariul celor mai prost platiti angajati din fiecare departament.
*/

SELECT last_name, x.minim
FROM employees e,
     (SELECT department_id, MIN(salary) minim
      FROM employees
      GROUP BY department_id) x
WHERE e.salary = x.minim AND e.department_id = x.department_id;

/*
8. Pentru fiecare departament, sã se obtina numele salariatului avand cea mai 
mare vechime din departament. Sã se ordoneze rezultatul dupã numele 
departamentului.
*/

SELECT d.department_name, e.last_name, e.hire_date
FROM departments d, employees e, 
    (SELECT department_id, MIN(hire_date) minim
     FROM employees
     GROUP BY department_id) x
WHERE d.department_id = e.department_id AND x.department_id = e.department_id
      AND e.hire_date = minim
ORDER BY hire_date;

/*
9. Sa se obtina numele salariatilor care lucreaza intr-un departament in care
exista cel putin 1 angajat cu salariul egal cu salariul maxim din departamentul 30.
*/

SELECT e.last_name
FROM employees e, 
    (SELECT COUNT(employee_id) cnt
     FROM employees
     WHERE salary = 
           (SELECT MAX(salary) sal
            FROM employees
            WHERE department_id = 30)) x, employees e2
WHERE cnt > 1 AND e2.department_id = 30 AND e.salary = e2.salary;

/*
10. Sa se obtina numele primilor 3 angajati avand salariul maxim. 
Rezultatul se va afiºa în ordine crescãtoare a salariilor.
*/

SELECT * FROM (SELECT last_name, salary
FROM employees
ORDER BY salary DESC)
WHERE ROWNUM <= 5;

/*
11. Sã se determine locaþiile în care se aflã cel puþin un departament.
*/

SELECT last_name, employee_id
FROM employees e,
    (SELECT manager_id, COUNT(employee_id) nr
     FROM employees
     GROUP BY manager_id) x
WHERE x.nr >= 2 AND x.manager_id = e.employee_id;

/*
12. Sã se determine locaþiile în care se aflã cel puþin un departament.
*/

SELECT location_id
FROM locations
WHERE EXISTS
     (SELECT 1
      FROM departments);
      
SELECT l.location_id, d.department_id
FROM locations l, departments d
WHERE l.location_id = d.location_id(+);

/*
13. Sã se determine departamentele în care nu existã nici un angajat.
*/

SELECT department_id, department_name
FROM departments d
WHERE NOT EXISTS (SELECT 'x'
FROM employees
WHERE department_id = d.department_id);

/*
14. Sã se afiºeze codul, numele, data angajãrii, salariul ºi managerul pentru:
a) subalternii directi ai lui De Haan;
b) ierarhia arborescenta de sub De Haan.
*/

SELECT last_name, hire_date, salary, manager_id, LEVEL
FROM employees
WHERE LEVEL > 1
START WITH employee_id =
          (SELECT employee_id
           FROM employees
           WHERE lower(last_name) LIKE '%de haan%')
CONNECT BY PRIOR employee_id = manager_id AND LEVEL > 1;
     