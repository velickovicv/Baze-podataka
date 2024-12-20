-- 2. a)

create view informacije
as select sektor.id, sektor.naziv, zaposleni.strucna_sprema, count(distinct zaposleni.id) as broj_radnika, count(distinct pozicija.naziv) as broj_pozicija, avg(NVL(datum_kraja, sysdate) - datum_poc) as prosecno
from zaposleni inner join pozicija on zaposleni.id = pozicija.zaposleni_id
inner join sektor on pozicija.sektor_id = sektor.id
where pozicija.datum_poc >= add_months(sysdate, -60)
group by sektor.id, sektor.naziv, zaposleni.strucna_sprema;

SELECT SEKTOR.ID, SEKTOR.NAZIV, MAX(BROJ_RADNIKA) AS MAX_RADNIKA
FROM INFORMACIJE
GROUP BY SEKTOR.ID, SEKTOR.NAZIV
ORDER BY MAX_RADNIKA
FETCH FIRST 1 ROW ONLY;



-- 2. b)

UPDATE PLATA
SET PLATA = PLATA * 1.20
WHERE EXISTS (SELECT 1
FROM ZAPOSLENI
WHERE POZICIJA.ZAPOSLENI_ID = ZAPOSLENI.ID
AND
(EXTRACT(YEAR FROM SYSDATE) - GOD_RODJENJA) < 40)

AND
(SELECT POZICIJA.SEKTOR_ID
FROM SEKTOR
WHERE SEKTOR.NAZIV = 'PRODAJA')

AND (SELECT COUNT(*)
FROM POZICIJA
WHERE ZAPOSLENI.ID = POZICIJA.ZAPOSLENI_ID
AND SEKTOR.ID = POZICIJA.SEKTOR_ID
GROUP BY
ZAPOSLENI.ID
HAVING COUNT(*) = 3);

-- 2. C)

DELETE FROM POZICIJA
WHERE SEKTOR.ID = (SELECT ID
FROM SEKTOR
WHERE NAZIV = 'PROIZVODNJA'
)
AND ZAPOSLENI_ID IN (
SELECT ID
FROM ZAPOSLENI
WHERE STRUCNA_SPREMA = 7
)
AND (NVL(DATUM_KRAJA, SYSDATE) - DATUM_POC) < 60;

