/*
Sã se afiºeze codul ºi numele angajaþilor care lucreazã în acelasi departament cu cel puþin un angajat al cãrui nume conþine litera “t”. 
Se vor afiºa, de asemenea, codul ºi numele departamentului respectiv. Rezultatul va fi ordonat alfabetic dupã nume. 
Se vor da 2 soluþii pentru join (condiþie în clauza WHERE ºi sintaxa introdusã de standardul SQL3).
*/

SELECT e1.employee_id, e1.last_name, d.department_name, e2.employee_id, e2.last_name, d.department_name
FROM employees e1 join employees e2 on (e1.department_id = e2.department_id) join departments d on (e1.department_id = e2.department_id)
WHERE lower(e2.last_name) like '%t%' and e1.last_name < e2.last_name
ORDER BY e1.last_name;

SELECT e1.employee_id, e1.last_name, d.department_name, e2.employee_id, e2.last_name, d.department_name
FROM employees e1, employees e2, departments d
WHERE lower(e2.last_name) like '%t%' and e1.last_name < e2.last_name and e1.department_id = e2.department_id and e1.department_id = d.department_id
ORDER BY e1.last_name;

/*
Sa se afiseze codul departamentului, numele departamentului, numele si job-ul tuturor angajatilor din departamentele al cãror nume conþine ºirul ‘ti’. 
De asemenea, se va lista salariul angajaþilor, în formatul “$99,999.00”. 
Rezultatul se va ordona alfabetic dupã numele departamentului, ºi în cadrul acestuia, dupã numele angajaþilor.
*/

SELECT e.department_id, department_name, last_name, job_title, TO_CHAR(salary,'$99,999.00')
FROM employees e
     join departments d on (e.department_id = d.department_id)
     join jobs j on (e.job_id = j.job_id)
WHERE lower(d.department_name) like '%ti%'
ORDER BY d.department_name, e.last_name;

SELECT e.department_id, department_name, last_name, job_title, TO_CHAR(salary,'$99,999.00')
FROM employees e, departments d, jobs j
WHERE lower(d.department_name) like '%ti%' and e.department_id = d.department_id and e.job_id = j.job_id
ORDER BY d.department_name, e.last_name;

/*
Sa se afiseze numele angajatilor, numarul departamentului, numele departamentului, 
oraºul si job-ul tuturor salariatilor al caror departament este localizat in Oxford.
*/

SELECT e.last_name, d.department_id, d.department_name, l.city, j.job_title
FROM employees e
     join departments d on (e.department_id = d.department_id)
     join locations l on (d.location_id = l.location_id)
     join jobs j on (e.job_id = j.job_id)
WHERE lower(city) like '%oxford%';

/*
Sa se modifice fisierul p2l3.sql pentru a afisa codul, numele si salariul tuturor angajatilor care castiga mai mult decat salariul mediu pentru 
job-ul corespunzãtor si lucreaza intr-un departament cu cel putin unul din angajatii al caror nume contine litera “t”. 
Salvati ca p7l3.sql. Executati cererea.
*/

SELECT employee_id, last_name, salary
FROM employees
WHERE salary > ANY (SELECT AVG(salary) 
                 FROM employees
                 GROUP BY job_id);
                 
/*
Sã se afiºeze numele salariaþilor ºi numele departamentelor în care lucreazã. 
Se vor afiºa ºi salariaþii care nu au asociat un departament. (right outer join, 2 variante).
*/

SELECT last_name, department_name
FROM employees join departments using(department_id);

SELECT last_name, department_name, departments.manager_id
FROM employees left join departments using (department_id);

SELECT last_name, department_name
FROM employees e, departments d
WHERE e.department_id(+) = d.department_id;

SELECT last_name, department_name
FROM employees FULL OUTER JOIN departments USING (department_id);