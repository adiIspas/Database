/*
10. Cum se poate implementa full outer join?
Obs: Full outer join se poate realiza fie prin reuniunea rezultatelor lui right outer join �i left outer join, fie utiliz�nd sintaxa introdus� de standardul SQL99.
*/
SELECT last_name, department_name
FROM employees e, departments d
WHERE e.department_id(+) = d.department_id
UNION
(SELECT last_name, department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id(+));

/*
11.
Se cer codurile departamentelor al c�ror nume con�ine �irul �re� sau �n care lucreaz� angaja�i av�nd codul job-ului �SA_REP�.
*/

SELECT department_id
FROM departments
WHERE lower(department_name) LIKE '%re%'
UNION
 (SELECT department_id
  FROM employees
  WHERE lower(job_id) LIKE '%re%');
  
/*
12. Sa se obtina codurile departamentelor in care nu lucreaza nimeni (nu este introdus nici un salariat in tabelul employees). Se cer dou� solu�ii.
*/

SELECT department_id
FROM departments
MINUS
  (SELECT department_id
   FROM employees
   );
      
/*
14. Se cer codurile departamentelor al c�ror nume con�ine �irul �re� �i �n care lucreaz� angaja�i av�nd codul job-ului �HR_REP�.
*/

SELECT department_id
FROM departments
WHERE lower(department_name) LIKE '%re%'
INTERSECT
SELECT department_id
FROM employees
WHERE lower(job_id) like '%re%';

/*
15. S� se determine codul angaja�ilor, codul job-urilor �i numele celor al c�ror salariu este mai mare dec�t 3000 sau este egal cu media dintre salariul minim �i cel maxim pentru job-ul respectiv.
*/

SELECT employee_id, job_id, last_name
FROM employees
WHERE salary > 3000
UNION
SELECT employee_id, job_id, last_name
FROM jobs JOIN employees USING(job_id)
WHERE salary = (min_salary + max_salary)/2;

/*
16. Folosind subcereri, s� se afi�eze numele �i data angaj�rii pentru salaria�ii care au fost angaja�i dup� Gates.
*/

SELECT last_name, hire_date
FROM employees
WHERE hire_date < (select hire_date from employees where upper(last_name) like '%GATES%');

/*
17. Folosind subcereri, scrie�i o cerere pentru a afi�a numele �i salariul pentru to�i colegii (din acela�i departament) lui Gates. Se va exclude Gates.
*/

SELECT last_name, salary
FROM employees
WHERE department_id = (select department_id from employees where lower(last_name) like '%gates%')
and lower(last_name) <> 'gates';

/*
18. Folosind subcereri, s� se afi�eze numele �i salariul angaja�ilor condu�i direct de pre�edintele companiei (acesta este considerat angajatul care nu are manager).
*/

SELECT last_name, salary
FROM employees
WHERE manager_id = (SELECT employee_id from employees where manager_id is NULL);

/*
19. Scrieti o cerere pentru a afi�a numele, codul departamentului si salariul angajatilor al caror num�r de departament si salariu coincid cu numarul departamentului si salariul unui angajat care castiga comision.
*/

SELECT last_name, department_id, salary
FROM employees
WHERE (department_id, salary) in (select department_id, salary from employees where commission_pct is not null);

SELECT DISTINCT e1.employee_id, e1.last_name, e1.salary
FROM employees e1 join departments d on (e1.department_id = d.department_id) join jobs j on (e1.job_id = j.job_id)
                  join employees e2 on (e1.department_id = e2.department_id)
WHERE e1.salary > (min_salary + max_salary) / 2 AND lower(e2.last_name) like '%t%';

SELECT employee_id, last_name, salary
FROM employees JOIN jobs USING(job_id)
WHERE salary > (min_salary + max_salary)/2 AND department_id IN (
      SELECT department_id
      FROM employees
      WHERE lower(last_name) like '%t%');
      
/*
21. Scrieti o cerere pentru a afisa angajatii care castiga mai mult decat oricare functionar (job-ul con�ine �irul �CLERK�). Sortati rezultatele dupa salariu, in ordine descrescatoare. (ALL)
*/

SELECT last_name, salary
FROM employees
WHERE salary > ALL(SELECT salary
                FROM employees JOIN jobs USING (job_id)
                WHERE lower(job_id) LIKE '%clerk%')
ORDER BY salary DESC;

/*
22. Scrie�i o cerere pentru a afi�a numele, numele departamentului �i salariul angaja�ilor care nu c�tig� comision, dar al c�ror �ef direct coincide cu �eful unui angajat care c�tig� comision.
*/

SELECT last_name, department_name, salary
from employees join departments using(department_id)
WHERE commission_pct is NULL and employees.manager_id in (SELECT manager_id FROM employees WHERE commission_pct is not null);

/*
23. Sa se afiseze numele, departamentul, salariul �i job-ul tuturor angajatilor al caror salariu si comision coincid cu salariul si comisionul unui angajat din Oxford.
*/

SELECT last_name, department_id, salary, job_id
FROM employees
WHERE (salary, commission_pct) in (select salary,commission_pct from employees join departments using(department_id) join locations using(location_id)
WHERE lower(city) like '%oxford%');
  
/*
24. S� se afi�eze numele angaja�ilor, codul departamentului �i codul job-ului salaria�ilor al c�ror departament se afl� �n Toronto.
*/

SELECT last_name, department_id, salary, job_id
FROM employees join departments using (department_id)
join locations using(location_id)
WHERE lower(city) like '%toronto%';

/*LABORATORY 4*/

/*
2. S� se afi�eze cel mai mare salariu, cel mai mic salariu, suma �i media salariilor tuturor angaja�ilor. Eticheta�i coloanele Maxim, Minim, Suma, respectiv Media. Sa se rotunjeasca rezultatele. Sa se salveze instructiunea SQL intr-un fisier p2l4.sql.
*/

SELECT max(salary), min(salary), sum(salary), round(avg(salary))
FROM employees;

/*
9. Pentru fiecare �ef, s� se afi�eze codul s�u �i salariul celui mai prost platit subordonat. 
Se vor exclude cei pentru care codul managerului nu este cunoscut. 
De asemenea, se vor exclude grupurile �n care salariul minim este mai mic de 1000$. 
Sorta�i rezultatul �n ordine descresc�toare a salariilor.
*/

SELECT e.employee_id, (SELECT MIN(salary) FROM employees WHERE e.employee_id = manager_id)
FROM employees e
WHERE e.manager_id is not null and employee_id in (SELECT DISTINCT manager_id from employees)
AND (SELECT MIN(salary) FROM employees where e.employee_id = manager_id) > 5000
ORDER BY 2;

/*
10. Pentru departamentele in care salariul maxim dep�e�te 3000$, s� se ob�in� codul, 
numele acestor departamente �i salariul maxim pe departament.
*/

SELECT department_id, department_name, (SELECT max(salary) FROM employees WHERE department_id = d.department_id)
FROM departments d
WHERE (SELECT max(salary) FROM employees WHERE department_id = d.department_id) > 3000;

/*
11. Care este salariul mediu minim al job-urilor existente? Salariul mediu al unui job va fi considerat drept media arirmetic� a salariilor celor care �l practic�.
*/

SELECT MIN(AVG(salary))
FROM employees
GROUP BY job_id;

/*
12. S� se afi�eze codul, numele departamentului �i suma salariilor pe departamente.
*/

SELECT department_id, department_name, SUM(salary)
FROM departments join employees using(department_id)
GROUP BY department_id, department_name;

/*
13. S� se afi�eze maximul salariilor medii pe departamente.
*/

SELECT round(MAX(AVG(salary)))
FROM employees
GROUP BY department_id;

/*
15. S� se afi�eze salariul mediu din firm� doar dac� acesta este mai mare dec�t 2500.
*/

SELECT round(AVG(salary))
FROM employees
HAVING AVG(salary) > 2500;

/*
16. S� se afi�eze suma salariilor pe departamente �i, �n cadrul acestora, pe job-uri.
*/

SELECT job_id, SUM(salary) 
FROM employees 
GROUP BY GROUPING SETS(job_id);

/*
17. S� se afi�eze numele departamentului si cel mai mic salariu din departamentul avand cel mai mare salariu mediu.
*/

SELECT d.department_name, c.f1
FROM departments d, (SELECT MAX(AVG(salary)) f1 FROM employees GROUP BY department_id) a,
                    (SELECT department_id, AVG(salary) f1 FROM employees GROUP BY department_id) b,
                    (SELECT department_id, MIN(salary) f1 FROM employees GROUP BY department_id) c
WHERE d.department_id = b.department_id AND d.department_id = c.department_id AND b.f1 = a.f1;


