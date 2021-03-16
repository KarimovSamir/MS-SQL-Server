use Turisma
go

-- 1.	Вывод всех маршрутов указанного города.
declare @CityName1 varchar(30);
-- Установите здесь название города который хотите
set @CityName1 = 'Odessa'
-- Сам запрос
select [Title], [Description], [City].[CityName]
from [Routes]
join [City] on [City].Id = [Routes].IdCity where [City].Id = (select [Id] from [City] where [CityName] = @CityName1)

-- 2.	Вывод всех маршрутов указанного города и типа.
declare @CityName2 varchar(30);
-- Установите здесь название города который хотите
set @CityName2 = 'Odessa'
declare @RoadType varchar(30)
-- Установите здесь тип дороги который хотите
set @RoadType = 'Пешеходный'
-- Сам запрос
select [City].[CityName], [Routes].[Title], [Routes].[Description], [RoadTypes].[TypeName]
from [Routes]
join [RoadTypes] on [RoadTypes].Id = [Routes].IdType
join [City] on [City].Id = [Routes].IdCity 
where [City].Id = (select [Id] from [City] where [CityName] = @CityName2)
and [RoadTypes].Id = (select [Id] from [RoadTypes] where [TypeName] = @RoadType)

-- 3.	Вывод всех маршрутов указанного города, типа и отсортированным по рейтингу.
declare @CityName3 varchar(20);
-- Установите здесь название города который хотите
set @CityName3 = 'Odessa'
declare @RoadType2 varchar(30)
-- Установите здесь тип дороги который хотите
set @RoadType2 = 'Пешеходный'
-- Сам запрос
select [City].[CityName], [Routes].[Title], [Routes].[Description], [RoadTypes].[TypeName], [SocialMedia].Rating
from [Routes]
join [RoadTypes] on [RoadTypes].Id = [Routes].IdType
join [User] on [User].Id = [Routes].IdUser
join [SocialMedia] on [SocialMedia].IdUserSocialMedia = [User].Id
join [City] on [City].Id = [Routes].IdCity 
where [City].Id = (select [Id] from [City] where [CityName] = @CityName3)
and [RoadTypes].Id = (select [Id] from [RoadTypes] where [TypeName] = @RoadType2)
order by [SocialMedia].Rating desc

-- 4.	Вывод всех маршрутов, которые пользователь создал.
declare @UserId int;
-- Установите здесь ID user который хотите
set @UserId = 2
-- Сам запрос
select City.CityName, [Title], [Description], [Time], [User].FirstName + ' ' + [User].LastName as [User Name]
from [Routes]
join [City] on [City].Id = [Routes].IdCity
join [User] on [User].Id = [Routes].IdUser where [User].Id = @UserId

-- 5.	Вывод информации и описания конкретного маршрута (по Id)
declare @RoutesId1 int;
-- Установите здесь ID  который хотите
set @RoutesId1 = 1
-- Сам запрос
select [Title], [Description]
from [Routes]
where [Routes].Id = @RoutesId1

-- 6.	Вывод всех точек маршрута для отображения их списком
declare @RoutesId2 int;
-- Установите здесь ID  который хотите
set @RoutesId2 = 1
select [Routes].Title as 'Route Name', [Route].Title, [Route].[Description]
from [Route]
join [Routes] on [Routes].Id = [Route].IdRoute 
where [Routes].Id = @RoutesId2

-- 7.	Вывод всех точек маршрута для отображения их на карте
declare @RoutesId3 int;
-- Установите здесь ID  который хотите
set @RoutesId3 = 1
select [Routes].Title as 'Route Name', [Route].Coordinates
from [Route]
join [Routes] on [Routes].Id = [Route].IdRoute 
where [Routes].Id = @RoutesId3

-- 8.	Вывод всех комментариев к маршруту
declare @RoutesId4 int
-- Установите здесь ID  который хотите
set @RoutesId4 = 1
-- Сам запрос
select [Routes].Title, Commentary
from [SocialMedia]
join [Routes] on [Routes].[Id] = [SocialMedia].[IdRoutesSocialMedia] 
where [SocialMedia].[IdRoutesSocialMedia] = @RoutesId4

-- 9.	Запрос для регистрации пользователя через почтовый ящик
exec CreateUser 'Klark','Kent','superman@super.dc',null

select *
from [User]

-- 10.	Запрос для регистрации пользователя через FB
exec CreateUser 'Bruce','Wayne',null,'Batman'

select *
from [User]

-- 11.	Запрос для добавления маршрута
-- проверить есть ли юзер, проверить есть ли такой город, время, 

exec RoutesAdd 6, 2, 1, 0, '5:15', 'Monument of Batman', 'Gotham hero'

select *
from [User]

select *
from [Routes]

-- 12.	Запрос для добавления точки в маршрут
DECLARE @g geography;   
SET @g = geography::Point(47.65100, -122.34900, 4326) 
exec RoutePointAdd 2, 'Route point title 2', 'Route point description', @g

select *
from [Route]
-- 13.	Запрос для добавления комментария маршруту
exec CommentaryAndRatingAdd 5, 2, 'Superman commentary', 4

select *
from [SocialMedia]

-- 14.	Запрос для оценивания маршрута
exec CommentaryAndRatingAdd 5, 2, null, 5

select *
from [SocialMedia]

select *
from [Routes]

-- 15.	Триггер, для пересчета рейтинга маршрута
-- Сам триггер в файле Turisma ибо там он и должен быть, но я закоменчу его тут, чтобы вы его там не искали

--create trigger RatingSum
--on SocialMedia
--after insert, update
--as
--begin
--	declare @rating int
--	select @rating = Rating from inserted

--	declare @id_routes int
--	select @id_routes = IdRoutesSocialMedia from inserted

--	update [Routes] set [RoutesRatingSum] = @rating + [RoutesRatingSum]
--	where [Routes].Id = @id_routes
--end