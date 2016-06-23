/*
Scrieþi o cerere pentru a se afiºa numele, luna (în litere) ºi anul angajãrii 
pentru toþi salariaþii din acelaºi departament cu Gates, al cãror nume conþine 
litera “a”. Se va exclude Gates. Se vor da 2 soluþii pentru determinarea apariþiei 
literei “A” în nume. De asemenea, pentru una din metode se va da ºi varianta 
join-ului conform standardului SQL99.
*/

select last_name Nume, to_char(hire_date,'MONTH YYYY') Angajare
from employees
where department_id = (select department_id
                        from employees
                        where lower(last_name) like '%gates%')
      and lower(last_name) like '%a%';


/*
Sã se afiºeze codul ºi numele angajaþilor care lucreazã în acelasi departament 
cu cel puþin un angajat al cãrui nume conþine litera “t”. Se vor afiºa, de asemenea, codul ºi
numele departamentului respectiv. Rezultatul va fi ordonat alfabetic dupã nume.
Se vor da 2 soluþii pentru join (condiþie în clauza WHERE ºi sintaxa introdusã de standardul SQL3).
*/

select employee_id, last_name, e.department_id, department_name
from employees e join departments d on (e.department_id = d.department_id)
where e.department_id in (select distinct department_id
                          from employees
                          where lower(last_name) like '%t%' and department_id is not null)
order by last_name;


select distinct e1.employee_id Cod1, e1.last_name Nume1, e2.employee_id Cod2, e2.last_name Nume2, d.department_name Departament2
from employees e1 join employees e2 on(e1.department_id = e2.department_id) join departments d on (e1.department_id = e2.department_id)
where lower(e1.last_name) like '%x%' and e1.last_name < e2.last_name
order by e1.last_name;



/*
Sa se afiseze numele, salariul, titlul job-ului, oraºul ºi þara în care lucreazã 
angajatii condusi direct de King. Se vor da 2 soluþii pentru join.
*/

select distinct employee_id, salary, job_title, city, country_id
from employees e join jobs j on (e.job_id = j.job_id) 
     join departments d on (e.department_id = d.department_id) 
     join locations l on (d.location_id = l.location_id)
where e.manager_id = (select employee_id
                    from employees
                    where lower(last_name) like '%king%' and rownum <= 1);


