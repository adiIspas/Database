/*
1. Scrieþi o cerere pentru a se afiºa numele, luna (în litere) ºi anul angajãrii
pentru toþi salariaþii din acelaºi departament cu Gates, al cãror nume conþine 
litera “a”. Se va exclude Gates. Se vor da 2 soluþii pentru determinarea apariþiei 
literei “A” în nume. De asemenea, pentru una din metode se va da ºi varianta 
join-ului conform standardului SQL99.
*/

select last_name Nume, to_char(hire_date,'MONTH YYYY') "Data angajarii"
from employees
where lower(last_name) like '%a%' and lower(last_name) not like '%gates%' 
      and department_id = ( select department_id
                            from employees
                            where lower(last_name) like '%gates%');
                            
/*
2. Sã se afiºeze codul ºi numele angajaþilor care lucreazã în acelasi departament 
cu cel puþin un angajat al cãrui nume conþine litera “t”. Se vor afiºa, de asemenea, codul ºi
numele departamentului respectiv. Rezultatul va fi ordonat alfabetic dupã nume.
Se vor da 2 soluþii pentru join (condiþie în clauza WHERE ºi sintaxa introdusã de standardul SQL3).
*/

select distinct e1.employee_id Cod1, e1.last_name Nume1, e2.employee_id Cod2, e2.last_name Nume2, d.department_name Departament2
from employees e1 join employees e2 on(e1.department_id = e2.department_id) join departments d on (e1.department_id = e2.department_id)
where lower(e1.last_name) like '%x%' and e1.last_name < e2.last_name
order by e1.last_name;

/*
3. Sa se afiseze numele, salariul, titlul job-ului, oraºul ºi þara în care
lucreazã angajatii condusi direct de King. Se vor da 2 soluþii pentru join.
*/

select e1.last_name Nume, e1.salary Salariul, j.job_title Job, l.city Oras, l.country_id Tara
from employees e1 join employees e2 on (e1.manager_id = e2.employee_id) 
    join jobs j on (e1.job_id = j.job_id) 
    join departments d on (e1.department_id = d.department_id)
    join locations l on (d.location_id = l.location_id)
where lower(e2.last_name) like '%king%'
order by e1.last_name;

/*
5. Sa se afiseze codul departamentului, numele departamentului, numele si job-ul 
tuturor angajatilor din departamentele al cãror nume conþine ºirul ‘ti’. 
De asemenea, se va lista salariul angajaþilor, în formatul “$99,999.00”. 
Rezultatul se va ordona alfabetic dupã numele departamentului, ºi în cadrul acestuia, dupã numele angajaþilor.
*/

select e.department_id "Cod departament", d.department_name "Nume departament",
       e.last_name Nume, j.job_title Job, to_char(e.salary, '$99,999.00') Salariu
from employees e join departments d on (e.department_id = d.department_id)
     join jobs j on (e.job_id = j.job_id)
where lower(d.department_name) like '%ti%'
order by d.department_name;

/*
6. Sa se afiseze numele angajatilor, numarul departamentului, numele departamentului, 
oraºul si job-ul tuturor salariatilor al caror departament este localizat in Oxford.
*/

select e.last_name, e.department_id, d.department_name, l.city, j.job_title
from employees e join departments d on (e.department_id = d.department_id)
     join jobs j on (e.job_id = j.job_id) 
     join locations l on (d.location_id = l.location_id)
where lower(l.city) like '%oxford%';

/*
7. Sa se modifice fisierul p2l3.sql pentru a afisa codul, numele si salariul tuturor 
angajatilor care castiga mai mult decat salariul mediu pentru job-ul corespunzãtor
si lucreaza intr-un departament cu cel putin unul din angajatii al caror nume 
contine litera “t”. Salvati ca p7l3.sql. Executati cererea.
*/

select employee_id Cod, last_name Nume, salary Salariu
from employees e join departments d on (e.department_id = d.department_id)
where salary > ANY (select avg(salary)
                    from employees
                    group by job_id) and
      lower(d.department_name) like '%t%';

/*
8. Sã se afiºeze numele salariaþilor ºi numele departamentelor în care lucreazã. 
Se vor afiºa ºi salariaþii care nu au asociat un departament. (right outer join, 2 variante).
*/

select e.last_name Nume, d.department_name Departament
from employees e left outer join departments d on (e.department_id = d.department_id);

/*
9. Sã se afiºeze numele departamentelor ºi numele salariaþilor care lucreazã în ele. 
Se vor afiºa ºi departamentele care nu au salariaþi. (left outer join, 2 variante)
*/

select e.last_name Nume, d.department_name Departament
from employees e right outer join departments d on (e.department_id = d.department_id);

/*
11. Se cer codurile departamentelor al cãror nume conþine ºirul “re” sau 
în care lucreazã angajaþi având codul job-ului “SA_REP”.
*/

select department_id
from departments
where lower(department_name) like '%re%'
union
(select department_id
from employees
where lower(job_id) like '%sa_rep%');

/*
13. Sa se obtina codurile departamentelor in care nu lucreaza nimeni 
(nu este introdus nici un salariat in tabelul employees). Se cer douã soluþii.
*/

select department_id
from departments
minus
(select department_id
from employees);

/*
14. Se cer codurile departamentelor al cãror nume conþine ºirul “re”
ºi în care lucreazã angajaþi având codul job-ului “HR_REP”.
*/

select department_id
from departments
where lower(department_name) like '%re%'
intersect
(select department_id
from employees
where lower(job_id) like '%hr_rep%');

/*
15.
Sã se determine codul angajaþilor, codul job-urilor ºi numele celor al cãror 
salariu este mai mare decât 3000 sau este egal cu media dintre salariul 
minim ºi cel maxim pentru job-ul respectiv.
*/

select employee_id, job_id, last_name
from employees
where salary > 3000
union
select e.employee_id, e.job_id, e.last_name
from employees e join jobs j on (e.job_id = j.job_id)
where salary = (min_salary + max_salary)/2;

/*
16. Folosind subcereri, sã se afiºeze numele ºi data angajãrii pentru salariaþii care au fost angajaþi dupã Gates.
*/

select last_name, hire_date
from employees
where hire_date >
(select hire_date
from employees
where lower(last_name) like '%gates%');

/*
17. Folosind subcereri, scrieþi o cerere pentru a afiºa numele ºi salariul 
pentru toþi colegii (din acelaºi departament) lui Gates. Se va exclude Gates.
*/

select last_name, salary
from employees
where department_id = 
      (select department_id
       from employees
       where lower(last_name) like '%gates%') and lower(last_name) not like '%gates%';
       
/*
18. Folosind subcereri, sã se afiºeze numele ºi salariul angajaþilor conduºi 
direct de preºedintele companiei (acesta este considerat angajatul care nu are manager).
*/

select last_name, salary
from employees
where manager_id = 
      (select employee_id
       from employees
       where manager_id is null);
       
/*
19. Scrieti o cerere pentru a afiºa numele, codul departamentului si salariul 
angajatilor al caror numãr de departament si salariu coincid cu numarul 
departamentului si salariul unui angajat care castiga comision.
*/

select last_name, department_id, salary
from employees
where (department_id, salary) in (
      select department_id, salary
      from employees
      where commission_pct is not null);

/*
21. Scrieti o cerere pentru a afisa angajatii care castiga mai mult decat oricare 
functionar (job-ul conþine ºirul “CLERK”). Sortati rezultatele dupa salariu, in ordine descrescatoare. (ALL)
*/

select last_name, salary
from employees
where salary > all
      (select salary
      from employees
      where lower(job_id) like '%clerk%')
order by salary desc;

/*
22. Scrieþi o cerere pentru a afiºa numele, numele departamentului ºi salariul 
angajaþilor care nu câºtigã comision, dar al cãror ºef direct coincide cu ºeful 
unui angajat care câºtigã comision.
*/

select e.last_name, d.department_name, e.salary
from employees e join departments d on (e.department_id = d.department_id)
where e.commission_pct is null and e.manager_id in (
select manager_id
from employees
where employee_id in (select employee_id
                      from employees
                      where commission_pct is not null));
                      
/*
23. Sa se afiseze numele, departamentul, salariul ºi job-ul tuturor angajatilor
al caror salariu si comision coincid cu salariul si comisionul unui angajat din Oxford.
*/

select last_name, department_id, salary, job_id
from employees
where (salary, commission_pct) in (
      select salary, commission_pct
      from employees join departments using (department_id) join locations l using (location_id)
      where lower(l.city) like '%oxford%');
      
/*
24. Sã se afiºeze numele angajaþilor, codul departamentului ºi codul job-ului 
salariaþilor al cãror departament se aflã în Toronto.
*/

select last_name, department_id, job_id
from employees
where department_id = (
      select department_id
      from departments join locations using (location_id)
      where lower(city) like '%toronto%');