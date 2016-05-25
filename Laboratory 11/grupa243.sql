/*
1. Pe baza tabelului EMP_PNU, sã se creeze o vizualizare VIZ_EMP30_PNU, 
care conþine codul, numele, email-ul ºi salariul angajaþilor din departamentul 30. 
Sã se analizeze structura ºi conþinutul vizualizãrii. Ce se observã referitor la constrângeri? 
Ce se obþine de fapt la interogarea conþinutului vizualizãrii? Inseraþi o linie prin intermediul 
acestei vizualizãri; comentaþi.
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
a) Inseraþi o linie prin intermediul vizualizãrii precedente. Comentaþi.
b) Care sunt coloanele actualizabile ale acestei vizualizãri? Verificaþi rãspunsul în dicþionarul datelor (USER_UPDATABLE_COLUMNS).
c) Inseraþi o linie specificând valori doar pentru coloanele actualizabile.
d) Analizaþi conþinutul vizualizãrii viz_empsal50_pnu ºi al tabelului emp_pnu.
*/

/*
5.
a) Sã se creeze vizualizarea VIZ_EMP_DEP30_PNU, astfel încât aceasta sã includã coloanele vizualizãrii VIZ_EMP_30_PNU, precum ºi numele ºi codul departamentului. Sã se introducã aliasuri pentru coloanele vizualizãrii.
! Asiguraþi-vã cã existã constrângerea de cheie externã între tabelele de bazã ale acestei vizualizãri.
b) Inseraþi o linie prin intermediul acestei vizualizãri.
c) Care sunt coloanele actualizabile ale acestei vizualizãri? Ce fel de tabel este cel ale cãrui coloane sunt actualizabile? Inseraþi o linie, completând doar valorile corespunzãtoare.
d) Ce efect are o operaþie de ºtergere prin intermediul vizualizãrii viz_emp_dep30_pnu? Comentaþi.
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
6. Sã se creeze vizualizarea VIZ_DEPT_SUM_PNU, care conþine codul departamentului 
ºi pentru fiecare departament salariul minim, maxim si media salariilor.
Ce fel de vizualizare se obþine (complexa sau simpla)? Se poate actualiza vreo 
coloanã prin intermediul acestei vizualizãri?
*/

CREATE VIEW VIZ_DEPT_SUM_ISP as
SELECT e.department_id, min(salary) minim, max(salary) maxim, avg(salary) medie
FROM employees e, departments d
WHERE e.department_id = d.department_id
GROUP BY e.department_id;

/*
7. Modificaþi vizualizarea VIZ_EMP30_PNU astfel încât sã nu permitã modificarea 
sau inserarea de linii ce nu sunt accesibile ei. Vizualizarea va selecta ºi 
coloana department_id. Daþi un nume constrângerii ºi regãsiþi-o în vizualizarea
USER_CONSTRAINTS din dicþionarul datelor. Încercaþi sã modificaþi ºi sã inseraþi
linii ce nu îndeplinesc condiþia department_id = 30.
*/

ALTER VIEW EMP30_ISP
ADD CONSTRAINT dep_constr check option(department_id < 30)

