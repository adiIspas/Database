/*
Sa se afiseze numele, salariul si comisionul pentru toti salariatii care castiga
comisioane. Sa se sorteze datele in ordine descrescatoare a salariilor si
comisioanelor.
*/

select last_name, salary, commission_pct
from employees
where commission_pct is not null
order by 2 desc;

/*
Sa se listeze numele tuturor angajatilor care au a treia litera din nume ‘A’.
*/

select distinct last_name
from employees
where lower(last_name) like '__a%';

/*
Sa se listeze numele tuturor angajatilor care au 2 litere ‘L’ in nume si lucreaza în
departamentul 30 sau managerul lor este 7782.
*/

select last_name 
from employees
where lower(last_name) like '%l%l%';

/*
Scrieti o cerere care are urmatorul rezultat pentru fiecare angajat:
<prenume angajat> <nume angajat> castiga <salariu> lunar dar doreste <salariu de 3 ori
mai mare>. Etichetati coloana “Salariu ideal”. Pentru concatenare, utilizati atât functia
CONCAT cât si operatorul “||”.
*/

select last_name || ' castiga ' || salary || ' lunar dar doreste ' || salary * 3 "Salariul ideal"
from employees;

/*
Sa se afiseze detalii despre salariatii care au lucrat un numar întreg de saptamâni pâna la
data curenta.
*/

select last_name, employee_id
from employees
where mod(round(sysdate - hire_date),7) = 0;

/*
Sa se afiseze numele, codul job-ului, salariul si o coloana care sa arate salariul dupa
marire. Se presupune ca pentru IT_PROG are loc o marire de 20%, pentru SA_REP
cresterea este de 25%, iar pentru SA_MAN are loc o marire de 35%. Pentru ceilalti
angajati nu se acorda marire. Sa se denumeasca coloana "Salariu renegociat".
*/

select last_name, job_id, salary,
      decode(job_id,
             'IT_PROG', salary + salary * 20/100,
             'SA_REP', salary + salary * 25/100,
             'SA_MAN', salary + salary * 35/100,
             salary) "Salariu renegociat"
from employees;

/*
Sa se afiseze numele salariatului, codul si numele departamentului pentru toti angajatii.
*/

select last_name, e.department_id, department_name
from employees e join departments d on (e.department_id = d.department_id);

/*
Sa se listeze job-urile care exista în departamentul 30.
*/

select j.job_title
from employees e join jobs j on (e.job_id = j.job_id)
where department_id = 30;


/*
Sa se afiseze numele angajatului, numele departamentului si locatia pentru toti angajatii
care câstiga comision.
*/

select last_name, department_name, city
from employees e join departments d on (e.department_id = d.department_id) 
     join locations l on (d.location_id = l.location_id)
where commission_pct is not null;