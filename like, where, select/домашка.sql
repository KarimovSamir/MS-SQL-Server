-- 1
select [Name], [Price]*[Pressrun] as 'Сумма цены на тираж'
from [Books]
-- 2
select distinct [Category]
from [Books]
-- 3
select distinct [Topic]
from [Books]
-- 4
SET ARITHABORT off
SET ANSI_WARNINGS off
select [Name], [Code], [Price]/[Pages] as 'Цена за одну страницу'
from [Books]

------------------------------------------------------

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
where ([Name] like N'%Учебник%' or [Topic] like '%C&C++%')
and (Publisher=N'Питер' or Publisher like '%DiaSoft%')

------------------------------------------------------

-- 1
select *
from [Books]
where [Name] like '%Windows%'

-- 2
select *
from [Books]
where [Name] like '%Windows%'
and [Name] not like '%Microsoft%'

-- 3
select *
from [Books]
where [Name] like '%[0-9]%'

-- 4
select *
from [Books]
where [Name] like '%[0123456789]%[0123456789]%[0123456789]%'

-- 5
INSERT INTO Books
VALUES (1111,1,N'Язык программирования С++',18.20,817,'70х100/16', '1985-01-01',1000,N'Программирование на С++',N' Addison-Wesley', N'Программирование')

-- 6
select *
from [Books]
update [Books] set [Price]=[Price]*0.9

-- 7
select *
from [Books]
delete from [Books]
where [Name] like '%[6]%' or [Name] like '%[7]%'