/*
1. Pe baza tabelului EMP_PNU, s� se creeze o vizualizare VIZ_EMP30_PNU, 
care con�ine codul, numele, email-ul �i salariul angaja�ilor din departamentul 30. 
S� se analizeze structura �i con�inutul vizualiz�rii. Ce se observ� referitor la constr�ngeri? 
Ce se ob�ine de fapt la interogarea con�inutului vizualiz�rii? Insera�i o linie prin intermediul 
acestei vizualiz�ri; comenta�i.
*/

CREATE TABLE emp30_isp AS SELECT * FROM employees;

CREATE VIEW emp30_isp
AS SELECT employee_id, last_name, email, salary
FROM employees_isp
WHERE department_id = 30;

CREATE VIEW emp30_isp2
AS SELECT employee_id, last_name, email, salary, hire_date, job_id
FROM employees_isp
WHERE department_id = 30;

INSERT INTO emp30_isp2 VALUES(2,'NumeA','email@emai.com',1000,SYSDATE,'IT_PROG');

SELECT * FROM employees_isp;

/*
4.
a) Insera�i o linie prin intermediul vizualiz�rii precedente. Comenta�i.
b) Care sunt coloanele actualizabile ale acestei vizualiz�ri? Verifica�i r�spunsul �n dic�ionarul datelor (USER_UPDATABLE_COLUMNS).
c) Insera�i o linie specific�nd valori doar pentru coloanele actualizabile.
d) Analiza�i con�inutul vizualiz�rii viz_empsal50_pnu �i al tabelului emp_pnu.
*/

/*
5.
a) S� se creeze vizualizarea VIZ_EMP_DEP30_PNU, astfel �nc�t aceasta s� includ� coloanele vizualiz�rii VIZ_EMP_30_PNU, precum �i numele �i codul departamentului. S� se introduc� aliasuri pentru coloanele vizualiz�rii.
! Asigura�i-v� c� exist� constr�ngerea de cheie extern� �ntre tabelele de baz� ale acestei vizualiz�ri.
b) Insera�i o linie prin intermediul acestei vizualiz�ri.
c) Care sunt coloanele actualizabile ale acestei vizualiz�ri? Ce fel de tabel este cel ale c�rui coloane sunt actualizabile? Insera�i o linie, complet�nd doar valorile corespunz�toare.
d) Ce efect are o opera�ie de �tergere prin intermediul vizualiz�rii viz_emp_dep30_pnu? Comenta�i.
*/

DROP TABLE employees_isp;
CREATE TABLE employees_isp AS SELECT * FROM employees;

ALTER TABLE employees_isp
ADD CONSTRAINT PK_EMP_SPR1 PRIMARY KEY(employee_id);

ALTER TABLE employees_isp;
ADD CONSTRAINT FK_EMP_ISP1 FOREIGN KEY(department_id)
REFERENCES departments(department_id);

CREATE VIEW VIZ_EMP_DEP30_ISP
AS SELECT a.*, b.department_id, b.department_name FROM EMP30_ISP2 a, departments_isp b;

/*
6. S� se creeze vizualizarea VIZ_DEPT_SUM_PNU, care con�ine codul departamentului 
�i pentru fiecare departament salariul minim, maxim si media salariilor.
Ce fel de vizualizare se ob�ine (complexa sau simpla)? Se poate actualiza vreo 
coloan� prin intermediul acestei vizualiz�ri?
*/

CREATE VIEW VIZ_DEPT_SUM_ISP as
SELECT e.department_id, min(salary) minim, max(salary) maxim, avg(salary) medie
FROM employees e, departments d
WHERE e.department_id = d.department_id
GROUP BY e.department_id;

/*
7. Modifica�i vizualizarea VIZ_EMP30_PNU astfel �nc�t s� nu permit� modificarea 
sau inserarea de linii ce nu sunt accesibile ei. Vizualizarea va selecta �i 
coloana department_id. Da�i un nume constr�ngerii �i reg�si�i-o �n vizualizarea
USER_CONSTRAINTS din dic�ionarul datelor. �ncerca�i s� modifica�i �i s� insera�i
linii ce nu �ndeplinesc condi�ia department_id = 30.
*/

ALTER VIEW EMP30_ISP
ADD CONSTRAINT dep_constr check option(department_id < 30)

