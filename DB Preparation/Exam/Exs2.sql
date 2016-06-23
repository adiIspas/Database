/*
Scrie�i o cerere pentru a se afi�a numele, luna (�n litere) �i anul angaj�rii 
pentru to�i salaria�ii din acela�i departament cu Gates, al c�ror nume con�ine 
litera �a�. Se va exclude Gates. Se vor da 2 solu�ii pentru determinarea apari�iei 
literei �A� �n nume. De asemenea, pentru una din metode se va da �i varianta 
join-ului conform standardului SQL99.
*/

select last_name Nume, to_char(hire_date,'MONTH YYYY') Angajare
from employees
where department_id = (select department_id
                        from employees
                        where lower(last_name) like '%gates%')
      and lower(last_name) like '%a%';


/*
S� se afi�eze codul �i numele angaja�ilor care lucreaz� �n acelasi departament 
cu cel pu�in un angajat al c�rui nume con�ine litera �t�. Se vor afi�a, de asemenea, codul �i
numele departamentului respectiv. Rezultatul va fi ordonat alfabetic dup� nume.
Se vor da 2 solu�ii pentru join (condi�ie �n clauza WHERE �i sintaxa introdus� de standardul SQL3).
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
Sa se afiseze numele, salariul, titlul job-ului, ora�ul �i �ara �n care lucreaz� 
angajatii condusi direct de King. Se vor da 2 solu�ii pentru join.
*/

select distinct employee_id, salary, job_title, city, country_id
from employees e join jobs j on (e.job_id = j.job_id) 
     join departments d on (e.department_id = d.department_id) 
     join locations l on (d.location_id = l.location_id)
where e.manager_id = (select employee_id
                    from employees
                    where lower(last_name) like '%king%' and rownum <= 1);


