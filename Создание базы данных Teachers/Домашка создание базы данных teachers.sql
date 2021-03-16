-- 1
use [master]
create database [Teachers]

use [Teachers]
create table [dbo].[Post](
	[Id] int primary key IDENTITY,
	[Name] nvarchar(20) not null
);

create table [dbo].[Teacher](
	[Id] int IDENTITY(1,1) not null, --(1 - с какого числа нужно начинать, 1 - на какое число надо прибавлять)
	[Name] nvarchar(15) not null,
	[Code] char(10),
	[IdPost] int,
	[Tel] char(7),
	[Salary] int,
	[Rise] numeric(6,2),
	[HireDate] datetime

	constraint PK_Teacher_Id primary key(Id)
	constraint FK_Teacher_IdPost foreign key(IdPost) references [Post](Id) on delete cascade
);

--drop table [Teacher]
--drop table [Post]

-- 2
alter table [Teacher]
drop constraint FK_Teacher_IdPost
drop table [Post]

-- 3
alter table [Teacher]
drop column [IdPost]

-- 4
alter table [Teacher]
add constraint CHK_Teacher_HireDate check ([HireDate] >= '1990.01.01')

-- 5
alter table [Teacher]
add constraint UC_Teacher_Code unique ([Code]);
--add unique ([Code]);

-- 6
alter table [Teacher]
alter column Salary numeric(6,2)

-- 7
alter table [Teacher]
add constraint CHK_Teacher_Salary check ([Salary] between 1000 and 5000)

-- 8
EXEC sp_rename 'Teacher.Tel', 'Phone', 'COLUMN'

-- 9
alter table [Teacher]
alter column Phone char(11)

-- 10
create table [dbo].[Post](
	[Id] int primary key IDENTITY,
	[Name] nvarchar(20) not null
);

-- 11
alter table [Post]
add constraint CHK_Post_Name check ([Name] = 'Профессор' or [Name] = 'Доцент' or [Name] = 'Преподаватель' or [Name] = 'Ассистент')

-- 12
alter table [Teacher]
add constraint CHK_Teacher_Name check ([Name] NOT LIKE '%[0-9]%')

-- 13
alter table [Teacher]
add [IdPost] int

-- 14
alter table [Teacher]
add constraint FK_Teacher_NewIdPost foreign key(IdPost) references [Post](Id)

-- 15
SET IDENTITY_INSERT [Post] ON

INSERT INTO post(Id,Name) VALUES(1,N'Профессор');
INSERT INTO post(Id,Name) VALUES(2,N'Доцент');
INSERT INTO post(Id,Name) VALUES(3,N'Преподаватель');
INSERT INTO post(Id,Name) VALUES(4,N'Ассистент');

SET IDENTITY_INSERT [Post] OFF

SET IDENTITY_INSERT [Teacher] ON

INSERT INTO TEACHER (Id, Name, Code, IdPost, phone, Salary, Rise, HireDate)
VALUES (1, N'Сидоров','0123456789', 1, NULL, 1070, 470, '01.09.1992');
INSERT INTO TEACHER (Id, Name, Code, IdPost, phone, Salary, Rise, HireDate)
VALUES (2, N'Рамишевский','4567890123', 2, '4567890', 1110, 370, '09.09.1998');
INSERT INTO TEACHER (Id, Name, Code, IdPost, phone, Salary, Rise, HireDate)
VALUES (3, N'Хоренко','1234567890', 3, NULL, 2000, 230, '10.10.2001');
INSERT INTO TEACHER (Id, Name, Code, IdPost, phone, Salary, Rise, HireDate)
VALUES (4, N'Вибровский','2345678901', 4, NULL, 4000, 170, '01.09.2003');
INSERT INTO TEACHER (Id, Name, Code, IdPost, phone, Salary, Rise, HireDate)
VALUES (5, N'Воропаев',NULL, 4, NULL, 1500, 150, '02.09.2002');
INSERT INTO TEACHER (Id, Name, Code, IdPost, phone, Salary, Rise, HireDate)
VALUES (6, N'Кузинцев','5678901234', 3, '4567890', 3000, 270, '01.01.1991');

SET IDENTITY_INSERT [Teacher] OFF 

select *
from [Teacher]

select *
from [Post]

-- 16

go
create view TeacherView
as
select [Teacher].[Id], [Teacher].[Name], [Teacher].[Code], [Post].[Name] as 'Position', [Teacher].[Phone], [Teacher].[Salary], [Teacher].[Rise], [Teacher].[HireDate]
from [Teacher]
inner join [Post] on [Teacher].[IdPost] = [Post].[Id]
go

select *
from TeacherView

-- 16.1
select [Position] 
from TeacherView

-- 16.2
select [Name] 
from TeacherView

-- 16.3
select [Code], [Name], [Position], [Salary] 
from TeacherView
order by [Salary]

select [Code],[Name],[Phone]
from TeacherView
where [Phone] is not null

-- 16.4
select [Name], [Position], Format([HireDate], 'dd/MM/yyyy')
from TeacherView

-- 16.5
select [Name], [Position], Format([HireDate], 'dd/MMMM/yyyy')
from TeacherView