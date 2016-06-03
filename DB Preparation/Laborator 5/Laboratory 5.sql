/*
1.
a) S� se afi�eze numele departamentelor, titlurile job-urilor �i valoarea medie a salariilor, pentru:
- fiecare departament �i, �n cadrul s�u pentru fiecare job;
- fiecare departament (indiferent de job);
- �ntreg tabelul.
b) Analog cu a), afi��nd �i o coloan� care arat� interven�ia coloanelor 
department_name, job_title, �n ob�inerea rezultatului.
*/

select department_name Departament, job_title Job, round(avg(salary)) Media, grouping(department_name) Dep, grouping(job_title) Tit
from employees e join departments d on (e.department_id = d.department_id) 
     join jobs j on (e.job_id = j.job_id)
group by rollup(d.department_name, j.job_title);


/*
2.
a) S� se afi�eze numele departamentelor, titlurile job-urilor �i valoarea medie a salariilor, pentru:
- fiecare departament �i, �n cadrul s�u pentru fiecare job;
- fiecare departament (indiferent de job);
- fiecare job (indiferent de departament)
- �ntreg tabelul.
*/

select department_name Departament, job_title Job, round(avg(salary)) Media, grouping(department_name) Dep, grouping(job_title) Tit
from employees e join departments d on (e.department_id = d.department_id)
     join jobs j on (e.job_id = j.job_id)
group by cube(department_name,job_title);

/*
3.
S� se afi�eze numele departamentelor, numele job-urilor, codurile managerilor, maximul �i suma salariilor pentru:
- fiecare departament �i, �n cadrul s�u, fiecare job;
- fiecare job �i, �n cadrul s�u, pentru fiecare manager;
- �ntreg tabelul.
*/

select department_name, job_title, e.manager_id, max(salary), sum(salary)
from employees e join departments d on (e.department_id = d.department_id) 
     join jobs j on (e.job_id = j.job_id)
group by grouping sets((department_name,job_title),(job_title,e.manager_id),());

/*
4. S� se afi�eze salariul maxim al angajatilor doar daca acesta este mai mare dec�t 15000.
*/

select max(salary)
from employees
group by salary
having max(salary) > 15000;

/*
5. S� se afi�eze informa�ii despre angaja�ii al c�ror salariu dep�e�te
valoarea medie a salariilor colegilor s�i de departament.
*/

select last_name, salary
from employees e
where salary > 
      (select avg(salary)
       from employees
       where department_id = e.department_id);
       
/*
6. S� se afi�eze numele �i salariul angaja�ilor al c�ror salariu este mai mare 
dec�t salariile medii din toate departamentele. Se cer 2 variante de rezolvare: 
cu operatorul ALL sau cu func�ia MAX.
*/

select last_name, salary
from employees e
where salary > all
      (select avg(salary)
       from employees
       group by department_id);p
   
/*    
7. Sa se afiseze numele si salariul celor mai prost platiti angajati din fiecare departament.
*/

select last_name, salary, department_id
from employees e
where salary = (select min(salary)
                from employees
                where e.department_id = department_id);
                
/*
8. Pentru fiecare departament, s� se obtina numele salariatului avand cea mai 
mare vechime din departament. S� se ordoneze rezultatul dup� numele departamentului.
*/

select last_name, department_name
from employees e join departments d on (e.department_id = d.department_id)
where hire_date = (select min(hire_date)
                   from employees
                   where e.department_id = department_id)
order by department_name;
                
/*
9. Sa se obtina numele salariatilor care lucreaza intr-un departament in 
care exista cel putin 1 angajat cu salariul egal cu salariul maxim din departamentul 30.
*/

select last_name, salary
from employees
where department_id in (select department_id
                    from employees
                    where salary = (select max(salary) maxim30
                                from employees
                                where department_id = 30));
                              

/*
10. Sa se obtina numele primilor 3 angajati avand salariul maxim. 
Rezultatul se va afi�a �n ordine cresc�toare a salariilor.
*/

select *
from (select last_name, salary
      from employees
      order by salary desc)
where rownum <= 3;

/*
11. S� se afi�eze codul, numele �i prenumele angaja�ilor care au cel pu�in doi subalterni.
*/

select employee_id, last_name, first_name, cnt
from employees e,
     (select manager_id, count(employee_id) cnt
      from employees
      group by manager_id
     ) t
where cnt >= 2 and t.manager_id = e.employee_id;

/*
12. S� se determine loca�iile �n care se afl� cel pu�in un departament.
*/

select city
from locations
where exists (select 1
              from departments);

/*
13. S� se determine departamentele �n care nu exist� nici un angajat.
*/

select department_name, department_id
from departments d
where not exists (select 1 
                  from employees
                  where department_id = d.department_id);

/*
14.
S� se afi�eze codul, numele, data angaj�rii, salariul �i managerul pentru:
a) subalternii directi ai lui De Haan;
b) ierarhia arborescenta de sub De Haan.
*/

SELECT employee_id, last_name, hire_date, salary, manager_id
FROM employees 
START WITH employee_id=( SELECT employee_id
FROM employees
WHERE LOWER(last_name)='de haan')
CONNECT BY manager_id = PRIOR employee_id;

/*
15. S� se ob�in� ierarhia �ef-subaltern, consider�nd ca r�d�cin� angajatul av�nd codul 114.
*/

select employee_id, last_name, level
from employees
start with employee_id = 114
connect by manager_id = prior employee_id;

/*
16. Scrieti o cerere ierarhica pentru a afisa codul salariatului, codul 
managerului si numele salariatului, pentru angajatii care sunt cu 2 niveluri 
sub De Haan. Afisati, de asemenea, nivelul angajatului �n ierarhie.
*/

select employee_id, manager_id, last_name, level
from employees
where level > 2
start with employee_id = (select employee_id
            from employees
            where lower(last_name) = 'de haan')
connect by manager_id = prior employee_id;          

/*
17. Pentru fiecare linie din tabelul EMPLOYEES, se va afisa o structura 
arborescenta in care va ap�rea angajatul, managerul s�u, managerul 
managerului etc. Coloanele afi�ate vor fi: codul angajatului, 
codul managerului, nivelul �n ierarhie (LEVEL) si numele angajatului. 
Se vor folosi indentari.
*/

select employee_id, last_name, level
from employees
connect by manager_id = prior employee_id;

/*
18. S� se afi�eze ierarhia de sub angajatul av�nd salariul maxim, 
re�in�nd numai angaja�ii al c�ror salariu este mai mare de 5000. 
Se vor afi�a codul, numele, salariul, nivelul din ierarhie �i codul managerului.
*/

select employee_id, last_name, level, salary
from employees
where salary > 5000
start with employee_id = (select employee_id
                          from employees
                          where salary = (
                                select max(salary)
                                from employees))
connect by manager_id = prior employee_id;

/*
19. Utiliz�nd clauza WITH, s� se scrie o cerere care afi�eaz� numele
departamentelor �i valoarea total� a salariilor din cadrul acestora. 
Se vor considera departamentele a c�ror valoare total� a salariilor este
mai mare dec�t media valorilor totale ale salariilor tuturor angajatilor.
*/

WITH val_dep AS (SELECT department_name, SUM(salary) AS total
FROM departments d, employees e
WHERE d.department_id = e.department_id
GROUP BY department_name),
val_medie AS (SELECT SUM(total)/COUNT(*) AS medie
FROM val_dep)
SELECT *
FROM val_dep
WHERE total > (SELECT medie
FROM val_medie)
ORDER BY department_name;

/*
21. S� se detemine primii 10 cei mai bine pl�ti�i angaja�i.
*/

SELECT * FROM (SELECT * FROM employees ORDER BY salary DESC)
WHERE ROWNUM < 11;