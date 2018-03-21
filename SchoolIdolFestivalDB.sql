CREATE TABLE Set_carta
(
Nome varchar(20) PRIMARY KEY,
Data_rilascio date
);

CREATE TABLE Gruppo 
( 
Nome varchar(20) PRIMARY KEY
);

CREATE TABLE Subunit 
(
Nome varchar(20) PRIMARY KEY,
Gruppo_appartenenza varchar(20) NOT NULL REFERENCES Gruppo(Nome) on delete cascade 
);

CREATE TABLE School_idol
(
Nome varchar(20),
Cognome varchar(20),
Data_nascita date,
Scuola varchar(20),
Anno_frequenza tinyint,
Gruppo varchar(20) NOT NULL REFERENCES Gruppo(Nome),
Subunit varchar(20) REFERENCES Subunit(Nome),

PRIMARY KEY (Nome, Cognome)
);

CREATE TABLE Carta_giocabile 
(
ID char(5) PRIMARY KEY,
Rappresentazione_grafica BLOB default NULL,
Idolizzata bool NOT NULL default false, 
Liv_max tinyint NOT NULL,
Skill varchar(250),
Attributo varchar(20) NOT NULL,
Rarita varchar(2) NOT NULL,
Center_skill varchar(30),
Stamina tinyint NOT NULL, 
Smile int NOT NULL,
Pure int NOT NULL,
Cool int NOT NULL,
Set_appartenenza varchar(20) REFERENCES Set_carta(Nome) on delete set NULL,
Nome_idol varchar(20) NOT NULL,
Cognome_idol varchar(20) NOT NULL, 

FOREIGN KEY (Nome_idol, Cognome_idol) REFERENCES School_idol(Nome, Cognome)
on delete cascade
on update cascade 
);

CREATE TABLE Carta_supporto
(
ID char(5) PRIMARY KEY,
Rappresentazione_grafica BLOB default NULL,
Skill varchar(250),
Attributo varchar(20) NOT NULL,
Rarita varchar(2) NOT NULL,
Set_appartenenza varchar(20) REFERENCES Set_carta(Nome) on delete set NULL,
Nome varchar(20) NOT NULL
);

CREATE TABLE Album
(
Titolo varchar(20) PRIMARY KEY,
Data_rilascio date
);

CREATE TABLE Canzone
(
Titolo varchar(20) PRIMARY KEY, 
Data_rilascio date,
Durata varchar(20), 
Attributo varchar(20),
Album varchar(20) REFERENCES Album(Titolo) on delete set NULL
);

CREATE TABLE Interpretazione_solista
(
Nome_idol_solista varchar(20),
Cognome_idol_solista varchar(20),
Canzone varchar(20) REFERENCES Canzone(Titolo) on delete cascade,

PRIMARY KEY (Nome_idol_solista, Cognome_idol_solista, Canzone), 
FOREIGN KEY (Nome_idol_solista, Cognome_idol_solista) REFERENCES School_idol(Nome, Cognome) on delete cascade
);

CREATE TABLE Interpretazione_gruppo
(
Gruppo varchar(20) REFERENCES Gruppo(Nome) on delete cascade,
Canzone varchar(20) REFERENCES Canzone(Titolo) on delete cascade,

PRIMARY KEY (Gruppo, Canzone)
);

CREATE TABLE Interpretazione_subunit
(
Subunit varchar(20) REFERENCES Subunit(Nome) on delete cascade,
Canzone varchar(20) REFERENCES Canzone(Titolo) on delete cascade,

PRIMARY KEY (Subunit, Canzone)
);

CREATE TABLE Evento
(
Nome varchar(20) PRIMARY KEY,
Tipologia varchar(20),
Data_inizio date,
Data_fine date,
Stato_evento varchar(10) NOT NULL CHECK (Stato_evento in ('Passato', 'Presente', 'Futuro')),
Carta_premio char(5) NOT NULL REFERENCES Carta_giocabile(ID),
Punteggio_vincita int
);

CREATE TABLE Canzoni_evento
(
Evento varchar(20) REFERENCES Evento(Nome) on delete cascade,
Canzone varchar(20) REFERENCES Canzone(Titolo) on delete cascade,

PRIMARY KEY (Evento, Canzone)
);




DELIMITER ||

CREATE TRIGGER Controllo_attributi
BEFORE INSERT ON Carta_giocabile
FOR EACH ROW
BEGIN
if(NEW.Attributo = 'Smile') THEN
if(new.Smile < new.Cool OR new.Smile < new.Pure )THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT ='SMILE minore di PURE o COOL';
END IF;
END IF;
if(NEW.Attributo = 'Cool') THEN
if(new.Cool < new.Smile OR new.Cool < new.Pure )THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT ='COOL minore di PURE o SMILE';
END IF;
END IF;
if(NEW.Attributo = 'Pure') THEN
if(new.Pure < new.Smile OR new.Pure < new.Cool )THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT ='PURE minore di COOL o SMILE';
END IF;
END IF;
END || 


CREATE TRIGGER Riempi_statoevento
BEFORE INSERT ON Evento
FOR EACH ROW
BEGIN
IF(new.Data_fine < CURDATE()) THEN
SET new.Stato_evento = 'Passato';
END IF;
IF(new.Data_inizio <= CURDATE() AND new.Data_fine >= CURDATE()) THEN
SET new.Stato_evento = 'Presente'; 
END IF;
IF(new.Data_inizio > CURDATE()) THEN 
SET new.Stato_evento = 'Futuro';
END IF;
END || 

DELIMITER ; 



INSERT INTO Set_carta(Nome, Data_rilascio) VALUES
('Seven Lucky Gods', 20151215),
('Valentines Set', 20160114), 
('White Day Set', 20160215), 
('Job Set part2', 20160317), 
('Cyber Set', 20160414),
('Marine Set', 20160610),
('Pool Set', 20160703), 
('Parents', 20160724),
('Animal ver2', 20160801),
('Victorian Set', 20160825),
('Christmas Set', 20131201),
('Bokura wa', 20150415),
('Snow Halation', 20150615), 
('Wonderful Rush', 20170131), 
('Rainy Season ver', 20160619),
('Initial', 20130512), 
('Job set part1', 20130715),
('Animal ver1', 20130814), 
('August Set', 20131010), 
('New Year Set', 20140101), 
('Fruit Set', 20141121),
('Maid Set', 20151010),
('Beach', 20140626);

INSERT INTO Gruppo (Nome) VALUES
('Muse'), 
('Aqours'), 
('Arise'),
('Wild Cats'), 
('Happy Children');

INSERT INTO Subunit (Nome, Gruppo_appartenenza) VALUES
('Lily White', 'Muse'),
('Printemps', 'Muse'), 
('BiBi', 'Muse'), 
('Azalea', 'Aqours'),
('CYaRon', 'Aqours'), 
('Guilty Kiss', 'Aqours'),
('Supersonicat', 'Wild Cats');

INSERT INTO School_idol (Nome, Cognome, Data_nascita, Scuola, Anno_frequenza, Gruppo, Subunit) VALUES
('Rin', 'Hoshizora', 19991101, 'Otonokizaka High', 1, 'Muse', 'Lily White'), 
('Hanayo', 'Koizumi', 19990117, 'Otonokizaka High', 1, 'Muse', 'Printemps'),
('Umi', 'Sonoda', 19980315, 'Otonokizaka High', 2, 'Muse', 'Lily White'),
('Maki', 'Nishikino', 19990419, 'Otonokizaka High', 1, 'Muse', 'BiBi'), 
('Eli', 'Ayase', 19971021, 'Otonokizaka High', 3, 'Muse', 'BiBi'),
('Honoka', 'Kosaka', 19980803, 'Otonokizaka High', 2, 'Muse', 'Printemps'),
('Kotori', 'Minami', 19980912, 'Otonokizaka High', 2, 'Muse', 'Printemps'),
('Nozomi', 'Tojo', 19970609, 'Otonokizaka High', 3, 'Muse', 'Lily White'), 
('Nico', 'Yazawa', 19970702, 'Otonokizaka High', 3, 'Muse', 'BiBi'),
('Ruby', 'Kurosawa', 19990921, 'Uranoakaoshi High', 1, 'Aqours', 'CYaRon'),
('Yoshiko', 'Tsushima', 19980713, 'Uranoakaoshi High', 2, 'Aqours', 'Guilty Kiss'),
('Hanamaru','Kunikida', 19990303, 'Uranoakaoshi High', 1, 'Aqours', 'Azalea'),
('Ryou', 'Ayakawa', 19970506, 'Touhou Academy', 3, 'Wild Cats', NULL),
('Yurii', 'Midou', 19981225, 'Shinomome', 2, 'Happy Children', NULL),
('Christina', 'Sista', 19990912, 'Touhou Academy', 3, 'Wild Cats', 'Supersonicat'), 
('Shun', 'Kurosaki', 19981125, 'Touhou Academy', 1, 'Wild Cats', 'Supersonicat'),
('Kira', 'Tsubasa', 19970721, 'UTX', 3, 'Arise', NULL),
('Elena', 'Toudou', 19970801, 'UTX', 3, 'Arise', NULL),
('Yuki', 'Anjou', 19971121, 'UTX', 3, 'Arise', NULL),
('Konoe', 'Kanata', 19991216, 'Shinomome', 1, 'Happy Children', NULL);


INSERT INTO Carta_giocabile (ID, Idolizzata, Liv_max, Skill, Attributo, Rarita, Center_skill, Stamina, Smile, Pure, Cool, Set_appartenenza, Nome_idol, Cognome_idol) VALUES
('0031b', 0, 40, 'Ogni 10 secondi dà la possibilità del 36% di aumentare il tuo punteggio di 200', 'Smile', 'R', 'Smile Power', 3, 2580, 1280, 1600, 'Beach', 'Umi', 'Sonoda'), 
('0031i', 1, 60, 'Ogni 8 secondi dà la possibilità del 36% di aumentare il tuo punteggio di 250', 'Smile', 'R', 'Smile Power', 4, 3350, 2050, 2370, 'Beach', 'Umi', 'Sonoda'),
('0043b', 0, 40, 'C è la possibilità del 36% che la tua Stamina aumenti di 1 quando arrivi ad una combo di 17 note', 'Pure', 'R', 'Pure Power', 3, 1020, 3100, 1280, 'Maid Set', 'Nozomi', 'Tojo'),
('0043i', 1, 60, 'C è la possibilità del 36% che la tua Stamina aumenti di 1 quando arrivi ad una combo di 15 note', 'Pure', 'R', 'Pure Power', 4, 1790, 3870, 2050, 'Maid Set', 'Nozomi', 'Tojo'), 
('0049b', 0, 40, 'Possibilità del 36% di aumentare il punteggio di 200 dopo 15 Perfect', 'Cool', 'R', 'Cool Power', 3, 1390, 1020, 2900, 'Wonderful Rush', 'Umi', 'Sonoda'),
('0049i', 1, 60, 'Possibilità del 36% di aumentare il punteggio di 249 dopo 15 Perfect', 'Cool', 'R', 'Cool Power', 4, 2160, 1790, 3670, 'Wonderful Rush', 'Umi', 'Sonoda'),
('0268b', 0, 30, NULL, 'Pure', 'N', NULL, 3, 300, 1520, 560, NULL, 'Yurii', 'Midou'), 
('0268i', 1, 40, NULL, 'Pure', 'N', NULL, 4, 490, 1900, 800, NULL, 'Yurii', 'Midou'),
('0287b', 0, 30, NULL, 'Cool', 'N', NULL, 2, 320, 410, 1620, NULL, 'Shun', 'Kurosaki'),
('0287i', 1, 40, NULL, 'Cool', 'N', NULL, 3, 390, 480, 1920, NULL, 'Shun', 'Kurosaki'),
('0284b', 0, 40,'Ogni 20 note c è la possibilità del 36% che il timing rallenti', 'Smile', 'R', 'Smile Power', 3, 3240, 1290, 1020, 'Bokura wa', 'Honoka', 'Kosaka'),
('0284i', 1, 60, 'Ogni 15 note c è la possibilità del 36% che il timing rallenti', 'Smile', 'R', 'Smile Power', 4, 4010, 2060, 1790, 'Bokura wa', 'Honoka', 'Kosaka'),
('0286b', 0, 40, 'Ogni 20 note c è il 36% di probabilità che il tuo punteggio aumenti di 220', 'Pure', 'R', 'Pure Power', 3, 1040, 3250, 1260, 'Bokura wa', 'Kotori', 'Minami'),
('0286i', 1, 60, 'Ogni 20 note c è il 36% di probabilità che il tuo punteggio aumenti di 250', 'Pure', 'R', 'Pure Power', 4, 1810, 4020, 2030, 'Bokura wa', 'Kotori', 'Minami'), 
('0441b', 0, 60, 'Ogni 11 secondi c è la possibilità di recuperare 4 punti stamina', 'Cool', 'SR', 'Cool Heart', 3, 2620, 2470, 3800, 'Christmas Set', 'Rin', 'Hoshizora'),  
('0441i', 1, 80, 'Ogni 10 secondi c è la possibilità di recuperare 4 punti stamina', 'Cool', 'SR', 'Cool Heart', 4, 3730, 3580, 4910, 'Christmas Set', 'Rin', 'Hoshizora'),
('0753b', 0, 30, NULL, 'Smile', 'N', NULL, 3, 1560, 450, 320, 'White Day Set', 'Konoe', 'Kanata'), 
('0753i', 1, 40, NULL, 'Smile', 'N', NULL, 4, 1950, 560, 450, 'White Day Set', 'Konoe', 'Kanata'),
('0802b', 0, 40, 'Ogni 10 secondi dà la possibilità del 36% di aumentare il tuo punteggio di 200', 'Pure', 'R', 'Pure Power', 3, 1400, 2340, 1630, 'Rainy Season ver', 'Ruby', 'Kurosawa'),
('0802i', 1, 60, 'Ogni 10 secondi dà la possibilità del 36% di aumentare il tuo punteggio di 250', 'Pure', 'R', 'Pure Power', 4, 1560, 4030, 1830, 'Rainy Season ver', 'Ruby', 'Kurosawa'),
('0803b', 0, 60, 'Ogni 15 note c è la possibilità di aumentare il tuo punteggio di 400', 'Cool', 'SR', 'Cool Heart', 3, 2500, 2750, 3600, 'Rainy Season ver', 'Hanamaru', 'Kunikida'),
('0803i', 1, 80, 'Ogni 15 note c è la possibilità di aumentare il tuo punteggio di 450', 'Cool', 'SR', 'Cool Heart', 4, 2810, 3100, 4850, 'Rainy Season ver', 'Hanamaru', 'Kunikida'),
('0804b', 0, 60, 'Ogni 10 note c è la possibilità del 36% che il timing rallenti', 'Smile', 'SR', 'Smile Power', 3, 3120, 1450, 2020, 'Rainy Season ver', 'Yoshiko', 'Tsushima'),
('0804i', 1, 80, 'Ogni 8 note c è la possibilità del 36% che il timing rallenti', 'Smile', 'SR', 'Smile Power', 4, 3920, 1950, 2420, 'Rainy Season ver', 'Yoshiko', 'Tsushima'),
('0349b', 0, 80, 'Ogni 22 perfetti c è il 35% di possibilità che il punteggio aumenti di 590', 'Smile', 'UR', 'Smile Princess', 4, 5000, 4305, 3620, 'Seven Lucky Gods', 'Kira', 'Tsubasa'),
('0349i', 1, 100, 'Ogni 20 perfetti c è il 35% di possibilità che il punteggio aumenti di 600', 'Smile', 'UR', 'Smile Princess', 4, 5420, 4630, 3910, 'Seven Lucky Gods', 'Kira', 'Tsubasa'),
('0350b', 0, 80, 'Ogni 17 perfect il timing rallenta per 3 secondi', 'Cool', 'UR', 'Cool Princess', 4, 3640, 4230, 5010, 'Victorian Set', 'Elena', 'Toudou'),
('0350i', 1, 100, 'Ogni 15 perfect il timing rallenta per 3 secondi', 'Cool', 'UR', 'Cool Princess', 4, 3900, 4750, 5520, 'Victorian Set', 'Elena', 'Toudou'),
('0351b', 0, 80, 'Ogni 20 secondi c è la possibilità del 10% di recuperare tutta la stamina', 'Pure', 'UR', 'Pure Princess', 4, 3450, 4520, 3120, 'Valentines Set', 'Yuki', 'Anjou'),
('0351i', 1, 100, 'Ogni 15 secondi c è la possibilità del 20% di recuperare tutta la stamina', 'Pure', 'UR', 'Pure Princess', 4, 3740, 5310, 3850, 'Valentines Set', 'Yuki', 'Anjou'); 


INSERT INTO Carta_supporto( ID, Rappresentazione_grafica, Skill, Attributo, Rarita, Set_appartenenza, Nome) VALUES 
('0070', NULL, 'Dà la possibilità di rafforzare di poco la skill di una carta Smile', 'Smile', 'R', 'Animal ver2', 'Alpaca'), 
('0156', NULL, 'Dà la possibilità di rafforzare di molto la skill di una carta Pure', 'Pure', 'SR', NULL, 'Yazawa Cotaro'), 
('0157', NULL, 'Dà la possibilità di rafforzare di molto la skill di una carta Cool', 'Cool', 'SR', 'Parents', 'Nicos Mom'), 
('0620', NULL, 'Dà la possibilità di rafforzare di poco la skill di una carta Smile', 'Smile', 'R', 'Parents', 'Honokas Father'); 

INSERT INTO Album(Titolo, Data_rilascio) VALUES
('Snow Halation', 20131101), 
('Egao de Jump', 20140602), 
('BiBi Hits', 20160909),
('Private Wars', 20130914);

INSERT INTO Canzone(Titolo, Data_rilascio, Durata, Attributo, Album) VALUES 
('Private Wars', 20130914, '3:12 minuti', 'Cool', 'Private Wars'), 
('Start Dash', 20131112, '4:00 minuti', 'Smile', NULL),
('Dance! Dance!', 20140602, '2:50 minuti', 'Smile', 'Egao de Jump'), 
('My demons', 20151109, '1:49 minuti', 'Cool', NULL),
('Cutie Panther', 20140807, '2:58 minuti', 'Smile', 'BiBi Hits'), 
('Heartbeat', 20160421, '3:37 minuti', 'Cool', 'BiBi Hits'), 
('Soldier!!', 20160909, '4:15 minuti', 'Cool', 'BiBi Hits'), 
('Mystery', 20131101, '5:10 minuti', 'Pure', 'Snow Halation'),
('Love Novels', 20150603, '3:05 minuti', 'Pure', NULL), 
('Loneliest Baby', 20131017, '1:57 minuti', 'Cool', 'Snow Halation'),
('Rin Rin Rin', 20140902, '1:03 minuti', 'Smile', NULL), 
('Angelic Angel', 20130202, '2:05 minuti', 'Pure', NULL);


INSERT INTO Interpretazione_solista(Nome_idol_solista, Cognome_idol_solista, Canzone) VALUES 
('Rin', 'Hoshizora', 'Rin Rin Rin'), 
('Rin', 'Hoshizora', 'Mystery'), 
('Ruby', 'Kurosawa', 'Dance! Dance!'),
('Yuki', 'Anjou', 'Loneliest Baby'), 
('Christina', 'Sista', 'Gregorian'), 
('Eli', 'Ayase', 'Love Crime'), 
('Hanayo', 'Koizumi', 'Love Rice'), 
('Kotori','Minami', 'Happy'),
('Umi', 'Sonoda', 'Ocean'), 
('Nico','Yazawa', 'iSuck'), 
('Maki', 'Nishikino', 'Red'), 
('Honoka', 'Kosaka', 'Bread'), 
('Nozomi', 'Tojo', 'Wish'),
('Nozomi', 'Tojo', 'Prestige'),
('Yoshiko', 'Tsushima','Yohane'), 
('Elena', 'Toudou','TheBest'), 
('Konoe','Kanata', 'UfoBaby');

INSERT INTO Interpretazione_gruppo(Gruppo, Canzone) VALUES
('Muse', 'Start Dash'), 
('Wild Cats', 'My Demons'), 
('Arise', 'Private Wars'), 
('Muse', 'Love Novels'); 

INSERT INTO Interpretazione_subunit(Subunit, Canzone) VALUES
('BiBi', 'Cutie Panther'), 
('BiBi', 'Heartbeat'),
('BiBi', 'Soldier!!'),
('Supersonicat', 'Angelic Angel');


INSERT INTO Evento(Nome, Tipologia, Data_inizio, Data_fine, Carta_premio, Punteggio_vincita) VALUES
('Kunikuni Summer', 'Score Match', 20160619, 20160629, '0803i', 25000),
('I wanna see you', 'Medley', 20131201, 20131212, '0441i', 22000), 
('Rainbrella', 'Challenge Festival', 20160705, 20160716, '0804i', 24500),
('Bachelor Match', 'Token', 20160909, 20160920, '0351b', 11000),
('LL Sunshine', 'Medley', 20160810, 20160818, '0031b', 23000);

INSERT INTO Canzoni_evento(Evento, Canzone) VALUES
('Kunikuni Summer', 'Start Dash'), 
('Kunikuni Summer', 'My Demons'), 
('Kunikuni Summer', 'Love Novels'), 
('I wanna see you', 'My Demons'), 
('I wanna see you', 'Private Wars'), 
('I wanna see you', 'Angelic Angel'), 
('I wanna see you', 'Rin Rin Rin'),
('I wanna see you', 'Mystery'),
('Rainbrella', 'Cutie Panther'), 
('Rainbrella', 'Soldier!!'), 
('Rainbrella', 'Rin Rin Rin'),
('Bachelor Match', 'Mystery'),
('Bachelor Match', 'Heartbeat'), 
('Bachelor Match', 'Dance! Dance!'),
('Bachelor Match', 'My Demons'), 
('LL Sunshine', 'UfoBaby'),
('LL Sunshine', 'Prestige'); 


CREATE VIEW Query1 (Canzone, Album, Evento) AS
SELECT	c.Titolo, a.Titolo, ce.Evento
FROM Album a RIGHT JOIN Canzone c ON a.Titolo = c.Album 
JOIN Canzoni_evento ce ON c.Titolo = ce.Canzone 
JOIN Interpretazione_subunit i ON c.Titolo=i.Canzone
JOIN Subunit s on i.Subunit=s.Nome
WHERE s.Gruppo_appartenenza='Muse' AND YEAR(c.Data_rilascio) = 2016; 


CREATE VIEW Idol_Song_Medley(Nome_idol,Cognome_idol, Numero_canz) AS
SELECT School_idol.Nome, School_idol.Cognome, count(*)
FROM School_idol, Interpretazione_solista, Canzoni_evento, Evento
WHERE School_idol.Nome = Interpretazione_solista.Nome_idol_solista
AND School_idol.Cognome = Interpretazione_solista.Cognome_idol_solista
AND Interpretazione_solista.Canzone = Canzoni_evento.Canzone
AND Canzoni_evento.Evento = Evento.Nome
AND Evento.Tipologia = "Medley"
GROUP BY School_idol.Nome, School_idol.Cognome; 


CREATE VIEW Query2 (Nome_idol, Cognome_idol, Gruppo_di_appartenenza) as 

SELECT School_idol.Nome, School_idol.Cognome,Gruppo.Nome
FROM School_idol JOIN Gruppo on School_idol.Gruppo = Gruppo.Nome
WHERE School_idol.Nome not in (SELECT Nome_idol_solista FROM Interpretazione_solista) AND Cognome not in (SELECT Cognome_idol_solista FROM Interpretazione_solista)
UNION
SELECT SI.Nome,SI.Cognome,G.Nome
FROM School_idol SI, Gruppo G, Carta_giocabile CG, Set_carta S
WHERE SI.Gruppo = G.Nome
AND CG.Nome_idol = SI.Nome
AND  CG.Cognome_idol = SI.Cognome
AND CG.Set_appartenenza = S.Nome
AND S.Data_rilascio < 20141225
AND EXISTS (
SELECT* 
FROM Idol_Song_Medley ISM 
WHERE ISM.Nome_idol = SI.Nome AND ISM.Cognome_idol = SI.Cognome AND  Numero_canz >= 2)
;


DELIMITER || 
CREATE FUNCTION Media_attributi(NomeIdol varchar(20),CognomeIdol varchar(20),Stat varchar(20))
RETURNS decimal(6,2) 
BEGIN
DECLARE media decimal(6,2);
IF(Stat ='Smile') THEN
SELECT avg(Smile) into media
FROM Carta_giocabile
WHERE Nome_idol = NomeIdol && Cognome_idol = CognomeIdol;
END IF;
IF(Stat ='Cool') THEN
SELECT avg(Cool) into media
FROM Carta_giocabile
WHERE Nome_idol = NomeIdol && Cognome_idol = CognomeIdol;
END IF;
IF(Stat ='Pure') THEN
SELECT avg(Pure) into media
FROM Carta_giocabile
WHERE Nome_idol = NomeIdol && Cognome_idol = CognomeIdol;
END IF;
RETURN media;
END || 



CREATE FUNCTION Carta_maggiore(statistica varchar(20), valore varchar(20))
RETURNS char(5)
BEGIN
DECLARE Best char(5);
IF(statistica = "Smile") THEN
SELECT ID into Best
FROM Carta_giocabile
WHERE Smile = (SELECT MAX(Smile) FROM School_idol) AND Rarita = valore 
LIMIT 1;
END IF;
IF(statistica = "Cool") THEN
SELECT ID into Best
FROM Carta_giocabile
WHERE Cool = (SELECT MAX(Cool) FROM School_idol) AND Rarita = valore
LIMIT 1;
END IF;
IF(statistica = "Pure") THEN
SELECT ID into Best
FROM Carta_giocabile
WHERE Pure = (SELECT MAX(Pure) FROM School_idol) AND Rarita = valore
LIMIT 1;
END IF;
RETURN Best;
END || 


CREATE PROCEDURE ModificaStat_percentuale(idCarta char(5), attributo varchar(20), percentuale int)
BEGIN
IF(attributo = "Smile") THEN
UPDATE Carta_giocabile
SET Smile = Smile +  (Smile*percentuale)/100
WHERE ID = idCarta;
END IF;
IF(attributo = "Cool") THEN
UPDATE Carta_giocabile
SET Cool = Cool +  (Cool*percentuale)/100
WHERE ID = idCarta;
END IF;
IF(attributo = "Pure") THEN
UPDATE Carta_giocabile
SET Pure = Pure +  (Pure*percentuale)/100
WHERE ID = idCarta; 
END IF;
END||


DELIMITER ;


