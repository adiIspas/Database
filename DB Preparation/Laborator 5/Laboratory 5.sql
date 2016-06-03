/*
1.
a) Sã se afiºeze numele departamentelor, titlurile job-urilor ºi valoarea medie a salariilor, pentru:
- fiecare departament ºi, în cadrul sãu pentru fiecare job;
- fiecare departament (indiferent de job);
- întreg tabelul.
b) Analog cu a), afiºând ºi o coloanã care aratã intervenþia coloanelor 
department_name, job_title, în obþinerea rezultatului.
*/

select department_name Departament, job_title Job, round(avg(salary)) Media, grouping(department_name) Dep, grouping(job_title) Tit
from employees e join departments d on (e.department_id = d.department_id) 
     join jobs j on (e.job_id = j.job_id)
group by rollup(d.department_name, j.job_title);


/*
2.
a) Sã se afiºeze numele departamentelor, titlurile job-urilor ºi valoarea medie a salariilor, pentru:
- fiecare departament ºi, în cadrul sãu pentru fiecare job;
- fiecare departament (indiferent de job);
- fiecare job (indiferent de departament)
- întreg tabelul.
*/

select department_name Departament, job_title Job, round(avg(salary)) Media, grouping(department_name) Dep, grouping(job_title) Tit
from employees e join departments d on (e.department_id = d.department_id)
     join jobs j on (e.job_id = j.job_id)
group by cube(department_name,job_title);

/*
3.
Sã se afiºeze numele departamentelor, numele job-urilor, codurile managerilor, maximul ºi suma salariilor pentru:
- fiecare departament ºi, în cadrul sãu, fiecare job;
- fiecare job ºi, în cadrul sãu, pentru fiecare manager;
- întreg tabelul.
*/

select department_name, job_title, e.manager_id, max(salary), sum(salary)
from employees e join departments d on (e.department_id = d.department_id) 
     join jobs j on (e.job_id = j.job_id)
group by grouping sets((department_name,job_title),(job_title,e.manager_id),());

/*
4. Sã se afiºeze salariul maxim al angajatilor doar daca acesta este mai mare decât 15000.
*/

select max(salary)
from employees
group by salary
having max(salary) > 15000;

/*
5. Sã se afiºeze informaþii despre angajaþii al cãror salariu depãºeºte
valoarea medie a salariilor colegilor sãi de departament.
*/

select last_name, salary
from employees e
where salary > 
      (select avg(salary)
       from employees
       where department_id = e.department_id);
       
/*
6. Sã se afiºeze numele ºi salariul angajaþilor al cãror salariu este mai mare 
decât salariile medii din toate departamentele. Se cer 2 variante de rezolvare: 
cu operatorul ALL sau cu funcþia MAX.
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
8. Pentru fiecare departament, sã se obtina numele salariatului avand cea mai 
mare vechime din departament. Sã se ordoneze rezultatul dupã numele departamentului.
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
Rezultatul se va afiºa în ordine crescãtoare a salariilor.
*/

select *
from (select last_name, salary
      from employees
      order by salary desc)
where rownum <= 3;

/*
11. Sã se afiºeze codul, numele ºi prenumele angajaþilor care au cel puþin doi subalterni.
*/

select employee_id, last_name, first_name, cnt
from employees e,
     (select manager_id, count(employee_id) cnt
      from employees
      group by manager_id
     ) t
where cnt >= 2 and t.manager_id = e.employee_id;

/*
12. Sã se determine locaþiile în care se aflã cel puþin un departament.
*/

select city
from locations
where exists (select 1
              from departments);

/*
13. Sã se determine departamentele în care nu existã nici un angajat.
*/

select department_name, department_id
from departments d
where not exists (select 1 
                  from employees
                  where department_id = d.department_id);

/*
14.
Sã se afiºeze codul, numele, data angajãrii, salariul ºi managerul pentru:
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
15. Sã se obþinã ierarhia ºef-subaltern, considerând ca rãdãcinã angajatul având codul 114.
*/

select employee_id, last_name, level
from employees
start with employee_id = 114
connect by manager_id = prior employee_id;

/*
16. Scrieti o cerere ierarhica pentru a afisa codul salariatului, codul 
managerului si numele salariatului, pentru angajatii care sunt cu 2 niveluri 
sub De Haan. Afisati, de asemenea, nivelul angajatului în ierarhie.
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
arborescenta in care va apãrea angajatul, managerul sãu, managerul 
managerului etc. Coloanele afiºate vor fi: codul angajatului, 
codul managerului, nivelul în ierarhie (LEVEL) si numele angajatului. 
Se vor folosi indentari.
*/

select employee_id, last_name, level
from employees
connect by manager_id = prior employee_id;

/*
18. Sã se afiºeze ierarhia de sub angajatul având salariul maxim, 
reþinând numai angajaþii al cãror salariu este mai mare de 5000. 
Se vor afiºa codul, numele, salariul, nivelul din ierarhie ºi codul managerului.
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
19. Utilizând clauza WITH, sã se scrie o cerere care afiºeazã numele
departamentelor ºi valoarea totalã a salariilor din cadrul acestora. 
Se vor considera departamentele a cãror valoare totalã a salariilor este
mai mare decât media valorilor totale ale salariilor tuturor angajatilor.
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
21. Sã se detemine primii 10 cei mai bine plãtiþi angajaþi.
*/

SELECT * FROM (SELECT * FROM employees ORDER BY salary DESC)
WHERE ROWNUM < 11;