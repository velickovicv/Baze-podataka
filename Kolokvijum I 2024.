-- 1. a)

create table zaposleni
(
    jmbg int primary key,
    ime varchar(10),
    prezime varchar(15),
    ulica varchar(30),
    broj number,
    mesto varchar(50),
    plata decimal(10, 2) CHECK (plata >= 60000)
);

create table kompanija
(
    id int primary key,
    imek varchar(30) not null,
    godina_osn date not null,
    pib varchar2(50) not null,
    adresa varchar(50)
); 

create table radno_mesto
(
    id_kompanije int,
    jmbg_zaposlenog int,
    pozicija varchar(30),
    datum_poc date not null,
    datum_prestanka date,
    foreign key (id_kompanije) references kompanija(id),
    foreign key (jmbg_zaposlenog) references zaposleni(jmbg)
);

-- 2.
SELECT kompanija.imek, kompanija.pib, COUNT(*) AS broj_zaposlenih
FROM kompanija INNER JOIN radno_mesto ON kompanija.id = radno_mesto.id_kompanije
INNER JOIN zaposleni ON radno_mesto.jmbg_zaposlenog = zaposleni.jmbg
WHERE kompanija.godina_osn < 2000
GROUP BY kompanija.imek, kompanija.pib
ORDER BY broj_zaposlenih DESC;

-- 3.

select zaposleni.ime, zaposleni.prezime
from zaposleni inner join radno_mesto on zaposleni.jmbg = radno_mesto.jmbg_zaposlenog
where radno_mesto.pozicija != 'Rukovodilac'
group by zaposleni.ime, zaposleni.prezime
having count(radno_mesto.pozicija) >=2

-- 4. 

select kompanija.ime, count(*) as broj_zaposlenih
from kompanija inner join radno_mesto on kompanija.id = radno_mesto.id_kompanije
where radno_mesto.datum_restanka is null
group by kompanija.imek
order by count(*) desc
fetch first 1 row only;


