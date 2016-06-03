/*
2. Sa se afiseze cel mai mare salariu, cel mai mic salariu, suma si media salariilor 
tuturor angajatilor. Etichetati coloanele Maxim, Minim, Suma, respectiv Media. 
Sa se rotunjeasca rezultatele. Sa se salveze instructiunea SQL intr-un fisier p2l4.sql.
*/

select min(salary) Minimul, max(salary) Maximul, sum(salary) Suma, round(avg(salary)) Media
from employees;

/*
3. Sa se modifice fisierul p1l4.sql pentru a se afisa minimul, maximul, 
suma si media salariilor pentru fiecare job. Salvati acest fisier ca p2l4.sql. Executati cererea.
*/

select job_id Job,  min(salary) Minimul, max(salary) Maximul, sum(salary) Suma, round(avg(salary)) Media
from employees
group by job_id;

/*
4. Sa se afiseze numarul de angajati pentru fiecare job.
*/

select job_id Job, count(*) Numar
from employees
group by job_id;

/*
5. Sa se determine numarul de angajati care sunt sefi. Etichetati coloana “Nr. manageri”.
*/

select count(distinct manager_id) Manageri
from employees;

/*
6. Sa se afiseze diferenta dintre cel mai mare si cel mai mic salariu. Etichetati coloana “Diferenta”.
*/

select max(salary) - min(salary) Diferenta
from employees;

/*
7. Scrieti o cerere pentru a se afisa numele departamentului, locatia, 
numarul de angajati si salariul mediu pentru angajatii din acel departament. 
Coloanele vor fi etichetate corespunzator.
*/

select d.department_name Nume, l.city Locatie, count(*) Angajati, round(avg(e.salary)) Salariu
from departments d, locations l, employees e
where d.location_id = l.location_id and d.department_id = e.department_id
group by d.department_name, l.city;

/*
8. Sa se afiseze codul si numele angajatilor care câstiga mai mult decât 
salariul mediu din firma. Se va sorta rezultatul în ordine descrescatoare a salariilor.
*/

select employee_id Cod, last_name Nume
from employees
where salary > (select avg(salary)
                from employees)
order by salary desc;

/*
9. Pentru fiecare sef, sa se afiseze codul sau si salariul celui mai prost 
platit subordonat. Se vor exclude cei pentru care codul managerului nu este cunoscut. 
De asemenea, se vor exclude grupurile în care salariul minim este mai mic de 1000$. 
Sortati rezultatul în ordine descrescatoare a salariilor.
*/

select manager_id Manager, min(salary) "Salariul minim"
from employees
where manager_id is not null
group by manager_id
having min(salary) > 1000
order by 2 desc;

/*
10. Pentru departamentele in care salariul maxim depaseste 3000$, sa se obtina 
codul, numele acestor departamente si salariul maxim pe departament.
*/

select department_id Cod, department_name Nume, (select max(salary) from employees where department_id = d.department_id) "Salariul maxim"
from departments d 
where (select max(salary) from employees where department_id = d.department_id) > 3000 ;

/*
11. Care este salariul mediu minim al job-urilor existente? Salariul mediu al 
unui job va fi considerat drept media arirmetica a salariilor celor care îl practica.
*/

select min(avg(salary)) "Salariul minim"
from employees
group by job_id;

/*
12. Sa se afiseze codul, numele departamentului si suma salariilor pe departamente.
*/

select d.department_id Cod, department_name Nume, SUM(e.salary)
from employees e join departments d on (d.department_id = e.department_id)
group by d.department_id, department_name;

/*
13. Sa se afiseze maximul salariilor medii pe departamente.
*/

select round(max(avg(salary))) 
from employees
group by department_id;

/*
14. Sa se obtina codul, titlul si salariul mediu al job-ului pentru care salariul mediu este minim.
*/

select e.job_id Cod, j.job_title Job, avg(e.salary) Mediu
from employees e join jobs j on (e.job_id = j.job_id)
group by e.job_id, j.job_title
having avg(e.salary) <= all (select avg(salary)
                             from employees
                             group by job_id);

/*
15. Sa se afiseze salariul mediu din firma doar daca acesta este mai mare decât 2500.
*/

select round(avg(salary))
from employees
having avg(salary) > 2500;

/*
16. Sa se afiseze suma salariilor pe departamente si, în cadrul acestora, pe job-uri.
*/

select department_id Departament, job_id Job, sum(salary) Salariu
from employees
where department_id is not null
group by department_id, job_id
order by 1;

/*
17. Sa se afiseze numele departamentului si cel mai mic salariu 
din departamentul avand cel mai mare salariu mediu.
*/

select department_name Departament, round(min(salary)) Salariu
from employees e join departments d on (e.department_id = d.department_id)
group by department_name
having avg(salary) = (select max(avg(salary))
                from employees
                group by department_id);
                
/*
18.
Sa se afiseze codul, numele departamentului si numarul de angajati care lucreaza in acel departament pentru:
a) departamentele in care lucreaza mai putin de 4 angajati;
b) departamentul care are numarul maxim de angajati.
*/

select e.department_id Cod, d.department_name Nume, count(e.employee_id) Angajati
from employees e join departments d on (e.department_id = d.department_id)
group by d.department_name, e.department_id
having count(employee_id) < 4;

select e.department_id Cod, d.department_name Nume, count(e.employee_id) Angajati
from employees e join departments d on (e.department_id = d.department_id)
group by d.department_name, e.department_id
having count(employee_id) = (select max(count(employee_id))
                            from employees
                            group by department_id);
                            
/*
19. Sa se afiseze salariatii care au fost angajati în aceeasi zi a lunii în care cei mai multi dintre salariati au fost angajati.
*/

select last_name || ' ' || first_name Angajat
from employees
where to_char(hire_date,'dd') in (select to_char(hire_date, 'dd')
          from employees
          group by to_char(hire_date,'dd')
          having count(employee_id) = (select max(count(employee_id))
                 from employees
                 group by to_char(hire_date, 'dd')));
                 
/*
20. Sa se obtina numarul departamentelor care au cel putin 15 angajati.
*/

select count(count(department_id)) Departament
from employees
group by department_id
having count(employee_id) > 15;


/*
21.
Sa se obtina codul departamentelor si suma salariilor angajatilor care lucreaza 
în acestea, în ordine crescatoare. Se considera departamentele care au mai mult
de 10 angajati si al caror cod este diferit de 30.
*/

select department_id Departament, sum(salary) Suma
from employees
group by department_id
having count(employee_id) > 10 and department_id != 30
order by 2;

/*
22. Sa se afiseze codul, numele departamentului, numarul de angajati si salariul 
mediu din departamentul respectiv, impreuna cu numele, salariul si jobul 
angajatilor din acel departament. Se vor afisa si departamentele fara angajati (outer join).
*/

select e.department_id, 
       d.department_name,
      (select count(employee_id)
       from employees
       where e.department_id = department_id),
      (select round(avg(salary))
       from employees
       where e.department_id = department_id),
       last_name, 
       job_id,
       salary
from employees e join departments d on (e.department_id = d.department_id)
group by e.department_id, department_name, last_name, job_id, salary;

/*
23. Scrieti o cerere pentru a afisa, pentru departamentele avand codul > 80,
salariul total pentru fiecare job din cadrul departamentului. 
Se vor afisa orasul, numele departamentului, jobul si suma salariilor. 
Se vor eticheta coloanele corespunzator.
*/

select department_name Departament, city Oras, job_id Job, sum(salary) Salariu
from employees e join departments d on (e.department_id = d.department_id) join locations l on (d.location_id = l.location_id)
where d.department_id > 80
group by department_name, city, job_id;

/*
24. Care sunt angajatii care au mai avut cel putin doua joburi?
*/

select employee_id Angajati
from job_history
group by employee_id
having count(employee_id) > 1;

/*
25. Sa se calculeze comisionul mediu din firma, luând în considerare toate liniile din tabel.
*/

select avg(commission_pct)
from employees;

---
SELECT department_id, TO_CHAR(hire_date, 'yyyy'), SUM(salary)
FROM employees
WHERE department_id < 50
GROUP BY CUBE(department_id, TO_CHAR(hire_date, 'yyyy'));

SELECT department_id, TO_CHAR(hire_date, 'yyyy'), SUM(salary)
FROM employees
WHERE department_id < 50
GROUP BY ROLLUP(department_id, TO_CHAR(hire_date, 'yyyy'));
---

/*
27. Scrieti o cerere pentru a afisa job-ul, salariul total pentru job-ul
respectiv pe departamente si salariul total pentru job-ul respectiv pe
departamentele 30, 50, 80. Se vor eticheta coloanele corespunzator.
*/

select job_id Job, department_id Departament, sum(salary) "Salariu total",
       sum(decode(department_id,30,salary,50,salary,80,salary)) "Salariu total pe departamente"
from employees
group by job_id, department_id;

/*
28. Sã se creeze o cerere prin care sã se afiºeze numãrul total de angajaþi ºi, 
din acest total, numãrul celor care au fost angajaþi în 1997, 1998, 1999 si 2000. 
Denumiti capetele de tabel in mod corespunzator.
*/

select count(employee_id), to_char(hire_date,'yyyy')
from employees
group by to_char(hire_date,'yyyy')
having to_char(hire_date,'yyyy') = '1997'
    or to_char(hire_date,'yyyy') = '1998'
    or to_char(hire_date,'yyyy') = '1999'
    or to_char(hire_date,'yyyy') = '2000'
order by to_char(hire_date,'yyyy');

/*
30. Sã se afiºeze codul, numele departamentului ºi suma salariilor pe departamente.
*/

select d.department_id, department_name, a.suma
from departments d, 
                (select department_id, sum(salary) suma
                from employees
                group by department_id) a
where d.department_id = a.department_id;

/*
31. Sã se afiºeze numele, salariul, codul departamentului si salariul mediu din departamentul respectiv.
*/

select d.department_name, e.department_id, round(avg(salary))
from employees e join departments d on (e.department_id = d.department_id)
group by e.department_id, d.department_name;

/*
32. Modificaþi cererea anterioarã, pentru a determina ºi listarea numãrului de angajaþi din departamente.
*/

select d.department_name, e.department_id, round(avg(salary)), count(employee_id)
from employees e join departments d on (e.department_id = d.department_id)
group by e.department_id, d.department_name;

/*
33. Pentru fiecare departament, sã se afiºeze numele acestuia, numele ºi 
salariul celor mai prost plãtiþi angajaþi din cadrul sãu.
*/


select last_name, salary, department_name
from employees e, departments d,
              (select department_id, min(salary) minim
              from employees
              group by department_id) a
where e.department_id = d.department_id and e.department_id = a.department_id and salary = a.minim;