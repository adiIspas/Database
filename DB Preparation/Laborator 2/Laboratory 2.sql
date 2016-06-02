/*
1. Scrieþi o cerere care are urmãtorul rezultat pentru fiecare angajat:
<prenume angajat> <nume angajat> castiga <salariu> lunar dar doreste <salariu de 3 ori
mai mare>. Etichetati coloana “Salariu ideal”. Pentru concatenare, utilizaþi atât funcþia
CONCAT cât ºi operatorul “||”.
*/

select last_name || ' ' || first_name || ' castiga ' || salary || ' lunar dar doreste ' || salary * 3 "Salariul ideal"
from employees;

/*
2. Scrieþi o cerere prin care sã se afiºeze prenumele salariatului cu prima litera majusculã ºi
toate celelalte litere minuscule, numele acestuia cu majuscule ºi lungimea numelui, pentru
angajaþii al cãror nume începe cu J sau M sau care au a treia literã din nume A. Rezultatul
va fi ordonat descrescãtor dupã lungimea numelui. Se vor eticheta coloanele
corespunzãtor. Se cer 2 soluþii (cu operatorul LIKE ºi funcþia SUBSTR).
*/

select initcap(first_name) Prenume, upper(last_name) Nume, length(last_name) "Lungime nume"
from employees
where lower(last_name) like 'm%' or lower(last_name) like 'j%' or lower(last_name) like '__a%'
order by 3 desc;

/*
3. Sã se afiºeze pentru angajaþii cu prenumele „Steven”, codul, numele ºi codul
departamentului în care lucreazã. Cãutarea trebuie sã nu fie case-sensitive, iar
eventualele blank-uri care preced sau urmeazã numelui trebuie ignorate.
*/

select employee_id Cod, last_name Nume, department_id Departament
from employees
where ltrim(rtrim(lower(first_name))) = 'steven';

/*
4. Sã se afiºeze pentru toþi angajaþii al cãror nume se terminã cu litera 'e', codul, numele,
lungimea numelui ºi poziþia din nume în care apare prima data litera 'a'. Utilizaþi alias-uri
corespunzãtoare pentru coloane.*/

select employee_id Cod, last_name Nume, length(last_name) "Lungime nume", instr(lower(last_name),'a',1) "Prima aparitie"
from employees
where lower(last_name) like '%e';

/*
5. Sã se afiºeze detalii despre salariaþii care au lucrat un numãr întreg de sãptãmâni pânã la
data curentã.
*/

select employee_id Cod, last_name Nume, salary Salariu
from employees
where mod(round(sysdate - hire_date),7) = 0;

/*
6. Sã se afiºeze codul salariatului, numele, salariul, salariul mãrit cu 15%, exprimat cu douã
zecimale ºi numãrul de sute al salariului nou rotunjit la 2 zecimale. Etichetaþi ultimele douã
coloane “Salariu nou”, respectiv “Numar sute”. Se vor lua în considerare salariaþii al cãror
salariu nu este divizibil cu 1000. Salvaþi instrucþiunea SQL într-un fiºier p2l2.sql.
*/

select employee_id Cod, last_name Nume, salary Salariu, round(salary + salary * 15/100,2) "Salariu marit", round(salary * 1.15/100,2) "Numar sute"
from employees
where mod(salary,1000) != 0;

/*
7. Sã se modifice p6l2.sql pentru a adauga o nouã coloanã, care va scade salariul vechi din
salariul nou, rezultatul fiind afiºat în sute.
*/

select employee_id Cod, last_name Nume, salary Salariu, round(salary + salary * 15/100,2) "Salariu marit", round((salary * 1.15 - salary)/100,2) "Diferenta in sute"
from employees
where mod(salary,1000) != 0;

/*
9. Sã se listeze numele ºi data angajãrii salariaþilor care câºtigã comision. Sã se eticheteze
coloanele „Nume angajat”, „Data angajarii”. Pentru a nu obþine alias-ul datei angajãrii
trunchiat, utilizaþi funcþia RPAD.
*/

select last_name Nume, hire_date "Data angajarii"
from employees
where commission_pct is not null;

/*
10. Sã se afiºeze data (numele lunii, ziua, anul, ora, minutul si secunda) de peste 30 zile.
*/

select to_char(sysdate + 30, 'MONTH DD DAY HH24:MM:SS') Data
from dual;

/*
11. Sã se afiºeze numãrul de zile rãmase pânã la sfârºitul anului.
*/

select round(to_date('31-DEC-2016') - sysdate)
from dual;

/*
12. 
a) Sã se afiºeze data de peste 12 ore.
b) Sã se afiºeze data de peste 5 minute
Obs: O zi reprezintã un întreg, iar 5 minute sunt a 288-a parte dintr-o zi.
*/

select sysdate + 12/24 "Data peste 12 ore"
from dual;

select sysdate + 1/288 "Data peste 5 minute"
from dual;

/*
13. Sã se afiºeze numele ºi prenumele angajatului (într-o singurã coloanã), data angajãrii ºi
data negocierii salariului, care este prima zi de Luni dupã 6 luni de serviciu. Etichetaþi
aceastã coloanã “Negociere”.
*/

select last_name || ' ' || first_name "Nume Prenume", hire_date "Data angajarii", next_day(add_months(hire_date, 6), 'Luni') "Data negocierii"
from employees;

/* 
15. Pentru fiecare angajat sã se afiºeze numele ºi numãrul de luni de la data angajãrii.
Etichetaþi coloana “Luni lucrate”. Sã se ordoneze rezultatul dupã numãrul de luni lucrate.
Se va rotunji numãrul de luni la cel mai apropiat numãr întreg.
*/

select last_name Nume, round(months_between(sysdate, hire_date)) "Luni lucrate"
from employees
order by 2;

/*
16. Sã se afiºeze numele, data angajãrii ºi ziua sãptãmânii în care a început lucrul fiecare
salariat. Etichetaþi coloana “Zi”. Ordonaþi rezultatul dupã ziua sãptãmânii, începând cu
Luni.
*/

select last_name Nume, hire_date "Data angajarii", to_char(hire_date,'day') Zi
from employees
order by to_char(hire_date,'d');

/*
17. Sã se afiºeze numele angajaþilor ºi comisionul. Dacã un angajat nu câºtigã comision, sã
se scrie “Fara comision”. Etichetaþi coloana “Comision”.
*/

select last_name Nume, nvl(to_char(commission_pct,'0.99'),'Fara comision') Comision
from employees;

/*
18. Sã se listeze numele, salariul ºi comisionul tuturor angajaþilor al cãror venit lunar
depãºeºte 10000$.
*/

select last_name Nume, salary Salariu, commission_pct Comision
from employees
where salary > 10000;

/*
19. Sã se afiºeze numele, codul job-ului, salariul ºi o coloanã care sã arate salariul dupã
mãrire. Se presupune cã pentru IT_PROG are loc o mãrire de 20%, pentru SA_REP
creºterea este de 25%, iar pentru SA_MAN are loc o mãrire de 35%. Pentru ceilalþi
angajaþi nu se acordã mãrire. Sã se denumeascã coloana "Salariu renegociat".
*/

select last_name Nume, job_id Job, salary Salariu, 
       decode(job_id,
       'IT_PROG', salary * 20/100,
       'SA_REP', salary * 25/100,
       'SA_MAN', salary * 35/100,
       salary
       ) "Salariu renegociat"
from employees;

/*
20. Sã se afiºeze numele salariatului, codul ºi numele departamentului pentru toþi angajaþii.
*/

select e.last_name Nume, e.employee_id Cod, d.department_name Departament
from employees e, departments d
where e.department_id = d.department_id;

/*
21. Sã se listeze job-urile care existã în departamentul 30.
*/

select distinct e.job_id Job, j.job_title
from employees e, jobs j
where e.job_id = j.job_id and e.department_id = 30;

/*
22. Sã se afiºeze numele angajatului, numele departamentului ºi locatia pentru toþi angajaþii
care câºtigã comision.
*/

select e.last_name Nume, d.department_name, l.city
from employees e, departments d, locations l 
where e.department_id = d.department_id and d.location_id = l.location_id and e.commission_pct is not null;

/*
23. Sã se afiºeze numele salariatului ºi numele departamentului pentru toþi salariaþii care au
litera A inclusã în nume.
*/

select e.last_name Nume, d.department_name Departament
from employees e, departments d
where e.department_id = d.department_id and lower(e.last_name) like '%a%';

/*
24. Sã se afiºeze numele, job-ul, codul ºi numele departamentului pentru toþi angajaþii care
lucreazã în Oxford.
*/

select e.last_name Nume, e.job_id Job, e.department_id Cod, d.department_name Departament
from employees e, departments d, locations l
where e.department_id = d.department_id and d.location_id = l.location_id and lower(l.city) like '%oxford%';

/*
25. Sã se afiºeze codul angajatului ºi numele acestuia, împreunã cu numele ºi codul ºefului
sãu direct. Se vor eticheta coloanele Ang#, Angajat, Mgr#, Manager. Sã se salveze
instrucþiunea într-un fiºier numit p25l2.sql.
*/

select e.employee_id "Cod Angajat", e.last_name "Nume Angajat", m.employee_id "Cod Manager", m.last_name "Nume Manager"
from employees e, employees m
where e.manager_id = m.manager_id;

/*
26. Sã se modifice p25l2.sql pentru a afiºa toþi salariaþii, inclusiv cei care nu au ºef. Salvati ca
p26l2.sql. Rulaþi p26l2.sql.
*/

select e.employee_id "Cod Angajat", e.last_name "Nume Angajat", m.employee_id "Cod Manager", m.last_name "Nume Manager"
from employees e, employees m
where e.manager_id = m.employee_id(+);

/*
27. Sa se listeze numele, salariul si comisionul tuturor angajatilor al cãror salariu total (cu tot
cu comision) depãºeste 10000$.
*/

select last_name Nume, salary Salariu, commission_pct Comision, salary + salary * nvl(commission_pct,0) "Salariu Comision"
from employees
where salary + salary * nvl(commission_pct,0) > 10000;

/*
28. Creaþi o cerere care sã afiºeze numele angajatului, codul departamentului ºi toþi salariaþii
care lucreazã în acelaºi departament cu el. Se vor eticheta coloanele corespunzãtor.
*/

select e.last_name, e.department_id, c.last_name
from employees e, employees c
where e.department_id = c.department_id  and e.employee_id > c.employee_id;

/*
29. Sã se listeze structura tabelului JOBS. Creaþi o cerere prin care sã se afiºeze numele,
codul job-ului, titlul job-ului, numele departamentului ºi salariul angajaþilor.
*/

desc jobs;
select e.last_name, e.job_id, j.job_title, d.department_name, e.salary
from employees e, departments d, jobs j
where e.department_id = d.department_id and e.job_id = j.job_id;

/*
30. Sã se afiºeze numele ºi data angajãrii pentru salariaþii care au fost angajaþi dupã Gates.
*/

select e.last_name Nume, e.hire_date "Data angajarii"
from employees e, employees g
where lower(g.last_name) = 'gates' and e.hire_date > g.hire_date;

/*
31. Sã se afiºeze numele salariatului ºi data angajãrii împreunã cu numele ºi data angajãrii
ºefului direct pentru salariaþii care au fost angajaþi înaintea ºefilor lor. Se vor eticheta
coloanele Angajat, Data_ang, Manager si Data_mgr.
*/

select e.last_name "Nume angajat", e.hire_date "Data angajarii angajat", m.last_name "Nume manager", m.hire_date "Data angajarii manager"
from employees e, employees m
where e.manager_id = m.employee_id and e.hire_date < m.hire_date;
