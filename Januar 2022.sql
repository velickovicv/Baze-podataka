-- 2. A)

CREATE VIEW STATISTIKA 
AS SELECT KOMPOANIJA.ID, KOMPANIJA.NAZIV, KOMPANIJA.GRAD, COUNT(DISTINCT FAKTURA.KOMP_SALJE) AS BROJ_FAKTURA_POSLATE, COUNT(DISTINCT FAKTURA.KOMP_PRIMA) AS BROJ_FAKTURA_PRIMLJENIH
FROM KOMPANIJA INNER JOIN FAKTURA ON KOMPANIJA.ID = FAKTURA.KOMP_SALJE OR KOMPANIJA.ID = FAKTURA.KOMP_SALJE
GROUP BY KOMPANIJA.ID, KOMPANIJA.NAZIV, KOMPANIJA.GRAD

SELECT KOMPANIJA.ID, KOMPANIJA.NAZIV, KOMPANIJA.GRAD
FROM STATISTIKA
GROUP BY KOMPANIJA.ID, KOMPANIJA.NAZIV, KOMPANIJA.GRAD
HAVING SUM(BROJ_FAKTURA_IZDATIH) + SUM(BROJ_FAKTURA_PRIMLJENIH) < 100;


-- 2. B)

UPDATE FAKTURA
SET IZNOS = IZNOS * 1.05
WHERE KOMP_SALJE IN (SELECT ID FROM KOMPANIJA WHERE DRZAVA = 'SRBIJA')
AND VALUTA = 'EUR';
