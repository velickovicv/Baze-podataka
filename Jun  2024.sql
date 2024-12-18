1.

A)

CREATE TABLE POSLASTICAR (

ID INT PRIMARY KEY,
IME VARCHAR(20),
PREZIME VARCHAR(30),
RADNI_STAZ INT CHECK (RADNI_STAZ >= 0),
POL CHAR(1) CHECK (POL IN('M','Z')),
SPECIJALNOST VARCHAR(20) CHECK (SPECIJALNOST IN('SITNI_KOLACI','DOMACE_TORTE','OSTALO'))

);

CREATE TABLE POSLASTICA (

ID INT PRIMARY KEY,
NAZIV VARCHAR(20) NOT NULL,
TIP VARCHAR(5) CHECK (TIP IN('TORTA','KOLAC')),
GRAMAZA DECIMAL (10,2) CHECK (GRAMAZA > 0),
BROJ KALORIJA DECIMAL (5,2),
VEGANSKO CHAR(1) CHECK (VEGANSKO IN('1','0')

);

CREATE TABLE KUPAC (

ID INT PRIMARY KEY,
IME VARCHAR(20),
PREZIME VARCHAR(30),
ADRESA VARCHAR(50)

);

CREATE TABLE NARUDZBINA (

ID INT PRIMARY KEY,
ID_POSLASTICARA INT,-- FOREIGN KEY
ID_POSLASTICE INT, -- FOREIGN KEY
ID_KUPCA INT,
CENA DECIMAL (10,2),
DATUM DATE,
ADRESA_DOSTAVE VARCHAR(50),
OCENA INT CHECK (OCENA >= 0 AND OCENA <= 5),
FOREIGN KEY (ID_POSLASTICARA) REFERENCES POSLASTICAR(ID),
FOREIGN KEY (ID_POSLASTICE) REFERENCES POSLASTICA(ID),
FOREIGN KEY (ID_KUPCA) REFERENCES KUPAC(ID)

);

B)

SELECT POSLASTICA.NAZIV || ' - ' || POSLASTICA.TIP || ' - ' || POSLASTICA.GRAMAZA, COUNT(POSLASTICA.ID) AS BROJ_POJAVLJIVANJA
FROM POSLASTICA INNER JOIN NARUDZBINA ON POSLASTICA.ID = NARUDZBINA.ID_POSLASTICE
WHERE NARUDZBINA.DATUM > '31-12-2023'
GROUP BY POSLASTICA.NAZIV, POSLASTICA.TIP, POSLASTICA.GRAMAZA, POSLASTICA.ID
ORDER BY POSLASTICA.TIP DESC;

C)

SELECT KUPAC.IME, KUPAC.PREZIME, KUPAC.ID
FROM KUPAC INNER JOIN NARUDZBINA ON KUPAC.ID = NARUDZBINA.ID_KUPCA
INNER JOIN POSLASTICA ON NARUDZBINA.ID_POSLASTICE = POSLASTICA.ID
WHERE KUPAC.ADRESA = 'BEOGRAD' AND POSLASTICA.KALORIJE < 150 AND POSLASTICA.VEGANSKO = 0;
GROUP BY KUPAC.IME, KUPAC.PREZIME 
HAVING
COUNT(CASE POSLASTICA.BROJ_KALORIJE < 150 THEN 1 END) >= 3;
AND COUNT(CASE POSLASTICA.VEGANSKO = 1 THEN 1 END) = 0;


D)

SELECT POSLASTICAR.IME, POSLASTICAR.PREZIME, POSLASTICAR.POL, POSLASTICAR.RADNI_STAZ
FROM POSLASTICAR INNER JOIN NARUDZBINA ON POSLASTICAR.ID = NARUDZBINA.ID_POSLASTICARA
INNER JOIN POSLASTICA ON NARUDZBINA.ID_POSLASTICE = POSLASTICA.ID
INNER JOIN KUPAC ON NARUDZBINA.ID_KUPCA = KUPAC.ID
WHERE POSLASTICAR.SPECIJALNOST = 'DOMACE_TORTE' AND KUPAC.ADRESA = 'NIS' 
GROUP BY POSLASTICAR.IME, POSLASTICAR.PREZIME, POSLASTICAR.POL, POSLASTICAR.RADNI_STAZ
HAVING COUNT(poslastica.id) > 0
ORDER BY COUNT(poslastica.id) desc
FETCH FIRST 1 ROWS ONLY;

2. a)

 create view statistika as
select poslasticar.ime, poslasticar.prezime, count(*) as ukupno, avg(narudzbina.cena) as prosecna_cena_narudzbine, avg(narudzbina.ocena) as prosecna_ocena_narudzbine, poslastica.tip
from poslasticar inner join narudzbina on poslasticar.id = narudzbina.poslasticar_id
inner join poslastica on narudzbina.poslastica_id = poslastica.id
group by poslasticar.ime, poslasticar.prezime, poslastica.tip


select poslasticar.ime, poslasticar.prezime, ukupno, poslastica.tip, prosecna_cena_narudzbine, prosecna_ocena_narudzbine
from satistika
where tip = 'kolac'
order by ukupno desc
fetch first 1 rows only;

2. b)

SELECT id_kupca
FROM narudzbina
WHERE id_poslastice IN (
    SELECT id
    FROM poslastica
    WHERE tip = 'torta'
)
GROUP BY id_kupca
HAVING COUNT(*) >= 2;

UPDATE narudzbina n
SET n.cena = n.cena * 0.95 -- smanjenje cene za 5%
WHERE n.datum_dostave IS NULL -- narudzbine koje jos uvek nisu isporucene
AND EXISTS (
    SELECT 1
    FROM (
        SELECT id_kupca
        FROM narudzbina
        WHERE id_poslastice IN (
            SELECT id
            FROM poslastica
            WHERE tip = 'torta'
        )
        GROUP BY id_kupca
        HAVING COUNT(*) >= 2
    ) k
    WHERE k.id_kupca = n.id_kupca
);
