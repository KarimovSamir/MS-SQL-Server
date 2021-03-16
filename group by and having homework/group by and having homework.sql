use [Books]

select *
from [Books]

-- 1
select [Publisher]
from [Books]
where [Date]>'2000'
group by [Publisher]

-- 2
select [Name], [Pages]
from [Books]
where [Pages] > (select Avg([Pages]) from [Books])

-- 3
select [Topic], sum([Pages])
from [Books]
where [Price] > 50
group by [Topic]

-- 4
select [Topic]
from [Books]
Where [Category] is null
group by [Topic]

-- 5
-- Variant 1
select top(1) [Price]
from [Books]
where [Publisher] like N'%BHV%'
order by [Price] desc

-- Variant 2
select [Price]
from [Books]
where [Price] = (select max([Price])
from [Books]
where [Publisher] like N'%BHV%')

-- 6
--variant 1
select top(1) [Publisher], sum([Pages])
from [Books]
group by [Publisher]
order by sum([Pages]) desc

--variant 2
SELECT top(1) [Publisher], sum(Pages)
FROM Books
where Pages = (select sum(Pages) from Books)
group by [Publisher]
order by sum([Pages]) desc

-- 7
--variant 1
select top(1) [Publisher], count(Topic)
from [Books]
where [Topic] like 'Программирование'
group by [Publisher]
order by count(Topic) desc

--variant 2
select top(1) [Publisher], count(Topic)
from [Books]
where [Topic] = (select max(Topic)
from [Books]
where [Topic] like 'Программирование')
group by [Publisher]
order by count(Topic) desc

-- 8
select Topic, count([Name])
from [Books]
group by Topic
order by count([Name]) desc

-- 9 
select [Name]
from (select Topic, MIN(price)price
	  from Books
      where Topic IN ('Программирование','Базы данных клиент-сервер','Мультимедиа')
      group by Topic) as p JOIN Books [Name] on [Name].Topic=p.Topic and [Name].Price=p.Price

-- 10
select Publisher,[Name], [Date]
from Books as MT
where [Date] = (select T.D
            from(select Publisher,Min([Date]) as D
                from Books
                where [Date] is not null
                 group by Publisher) as T
                 where MT.Publisher = t.Publisher)

-- 11
select Publisher,count([Name])
from Books as MT
where [Date] = (select T.D
            from(select Publisher,Max([Date]) as D
                from Books
                where [Date] is not null
                 group by Publisher) as T
                 where MT.Publisher = t.Publisher)
				 group by Publisher

-- 12
select top(1) Publisher
from Books as MT
where [Date] = (select T.D
            from(select Publisher,Max([Date]) as D
                from Books
                where [Date] is not null
                 group by Publisher) as T
                 where MT.Publisher = t.Publisher)
				 group by Publisher
				 order by count([Name]) desc

-- 13 &&&&&&&&&& 
-- Я пытался
--select topic, max(Price)*0.01
--from [Books] t1
--where [Date] = (
--Select max([Date])
--from [Books]
--where topic = t1.Topic
--)
--group by topic

select topic, sum(price) as D
from [Books]
group by topic

select sum(price) as D
from [Books]

select Topic, Price
from Books as MT
where Price = (select T.D
				from(select topic, sum(price) as D
				from [Books]
				group by topic) as T inner join
				(select sum(price) as D2
				from [Books]) as T2 on MT.Price = T.D/T2.D2 * 0.01)

-- 14
select [Publisher], AVG(Price)
from [Books]
where Date BETWEEN '1999-03-01' AND '1999-05-31'
group by [Publisher]

-- 15
-- Variant 1
select top(1) [Name]
from [Books]
group by [Name]
order by max(pressrun) desc

-- Variant 2
select top(1) [Name]
from [Books]
where [Name] = (select top(1) [Name]
				from [Books]
				group by [Name]
				order by max(pressrun) desc)

-- 16
select Publisher
from Books
group by Publisher
having count(Id) > ( select COUNT(*) from Books ) * 0.05

-- 17
select [Name], [Code]
from [Books]
where [Code] like '%[7]%[7]%' and [Code] not like '%[7]%[7]%[7]%'

-- 18
select distinct [Publisher]
from [Books]
where [Publisher] like '%[л]%[а]%[к]%'

-- 19
select [Name]
from [Books]
where [Name] not like '%[a-z]%' and Convert(int, [Pages]) % 2 = 0

-- 20
select count([Name])
from [Books]
where [Date] is null