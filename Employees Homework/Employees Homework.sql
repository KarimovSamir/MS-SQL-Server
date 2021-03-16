use [Employees]

select *
from [Employees]

select *
from dbo.Employees

select *
from dbo.History

-- 1
select BusinessEntityID, Firstname, Lastname, StateProvinceName, CountryRegionName, City
from [Employees]
where CountryRegionName = 'United States'

-- 2
select count(*) as 'Колличество работников', JobTitle
from Employees
group by JobTitle

-- 3
select count(*) as 'Людей на каждое имя', FirstName
from Employees
group by FirstName

-- 4
select top(1) count(*) as 'Cамое распространенное имя', FirstName
from Employees
group by FirstName 
order by 'Cамое распространенное имя' desc

-- 5
select top(1) count(*) as 'Наименее распространенное имя', FirstName
from Employees
group by FirstName 
order by 'Наименее распространенное имя' asc

-- 6
select top(5) count(*) as 'Колличество работников', City
from Employees
group by City 
order by 'Колличество работников' desc

-- 7
SELECT TOP(5) E.City, COUNT(E.JobTitle) AS [Count]
FROM (
		SELECT DISTINCT E.City, E.JobTitle
		FROM Employees AS E
	 ) AS E
GROUP BY E.City
ORDER BY [Count] DESC

-- 8
select EmailAddress
from [Employees]
where StartDate >= '2012-01-01'

-- 9
select count(*) as 'Людей было принято на работу в каждый год', year(StartDate)
from Employees
group by year(StartDate)

-- 10
select count(*), year(StartDate), City
from Employees
group by year(StartDate), City

-- 11 - 13 Вы сказали делать не надо
