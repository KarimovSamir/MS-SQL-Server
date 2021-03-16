-- 1
select [Name]
from [Books]
Where not Publisher='Питер'
and [Price] < 20

-- 2
select [Name]
from [Books]
Where not Publisher='Питер'
and [Price] > 20 and [Price] < 40

-- 3
select [Name]
from [Books]
Where not Publisher='Питер'
and [Price] > 20 and [Price] < 40
or [Price] < 10

-- 4
SET ARITHABORT off
SET ANSI_WARNINGS off
select *
from [Books]
where [Price] / [Pages] < 0.10

-- 5
select *
from [Books]
where ([Name] like N'%Самоучитель%' or [Topic] like '%Операционные системы%')
and (Publisher=N'Питер' or Publisher like '%BHV%')


------------------------------------------------------

-- 1
select *
from [Books]
where [Name] like '%Visual%'

-- 2
select *
from [Books]
where [Name] like '%Visual%'
and [Name] not like '%Basic%'

-- 3
select *
from [Books]
where [Name] like '%[0-9]%'

-- 4
select *
from [Books]
where [Name] like '%[0123456789]%[0123456789]%[0123456789]%'

-- 5
select [Name]
from [Books]
WHERE [Name] LIKE '%[0-9]%[0-9]%[0-9]%[0-9]%' AND
[Name] NOT LIKE '%[0-9]%[0-9]%[0-9]%[0-9]%[0-9]%'

-- 6
INSERT INTO Books
VALUES (1111,1,N'Язык программирования С++',18.20,817,'70х100/16', '1985-01-01',1000,N'Программирование на С++',N' Addison-Wesley', N'Программирование')

-- 7
select *
from [Books]
update [Books] set [Price]=[Price]*0.9

-- 8
select *
from [Books]
delete from [Books]
where [Name] like '%[6]%' or [Name] like '%[7]%'