/*
1. Sã se listeze informatii despre angajatii care au lucrat în toate proiectele demarate în primele 6 luni
ale anului 2006. Implementati toate variantele.
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
2. Sã se listeze informatii despre proiectele la care au participat toti angajatii care au detinut alte 2
posturi în firmã.
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
