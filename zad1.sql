/* 
POSZCZEGÓLNE KOMENDY URUCHAMIAMY ZAZNACZAJ¥C JE A NASTÊPNIE KLIKAJ¥C EXECUTE LUB F5
 */ 

--TWORZENIE BAZY
CREATE DATABASE s293125;

--UZYWANIE UTWORZONEJ BAZY
USE s293125;

--TWORZENIE SCHEMY
CREATE SCHEMA firma;

--SPRAWDZAMY CZY SCHEMA ZOSTA£A UTWORZONA
select *
from information_schema.schemata;

--TWORZENIE ROLI
CREATE ROLE ksiegowosc

--NADAWANIE UPRAWNIEÑ
GRANT SELECT TO ksiegowosc 

--DODAWANIE TABELI
CREATE TABLE firma.pracownicy(
id_pracownika UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
imie VARCHAR(20) NOT NULL,
nazwisko VARCHAR(20) NOT NULL,
adres VARCHAR(50),
telefon VARCHAR(20) --DO ZASTANOWIENIA SIÊ Z KIERUNKOWYM... NA RAZIE ZOSTAWIAM TAK
)

CREATE TABLE firma.godziny(
id_godziny UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
data DATE ,
liczba_godzin FLOAT NOT NULL DEFAULT 0, 
id_pracownika UNIQUEIDENTIFIER NOT NULL,
FOREIGN KEY (id_pracownika) REFERENCES firma.pracownicy(id_pracownika) ON DELETE CASCADE
)

CREATE TABLE firma.pensja_stanowisko(
id_pensji UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
stanowisko VARCHAR(50),
kwota DECIMAL NOT NULL
)

CREATE TABLE firma.premia(
id_premii UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
rodzaj VARCHAR(50) NOT NULL,
kwota DECIMAL NOT NULL
)

CREATE TABLE firma.wynagrodzenie(
id_wynagrodzenia UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
data DATE NOT NULL,
id_pracownika UNIQUEIDENTIFIER NOT NULL,
id_godziny UNIQUEIDENTIFIER NOT NULL,
id_pensji UNIQUEIDENTIFIER NOT NULL,
id_premii UNIQUEIDENTIFIER,
FOREIGN KEY (id_pracownika) REFERENCES firma.pracownicy(id_pracownika) ,
FOREIGN KEY (id_godziny) REFERENCES firma.godziny(id_godziny) ON DELETE CASCADE,
FOREIGN KEY (id_pensji) REFERENCES firma.pensja_stanowisko(id_pensji) ON DELETE CASCADE,
FOREIGN KEY (id_premii) REFERENCES firma.premia(id_premii) ON DELETE CASCADE
)

--TWORZENIE INDEKSÓW
CREATE INDEX index_pracownicy
ON firma.pracownicy (nazwisko, imie);

CREATE INDEX index_pensja_stanowisko
ON firma.pensja_stanowisko (stanowisko, kwota);

CREATE INDEX index_premia
ON firma.premia (rodzaj, kwota);

--KOMENTARZE DO TABEL DO UZUPE£NIENA W POSTGRES

COMMENT ON TABLE firma.pracownicy is 'tabela przechowywuj¹ca pracowników';
COMMENT ON TABLE firma.godziny is 'tabela przechowywuj¹ca godziny';
COMMENT ON TABLE firma.pensja_stanowisko is 'tabela przechowywuj¹ca stanowisko i pensje do nich';
COMMENT ON TABLE firma.premia is 'tabela przechowywuj¹ca premie przyznawane pracownikom';
COMMENT ON TABLE firma.wynagrodzenie is 'tabela przechowywuj¹ca wynagrodzenie pracownika';


--DODAWANIE POL DO TABELI GODZINY
ALTER TABLE firma.godziny ADD miesiac DATE;
ALTER TABLE firma.godziny ADD numer_tygodnia DATE;

--ZMIANA TYPU POLA W TABELI PRACOWNICY
ALTER TABLE firma.wynagrodzenie ALTER COLUMN data VARCHAR(50);

--WARTOSC POLA RODZAJ = BRAK (JA TO BYM ZROBI£ TRIGGEREM, I TAK TE¯ ZROBI£EM ALE NIE WIEM CZY O TO MU CHODZI£O :/)
CREATE TRIGGER firma.setBrakIfPremiaIsNull ON firma.premia
FOR INSERT 
AS
	BEGIN
		UPDATE firma.premia
		SET rodzaj = IIF(kwota = 0, 'brak', rodzaj)
	END;

--WYPE£NIANIE TABELI
INSERT INTO firma.pracownicy (id_pracownika, imie, nazwisko, adres, telefon) VALUES 
('1EEA153C-7C3A-4F07-A9E3-0B06FA9119DF', 'Jan', 'Kowalski', 'Kraków', '123456789'),
('33EDD913-A0E6-4B81-94AA-3E6080244EA2', 'Anna', 'Nowak', 'Krynica', '123456789'),
('4C03AF6D-01BB-4861-B697-58C741C754D2', 'Kamil', 'Loksz', 'Gdynia', '123456789'),
('22D4F621-4899-436A-A049-5D7D7478765F', 'Krzysztof', 'Orczyk', 'Kraków', '123456789'),
('0278D9E8-2CEC-40FC-AE9A-702DC493FC20', 'Janina', 'Wozowczyk', 'Gdynia', '123456789'),
('6E536143-B779-42E5-8EF4-89E36B757655', 'Arkadiusz', 'Puzinowski', 'Kraków', '123456789'),
('35907B42-000E-41B3-BD99-8D185FF5AF46', 'Ola', 'Tuszkiewicz', 'Tylicz', '123456789'),
('3662F435-3A80-48B9-B8F2-9799B381650A', 'Andrzej', 'Caba', 'Kraków', '123456789'),
('D07CF3B5-B20F-48D5-99B0-A3A1CF9608B6', 'Janusz', 'Nosacz', 'Radom', '123456789'),
('F811F59C-A8E0-4D27-9E8F-C12B1C0F2A8D', 'Adelajda', 'Cabon', 'Poznañ', '123456789');

INSERT INTO firma.godziny(id_godziny, data, liczba_godzin, id_pracownika, miesiac, numer_tygodnia) VALUES 
('D8FF6161-8098-47C6-B25D-0755E5EC0D4C', '2020.02.20', 160, '1EEA153C-7C3A-4F07-A9E3-0B06FA9119DF', '2020.02.01', '2020.02.01'),
('86C8BAF4-0959-42DA-B3AB-48E4520B36FC', '2020.02.20', 168, '33EDD913-A0E6-4B81-94AA-3E6080244EA2', '2020.02.01', '2020.02.01'),
('FC7FB04E-87E4-468F-A4D5-639F3C19BFD3', '2020.02.20', 172, '4C03AF6D-01BB-4861-B697-58C741C754D2', '2020.02.01', '2020.02.01'),
('8551657A-BD14-4CA4-B6BB-81919C1E0AA7', '2020.02.20', 168, '22D4F621-4899-436A-A049-5D7D7478765F', '2020.02.01', '2020.02.01'),
('5E36C6FE-50CB-49E0-A1BB-94B148E884DD', '2020.02.20', 160, '6E536143-B779-42E5-8EF4-89E36B757655', '2020.02.01', '2020.02.01'),
('D99DCA51-1CD9-47B0-8BCF-A3D2A58550EF', '2020.02.20', 168, '35907B42-000E-41B3-BD99-8D185FF5AF46', '2020.02.01', '2020.02.01'),
('31928204-583A-424E-B0B9-AA1A4D663725', '2020.02.20', 140, '3662F435-3A80-48B9-B8F2-9799B381650A', '2020.02.01', '2020.02.01'),
('2B8A9EF8-8A17-48DB-ABB7-CDDDFA2709E7', '2020.02.20', 168, 'D07CF3B5-B20F-48D5-99B0-A3A1CF9608B6', '2020.02.01', '2020.02.01'),
('381E5E8B-8E2A-4AE4-9238-D78C45B6DA15', '2020.02.20', 3, 'F811F59C-A8E0-4D27-9E8F-C12B1C0F2A8D', '2020.02.01', '2020.02.01'),
('3BA9C8AB-74A2-4F60-9BBE-FB4FB2B46FB6', '2020.02.20', 152, '0278D9E8-2CEC-40FC-AE9A-702DC493FC20', '2020.02.01', '2020.02.01');

INSERT INTO firma.pensja_stanowisko (id_pensji, stanowisko, kwota) VALUES 
('F0DB0D11-1DCC-4659-9A00-6CA192D1424D', 'Sekretarka', 2000),
('CB25E50C-B19A-4BC0-8135-D8EF52A932A6', 'Sprz¹taczka', 1700),
('8BAB774C-82CD-4BFB-83CC-70D0E27A7AEE', 'Praktykant', 2300),
('A8F070CD-99FB-4C2F-872B-01918D9BA999', 'Ochroniarz', 1600),
('B150DA6C-6B82-4BDB-B5C3-F667CC2E911D', 'Informatyk', 4000),
('1292E0F2-1EBE-447C-A6B4-29A553736DB1', 'Programista C', 8000),
('7523ED65-B6C7-4EDE-99FF-F692A712E3F7', 'Programista C#', 7000),
('67FD49A6-137F-40F5-9FF0-C531C5584004', 'Kierownik', 12000),
('C49200B2-6DAC-4B4A-A581-7101492CDAEA', 'Programista sql', 7000),
('9AAC2C01-E604-490A-90C4-33DF3B72AD37', 'FrontEnd', 4000);

INSERT INTO firma.premia (id_premii, rodzaj, kwota) VALUES
('8FE7B87D-3E06-4E75-BB2E-EA212516921E', 'roczna',1000),
('701AAA7B-D4E3-41A6-82DE-ACB598781805', 'miesiêczna',50),
('44DF8F33-9DB9-4E14-B18D-C948ACEFBF0E', 'pó³roczna',550),
('323489D7-20C3-412C-B123-6217DFABAF03', '',0),
('FDD970A2-3391-4E96-9A33-BE1059E80E6C', 'dodatkowa',40),
('DA93A138-79D0-4843-B145-8E0796F07078', 'transportowa',30),
('AC76966C-8548-4766-8369-A5ABA5440975', 'ubezpieczenia',70),
('2B7F375C-8057-4994-943B-F6855C2404CA', 'stanowiskowa',800),
('2D112AA5-CB28-4931-9C34-67D0B8E342AE', 'uznaniowa',600),
('6F0FA454-61D3-4554-8AE1-6465BFBB20B1', 'kwartalna',400);

INSERT INTO firma.wynagrodzenie (id_wynagrodzenia, data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES 
('9D4029D4-0954-433B-AD9B-05B935E8D26F', '2020.02.20', '1EEA153C-7C3A-4F07-A9E3-0B06FA9119DF', 'D8FF6161-8098-47C6-B25D-0755E5EC0D4C', 'F0DB0D11-1DCC-4659-9A00-6CA192D1424D', '8FE7B87D-3E06-4E75-BB2E-EA212516921E'),
('2CA4E892-3A7D-4E8D-9137-0E51EB9907E1', '2020.02.20', '33EDD913-A0E6-4B81-94AA-3E6080244EA2', '86C8BAF4-0959-42DA-B3AB-48E4520B36FC', 'CB25E50C-B19A-4BC0-8135-D8EF52A932A6', '701AAA7B-D4E3-41A6-82DE-ACB598781805'),
('2304A3A7-408C-4521-8C30-14165EE0CEF3', '2020.02.20', '4C03AF6D-01BB-4861-B697-58C741C754D2', 'FC7FB04E-87E4-468F-A4D5-639F3C19BFD3', '8BAB774C-82CD-4BFB-83CC-70D0E27A7AEE', '44DF8F33-9DB9-4E14-B18D-C948ACEFBF0E'),
('145291C7-D7C7-474A-893E-1E9EA6375E11', '2020.02.20', '22D4F621-4899-436A-A049-5D7D7478765F', '8551657A-BD14-4CA4-B6BB-81919C1E0AA7', 'A8F070CD-99FB-4C2F-872B-01918D9BA999', '323489D7-20C3-412C-B123-6217DFABAF03'),
('1585B783-140E-4785-B298-3C51547FD876', '2020.02.20', '0278D9E8-2CEC-40FC-AE9A-702DC493FC20', '5E36C6FE-50CB-49E0-A1BB-94B148E884DD', 'B150DA6C-6B82-4BDB-B5C3-F667CC2E911D', 'FDD970A2-3391-4E96-9A33-BE1059E80E6C'),
('EE6174D2-64BD-4425-9591-93A0DDAB1624', '2020.02.20', '6E536143-B779-42E5-8EF4-89E36B757655', 'D99DCA51-1CD9-47B0-8BCF-A3D2A58550EF', '1292E0F2-1EBE-447C-A6B4-29A553736DB1', 'DA93A138-79D0-4843-B145-8E0796F07078'),
('7C818FEE-FACA-4165-97C0-971AD3B0B3A2', '2020.02.20', '35907B42-000E-41B3-BD99-8D185FF5AF46', '31928204-583A-424E-B0B9-AA1A4D663725', '7523ED65-B6C7-4EDE-99FF-F692A712E3F7', 'AC76966C-8548-4766-8369-A5ABA5440975'),
('409C22AA-5176-4D38-9ED4-CC4A8DE0E341', '2020.02.20', '3662F435-3A80-48B9-B8F2-9799B381650A', '2B8A9EF8-8A17-48DB-ABB7-CDDDFA2709E7', '67FD49A6-137F-40F5-9FF0-C531C5584004', '2B7F375C-8057-4994-943B-F6855C2404CA'),
('C2D38E97-0D10-40A1-B29F-E4CF427ECE84', '2020.02.20', 'D07CF3B5-B20F-48D5-99B0-A3A1CF9608B6', '381E5E8B-8E2A-4AE4-9238-D78C45B6DA15', 'C49200B2-6DAC-4B4A-A581-7101492CDAEA', '2D112AA5-CB28-4931-9C34-67D0B8E342AE'),
('4122BA74-DB1D-4EA6-967A-FDCC6CEC5775', '2020.02.20', 'F811F59C-A8E0-4D27-9E8F-C12B1C0F2A8D', '3BA9C8AB-74A2-4F60-9BBE-FB4FB2B46FB6', '9AAC2C01-E604-490A-90C4-33DF3B72AD37', NULL);

--ZAPYTANIA 
--6A
SELECT firma.pracownicy.id_pracownika, firma.pracownicy.nazwisko FROM firma.pracownicy;

--6B
SELECT w.id_pracownika FROM firma.wynagrodzenie w, firma.pensja_stanowisko ps
WHERE ps.id_pensji = w.id_pensji AND ps.kwota > 1000

--6C w tym wypadku trochê przekombinowane ale nie mog³em porównac pola UNIQUEIDENTIFIER do null
DECLARE @myvar uniqueidentifier = NULL
SELECT w.id_pracownika FROM firma.wynagrodzenie w, firma.pensja_stanowisko ps
WHERE ((@myvar IS NULL AND w.id_premii IS NULL) OR (w.id_premii = @myvar)) AND ps.id_pensji = w.id_pensji AND ps.kwota > 2000
UNION
SELECT w.id_pracownika FROM firma.premia pr, firma.wynagrodzenie w, firma.pensja_stanowisko ps
WHERE pr.id_premii = w.id_premii AND pr.rodzaj = 'brak' AND ps.id_pensji = w.id_pensji AND ps.kwota > 2000;

--6D
SELECT * FROM firma.pracownicy p
WHERE p.imie LIKE 'J%';

--6E
SELECT * FROM firma.pracownicy p
WHERE p.nazwisko LIKE '%n%' AND p.imie LIKE '%a';

--6F
SELECT p.imie, p.nazwisko, g.liczba_godzin - 160 FROM firma.pracownicy p, firma.godziny g, firma.wynagrodzenie w
WHERE g.id_godziny = w.id_godziny AND w.id_pracownika = p.id_pracownika AND g.liczba_godzin > 160

--6G
SELECT p.imie, p.nazwisko FROM firma.pracownicy p, firma.pensja_stanowisko ps, firma.wynagrodzenie w
WHERE w.id_pracownika = p.id_pracownika AND w.id_pensji = ps.id_pensji AND ps.kwota BETWEEN 1500 AND 3000

--6H i znów musia³em troszkê to rozbudowaæ 
DECLARE @nullGuid uniqueidentifier = NULL
SELECT p.imie, p.nazwisko FROM firma.wynagrodzenie w, firma.pensja_stanowisko ps, firma.godziny g, firma.pracownicy p
WHERE ((@nullGuid IS NULL AND w.id_premii IS NULL) OR (w.id_premii = @nullGuid)) AND ps.id_pensji = w.id_pensji AND ps.kwota > 2000 AND g.id_godziny = w.id_godziny AND g.liczba_godzin > 160
AND p.id_pracownika = w.id_pracownika 
UNION
SELECT p.imie, p.nazwisko FROM firma.premia pr, firma.wynagrodzenie w, firma.pensja_stanowisko ps, firma.godziny g, firma.pracownicy p
WHERE pr.id_premii = w.id_premii AND pr.rodzaj = 'brak' AND ps.id_pensji = w.id_pensji AND ps.kwota > 2000 AND g.id_godziny = w.id_godziny AND g.liczba_godzin > 160
AND p.id_pracownika = w.id_pracownika

--7a
SELECT p.imie, p.nazwisko, ps.kwota FROM firma.pracownicy p, firma.pensja_stanowisko ps, firma.wynagrodzenie w
WHERE w.id_pracownika = p.id_pracownika AND ps.id_pensji = w.id_pensji
ORDER BY ps.kwota ASC

--7B
SELECT p.imie, p.nazwisko, ps.kwota, pr.kwota FROM firma.pracownicy p, firma.pensja_stanowisko ps, firma.wynagrodzenie w, firma.premia pr
WHERE w.id_pracownika = p.id_pracownika AND ps.id_pensji = w.id_pensji AND pr.id_premii = w.id_premii
ORDER BY ps.kwota, pr.kwota DESC

--7C
SELECT ps.stanowisko ,COUNT(*) FROM firma.pracownicy p, firma.wynagrodzenie w, firma.pensja_stanowisko ps
WHERE p.id_pracownika = w.id_pracownika AND w.id_pensji = ps.id_pensji
GROUP BY ps.stanowisko

--7D
SELECT AVG(ps.kwota) AS rednia, MIN(ps.kwota) AS minimum, MAX(ps.kwota) as maksimum FROM firma.pensja_stanowisko ps
WHERE ps.stanowisko = 'FrontEnd'

--7E
SELECT SUM(ps.kwota) AS suma FROM firma.pensja_stanowisko ps, firma.wynagrodzenie w
WHERE w.id_pensji = ps.id_pensji

--7F
SELECT ps.stanowisko, SUM(ps.kwota) AS suma FROM firma.pensja_stanowisko ps, firma.wynagrodzenie w
WHERE w.id_pensji = ps.id_pensji
GROUP BY (ps.stanowisko)

--7G
SELECT ps.stanowisko, COUNT(*) FROM firma.wynagrodzenie w, firma.premia pr, firma.pensja_stanowisko ps
WHERE w.id_premii = pr.id_premii AND ps.id_pensji = w.id_pensji
GROUP BY (ps.stanowisko)

--7h
DELETE firma.pracownicy FROM firma.pracownicy p, firma.wynagrodzenie w, firma.pensja_stanowisko ps, firma.godziny g
WHERE p.id_pracownika = w.id_pracownika AND w.id_pensji = ps.id_pensji AND g.id_godziny = w.id_godziny AND ps.kwota < 1200;

--8a
UPDATE firma.pracownicy 
SET telefon=CONCAT('(+48) ', telefon);

--8b
UPDATE firma.pracownicy 
SET telefon=CONCAT(SUBSTRING(telefon, 1, 9), '-', substring(telefon, 10, 3), '-', substring(telefon, 13, 3));

--8c
select imie, upper(nazwisko) as "nazwisko", adres, telefon 
from firma.pracownicy p
where LEN(p.nazwisko) = (select max(LEN(nazwisko)) from firma.pracownicy);

--8d
select CONVERT(VARCHAR(32), HashBytes('MD5', p.imie), 2) as "imie", 
CONVERT(VARCHAR(32), HashBytes('MD5', p.nazwisko), 2) as "nazwisko", 
CONVERT(VARCHAR(32), HashBytes('MD5', p.adres), 2) as "adres", 
CONVERT(VARCHAR(32), HashBytes('MD5', p.telefon), 2) as "telefon", 
CONVERT(VARCHAR(32), HashBytes('MD5', convert(varchar,convert(decimal(8,2),ps.kwota))), 2) as "pensja" 
from firma.pracownicy p 
join firma.wynagrodzenie w on w.id_pracownika = p.id_pracownika 
join firma.pensja_stanowisko ps on ps.id_pensji = w.id_pensji;

--9
select concat('Pracownik ', p.imie, ' ', p.nazwisko, ', w dniu ', w."data", ' otrzyma³ pensjê ca³kowit¹ na kwotê ', ps.kwota+pr.kwota,'z³, gdzie wynagrodzenie zasadnicze wynosi³o: ', ps.kwota, 'z³, premia: ', pr.kwota, 'z³. Liczba nadgodzin: ') as "raport" 
from firma.pracownicy p join 
firma.wynagrodzenie w on p.id_pracownika = w.id_pracownika 
join firma.pensja_stanowisko ps on ps.id_pensji = w.id_pensji 
join firma.premia pr on pr.id_premii = w.id_premii;







