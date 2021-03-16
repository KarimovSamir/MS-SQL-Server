use [master]
create database GAI
go

use GAI
create table [dbo].[Drivers](
	[Id] int primary key identity,
	[Name] char (20) not null,
	[Surname] char (20) not null,
	[BirthDate] date not null,
	[Adress] char (20) not null,
	[Passport] int unique,
	[Penalty] int,
	[DrivingLicense] int not null unique,
	[DrivingLicense_Date] date not null,
	[DrivingCathegory] CHAR (1) not null	
);

create table [dbo].[Firm](
	[Id] int primary key identity,
	[Name] char (20) not null	
);

create table [dbo].[Country](
	[Id] int primary key identity,
	[Name] char (20) not null
);

create table [dbo].[CarsMarks](
	[Id] int primary key identity,
	[MarkName] char (10) not null unique,
	[IdFirm] int not null,
	[IdCountry] int not null
	
	constraint FK_CarsMarks_IdFirm foreign key ([IdFirm]) references [Firm](Id) on delete cascade,
	constraint FK_CarsMarks_IdCountry foreign key ([IdCountry]) references [Country](Id) on delete cascade
);

create table [dbo].[Cars](
	[Id] int primary key identity,
	[IdDriver] int not null,
	[IdCarMark] int not null,
	[CarNumber] char(10) unique,
	[Color] char(10)

	constraint FK_Cars_IdDriver foreign key ([IdDriver]) references [Drivers](Id) on delete cascade,
	constraint FK_Cars_IdCarMark foreign key ([IdCarMark]) references [CarsMarks](Id) on delete cascade
);

insert into CarsMarks values (1,'BMW',1,1)
insert into CarsMarks values (2,'Mersedes',2,2)
insert into CarsMarks values (3,'Honda',3,3)
insert into CarsMarks values (4,'Mclaren',4,4)
insert into CarsMarks values (5,'Nissan',5,5)

insert into Country values (1,'Azerbaijan')
insert into Country values (2,'Japan')
insert into Country values (3,'Germany')
insert into Country values (4,'France')
insert into Country values (5,'Austria')