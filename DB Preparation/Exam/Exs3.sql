/*
S� se afi�eze numele salaria�ilor �i numele departamentelor �n care lucreaz�. 
Se vor afi�a �i salaria�ii care nu au asociat un departament.
*/

select last_name, department_name
from employees e join departments d on (e.department_id = d.department_id);

/*
Folosind subcereri, s� se afi�eze numele �i data angaj�rii pentru salaria�ii care au fost angaja�i dup� Gates.
*/

select last_name, hire_date
from employees
where hire_date > (select hire_date
                   from employees
                   where lower(last_name) like '%gates%');
                   

/*
Folosind subcereri, scrie�i o cerere pentru a afi�a numele �i salariul pentru 
to�i colegii (din acela�i departament) lui Gates. Se va exclude Gates.
*/

select last_name, salary
from employees
where department_id = (select department_id
                       from employees
                       where lower(last_name) like '%gates%') 
                       and lower(last_name) not like '%gates%';

/*
S� se afi�eze numele angaja�ilor, codul departamentului �i codul job-ului 
salaria�ilor al c�ror departament se afl� �n Toronto.
*/

select last_name, department_id, job_id
from employees
where department_id in (select department_id
                        from departments d join locations j on (d.location_id = j.location_id)
                        where lower(city) like '%toronto%');
                        
                        
/*
S� se modifice fisierul p1l4.sql pentru a se afi�a minimul, maximul, 
suma �i media salariilor pentru fiecare job. Salvati acest fisier ca p2l4.sql. Executa�i cererea.
*/

select job_id, min(salary), max(salary), sum(salary), avg(salary)
from employees
group by job_id;

/*
Scrie�i o cerere pentru a se afi�a numele departamentului, loca�ia, 
num�rul de angaja�i �i salariul mediu pentru angaja�ii din acel departament. 
Coloanele vor fi etichetate corespunz�tor.
*/

select department_name, d.location_id, count(employee_id), round(avg(salary))
from employees e join departments d on (e.department_id = d.department_id)
     join locations l on (d.location_id = l.location_id)
group by e.department_id, department_name, d.location_id;

/*
Pentru fiecare �ef, s� se afi�eze codul s�u �i salariul celui mai prost platit 
subordonat. Se vor exclude cei pentru care codul managerului nu este cunoscut. 
De asemenea, se vor exclude grupurile �n care salariul minim este mai mic de 1000$. 
Sorta�i rezultatul �n ordine descresc�toare a salariilor.
*/

select manager_id, min(salary)
from employees
where manager_id is not null
group by manager_id
having min(salary) > 1000;

/*
Sa se afiseze codul, numele departamentului si numarul de angajati care lucreaza in acel departament pentru:
a) departamentele in care lucreaza mai putin de 4 angajati;
b) departamentul care are numarul maxim de angajati.
*/

select e.department_id, department_name, count(employee_id)
from employees e join departments d on (e.department_id = d.department_id)
group by e.department_id, department_name
having count(employee_id) < 4;

select e.department_id, department_name, count(employee_id)
from employees e join departments d on (e.department_id = d.department_id)
group by e.department_id, department_name
having count(employee_id) = (
select max(count(employee_id)) Nr
from employees
group by department_id);

/*
Scrie�i o cerere pentru a afi�a job-ul, salariul total pentru job-ul respectiv 
pe departamente si salariul total pentru job-ul respectiv pe departamentele 30, 50, 80. 
Se vor eticheta coloanele corespunz�tor.
*/

select job_id,
       sum(decode(department_id,30,salary)) Dep30,
       sum(decode(department_id,50,salary)) Dep50,
       sum(decode(department_id,80,salary)) Dep80,
       sum(salary) Total
from employees
group by job_id, department_id;


/*
S� se afi�eze codul, numele departamentului �i suma salariilor pe departamente.
*/
select d.department_id, department_name, tabel.suma
from departments d,
(select department_id, sum(salary) suma
from employees
group by department_id) tabel
where d.department_id = tabel.department_id;


/*
S� se afi�eze numele, salariul, codul departamentului si salariul mediu din departamentul respectiv.
*/

select department_name, salary, e.department_id, avg(salary)
from employees e join departments d on (e.department_id = d.department_id)
group by e.department_id, department_name, salary;

/*
S� se afi�eze informa�ii despre angaja�ii al c�ror salariu dep�e�te valoarea medie a salariilor colegilor s�i de departament.
*/

select employee_id, last_name
from employees e
where salary > (select avg(salary)
                from employees
                where department_id = e.department_id);
                
                
/*
S� se afi�eze numele �i salariul angaja�ilor al c�ror salariu este mai mare dec�t salariile medii din toate departamentele.
*/

select last_name, salary
from employees
where salary > (select max(avg(salary))
                from employees
                group by department_id);


                
            