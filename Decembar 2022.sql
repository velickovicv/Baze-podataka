-- 1. a)

CREATE TABLE SPORTISTA (
    ID INT PRIMARY KEY,
    IME VARCHAR(50) NOT NULL,
    PREZIME VARCHAR(50) NOT NULL,
    BRTEL VARCHAR(15),
    GOD_ROD INT,
    GRAD VARCHAR(50),
    PLATA DECIMAL(10, 2)
);

CREATE TABLE KLUB (
    ID INT PRIMARY KEY,
    NAZIV VARCHAR(100) NOT NULL,
    LOKACIJA VARCHAR(100),
    GOD_OSNIVANJA INT,
    SPORT VARCHAR(50)
);

CREATE TABLE CLANN (
    ID INT PRIMARY KEY,
    ID_SPORTISTE INT,
    ID_KLUBA INT,
    DATUM_OD DATE NOT NULL,
    DATUM_DO DATE,
    TIM VARCHAR(20) CHECK (TIM IN ('skola', 'prvi', 'mladi')),
    FOREIGN KEY (ID_SPORTISTE) REFERENCES SPORTISTA(ID),
    FOREIGN KEY (ID_KLUBA) REFERENCES KLUB(ID)
);

-- 1. b)

select klub.naziv, klub.lokacija, klub.god_osnivanja
from klub 
where extract (YEAR from sysdate) - klub.god_osnivanja > 20 AND klub.sport = 'odbojka'
order by god_osnivanja desc

-- 1. d)

select klub.naziv, klub.sport, count(*) as broj_clanova
from klub inner join clan on klub.id = clan.id_kluba
inner join sportista on clan.id_sportista = sportista.id
where klub.tim = 'skola' and extract (YEAR from sysdate) - clan.god_rod < 15
group by klub.naziv, klub.sport 
order by broj_clanova desc
fetch first 1 row only;

-- 1. c)

select  sportisa.ime, sportista.prezime, clan.tim
from sportista inner join clan on sportista.id = clan.id_sportista
inner join klub on clan.id_kluba = klub.id 
where extract (YEAR from sysdate) - sportista.god_rod < 30 and sportista.grad != klub.lokacija

-- 1. e)

SELECT 
    KLUB.NAZIV, 
    KLUB.LOKACIJA
FROM 
    KLUB
INNER JOIN 
    CLAN M ON KLUB.ID = M.ID_KLUBA
INNER JOIN 
    SPORTISTA SM ON M.ID_SPORTISTE = SM.ID
WHERE 
    KLUB.SPORT = 'vaterpolo'
    AND M.TIM = 'mladi'
    AND SM.PLATA > (
        SELECT AVG(SP.PLATA)
        FROM CLAN P
        INNER JOIN SPORTISTA SP ON P.ID_SPORTISTE = SP.ID
        WHERE P.ID_KLUBA = KLUB.ID
          AND P.TIM = 'prvi'
          AND P.DATUM_DO IS NULL
    )
    AND (SELECT COUNT(*) 
         FROM CLAN C2
         INNER JOIN SPORTISTA S2 ON C2.ID_SPORTISTE = S2.ID
         WHERE C2.ID_KLUBA = KLUB.ID
           AND C2.TIM = 'mladi'
           AND S2.PLATA > (
               SELECT AVG(SP.PLATA)
               FROM CLAN P
               INNER JOIN SPORTISTA SP ON P.ID_SPORTISTE = SP.ID
               WHERE P.ID_KLUBA = KLUB.ID
                 AND P.TIM = 'prvi'
                 AND P.DATUM_DO IS NULL
           )
    ) >= 2
    AND NOT EXISTS (
        SELECT 1
        FROM CLAN P1
        INNER JOIN SPORTISTA SP1 ON P1.ID_SPORTISTE = SP1.ID
        WHERE P1.ID_KLUBA = KLUB.ID
          AND P1.TIM = 'prvi'
          AND SP1.GRAD = 'Novi Sad'
          AND SP1.PLATA > 20000
    )
GROUP BY 
    KLUB.NAZIV, 
    KLUB.LOKACIJA;

-- 2. a)

  create view IGRAC_STAT as
  select sportista.ime, sportista.prezime, extract (YEAR from sysdate) - sportista.god_rod) as godine, sporista.plata, count(distinct id_kluba) as broj_klubova
  from sportista inner join clan on sportista.id = clan.id_sportiste
  group by ime, prezime, godine, plata;

select *
from igrac_stat 
where broj_klubova >= 2

-- 2. b)

UPDATE SPORTISTA
SET PLATA = PLATA * 0.97  -- Umanjenje plate za 3%
WHERE ID IN (
    SELECT S.ID
    FROM SPORTISTA S
    JOIN CLAN C ON S.ID = C.ID_SPORTISTE
    JOIN KLUB K ON C.ID_KLUBA = K.ID
    WHERE C.TIM = 'prvi'  -- Samo igrači u prvom timu
    AND K.LOKACIJA = 'Novi Sad'  -- Klubovi iz Novog Sada
    AND C.DATUM_DO IS NULL  -- Trenutni članovi
);

-- 2. c)

-- Brišemo iz tabele CLAN
DELETE C
FROM CLAN C
-- Povezujemo tabelu CLAN sa tabelom KLUB da dobijemo informacije o klubovima
JOIN KLUB K ON C.ID_KLUBA = K.ID
-- Povezujemo tabelu CLAN sa drugom instancom tabele CLAN da pronađemo sportiste koji su u timu "mladi"
LEFT JOIN CLAN MLADI ON C.ID_SPORTISTE = MLADI.ID_SPORTISTE AND MLADI.TIM = 'mladi'
-- Definišemo uslove za brisanje
WHERE C.TIM = 'skola'  -- Sportisti u timu "škola"
AND EXTRACT(YEAR FROM SYSDATE) - K.GOD_OSNIVANJA > 20  -- Klubovi stariji od 20 godina
AND MLADI.ID_SPORTISTE IS NULL;  -- Sportisti koji nisu u timu "mladi"
