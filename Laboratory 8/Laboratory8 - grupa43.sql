/*
12. a) S� se ob�in� numele angaja�ilor care au lucrat cel pu�in pe aceleasi proiecte ca si angajatul
av�nd codul 200.
Obs: Incluziunea dintre 2 mul�imi se testeaz� cu ajutorul propriet��ii �A inclus �n B => A-B =?�. Cum
putem implementa acest lucru �n SQL?
Pentru rezolvarea exerci�iului, trebuie selecta�i angaja�ii pentru care este vid� lista proiectelor pe care
a lucrat angajatul 200 mai pu�in lista proiectelor pe care au lucrat acei angaja�i.
b) S� se ob�in� numele angaja�ilor care au lucrat cel mult pe aceleasi proiecte ca si angajatul av�nd
codul 200.
*/

SELECT distinct first_name, last_name
FROM employees e JOIN works_on w ON (e.employee_id = w.employee_id)
WHERE NOT EXISTS (
  SELECT p.project_id
  FROM project p JOIN works_on w2 ON (p.project_id = w2.project_id)
  WHERE employee_id = 200 AND NOT EXISTS (SELECT project_id FROM works_on WHERE employee_id = e.employee_id)
);


/*
13. S� se ob�in� angaja�ii care au lucrat pe aceleasi proiecte ca si angajatul av�nd codul 200.
Obs: Egalitatea �ntre dou� mul�imi se testeaz� cu ajutorul propriet��ii �A=B => A-B=? si B-A=?�.
*/

SELECT distinct first_name, last_name
FROM employees e JOIN works_on w ON (e.employee_id = w.employee_id)
WHERE NOT EXISTS (
  SELECT p.project_id
  FROM project p JOIN works_on w2 ON (p.project_id = w2.project_id)
  WHERE employee_id = 200 AND NOT EXISTS (SELECT project_id FROM works_on WHERE employee_id = e.employee_id)
)
INTERSECT
SELECT distinct first_name, last_name
FROM employees e JOIN works_on w ON (e.employee_id = w.employee_id)
WHERE NOT EXISTS (
  SELECT p.project_id
  FROM project p JOIN works_on w2 ON (p.project_id = w2.project_id)
  WHERE employee_id = 200 AND NOT EXISTS (SELECT project_id FROM works_on WHERE employee_id = e.employee_id)
);

/*
14. Modelul HR con�ine un tabel numit JOB_GRADES, care con�ine grilele de salarizare ale companiei.
a) Afisa�i structura si con�inutul acestui tabel.
b) Pentru fiecare angajat, afisa�i numele, prenumele, salariul si grila de salarizare corespunz�toare.
Ce opera�ie are loc �ntre tabelele din interogare?
*/

SELECT *
FROM job_grades;

SELECT last_name, first_name, salary, grade_level
FROM employees CROSS JOIN job_grades
WHERE salary >= lowest_sal AND salary <= highest_sal;

-----------
DEFINE valoare = 20000

SELECT last_name, salary
FROM employees
WHERE salary > &&valoare;

/*
18. Sa se afiseze numele, codul departamentului si salariul anual pentru toti angajatii care au un anumit
job.
*/

SELECT first_name || ' ' || last_name, department_id, salary * 12
FROM employees
WHERE lower(job_id) LIKE '&job';

/*
19. Sa se afiseze numele, codul departamentului si salariul anual pentru toti angajatii care au fost
angajati dupa o anumita data calendaristica.
*/

SELECT first_name || ' ' || last_name, department_id, salary * 12
FROM employees
WHERE hire_date > to_date('&data','dd-MON-yyyy');

/*
Sa se afiseze o coloana aleasa de utilizator, dintr-un tabel ales de utilizator, ordonand dupa aceeasi
coloana care se afiseaza. De asemenea, este obligatorie precizarea unei conditii WHERE.
SELECT &&p_coloana -- && determina ca valoarea lui p_coloana san nu mai
--fie ceruta si pentru clauza ORDER BY, urmand sa
--fie utilizata valoarea introdusa aici pentru toate
--aparitiile ulterioare ale lui &p_coloana
FROM &p_tabel
WHERE &p_where
ORDER BY &p_coloana;
*/
SELECT &&coloana
FROM &&tabel
WHERE &&conditie
ORDER BY &&ordine;

/*
21. S� se realizeze un script (fisier SQL*Plus) prin care s� se afiseze numele, job-ul si data angaj�rii
salaria�ilor care au �nceput lucrul �ntre 2 date calendaristice introduse de utilizator. S� se 
concateneze numele si job-ul, separate prin spa�iu si virgul�, si s� se eticheteze coloana "Angajati".
Se vor folosi comanda ACCEPT si formatul pentru data calendaristica MM/DD/YY.
*/

SELECT last_name, job_id, hire_date
FROM employees
WHERE hire_date > to_date('&data1','dd-MON-yyyy') AND hire_date < to_date ('&data2','dd-MON-yyyy');

/*
22. Sa se realizeze un script pentru a afisa numele angajatului, codul job-ului, salariul si numele
departamentului pentru salariatii care lucreaza intr-o locatie data de utilizator. Va fi permisa cautarea
case-insensitive.
*/

SELECT last_name, job_id, salary, department_name
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
JOIN locations l ON (d.location_id = l.location_id)
WHERE lower(city) LIKE '&oras';

/*
23. S� se citeasc� dou� date calendaristice de la tastatur� si s� se afiseze zilele dintre aceste dou�
date.
Exemplu: Dac� se introduc datele 1-apr-2008 si 14-apr-2008, rezultatul cererii va fi:
01-apr-2008
02-apr-2008
...
14-apr-2008
Modifica�i cererea anterioar� astfel �nc�t s� afiseze doar zilele lucr�toare dintre cele dou� date
calendaristice introduse.
*/
SELECT to_date('&data_mica','dd-MON-yyyy') + level
FROM dual
CONNECT BY level < to_date('&data_mare','dd-MON-yyyy') - to_date('&data_mica','dd-MON-yyyy');

CREAT TABLE employees_isp 
AS SELECT * FROM employees;

CREAT TABLE departments_isp 
AS SELECT * FROM departments;

ALTER TABLE employees_isp
ADD CONSTRAINT pk_employees_isp PRIMARY KEY(employee_id);
ALTER TABLE departments_isp
ADD CONSTRAINT pk_departments_isp PRIMARY KEY(department_id);
ALTER TABLE employees_isp
ADD CONSTRAINT fk_emp_dep_isp
FOREIGN KEY(department_id) REFERENCES departments_isp (department_id);




