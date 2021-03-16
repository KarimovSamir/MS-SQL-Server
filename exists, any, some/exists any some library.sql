-- 1
-- Variant with Exists
select [Name]
from [Press]
where exists (select * from [Books] where [Press].Id = [Books].Id_Press)

-- Variant with Any
select [Name]
from [Press]
where Id = Any (select [Books].Id_Press from [Books])

-- Variant with Some
select [Name]
from [Press]
where Id = some (select [Books].Id_Press from [Books])

-- 2
-- Variant with aggregation function
select top(1) [Name]
from [Books]
group by [Name]
order by max([Pages]) desc

-- Variant with All
select [Name]
from [Books]
where Pages = All(select max(Pages) from [Books])


select * from [Teachers]
select * from Categories
select * from Books
order by Id_Category
select * from T_Cards
order by Id_Book
select * from S_Cards
order by Id_Book
select Id,[Name],Id_Category from [Books] 
order by Id

-- 3
-- Variant with Exists
select [FirstName] 
from [Teachers]
where not exists (select * from [T_Cards] where [Teachers].[Id] = [T_Cards].Id_Teacher)

-- Variant with Any
select [FirstName]
from [Teachers]
where not Id = Any (select [T_Cards].Id_Teacher from [T_Cards])

-- Variant with Join
select [FirstName]
from [Teachers]
join [T_Cards] on not exists (select * from [T_Cards] where [Teachers].[Id] = [T_Cards].Id_Teacher) 
group by [FirstName]

-- 4
-- Variant with Join
select [Name] 
from [Books] 
join [T_Cards] on [Books].Id = [T_Cards].Id_Book 
join [S_Cards] on [Books].Id = [S_Cards].Id_Book
group by [Name]

-- Variant with Any
select [Name] 
from [Books]
where Id = Any (select Id_Book from [T_Cards] intersect select Id_Book from [S_Cards])
group by [Name]

-- 5 € пыталс€
-- ¬ыбрать категории, в которых не брали книг.
select distinct Id_Category 
from Books 
join [T_Cards] on not exists (select * from [T_Cards] where Books.[Id] = [T_Cards].Id_Book) 
join [S_Cards] on not exists (select * from [S_Cards] where Books.[Id] = [S_Cards].Id_Book) 
where Id_Category = (select Id_Book from [T_Cards] union select Id_Book from [S_Cards])
group by Id_Category

select distinct Id_Category 
from Books
where not exists (select * from [T_Cards] where [T_Cards].Id_Book = Books.[Id])

select * from [Books] 
order by Id_Category
select [Name] from Categories 

select * from Categories
select * from Books
order by Id_Category

select * from T_Cards
order by Id_Book
select * from S_Cards
order by Id_Book

select distinct B.Id_Category
from (
	select Books.Id_Category
	from Books 
	join [T_Cards] on not exists (select * from [T_Cards] where Books.[Id] = [T_Cards].Id_Book) 
	
	union all
	
	select Books.Id_Category
	from Books 
	join [S_Cards] on not exists (select * from [S_Cards] where Books.[Id] = [S_Cards].Id_Book) 
) as B

select Id
from Books
where not Books.Id = Any (select Id_Book from [T_Cards] union select Id_Book from [S_Cards])