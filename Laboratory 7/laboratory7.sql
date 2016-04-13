/*
24. Sã se afiºeze numele, prenumele angajaþilor ºi lungimea numelui pentru înregistrãrile în care
aceasta este diferitã de lungimea prenumelui.
*/

SELECT last_name, first_name
FROM employees
WHERE nullif(length(last_name),length(first_name)) is not null;

/*
25. Sã se afiºeze numele, data angajãrii, salariul ºi o coloanã reprezentând salariul 
dupã ce se aplicã o mãrire, astfel: pentru salariaþii angajaþi în 1989 creºterea
este de 20%, pentru cei angajaþi în 1990 creºterea este de 15%, iar salariul celor 
angajaþi în anul 1991 creºte cu 10%. Pentru salariaþii angajaþi în alþi ani 
valoarea nu se modificã.*/

SELECT last_name, hire_date, salary,
       DECODE(to_char(hire_date,'yyyy'),1989,salary*1.2,1990,salary*1.15,1991,salary*1.1,salary) marit
FROM employees;

/*
26. Sã se afiºeze:
- suma salariilor, pentru job-urile care incep cu litera S;
- media generala a salariilor, pentru job-ul avand salariul maxim;
- salariul minim, pentru fiecare din celelalte job-uri.
*/
        
SELECT job_id,
( CASE
WHEN UPPER(job_id) LIKE 'S%' THEN SUM(salary)
WHEN job_id= (SELECT job_id
FROM employees
WHERE salary =(SELECT MAX(salary)
FROM employees))
THEN (SELECT AVG(salary) FROM employees)
ELSE MIN(salary)
END) calcul
FROM employees
GROUP BY job_id;
       
/*
1. Sã se listeze informatii despre angajatii care au lucrat în toate proiectele 
demarate în primele 6 luni ale anului 2006. ImplementaÑi toate variantele.
*/

SELECT DISTINCT employee_id
FROM works_on a
WHERE NOT EXISTS
     (SELECT project_id
      FROM project p
      WHERE to_char(start_date, 'mm') <= 6 AND 
            to_char(start_date, 'yyyy') = 2006 AND NOT EXISTS
            (SELECT employee_id
            FROM works_on b
            WHERE a.employee_id = b.employee_id
            AND p.project_id = b.project_id
            ));

/*
2. Sã se listeze informaÑii despre proiectele la care au participat
toÑi angajaÑii care au deÑinut alte 2 posturi în firmã.
*/

SELECT project_id 
FROM project a
WHERE NOT EXISTS
    (SELECT employee_id 
     FROM (SELECT employee_id, count(job_id) c1
           FROM job_history b GROUP BY employee_id) x
            WHERE c1 = 2 AND NOT EXISTS
            
            (SELECT employee_id
            FROM works_on d
            WHERE d.employee_id = x.employee_id
            AND a.project_id = d.project_id));
       
       
       