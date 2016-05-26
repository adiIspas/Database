/*
3. S� se listeze structura tabelelor din schema HR (EMPLOYEES, DEPARTMENTS,
JOBS, JOB_HISTORY, LOCATIONS, COUNTRIES, REGIONS), observ�nd tipurile
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
4. S� se listeze con�inutul tabelelor din schema considerat�, afi��nd valorile tuturor
c�mpurilor.
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
7. S� se afi�eze codul angajatului, numele, codul job-ului, data angajarii. Ce fel de
opera�ie este aceasta (selec�ie sau proiec�ie)? Salva�i instruc�iunea SQL �ntr-un fi�ier
p7l1.sql.
*/

select employee_id Cod, last_name Nume, job_id Job, hire_date "Data angajarii"
from employees;

/*
9. S� se listeze, cu �i f�r� duplicate, codurile job-urilor din tabelul EMPLOYEES.
*/

select job_id Joburi
from employees;

select distinct job_id Joburi
from employees;

/*
10. S� se afi�eze numele concatenat cu job_id-ul, separate prin virgula si spatiu, si
etichetati coloana �Angajat si titlu�.
*/

select last_name || ', ' || job_id "Angajat si titlu"
from employees;

/*
11. Creati o cerere prin care sa se afiseze toate datele din tabelul EMPLOYEES.
Separa�i fiecare coloan� printr-o virgul�. Etichetati coloana �Informatii complete�.
*/

desc employees;

select employee_id || ', ' || first_name || ', ' || last_name || ', ' || 
       email || ', ' || phone_number || ', ' || hire_date || ', ' || 
       job_id || ', ' || salary || ', ' || commission_pct || ', ' ||
       manager_id || ', ' || department_id "Informatii complete"
from employees;

/*
12. Sa se listeze numele si salariul angaja�ilor care c�tig� mai mult de 2850 $. Salva�i
instruc�iunea SQL �ntr-un fi�ier numit p12l1.sql. S� se ruleze acesta.
*/

select employee_id Cod, last_name Nume, salary Salariu
from employees
where salary > 2850;

/*
13. S� se creeze o cerere pentru a afi�a numele angajatului �i num�rul departamentului
pentru angajatul nr. 104.
*/

select last_name Nume, department_id Departament
from employees
where employee_id = 104;

/*
14. S� se modifice p12l1.sql pentru a afi�a numele �i salariul pentru to�i angaja�ii al
c�ror salariu nu se afl� �n domeniul 1500-2850$. Salva�i din nou instruc�iunea �ntr-un
fi�ier numit p14l1.sql. Executa�i cererea.
*/

select employee_id Cod, last_name Nume, salary Salariu
from employees
where salary not between 1500 and 2850;

/*
15. S� se afi�eze numele, job-ul �i data la care au �nceput lucrul salaria�ii angaja�i �ntre
20 Februarie 1987 �i 1 Mai 1989. Rezultatul va fi ordonat cresc�tor dup� data de
�nceput.
*/

select last_name Nume, job_id Job, hire_date "Data angajarii"
from employees
where hire_date between '20-02-1987' and '1-05-1989'
order by hire_date;

/*
16. S� se afi�eze numele salaria�ilor �i codul departamentelor pentru toti angaja�ii din
departamentele 10 �i 30 �n ordine alfabetic� a numelor.
*/

select last_name Nume, department_id Departament
from employees
where department_id in (10,30)
order by last_name;

/*
17. S� se modifice p14l1.sql pentru a lista numele �i salariile angajatilor care c�tig�
mai mult de 1500 $ �i lucreaz� �n departamentul 10 sau 30. Se vor eticheta
coloanele drept Angajat si Salariu lunar. Salva�i noua instructiune SQL �ntr-un fi�ier
numit p17l1.sql. Executati cererea.
*/

select employee_id Cod, last_name Nume, salary Salariu
from employees
where salary >= 1500 and department_id in (10,30);

/*
18. Care este data curent�? Afi�a�i diferite formate ale acesteia.
*/

select sysdate
from dual;

/*
19. Sa se afiseze numele �i data angaj�rii pentru fiecare salariat care a fost angajat in
1987. Se cer 2 solu�ii: una �n care se lucreaz� cu formatul implicit al datei �i alta prin
care se formateaz� data.
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
20. S� se afi�eze numele �i job-ul pentru to�i angaja�ii care nu au manager.
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
23. S� se listeze numele tuturor angajatilor care au a treia liter� din nume �A�.
*/

select distinct last_name Nume
from employees
where lower(last_name) like '__a%';

/*
24. S� se listeze numele tuturor angajatilor care au 2 litere �L� in nume �i lucreaz� �n
departamentul 30 sau managerul lor este 7782.
*/

select last_name Nume
from employees
where lower(last_name) like '%l%l%';

/*
25. S� se afiseze numele, job-ul si salariul pentru toti salariatii al caror job con�ine �irul
�clerk� sau �rep� si salariul nu este egal cu 1000, 2000 sau 3000 $. (operatorul NOT
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