/*
1. Scrie�i o cerere care are urm�torul rezultat pentru fiecare angajat:
<prenume angajat> <nume angajat> castiga <salariu> lunar dar doreste <salariu de 3 ori
mai mare>. Etichetati coloana �Salariu ideal�. Pentru concatenare, utiliza�i at�t func�ia
CONCAT c�t �i operatorul �||�.
*/

select last_name || ' ' || first_name || ' castiga ' || salary || ' lunar dar doreste ' || salary * 3 "Salariul ideal"
from employees;

/*
2. Scrie�i o cerere prin care s� se afi�eze prenumele salariatului cu prima litera majuscul� �i
toate celelalte litere minuscule, numele acestuia cu majuscule �i lungimea numelui, pentru
angaja�ii al c�ror nume �ncepe cu J sau M sau care au a treia liter� din nume A. Rezultatul
va fi ordonat descresc�tor dup� lungimea numelui. Se vor eticheta coloanele
corespunz�tor. Se cer 2 solu�ii (cu operatorul LIKE �i func�ia SUBSTR).
*/

select initcap(first_name) Prenume, upper(last_name) Nume, length(last_name) "Lungime nume"
from employees
where lower(last_name) like 'm%' or lower(last_name) like 'j%' or lower(last_name) like '__a%'
order by 3 desc;

/*
3. S� se afi�eze pentru angaja�ii cu prenumele �Steven�, codul, numele �i codul
departamentului �n care lucreaz�. C�utarea trebuie s� nu fie case-sensitive, iar
eventualele blank-uri care preced sau urmeaz� numelui trebuie ignorate.
*/

select employee_id Cod, last_name Nume, department_id Departament
from employees
where ltrim(rtrim(lower(first_name))) = 'steven';

/*
4. S� se afi�eze pentru to�i angaja�ii al c�ror nume se termin� cu litera 'e', codul, numele,
lungimea numelui �i pozi�ia din nume �n care apare prima data litera 'a'. Utiliza�i alias-uri
corespunz�toare pentru coloane.*/

select employee_id Cod, last_name Nume, length(last_name) "Lungime nume", instr(lower(last_name),'a',1) "Prima aparitie"
from employees
where lower(last_name) like '%e';

/*
5. S� se afi�eze detalii despre salaria�ii care au lucrat un num�r �ntreg de s�pt�m�ni p�n� la
data curent�.
*/

select employee_id Cod, last_name Nume, salary Salariu
from employees
where mod(round(sysdate - hire_date),7) = 0;

/*
6. S� se afi�eze codul salariatului, numele, salariul, salariul m�rit cu 15%, exprimat cu dou�
zecimale �i num�rul de sute al salariului nou rotunjit la 2 zecimale. Eticheta�i ultimele dou�
coloane �Salariu nou�, respectiv �Numar sute�. Se vor lua �n considerare salaria�ii al c�ror
salariu nu este divizibil cu 1000. Salva�i instruc�iunea SQL �ntr-un fi�ier p2l2.sql.
*/

select employee_id Cod, last_name Nume, salary Salariu, round(salary + salary * 15/100,2) "Salariu marit", round(salary * 1.15/100,2) "Numar sute"
from employees
where mod(salary,1000) != 0;

/*
7. S� se modifice p6l2.sql pentru a adauga o nou� coloan�, care va scade salariul vechi din
salariul nou, rezultatul fiind afi�at �n sute.
*/

select employee_id Cod, last_name Nume, salary Salariu, round(salary + salary * 15/100,2) "Salariu marit", round((salary * 1.15 - salary)/100,2) "Diferenta in sute"
from employees
where mod(salary,1000) != 0;

/*
9. S� se listeze numele �i data angaj�rii salaria�ilor care c�tig� comision. S� se eticheteze
coloanele �Nume angajat�, �Data angajarii�. Pentru a nu ob�ine alias-ul datei angaj�rii
trunchiat, utiliza�i func�ia RPAD.
*/

select last_name Nume, hire_date "Data angajarii"
from employees
where commission_pct is not null;

/*
10. S� se afi�eze data (numele lunii, ziua, anul, ora, minutul si secunda) de peste 30 zile.
*/

select to_char(sysdate + 30, 'MONTH DD DAY HH24:MM:SS') Data
from dual;

/*
11. S� se afi�eze num�rul de zile r�mase p�n� la sf�r�itul anului.
*/

select round(to_date('31-DEC-2016') - sysdate)
from dual;

/*
12. 
a) S� se afi�eze data de peste 12 ore.
b) S� se afi�eze data de peste 5 minute
Obs: O zi reprezint� un �ntreg, iar 5 minute sunt a 288-a parte dintr-o zi.
*/

select sysdate + 12/24 "Data peste 12 ore"
from dual;

select sysdate + 1/288 "Data peste 5 minute"
from dual;

/*
13. S� se afi�eze numele �i prenumele angajatului (�ntr-o singur� coloan�), data angaj�rii �i
data negocierii salariului, care este prima zi de Luni dup� 6 luni de serviciu. Eticheta�i
aceast� coloan� �Negociere�.
*/

select last_name || ' ' || first_name "Nume Prenume", hire_date "Data angajarii", next_day(add_months(hire_date, 6), 'Luni') "Data negocierii"
from employees;

/* 
15. Pentru fiecare angajat s� se afi�eze numele �i num�rul de luni de la data angaj�rii.
Eticheta�i coloana �Luni lucrate�. S� se ordoneze rezultatul dup� num�rul de luni lucrate.
Se va rotunji num�rul de luni la cel mai apropiat num�r �ntreg.
*/

select last_name Nume, round(months_between(sysdate, hire_date)) "Luni lucrate"
from employees
order by 2;

/*
16. S� se afi�eze numele, data angaj�rii �i ziua s�pt�m�nii �n care a �nceput lucrul fiecare
salariat. Eticheta�i coloana �Zi�. Ordona�i rezultatul dup� ziua s�pt�m�nii, �ncep�nd cu
Luni.
*/

select last_name Nume, hire_date "Data angajarii", to_char(hire_date,'day') Zi
from employees
order by to_char(hire_date,'d');

/*
17. S� se afi�eze numele angaja�ilor �i comisionul. Dac� un angajat nu c�tig� comision, s�
se scrie �Fara comision�. Eticheta�i coloana �Comision�.
*/

select last_name Nume, nvl(to_char(commission_pct,'0.99'),'Fara comision') Comision
from employees;

/*
18. S� se listeze numele, salariul �i comisionul tuturor angaja�ilor al c�ror venit lunar
dep�e�te 10000$.
*/

select last_name Nume, salary Salariu, commission_pct Comision
from employees
where salary > 10000;

/*
19. S� se afi�eze numele, codul job-ului, salariul �i o coloan� care s� arate salariul dup�
m�rire. Se presupune c� pentru IT_PROG are loc o m�rire de 20%, pentru SA_REP
cre�terea este de 25%, iar pentru SA_MAN are loc o m�rire de 35%. Pentru ceilal�i
angaja�i nu se acord� m�rire. S� se denumeasc� coloana "Salariu renegociat".
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
20. S� se afi�eze numele salariatului, codul �i numele departamentului pentru to�i angaja�ii.
*/

select e.last_name Nume, e.employee_id Cod, d.department_name Departament
from employees e, departments d
where e.department_id = d.department_id;

/*
21. S� se listeze job-urile care exist� �n departamentul 30.
*/

select distinct e.job_id Job, j.job_title
from employees e, jobs j
where e.job_id = j.job_id and e.department_id = 30;

/*
22. S� se afi�eze numele angajatului, numele departamentului �i locatia pentru to�i angaja�ii
care c�tig� comision.
*/

select e.last_name Nume, d.department_name, l.city
from employees e, departments d, locations l 
where e.department_id = d.department_id and d.location_id = l.location_id and e.commission_pct is not null;

/*
23. S� se afi�eze numele salariatului �i numele departamentului pentru to�i salaria�ii care au
litera A inclus� �n nume.
*/

select e.last_name Nume, d.department_name Departament
from employees e, departments d
where e.department_id = d.department_id and lower(e.last_name) like '%a%';

/*
24. S� se afi�eze numele, job-ul, codul �i numele departamentului pentru to�i angaja�ii care
lucreaz� �n Oxford.
*/

select e.last_name Nume, e.job_id Job, e.department_id Cod, d.department_name Departament
from employees e, departments d, locations l
where e.department_id = d.department_id and d.location_id = l.location_id and lower(l.city) like '%oxford%';

/*
25. S� se afi�eze codul angajatului �i numele acestuia, �mpreun� cu numele �i codul �efului
s�u direct. Se vor eticheta coloanele Ang#, Angajat, Mgr#, Manager. S� se salveze
instruc�iunea �ntr-un fi�ier numit p25l2.sql.
*/

select e.employee_id "Cod Angajat", e.last_name "Nume Angajat", m.employee_id "Cod Manager", m.last_name "Nume Manager"
from employees e, employees m
where e.manager_id = m.manager_id;

/*
26. S� se modifice p25l2.sql pentru a afi�a to�i salaria�ii, inclusiv cei care nu au �ef. Salvati ca
p26l2.sql. Rula�i p26l2.sql.
*/

select e.employee_id "Cod Angajat", e.last_name "Nume Angajat", m.employee_id "Cod Manager", m.last_name "Nume Manager"
from employees e, employees m
where e.manager_id = m.employee_id(+);

/*
27. Sa se listeze numele, salariul si comisionul tuturor angajatilor al c�ror salariu total (cu tot
cu comision) dep�este 10000$.
*/

select last_name Nume, salary Salariu, commission_pct Comision, salary + salary * nvl(commission_pct,0) "Salariu Comision"
from employees
where salary + salary * nvl(commission_pct,0) > 10000;

/*
28. Crea�i o cerere care s� afi�eze numele angajatului, codul departamentului �i to�i salaria�ii
care lucreaz� �n acela�i departament cu el. Se vor eticheta coloanele corespunz�tor.
*/

select e.last_name, e.department_id, c.last_name
from employees e, employees c
where e.department_id = c.department_id  and e.employee_id > c.employee_id;

/*
29. S� se listeze structura tabelului JOBS. Crea�i o cerere prin care s� se afi�eze numele,
codul job-ului, titlul job-ului, numele departamentului �i salariul angaja�ilor.
*/

desc jobs;
select e.last_name, e.job_id, j.job_title, d.department_name, e.salary
from employees e, departments d, jobs j
where e.department_id = d.department_id and e.job_id = j.job_id;

/*
30. S� se afi�eze numele �i data angaj�rii pentru salaria�ii care au fost angaja�i dup� Gates.
*/

select e.last_name Nume, e.hire_date "Data angajarii"
from employees e, employees g
where lower(g.last_name) = 'gates' and e.hire_date > g.hire_date;

/*
31. S� se afi�eze numele salariatului �i data angaj�rii �mpreun� cu numele �i data angaj�rii
�efului direct pentru salaria�ii care au fost angaja�i �naintea �efilor lor. Se vor eticheta
coloanele Angajat, Data_ang, Manager si Data_mgr.
*/

select e.last_name "Nume angajat", e.hire_date "Data angajarii angajat", m.last_name "Nume manager", m.hire_date "Data angajarii manager"
from employees e, employees m
where e.manager_id = m.employee_id and e.hire_date < m.hire_date;
