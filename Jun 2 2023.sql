Jun 2023.

1.

a)

CREATE TABLE ATLETICAR (
ID INT PRIMARY KEY,
IME VARCHAR(20), 
PREZIME VARCHAR(30),
NAPOMENA VARCHAR(255),
POL CHAR(1) CHECK (POL IN('M','Z')),
GOD_RODJ DATE
);

CREATE TABLE TAKMICENJE (
ID INT PRIMARY KEY,
DATUM DATE,
NAZIV VARCHAR(50),
DUZINA INT CHECK (DUZINA >= 0)
);

CREATE TABLE ATLETICAR_TAKMICENJE (
ID_ATLETICARA INT,
ID_TAKMICENJA INT,
PRIMARY KEY (ID_ATLETICARA, ID_TAKMICARA),
FOREIGN KEY (ID_ATLETICARA) REFERENCES ATLETICAR(ID),
FOREIGN KEY (ID_TAKMICENJA) REFERENCES TAKMICENJE(ID)
);

B)

SELECT TAKMICENJE.NAZIV, TAKMICENJE.ID, SUM(CASE WHEN ATLETICAR.POL = 'M' THEN 1 END) AS BROJ_MUSKIH, SUM(CASE WHEN ATLETICAR.POL = 'Z' THEN 1 END) AS BROJ_ZENSKIH
FROM TAKMICENJE INNER JOIN ATLETICAR_TAKMICENJE ON TAKMICENJE.ID = ATLETICAR_TAKMICENJE.ID_ATLETICARA
INNER JOIN ATLETICAR ON ATLETICAR_TAKMICENJE.ID_ATELTICARA = ATLETICAR.ID
GROUP BY TAKMICENJE.NAZIV, TAKMICENJE.ID
HAVING SUM(CASE WHEN ATLETICAR.POL = 'Z' THEN 1 END) > 10;

C)

SELECT ATLETICAR.IME, ATLETICAR.PREZIME, ATLETICAR.ID, COUNT(ATLETICAR_TAKMICENJE.ID_TAKMICENJA) AS BROJ_TAKMICENJA
FROM ATLETICAR INNER JOIN ATLETICAR_TAKMICENJE ON ATLETICAR.ID = ATLETICAR_TAKMICENJE.ID_ATLETICARA
INNER JOIN TAKMICENJE ON ATLETICAR_TAKMICENJE.ID_TAKMICENJA = TAKMICENJE.ID
WHERE TAKMICENJE.DUZINA >= 1000
GROUP BY ATLETICAR.IME, ATLETICAR.PREZIME, ATLETICAR.ID
HAVING COUNT(ATLETICAR_TAKMICENJE.ID_TAKMICENJA) > 4


D) 

SELECT TAKMICENJE.NAZIV
FROM TAKMICENJE INNER JOIN ATLETICAR_TAKMICENJE ON TAKMICENJE.ID = ATLETICAR_TAKMICENJE.ID_TAKMICENJA -- POVEZUJEMO TABELU TAKMICENJE SA TABELOM ALTETICAR_TAKMICENJE, DA BI VIDELI KOJI ATLETICARI SU UCESTVOVALI U KOM TAKMICENJU
GROUP BY TAKMICENJE.NAZIV -- FILTRIRAMO KAO STO U ZADATKU KAZE, PO NAZIVU TAKMICENJA
HAVING COUNT(ATLETICAR_TAKMICENJE.ID_ATLETICARA) ASC -- BROJIMO KOLIKO JE TAKMICARA UCESTVOVALO U TAKMICENJU I SORTIRAMO U RASTUCI REZULTAT
FETCH FIRST 1 ROW ONLY; -- IZBACUJEMO SAMO PRVI RED KOJI SE POJAVI (NAZIV TAKMICENJA SA NAJMANJIM BROJEM TAKMICARA)


2. a) 

create view informacije
select takmicenje.naziv, takmicenje.datum, count(atleticar_takmicenje.altericar_id) as ukupan_broj_takmicara
avg(extract(YEAR FROM SYSDATE) - atleticar.god_rod) as prosecna_starost
from takmicenje left join atletciar_takmicenje on takmicenje.id = atleticar_takmicenje.takmicenje_id
left join atleticar on atleticar_takmicenje.atleticar_id = atletciar.id
group by takmicenje.naziv. avg(god_rod)
order by ukupan_broj_ucesnika desc
fetch 1 rows only;

select takmicenje.id, takmicenje.naziv 
from informacije
order by ukupan_broj_takmicara desc
fetch 1 rows only;
