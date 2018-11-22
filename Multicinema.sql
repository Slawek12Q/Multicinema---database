
--Multikino 
If OBJECT_ID ('dbo.Multikino') IS NOT NULL 
Drop Table dbo.Multikino
Go
Create Table Multikino (
id_multikina		integer Primary Key not null,
nazwa				nvarchar(50),
adres				nvarchar (100),
telefon				char(12),
wlasciciel			nvarchar(50),
e_mail				nvarchar(20),
opis				text 
)

--etaty
If OBJECT_ID ('dbo.Etaty') IS NOT NULL 
Drop Table dbo.Etaty
Go
create table Etaty (
id_etatu 			int not null Primary Key,
nazwa				nvarchar(20) not null,
minimalna_pensja	real not null, 
maksymalna_pensja	real not null,
maksymalna_premia_proc	integer
 	
)

--pracownicy
If OBJECT_ID ('dbo.Pracownicy') IS NOT NULL 
Drop Table dbo.Pracownicy
Go
Create table Pracownicy (
id_pracownika   integer Primary Key not null IDENTITY,
id_multikina	integer  not null,
id_etatu		integer not null, 
imie			nvarchar(20) not null,
nazwisko		nvarchar (20) not null,
pesel			char(11) not null,
pensja			real not null,
Constraint pk_etatu 
Foreign Key (id_etatu) References Etaty(id_etatu) ON DELETE CASCADE ON UPDATE CASCADE,
Constraint			pk_multikina
Foreign Key	(id_multikina) References Multikino (id_multikina) ON DELETE CASCADE ON UPDATE CASCADE

)

--sala 

If OBJECT_ID ('dbo.Sala') IS NOT NULL 
Drop Table dbo.Sala
Go
create table Sala (
id_sali 			int not null Primary Key,
ilosc_rzedow		integer not null,
miejsca_w_rzedzie 	integer not null,
id_multikina		integer,
Constraint			pk_sali
Foreign Key	(id_multikina) References Multikino (id_multikina) 	ON DELETE CASCADE ON UPDATE CASCADE
)



--technologia 
If OBJECT_ID ('dbo.Technologia') IS NOT NULL 
Drop Table dbo.Technologia
Go
create table Technologia(
id_technologii		int not null Primary Key,
opis 				nvarchar(10) not null
)

--gatunek 
If OBJECT_ID ('dbo.Gatunki') IS NOT NULL 
Drop Table dbo.Gatunki
Go
create table Gatunki (
id_gatunku		int not null PRIMARY KEY,
opis			text not null, 
dozwolony_od_lat integer not null
) 


--filmy 
If OBJECT_ID ('dbo.Filmy') IS NOT NULL 
Drop Table dbo.Filmy 
Go
create table Filmy (
id_filmu		int not null Primary Key IDENTITY,
id_gatunku		integer not null,
nazwa			nvarchar(50) not null,
grany_od		date not null,
Constraint pk_gatunku 
FOREIGN Key (id_gatunku) References Gatunki(id_gatunku) ON DELETE CASCADE ON UPDATE CASCADE
)


--klienci 
If OBJECT_ID ('dbo.Klienci') IS NOT NULL 
Drop Table dbo.Klienci
Go
create table Klienci (
id_klienta 		int not null Primary Key IDENTITY,
imie 			nvarchar(20) not null,
nazwisko 		nvarchar(20) not null,
wiek			integer
)

--Rodzaje zywnosci
If OBJECT_ID ('dbo.RodzajeZywnosci') IS NOT NULL 
Drop Table dbo.RodzajeZywnosci
Go
Create Table RodzajeZywnosci (
id_rodzaju		integer not null Primary Key  IDENTITY,
nazwa			nvarchar(30) not null
)

--bufet 
If OBJECT_ID ('dbo.Bufet') IS NOT NULL 
Drop Table dbo.Bufet
Go
create table Bufet(
id_produktu		int not null Primary Key IDENTITY,
id_rodzaju		integer not null,
produkt 		nvarchar(25) not null,
cena			real not null
Constraint pk_rodzaju 
Foreign Key (id_rodzaju) References RodzajeZywnosci(id_rodzaju) ON DELETE CASCADE ON UPDATE CASCADE
)



--zamowienia 
If OBJECT_ID ('dbo.Zamowienia') IS NOT NULL 
Drop Table dbo.Zamowienia
Go
create table Zamowienia(
id_klienta 		integer not null,
id_produktu		integer not null,
ilosc			integer not null,
Constraint  	pk_klienta 
Foreign Key	(id_klienta) REFERENCES Klienci(id_klienta) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT		pk_produktu 
Foreign KEY	(id_produktu) references Bufet(id_produktu) ON DELETE CASCADE ON UPDATE CASCADE,
Constraint pk_zamowienia1 Primary Key (id_klienta, id_produktu)	
)


--Aktualnie grane filmy
If OBJECT_ID ('dbo.AktualnieGraneFilmy') IS NOT NULL 
Drop Table dbo.AktualnieGraneFilmy
Go
create table AktualnieGraneFilmy(
id_granego_filmu	int not null Primary Key IDENTITY,
id_filmu			integer not null,
id_technologii		integer not null,
grany_do			date not null,
cena 				real not null,
Constraint pk_filmu1 
Foreign Key (id_filmu) References Filmy (id_filmu) ON DELETE CASCADE ON UPDATE CASCADE,
Constraint pk_tech1 
Foreign Key (id_technologii) References Technologia (id_technologii) ON DELETE CASCADE ON UPDATE CASCADE
)

--Godziny seansow
If OBJECT_ID ('dbo.GodzinySeansow') IS NOT NULL 
Drop Table dbo.GodzinySeansow
Go
create table  GodzinySeansow(
id_godziny		integer not null Primary Key,
godzina_seasu	time not null
)

--seanse 
If OBJECT_ID ('dbo.Seanse') IS NOT NULL 
Drop Table dbo.seanse
Go
create table Seanse (
id_seansu			integer not null Primary Key IDENTITY,
id_granego_filmu	integer not null,
id_godziny			integer not null,
id_sali				integer not null,
Constraint pk1_seansu 
Foreign Key (id_granego_filmu) References AktualnieGraneFilmy (id_granego_filmu)
ON DELETE CASCADE ON UPDATE CASCADE,
Constraint pk2_seansu 
Foreign Key (id_godziny) References GodzinySeansow (id_godziny) ON DELETE CASCADE ON UPDATE CASCADE,
Constraint pk3_seansu 
Foreign Key (id_sali) References Sala (id_sali) ON DELETE CASCADE ON UPDATE CASCADE
) 


--bilety
If OBJECT_ID ('dbo.Bilety') IS NOT NULL 
Drop Table dbo.Bilety
Go
create table Bilety (
id_seansu		 	integer not null,
id_klienta			integer not null,
ilsoc				integer not null,
Constraint 		pk_seansu
Foreign Key (id_seansu) References Seanse(id_seansu) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT		pk1_klienta
Foreign KEY	(id_klienta) References Klienci (id_klienta) ON DELETE CASCADE ON UPDATE CASCADE,
Constraint pk_Biletu Primary Key (id_seansu, id_klienta)
)

--historia przychodu 
If OBJECT_ID ('dbo.HistoriaPrzychodu') IS NOT NULL 
Drop Table dbo.HistoriaPrzychodu
Go
create table HistoriaPrzychodu (
id			integer primary Key identity,
data		date not null, 
przychod_seanse	real not null,
przychod_bufet	real not null
)


Insert Into HistoriaPrzychodu Values 
  ('2017-02-07', 23020, 1200),
  ('2017-02-08', 12345, 900)


Insert Into Klienci Values
('Andrzej', 'Podgorny', 32),
( 'Stefan', 'Kwita', 24),
('Weronika', 'Pyl', 61),
('Lukasz', 'Natanek', 17),
('Michal', 'Czerstwy', 19),
('Bozena', 'Dych', 43)


Insert Into Multikino Values
 (1,'Czar Prysl', 'Krakow ul. Pawia 12', '+48 12307465', 'Jerzy Zamoyski', 'kontakt@tyzg.pl', 
 'Kino Czrl Prys to pierwsze w Polsce i jedno z pierwszych na swiecie kin oferujaych niezwykle efekty 5d praktycznie dla kazdego filmu 
 przyjdz do nas a nic juz nie bedzie takie samo')

Insert Into Sala Values 
(1, 4, 5,1),
(2, 3, 4,1 )
 
 

Insert Into Technologia Values
(1, '2d'),
(2, '3d'),
(3, '4d'),
(4, '4dx'),
(5, '5d') 

Insert Into RodzajeZywnosci Values
('napoje'),
('przekaski'),
('slodycze')



Insert Into Bufet Values
(1, 'Duza_cola', 12),
(1, 'Mala_cola', 7),
(2, 'Duzy_popcorn', 20),
(2, 'Maly_popcorn', 12),
(1, 'Woda', 7),
(2, 'Nachos', 16),
(3, 'Czekolada', 6),
(3, 'Batonik', 3)



Insert Into Zamowienia Values
(1, 2, 1),
(1, 3, 1),
(2, 5, 1),
(3, 6, 2),
(3, 1, 2),
(3, 3, 1),
(5, 5, 1),
(6, 4, 1)

 
 Insert Into etaty Values 
 (1, 'Kasjer', 2000, 3000, 20),
 (2, 'Sprzataczka', 1400, 1900, 20),
 (3, 'Sprzedawca',2000, 2800, 20),
 (4, 'Technik', 3000, 6000, 120),
 (5, 'Meneger', 8000, 10000, 90)  

 Insert Into Pracownicy Values 
 ( 1, 1,  'Anna', 'Byt', 90111112264, 2300),
 (1, 1,  'Mikolaj' , 'Miekki', 85101712272, 2500),
 (1, 2, 'Elzbieta', 'Zarzeczna', 70123012262, 1600),
 (1, 2, 'Weronika', 'Stoklosa', 75012323476, 1400),
 (1, 3, 'Lukasz', 'Zagrurny', 92031412247, 2200),
 (1, 4, 'Sywester', 'Maly', 88042612272, 3600),
 (1, 5, 'Johan', 'Smith', 58081971120, 9000),
 (1, 3, 'Weronika', 'Balamut', 96022954781, 2000),
 (1, 2, 'Stefan', 'Olszanksi', 60073014492, 1600)  

 Insert Into Gatunki Values 
 (1, 'Animacja', 3),
 (2, 'Thriller', 16),
 (3, 'Horror', 21),
 (4, 'Akcja', 12),
 (5, 'Rodzinny', 6)

 
 Insert Into Filmy Values
 (1, 'Zwierzogrod' ,'2017-02-20'),
 (5, 'Zwierzogrod' , '2017-02-20'),
 (3, 'Dzien Sadu' , '2017-01-01'),
 (4, 'Bardzo Szybcy i Wsciekli', '2017-01-10'),
 (2, 'Dawno Temu w Indiach', '2017-02-01'),
 (4, 'Dawno Temu w Indiach', '2017-02-01')

 Insert Into AktualnieGraneFilmy Values
 (3, 5, '2017-03-01', 60),
 (3, 1, '2017-03-01', 15),
 (4, 2, '2017-04-01', 25),
 (5, 3, '2017-02-28', 30),
 (5, 4, '2017-02-28', 35)


 Insert Into GodzinySeansow Values
 (1, '9:00'),
 (2, '14:00'),
 (3, '20:00')


 Insert Into Seanse Values
 (1, 1, 1),
 (1, 2, 1),
 (2, 3, 1),
 (4, 1, 2),
 (3, 2, 2),
 (5, 3, 2)


 Insert Into Bilety Values
 (1, 1, 2),
 (2, 2, 1),
 (6, 3, 4),
 (4, 4, 2),
 (1, 5, 1),
 (3, 6, 2)



create trigger b_technologii ON Technologia 
After Delete 
AS 
RollBack 
Raiserror ('Nie mozna kasowac danych z tej tabeli', 16 ,1 )
Go


create trigger T_gatunki ON Gatunki
After Delete 
AS 
RollBack 
Raiserror ('Nie mozna kasowac danych z tej tabeli', 16 ,1 )
Go

create trigger T_rodzajezywnosci On RodzajeZywnosci
After Delete 
As
Rollback
Raiserror ('Nie mozna kasowac danych z tej tabeli', 16 ,1 )
Go

--sprawdzamy czy pesja danego pracownika miesci w naszych normach

CREATE TRIGGER t1 ON Pracownicy
FOR INSERT
AS
DECLARE @sal integer,
@min real, @max real, @id integer
SELECT @sal = pensja FROM inserted
select @id = id_etatu From inserted
Set @min = (select minimalna_pensja from etaty where @id=id_etatu)
Set @max = (select maksymalna_pensja from etaty where @id=id_etatu)

IF @sal < @min or @sal > @max   
BEGIN
	ROLLBACK
	RAISERROR('Pensja nie mieszczaca sie przewidzianym przedziale dla danego etatu', 1, 2 )
END

--blokujemy mozliwosc sprzedawnia wiecej biletow niz pomiesci sala
create Trigger PelnaSala ON Bilety
FOR Insert 
AS 
DECLARE 
@id_seansu	integer, 
@id_sali	integer,
@wielkosc	integer
Select @id_seansu = id_seansu from inserted
set @id_sali=(select id_sali from Seanse where id_seansu=@id_seansu)
set @wielkosc=(select ilosc_rzedow*miejsca_w_rzedzie from sala where id_sali=@id_sali)
IF @wielkosc < (select sum(ilsoc) from bilety where id_seansu=@id_seansu) 
BEGIN
	ROLLBACK
	RAISERROR('Sala jest juz pelna, przykro nam', 1, 2 )
END

--sprawdzamy czy nasz klient ma wystarczajaca ilosc lat

Create Trigger OgraniczenieWiekowe ON Bilety
FOR INSERT 
AS 
Declare 
@wiek_K integer,
@od_lat integer,
@id_klienta integer, 
@id_seansu integer,
@id_granego_filmu integer,
@id_filmu integer
Select @id_klienta=id_klienta from inserted
Select @id_seansu=id_seansu from inserted
Set @wiek_k=(select wiek from klienci where id_klienta=@id_klienta)
Set @id_granego_filmu=(select id_granego_filmu from
 Seanse where @id_seansu=id_seansu)
Set @id_filmu=(select id_filmu from AktualnieGraneFilmy where @id_granego_filmu=id_granego_filmu)
Set @od_lat=(Select Max(dozwolony_od_lat) from gatunki g join filmy f on 
g.id_gatunku=f.id_gatunku where  id_filmu=@id_filmu group by f.nazwa)
IF
 @wiek_K<@od_lat
 BEGIN
	ROLLBACK
	RAISERROR('Jest Pan/i za mlody na ogladanie tego filmu', 1, 2 )
END

--nie mozemu usunac filmu z naszej bazy przed premiera
Create Trigger BlodaUsuwania ON Filmy
FOR DELETE 
AS
DECLARE
@date date
Select @date =  grany_od from deleted
If @date > CONVERT(date, SYSDATETIME())
Begin
	ROLLBACK
	RAISERROR ('Nie mozna usunac filmu przed jego premiera', 1, 2)
END


--dodajemy jakis seans i sprawdzamy czy sala i godzina jest wolna
Create Trigger BlokWstawiania ON Seanse 
FOR INSERT 
AS 
DECLARE
@id_sali integer,
@id_godziny integer,
@zero integer
Select @id_sali=id_sali from inserted
select @id_godziny=id_godziny from inserted
Set @zero = (select count(*) from seanse where id_sali=@id_sali and id_godziny=@id_godziny)-1
IF @zero >= 1
Begin
	ROLLBACK
	RAISERROR ('Ten termin lub sala jest zajeta', 1, 2) 
END



--dodajemy nowego klienta

Create procedure DodajKlienta 
	@Imie nvarchar(20),
	@nazwisko nvarchar(20),
	@wiek	int
AS
Begin
	Insert Into Klienci Values 
	(@Imie, @nazwisko, @wiek)
END
GO


--dodajemy pracownika

Create procedure DodajPracownika
	@Imie nvarchar(20),
	@nazwisko nvarchar(20),
	@Pesel   char(11),
	@Pensja  int,
	@etat	nvarchar(20)
AS
Begin
	Declare @id_etatu integer
	Set @id_etatu=(Select id_etatu from  etaty where nazwa=@etat)
	Insert Into Pracownicy Values
	(1, @id_etatu, @Imie, @nazwisko, @Pesel, @Pensja)
END
GO 

--klient sklada zamowienie

Create procedure Zamowienie
	@id integer,
	@nazwa	nvarchar(30),
	@ile	integer
AS
Begin
	Declare @id_prod	integer
	Set  @id_prod= (select id_produktu from bufet where @nazwa=produkt)
	Insert Into Zamowienia values
	(@id, @id_prod, @ile)
End
GO

--dodajemy film do naszej tabeli seanse
Create  procedure WstawFilm
	@name nvarchar(30),
	@tech nvarchar(30),
	@godz time,
	@sala integer
AS
Begin
Declare @id_film integer, 
	@id_h   integer,
	@id		integer,
	@id_tech integer
Set @id_film=(select top(1) id_filmu from filmy where @name=nazwa)
Set @id_tech=(select id_technologii from Technologia where @tech=opis) 
Set @id_h=(select id_godziny from GodzinySeansow where godzina_seasu=@godz)
Set @id=(select id_granego_filmu from AktualnieGraneFilmy 
	where @id_film=id_filmu and @id_tech=id_technologii)
	Insert Into seanse Values
	(@id, @id_h, @sala)
End
GO



Create procedure KupBilet 
	@id integer,
	@film nvarchar(30),
	@godzina time,
	@technologia nvarchar(6),
	@ile	integer, 
	@sala   integer
AS
BEGIN
Declare @id_filmu integer,
@id_tech		integer,
@id_h			integer,
@id_granego		integer,
@id_seansu		integer
Set @id_filmu=(Select TOP(1) id_filmu from Filmy where @film=nazwa )
Set @id_tech=(Select id_technologii from Technologia where opis=@technologia)
IF(select COUNT(*) from AktualnieGraneFilmy where  @id_tech=id_technologii AND @id_filmu=id_filmu) = 0
BEGIN
	Select 'Ten film nie jest grany w takiej technologi'
END
ELSE 
	BEGIN 
		SET @id_granego=(Select id_granego_filmu from AktualnieGraneFilmy 
			where id_filmu=@id_filmu AND id_technologii=@id_tech)
		SET @id_h=(Select id_godziny from GodzinySeansow where godzina_seasu=@godzina)
 IF(select COUNT(*) from Seanse where @id_h=id_godziny AND @id_granego=id_granego_filmu)=0
	BEGIN
		Select 'Tego filmu nie gramy w tej godzinie'
	END
 ELSE 
	BEGIN 
		IF(select COUNT(*) from Seanse where @id_h=id_godziny AND @id_granego=id_granego_filmu AND
		@sala=id_sali)=0
			BEGIN 
				Select 'Ten film nie jest grany w tej sali prosze wybrac inna'
			END
		ELSE 
			BEGIN
			Set @id_seansu=(select id_seansu from Seanse where @id_h=id_godziny AND @id_granego=id_granego_filmu AND
		@sala=id_sali)
			Insert Into Bilety Values 
			(@id_seansu, @id, @ile)
			END
	END
END
END
GO



Create View AktualneSeanse
AS
Select Distinct f.nazwa from AktualnieGraneFilmy a join filmy f on a.id_filmu=f.id_filmu
GO

Create View Ograniczenia
AS
Select nazwa, dozwolony_od_lat, opis from filmy join Gatunki on filmy.id_gatunku=Gatunki.id_gatunku
GO

Create View Pracownicy1
AS
Select p.imie, p.nazwisko, e.nazwa, p.pensja from Pracownicy p join Etaty e on p.id_etatu=e.id_etatu
GO

Create View info
AS
Select nazwa, adres, telefon, wlasciciel, e_mail from Multikino
GO


Create View CoGramy
AS
 Select nazwa, t.opis from AktualnieGraneFilmy a join filmy f on a.id_filmu=f.id_filmu join Technologia t 
 on t.id_technologii=a.id_technologii
GO

Create View Spektakle
AS
 Select nazwa, t.opis, g.godzina_seasu from AktualnieGraneFilmy a join filmy f on a.id_filmu=f.id_filmu join Technologia t 
 on t.id_technologii=a.id_technologii join seanse s on s.id_granego_filmu=a.id_granego_filmu
 join GodzinySeansow g on g.id_godziny=s.id_godziny
 Go

Create View jedzenie
AS
Select k.imie, k.nazwisko, b.produkt, b.cena, z.ilosc from klienci k, bufet b, Zamowienia z 
where k.id_klienta=z.id_klienta and b.id_produktu=z.id_produktu
GO

--srednie pensje na danych statnowiskach 
 Create Function dbo.SredniaPensja 
 (@name nvarchar (20))
  RETURNS real 
 AS
 Begin
 Declare @id integer,
 @avg decimal(8,2)
 Set @id= (select id_etatu from etaty where @name=nazwa)
 Set @avg = (select avg(pensja) as Srednia_pensja
	from pracownicy 
	where id_etatu=@id)
 Return @avg
 END
 GO

 Create Function dbo.WydatekOsoby
 (@id integer)
 Returns real
 AS
 Begin
 Declare @koszt real
 Set @koszt =  (select sum(ilosc*cena) from klienci k 
 join zamowienia z  on k.id_klienta=z.id_klienta 
 join bufet b on b.id_produktu=z.id_produktu
  where @id=k.id_klienta
 group by k.nazwisko, k.imie)
 return @koszt
 END
 GO

 --widok na wydatki klientow w bufecie
 Create View WydatkiBufet
 AS
 select imie, nazwisko, dbo.WydatekOsoby(id_klienta) as wydatek from Klienci
 where dbo.WydatekOsoby(id_klienta) Is not null
 GO


 
 
 Create View PrzychodBufet
 AS
 Select Sum(wydatek) as zysk from WydatkiBufet
 GO



 --ilosc sprzedanych biletow

 create function dbo.IloscSprzedanych 
 (@id integer)
 Returns integer
 AS
 Begin
 Declare @ilosc integer
 Set @ilosc = (select sum(ilsoc) from 
 bilety b join seanse s on b.id_seansu=s.id_seansu
 where s.id_granego_filmu=@id)
Return @ilosc
END
GO

--ilosc sprzedanych biletow na dany film w danej technologii
Create View SprzedaneBilety
AS
select f.nazwa, t.opis, dbo.IloscSprzedanych(id_granego_filmu) as sprzedane_bilety
 from AktualnieGraneFilmy a join filmy f on f.id_filmu=a.id_filmu
	join Technologia t on t.id_technologii=a.id_granego_filmu
 where dbo.IloscSprzedanych(id_granego_filmu) IS NOT NULL
Go



Create View ZyskiZeSprzedazy
AS
select f.nazwa, sum(dbo.IloscSprzedanych(id_granego_filmu)*a.cena) as zysk 
 from AktualnieGraneFilmy a join filmy f on f.id_filmu=a.id_filmu
 where dbo.IloscSprzedanych(id_granego_filmu) IS NOT NULL
 group by f.nazwa
GO


Create View DziennyZysk
AS
select sum(zysk) as przychod from ZyskiZeSprzedazy
Go


 
 --funkcja zwraca filmy z danego gatunku
 
 Create Function dbo.FilmyGatunki
 (@id integer) 
 Returns table 
 AS  
 Return (
	select f.nazwa, f.grany_od, g.opis from Filmy f join gatunki g on g.id_gatunku=f.id_gatunku
	 where f.id_gatunku=@id
	)

GO

--zapisujemy nasze dzienne zyski 
Create procedure Zapisz
AS
BEGIN
Declare @buf decimal (10,2),
@sea decimal (10,2)
IF (COnvert(time, Sysdatetime()) <'12:00')
	Begin 
		Select 'Nasze kino jest otwarte do 23 poczekaj z ksiegowaniem do tej godziny'
	END
Else  
begin
Set @buf = (select * from PrzychodBufet)
Set @sea = (select *from DziennyZysk)
Insert Into HistoriaPrzychodu Values 
(COnvert(date, Sysdatetime()), @sea , @buf )
delete from klienci
END
END
GO



  
  select *from AktualneSeanse
  Insert Into seanse values
	(4, 1, 1)
  
  select *from CoGramy
  select *from jedzenie
  select *from Spektakle
 

  
  exec KupBilet 1,'Bardzo Szybcy i Wsciekli', '14:00', '3d', 2, 2
  select nazwa, dbo.SredniaPensja(nazwa) as srednia from etaty 
  select *from DziennyZysk	
  exec KupBilet 3,'Bardzo Szybcy i Wsciekli', '14:00', '3d', 2, 2
  select *from DziennyZysk
  exec KupBilet 7, 'Dzien Sadu', '14:00', '5d', 2, 1
 
 exec WstawFilm 'Dzien Sadu', '5d', '14:00', 2
 Select *from WydatkiBufet
 select *from klienci
 exec Zamowienie 7, 'Woda', 2
 Select *from WydatkiBufet
 Select *from PrzychodBufet
 select *from Klienci
 select *from HistoriaPrzychodu
 exec Zapisz
 select *from HistoriaPrzychodu
 select *from Klienci  
 delete from Filmy 
  where nazwa='Dzien Sadu'