-- 1
SELECT Press.[Name], MinPages, Books.[Name]
FROM
  (SELECT Id_Press, min(Pages) as MinPages from Books GROUP BY Id_Press) pg
  JOIN Press ON Press.Id = pg.Id_Press 
  JOIN Books ON Books.Id_Press = pg.Id_Press AND Books.Pages = pg.MinPages

-- 2
select Press.[Name]
from Press
join Books on Books.Id_Press = Press.Id
group by Press.[Name]
having avg(pages) > 100

-- 3
select Press.[Name], sum(Pages)
from books
join Press ON Press.[Id] = Books.Id_Press
where Press.[Name] = 'BHV' or Press.[Name] = 'Бином'
group by Press.[Name]

-- 4
select Students.[FirstName] + ' ' + Students.[LastName] as [Student]
from Students
join S_Cards on S_Cards.Id_Student = Students.Id

-- 5
select Students.[FirstName] + ' ' + Students.[LastName] as [Student]
from Students
join S_Cards on S_Cards.Id_Student = Students.Id
join Books on Books.Id = S_Cards.Id_Book
where Books.[Name] = 'Реестр Windows 2000'

-- 6
select Authors.[FirstName] + ' ' + Authors.[LastName] as [Author]
from Authors
join Books on Books.Id_Author = Authors.Id
group by Authors.[FirstName] + ' ' + Authors.[LastName]
having avg(Pages) > 600

-- 7
select distinct Press.[Name]
from Press
join Books on Books.Id_Press = Press.Id
where PAges > 700

-- 8
select Books.[Name], 
	   Students.FirstName + ' ' + Students.LastName as [Student], 
	   Teachers.FirstName + ' ' +  Teachers.LastName as [Teacher]
from Books
full join [S_Cards] on Books.Id = [S_Cards].Id_Book
full join Students on Students.Id = [S_Cards].Id_Student
full join [T_Cards] on Books.Id = [T_Cards].Id_Book 
full join Teachers on Teachers.Id = [T_Cards].Id_Book 
where Books.[Name] is not null 
	  and
	  (Students.FirstName + ' ' + Students.LastName is not null 
	  or
	  Teachers.FirstName + ' ' +  Teachers.LastName is not null)

-- 9 
select top (6) Authors.FirstName, Authors.LastName, count(Books.[Name]) as [Books count]
from Authors
join Books on Authors.Id = Books.Id_Author
join S_Cards on S_Cards.Id_Book = Books.Id
group by
Authors.FirstName, Authors.LastName
order by
[Books count] desc;

-- 10
select top (1) Authors.FirstName, Authors.LastName, count(Books.[Name]) as [Books count]
from Authors
join Books on Authors.Id = Books.Id_Author
join T_Cards on T_Cards.Id_Book = Books.Id
group by Authors.FirstName, Authors.LastName
order by [Books count] desc;

-- 11
select top(3) Categories.[Name], count(Books.Id_Category) as [Category count]
from Categories
join Books on Categories.Id = Books.Id_Category
join T_Cards on T_Cards.Id_Book = Books.Id
join S_Cards on S_Cards.Id_Book = Books.Id
group by Categories.[Name]
order by [Category count] desc

-- 12
select count(C.Id) as [Teacher and students count]
from (
	select Teachers.Id
	from Teachers 
	join [T_Cards] on [T_Cards].Id_Teacher = Teachers.Id
	
	union all
	
	select Students.Id
	from Students 
	join [S_Cards] on [S_Cards].Id_Student = Students.Id
) as C

-- 13



-- 14


-- 15


-- 16 &&&&&&&&&&&&

select [Name]
from Books
where Id = (
select Id_Book
from [T_Cards]
where Id_Book = (
	select Id, max(Id_Book) 
	from [T_Cards] 
	where Id_Book = (
		select Id, count(Id_Book) 
		from [T_Cards] 
		group by Id
		order by count(Id_Book)  desc
		)))



-- 17
select Inf.FirstName as [Teacher and students]
from (
	select Teachers.FirstName
	from Teachers
	join Departments on Teachers.Id_Dep = Departments.Id where [Name] = 'Графики и Дизайна'
	
	union all
	
	select Students.FirstName
	from Students 
	join Groups on Students.Id_Group = Groups.Id where Groups.Id_Faculty = (
												select Id from Faculties where [Name] = 'Веб-Дизайна')
) as Inf

-- 18
select Inf.FirstName as [Teacher and students]
from (
	select Teachers.FirstName
	from Teachers 
	join [T_Cards] on [T_Cards].Id_Teacher = Teachers.Id
	
	union all
	
	select Students.FirstName
	from Students 
	join [S_Cards] on [S_Cards].Id_Student = Students.Id
) as Inf

-- 19
select [Name] 
from [Books] 
join [T_Cards] on [Books].Id = [T_Cards].Id_Book 
join [S_Cards] on [Books].Id = [S_Cards].Id_Book
group by [Name]

-- 20
select Libs.Id, Libs.FirstName, Libs.LastName, count(qq.Id) as Выдал
from Libs left join 
   (select Id_Lib, Id
   from S_Cards
   union all 
   select Id_Lib, Id
   from T_Cards) as qq 
on Libs.Id = qq.Id_Lib
group by Libs.Id, Libs.FirstName, Libs.LastName;
