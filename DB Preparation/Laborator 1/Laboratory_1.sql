/*
3. Sã se listeze structura tabelelor din schema HR (EMPLOYEES, DEPARTMENTS,
JOBS, JOB_HISTORY, LOCATIONS, COUNTRIES, REGIONS), observând tipurile
de date ale coloanelor.
*/

desc employees;
desc departments;
desc jobs;
desc job_history;
desc locations;
desc countries;
desc regions;

/*
4. Sã se listeze conþinutul tabelelor din schema consideratã, afiºând valorile tuturor
câmpurilor.
*/

select *
from employees;
select *
from departments;
select *
from jobs;
select *
from job_history;
select *
from locations;
select * 
from countries;

/*
7. Sã se afiºeze codul angajatului, numele, codul job-ului, data angajarii. Ce fel de
operaþie este aceasta (selecþie sau proiecþie)? Salvaþi instrucþiunea SQL într-un fiºier
p7l1.sql.
*/

select employee_id Cod, last_name Nume, job_id Job, hire_date "Data angajarii"
from employees;

/*
9. Sã se listeze, cu ºi fãrã duplicate, codurile job-urilor din tabelul EMPLOYEES.
*/

select job_id Joburi
from employees;

select distinct job_id Joburi
from employees;

/*
10. Sã se afiºeze numele concatenat cu job_id-ul, separate prin virgula si spatiu, si
etichetati coloana “Angajat si titlu”.
*/

select last_name || ', ' || job_id "Angajat si titlu"
from employees;

/*
11. Creati o cerere prin care sa se afiseze toate datele din tabelul EMPLOYEES.
Separaþi fiecare coloanã printr-o virgulã. Etichetati coloana ”Informatii complete”.
*/

desc employees;

select employee_id || ', ' || first_name || ', ' || last_name || ', ' || 
       email || ', ' || phone_number || ', ' || hire_date || ', ' || 
       job_id || ', ' || salary || ', ' || commission_pct || ', ' ||
       manager_id || ', ' || department_id "Informatii complete"
from employees;

/*
12. Sa se listeze numele si salariul angajaþilor care câºtigã mai mult de 2850 $. Salvaþi
instrucþiunea SQL într-un fiºier numit p12l1.sql. Sã se ruleze acesta.
*/

select employee_id Cod, last_name Nume, salary Salariu
from employees
where salary > 2850;

/*
13. Sã se creeze o cerere pentru a afiºa numele angajatului ºi numãrul departamentului
pentru angajatul nr. 104.
*/

select last_name Nume, department_id Departament
from employees
where employee_id = 104;

/*
14. Sã se modifice p12l1.sql pentru a afiºa numele ºi salariul pentru toþi angajaþii al
cãror salariu nu se aflã în domeniul 1500-2850$. Salvaþi din nou instrucþiunea într-un
fiºier numit p14l1.sql. Executaþi cererea.
*/

select employee_id Cod, last_name Nume, salary Salariu
from employees
where salary not between 1500 and 2850;

/*
15. Sã se afiºeze numele, job-ul ºi data la care au început lucrul salariaþii angajaþi între
20 Februarie 1987 ºi 1 Mai 1989. Rezultatul va fi ordonat crescãtor dupã data de
început.
*/

select last_name Nume, job_id Job, hire_date "Data angajarii"
from employees
where hire_date between '20-02-1987' and '1-05-1989'
order by hire_date;

/*
16. Sã se afiºeze numele salariaþilor ºi codul departamentelor pentru toti angajaþii din
departamentele 10 ºi 30 în ordine alfabeticã a numelor.
*/

select last_name Nume, department_id Departament
from employees
where department_id in (10,30)
order by last_name;

/*
17. Sã se modifice p14l1.sql pentru a lista numele ºi salariile angajatilor care câºtigã
mai mult de 1500 $ ºi lucreazã în departamentul 10 sau 30. Se vor eticheta
coloanele drept Angajat si Salariu lunar. Salvaþi noua instructiune SQL într-un fiºier
numit p17l1.sql. Executati cererea.
*/

select employee_id Cod, last_name Nume, salary Salariu
from employees
where salary >= 1500 and department_id in (10,30);

/*
18. Care este data curentã? Afiºaþi diferite formate ale acesteia.
*/

select sysdate
from dual;

/*
19. Sa se afiseze numele ºi data angajãrii pentru fiecare salariat care a fost angajat in
1987. Se cer 2 soluþii: una în care se lucreazã cu formatul implicit al datei ºi alta prin
care se formateazã data.
*/

-- v1
select last_name Nume, hire_date "Data angajarii" 
from employees
where hire_date like '%87%';

-- v2
select last_name Nume, hire_date "Data angajarii" 
from employees
where to_char(hire_date,'YYYY') = 1987;

/*
20. Sã se afiºeze numele ºi job-ul pentru toþi angajaþii care nu au manager.
*/

select last_name Nume, job_id Job
from employees
where manager_id is null;

/*
21. Sa se afiseze numele, salariul si comisionul pentru toti salariatii care castiga
comisioane. Sa se sorteze datele in ordine descrescatoare a salariilor si
comisioanelor.
*/

select last_name Nume, salary Salariu, commission_pct Comision
from employees
where commission_pct is not null
order by salary desc, commission_pct desc;

/*
23. Sã se listeze numele tuturor angajatilor care au a treia literã din nume ‘A’.
*/

select distinct last_name Nume
from employees
where lower(last_name) like '__a%';

/*
24. Sã se listeze numele tuturor angajatilor care au 2 litere ‘L’ in nume ºi lucreazã în
departamentul 30 sau managerul lor este 7782.
*/

select last_name Nume
from employees
where lower(last_name) like '%l%l%';

/*
25. Sã se afiseze numele, job-ul si salariul pentru toti salariatii al caror job conþine ºirul
“clerk” sau “rep” si salariul nu este egal cu 1000, 2000 sau 3000 $. (operatorul NOT
IN)
*/

select last_name Nume, job_id Job, salary Salariu
from employees
where salary not in (1000,2000,3000) and (lower(last_name) like '%clerk%' or lower(last_name) like '%rep%');

/*
26. Sa se modifice p17l1.sql pentru a afisa numele, salariul si comisionul pentru toti
angajatii al caror salariu este mai mare decat comisionul (salary*commission_pct)
marit de 5 ori. Executati din nou cererea . Salvati cererea ca p26l1.sql.
*/

select last_name Nume, salary Salariu, commission_pct Comision
from employees
where salary >= salary * commission_pct * 5;