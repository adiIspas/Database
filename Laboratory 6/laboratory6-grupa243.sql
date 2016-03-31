/*
25. S� se calculeze comisionul mediu din firm�, lu�nd �n considerare toate liniile din tabel.
*/

SELECT ROUND(AVG(NVL(commission_pct,0)),3)
FROM employees;

/*
27. Scrie�i o cerere pentru a afi�a job-ul, salariul total pentru job-ul respectiv 
pe departamente si salariul total pentru job-ul respectiv pe departamentele 
30, 50, 80. Se vor eticheta coloanele corespunz�tor.
*/

SELECT job_id "Job", department_id "Departament", SUM(salary) "Salariu total", 
       SUM(decode(department_id, 30, salary, 50, salary, 80, salary)) "Departament 30 | 50 | 80"
FROM employees
GROUP BY job_id, department_id;

/*
28. S� se creeze o cerere prin care s� se afi�eze num�rul total de angaja�i �i, 
din acest total, num�rul celor care au fost angaja�i �n 1997, 1998, 1999 si 
2000. Denumiti capetele de tabel in mod corespunzator.
*/

SELECT COUNT(employee_id) "Nr angajati", 
       COUNT(decode(to_char(hire_date,'yyyy'),1997,employee_id)) "1997",
       COUNT(decode(to_char(hire_date,'yyyy'),1998,employee_id)) "1998",
       COUNT(decode(to_char(hire_date,'yyyy'),1999,employee_id)) "1999",
       COUNT(decode(to_char(hire_date,'yyyy'),2000,employee_id)) "2000"
FROM employees;

/*
30. S� se afi�eze codul, numele departamentului �i suma salariilor pe departamente.
*/

SELECT d.department_id, department_name, a.suma
FROM departments d, 
     (SELECT department_id, SUM(salary) suma
      FROM employees
      GROUP BY department_id) a
WHERE d.department_id = a.department_id;

/*
33. Pentru fiecare departament, s� se afi�eze numele acestuia, numele �i salariul 
celor mai prost pl�ti�i angaja�i din cadrul s�u.
*/

SELECT last_name, salary, department_name
FROM employees e, departments d,
     (SELECT department_id, MIN(salary) minim
      FROM employees
      GROUP BY department_id) x
WHERE x.department_id = e.department_id AND salary = minim 
      AND e.department_id = d.department_id;

/*
34. Rezolva�i problema 22 cu ajutorul subcererilor specificate �n clauza FROM.
*/

SELECT d.department_id, department_name, x.nr, x.medie, last_name, job_id, salary
FROM employees e, departments d,
     (SELECT department_id, COUNT(employee_id) nr, ROUND(AVG(salary)) medie
      FROM employees
      GROUP BY department_id) x
WHERE d.department_id = e.department_id AND e.department_id = x.department_id;

/*
1. a) S� se afi�eze numele departamentelor, titlurile job-urilor �i valoarea medie a salariilor, pentru:
- fiecare departament �i, �n cadrul s�u pentru fiecare job;
- fiecare departament (indiferent de job);
- �ntreg tabelul.
b) Analog cu a), afi��nd �i o coloan� care arat� interven�ia coloanelor department_name, job_title, �n ob�inerea rezultatului.
*/

SELECT department_name, job_title, round(AVG(salary))
FROM employees e JOIN departments d ON (e.department_id = d.department_id) 
     JOIN jobs j ON (e.job_id = j.job_id)
GROUP BY department_name, job_title, CUBE(e.department_id, e.job_id);

/*
2. a) S� se afi�eze numele departamentelor, titlurile job-urilor �i valoarea 
medie a salariilor, pentru:
- fiecare departament �i, �n cadrul s�u pentru fiecare job;
- fiecare departament (indiferent de job);
- fiecare job (indiferent de departament)
- �ntreg tabelul.
b) Cum intervin coloanele �n ob�inerea rezultatului? S� se afi�eze �Dep�, 
dac� departamentul a intervenit �n agregare, �i �Job�, dac� job-ul a 
intervenit �n agregare.
*/

SELECT department_name, job_title, round(AVG(salary)), 
       decode(GROUPING(department_name),0, 'Dep'), 
       decode(GROUPING(job_title),0,'job')
FROM employees e JOIN departments d ON(e.department_id = d.department_id)
                 JOIN jobs j ON(e.job_id = j.job_id)
GROUP BY department_name, job_title, CUBE(department_name, job_title);
                 
/*
3. S� se afi�eze numele departamentelor, numele job-urilor, codurile managerilor, maximul �i suma salariilor pentru:
- fiecare departament �i, �n cadrul s�u, fiecare job;
- fiecare job �i, �n cadrul s�u, pentru fiecare manager;
- �ntreg tabelul.
*/

SELECT department_name, job_title, manager_id, MAX(salary), SUM(salary)
FROM employees e JOIN jobs j ON(e.job_id = j.job_id)
GROUP BY department_name, job_title, e.manager_id,
GROUPING SETS((department_id,e.job_id),(e.job_id,manager_id),());
                 
/*
4. S� se afi�eze salariul maxim al angajatilor doar daca acesta este mai mare dec�t 15000.
*/

SELECT salary
FROM employees
GROUP BY salary
HAVING MAX(salary) > 15000;

/*
5. a) S� se afi�eze informa�ii despre angaja�ii al c�ror salariu dep�e�te 
valoarea medie a salariilor colegilor s�i de departament.
b) Analog cu cererea precedent�, afi��ndu-se �i numele departamentului �i media
salariilor acestuia �i num�rul de angaja�i.
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
6. S� se afi�eze numele �i salariul angaja�ilor al c�ror salariu este mai mare 
dec�t salariile medii din toate departamentele. Se cer 2 variante de 
rezolvare: cu operatorul ALL sau cu func�ia MAX.
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
8. Pentru fiecare departament, s� se obtina numele salariatului avand cea mai 
mare vechime din departament. S� se ordoneze rezultatul dup� numele 
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
Rezultatul se va afi�a �n ordine cresc�toare a salariilor.
*/

SELECT * FROM (SELECT last_name, salary
FROM employees
ORDER BY salary DESC)
WHERE ROWNUM <= 5;

/*
11. S� se determine loca�iile �n care se afl� cel pu�in un departament.
*/

SELECT last_name, employee_id
FROM employees e,
    (SELECT manager_id, COUNT(employee_id) nr
     FROM employees
     GROUP BY manager_id) x
WHERE x.nr >= 2 AND x.manager_id = e.employee_id;

/*
12. S� se determine loca�iile �n care se afl� cel pu�in un departament.
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
13. S� se determine departamentele �n care nu exist� nici un angajat.
*/

SELECT department_id, department_name
FROM departments d
WHERE NOT EXISTS (SELECT 'x'
FROM employees
WHERE department_id = d.department_id);

/*
14. S� se afi�eze codul, numele, data angaj�rii, salariul �i managerul pentru:
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
     