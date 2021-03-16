use [master];
go

if db_id('Academy2') is not null
begin
	drop database [Academy2];
end
go

create database [Academy2];
go

use [Academy2];
go

create table [Departments]
(
	[Id] int not null identity(1, 1) primary key,
	[Financing] money not null check ([Financing] >= 0.0),
	[Name] nvarchar(100) not null unique check ([Name] <> N'')
);
go

create table [Faculties]
(
	[Id] int not null identity(1, 1) primary key,
	[Dean] nvarchar(max) not null check ([Dean] <> N''),
	[Name] nvarchar(100) not null unique check ([Name] <> N''),
);
go

create table [Groups]
(
	[Id] int not null identity(1, 1) primary key,
	[Name] nvarchar(10) not null unique check ([Name] <> N''),
	[Rating] float not null check ([Rating] between 0 and 5),
	[Year] int not null check ([Year] between 1 and 5)
);
go

create table [Teachers]
(
	[Id] int not null identity(1, 1) primary key,
	[EmploymentDate] date not null check ([EmploymentDate] >= '1990-01-01'),
	[IsAssistant] bit not null default 0,
	[IsProfessor] bit not null default 0,
	[Name] nvarchar(max) not null check ([Name] <> N''),
	[Position] nvarchar(max) not null check ([Position] <> N''),
	[Premium] money not null check ([Premium] >= 0.0) default 0.0,
	[Salary] money not null check ([Salary] > 0.0),
	[Surname] nvarchar(max) not null check ([Surname] <> N'')
);
go

SET IDENTITY_INSERT [Teachers] ON

insert into [Teachers] ([Id],[EmploymentDate],[IsAssistant],[IsProfessor],
			[Name],[Position],[Premium],[Salary],[Surname])
values (1,'1993-05-08',0,1,'Samir','Math professor',250,1975,'Kerimov')

insert into [Teachers] ([Id],[EmploymentDate],[IsAssistant],[IsProfessor],
			[Name],[Position],[Premium],[Salary],[Surname])
values (2,'1997-03-02',0,1,'Maestro','Physics professor',50,1000,'Moro')

insert into [Teachers] ([Id],[EmploymentDate],[IsAssistant],[IsProfessor],
			[Name],[Position],[Premium],[Salary],[Surname])
values (3,'1993-12-31',1,0,'Jhon','Math assistant',0,1000,'Doe')

insert into [Teachers] ([Id],[EmploymentDate],[IsAssistant],[IsProfessor],
			[Name],[Position],[Premium],[Salary],[Surname])
values (4,'2010-07-18',0,1,'Daniel','Ñhemistry professor',384,1329,'Goldsmith')

insert into [Teachers] ([Id],[EmploymentDate],[IsAssistant],[IsProfessor],
			[Name],[Position],[Premium],[Salary],[Surname])
values (5,'1993-04-04',1,0,'Laman','Samir assistant',600,1500,'Kerimova')

SET IDENTITY_INSERT [Teachers] OFF 

---------------------------------------------------------

SET IDENTITY_INSERT [Departments] ON

insert into [Departments] ([Id],[Financing],[Name])
values (1,50000,'Math department')

insert into [Departments] ([Id],[Financing],[Name])
values (2,21000,'Chemistry department')

insert into [Departments] ([Id],[Financing],[Name])
values (3,10000,'Physics department')

SET IDENTITY_INSERT [Departments] OFF 

---------------------------------------------------------

SET IDENTITY_INSERT [Faculties] ON

insert into [Faculties] ([Id],[Dean],[Name])
values (1,'Batman','Math faculty')

insert into [Faculties] ([Id],[Dean],[Name])
values (2,'Superman','Chemistry faculty')

insert into [Faculties] ([Id],[Dean],[Name])
values (3,'Flash','Physics faculty')


SET IDENTITY_INSERT [Faculties] OFF 

---------------------------------------------------------

SET IDENTITY_INSERT [Groups] ON

insert into [Groups] ([Id],[Name],[Rating],[Year])
values (1,'Math',5,3)

insert into [Groups] ([Id],[Name],[Rating],[Year])
values (2,'Chemistry',4,5)

insert into [Groups] ([Id],[Name],[Rating],[Year])
values (3,'Physics',2,1)

SET IDENTITY_INSERT [Groups] OFF 

---------------------------------------------------------

SELECT * FROM [Teachers];
SELECT * FROM [Departments];
SELECT * FROM [Faculties];
SELECT * FROM [Groups];

---------------------------------------------------------
-- 1
SELECT * FROM [Departments];
SELECT * FROM [Departments] order by [Id] DESC;

-- 2
SELECT * FROM [Groups];
SELECT [Name] AS [Group Name], [Rating] AS [Group Rating]
FROM [Groups]

-- 3
SELECT [Name], [Salary], [Premium] FROM [Teachers]
SELECT [Premium], COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()
FROM [Teachers] GROUP BY [Premium]

-- 4
SELECT * FROM [Faculties];
SELECT 'The dean of faculty ' + [Name] +' is '+ [Dean]
FROM [Faculties]

-- 5
SELECT [Surname] 
FROM [Teachers]
WHERE [Salary] > 1050 
AND [IsProfessor] = 1

-- 6
SELECT [Name] 
FROM [Departments]
WHERE [Financing] < 11000 
OR [Financing] > 25000

-- 7
SELECT [Name] 
FROM [Faculties]
WHERE [Name] <> 'Computer Science'

-- 8
SELECT [Name], [Position] 
FROM [Teachers]
WHERE [IsAssistant] = 1

-- 9
SELECT [Surname], [Salary], [Premium], [Position] 
FROM [Teachers]
WHERE [Premium] >= 160 AND [Premium] <= 550

-- 10
SELECT [Surname], [Salary]
FROM [Teachers]
WHERE [IsAssistant] = 1

-- 11
SELECT [Name], [Position], [EmploymentDate]  FROM [Teachers]
WHERE [EmploymentDate] <= '01-01-2000'

-- 12
SELECT [Name] AS [Name of Department]
FROM [Departments] WHERE [Name] < 'Software Development' ORDER BY [Name]

-- 13
SELECT [Name]
FROM [Teachers]
WHERE [Salary]+[Premium] <= 1200
AND [IsAssistant] = 1

-- 14
SELECT [Name]
FROM [Groups]
WHERE [Rating] >= 2 AND [Rating] <= 4

-- 15
SELECT [Name]
FROM [Teachers]
WHERE [Salary] < 550
OR [Premium] < 200
AND [IsAssistant] = 1