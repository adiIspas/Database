/*
1. S� se creeze tabelul ANGAJATI_pnu (pnu se alcatuie�te din prima liter� din prenume 
�i primele dou� din numele studentului) corespunz�tor schemei rela�ionale:
ANGAJATI_pnu(cod_ang number(4), nume varchar2(20), prenume varchar2(20), email char(15), 
data_ang date, job varchar2(10), cod_sef number(4), salariu number(8, 2), cod_dep number(2))
�n urm�toarele moduri:
a) f�r� precizarea vreunei chei sau constr�ngeri;
b)cu precizarea cheilor primare la nivel de coloan� si a constrangerilor NOT NULL pentru coloanele nume �i salariu;
c)cu precizarea cheii primare la nivel de tabel si a constr�ngerilor NOT NULL pentru coloanele nume �i salariu.
Se presupune c� valoarea implicit� a coloanei data_ang este SYSDATE.
*/

drop table angajati_isp;

create table angajati_isp (cod_ang number(4), nume varchar2(20), prenume varchar2(20), 
             email char(15), data_ang date, job varchar2(10), cod_sef number(4), 
             salariu number(8,2), cod_dep number(2));
             
create table angajati_isp (
       cod_ang number(4), 
       nume varchar2(20) constraint nume not null,
       prenume varchar2(20) constraint prenume not null, 
       email char(15), 
       data_ang date default sysdate, 
       job varchar2(10), 
       cod_sef number(4), 
       salariu number(8,2), 
       cod_dep number(2));
       
create table angajati_isp (
       cod_ang number(4), 
       nume varchar2(20) constraint nume not null,
       prenume varchar2(20) constraint prenume not null, 
       email char(15), 
       data_ang date default sysdate, 
       job varchar2(10), 
       cod_sef number(4), 
       salariu number(8,2), 
       cod_dep number(2),
       constraint pk_nume primary key(nume, salariu));
/*
2.
Ad�uga�i urm�toarele �nregistr�ri �n tabelul ANGAJATI_pnu:
Prima si a patra �nregistrare vor fi introduse specific�nd coloanele pentru care 
introduce�i date efectiv, iar celelalte vor fi inserate f�r� precizarea coloanelor �n comanda INSERT.
*/

insert into angajati_isp (cod_ang, nume, prenume, email, data_ang, job, cod_sef, salariu, cod_dep)
values (100,'Nume1','Prenume1',null,null,'Director',null,20000,10);

insert into angajati_isp
values (101,'Nume2', 'Prenume2', 'Nume2', '02-02-2004', 'Inginer', 100, 10000, 10);

insert into angajati_isp
values (102,'Nume3', 'Prenume3', 'Nume3', '05-06-2000', 'Analist', 101, 5000, 20);

insert into angajati_isp (cod_ang, nume, prenume, email, data_ang, job, cod_sef, salariu, cod_dep)
values (103,'Nume4','Prenume4',null,null,'Inginer',100,9000,20);

insert into angajati_isp
values (104,'Nume5','Prenume5','Nume5',null,'Analist',101,3000,30);

select * 
from angajati_isp;

/*
3. Crea�i tabelul ANGAJATI10_pnu, prin copierea angaja�ilor din departamentul 
10 din tabelul ANGAJATI_pnu. Lista�i structura noului tabel. Ce se observ�?
*/

create table angajati10_isp as select * from angajati_isp where cod_dep = 10;

select *
from angajati10_isp;

/*
4. Introduceti coloana comision in tabelul ANGAJATI_pnu. 
Coloana va avea tipul de date NUMBER(4,2).
*/

alter table angajati_isp
add comision number(4,2);

alter table angajati_isp
modify comision number(2,2);

select *
from angajati_isp;

/*
6. Seta�i o valoare DEFAULT pentru coloana salariu.
*/

alter table angajati_isp
modify salariu number(8,2) default 1000;

/*
8. Actualizati valoarea coloanei comision, set�nd-o la valoarea 0.1 pentru 
salaria�ii al c�ror job �ncepe cu litera A. (UPDATE)
*/

update angajati_isp
set comision = 0.1
where lower(job) like 'a%';

select *
from angajati_isp;

/*
9. Modifica�i tipul de date al coloanei email �n VARCHAR2.
*/

alter table angajati_isp
modify email varchar2(15);

/*
10. Ad�uga�i coloana nr_telefon �n tabelul ANGAJATI_pnu, set�ndu-i o valoare implicit�.
*/

alter table angajati_isp
add nr_telefon varchar2(10) default 0720000000;

select *
from angajati_isp;

/*
12. Redenumi�i tabelul ANGAJATI_pnu �n ANGAJATI3_pnu.
*/

rename angajati_isp to angajati3_isp;

select *
from angajati3_isp;
