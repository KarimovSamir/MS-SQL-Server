use Turisma
go

-- 1.	����� ���� ��������� ���������� ������.
declare @CityName1 varchar(30);
-- ���������� ����� �������� ������ ������� ������
set @CityName1 = 'Odessa'
-- ��� ������
select [Title], [Description], [City].[CityName]
from [Routes]
join [City] on [City].Id = [Routes].IdCity where [City].Id = (select [Id] from [City] where [CityName] = @CityName1)

-- 2.	����� ���� ��������� ���������� ������ � ����.
declare @CityName2 varchar(30);
-- ���������� ����� �������� ������ ������� ������
set @CityName2 = 'Odessa'
declare @RoadType varchar(30)
-- ���������� ����� ��� ������ ������� ������
set @RoadType = '����������'
-- ��� ������
select [City].[CityName], [Routes].[Title], [Routes].[Description], [RoadTypes].[TypeName]
from [Routes]
join [RoadTypes] on [RoadTypes].Id = [Routes].IdType
join [City] on [City].Id = [Routes].IdCity 
where [City].Id = (select [Id] from [City] where [CityName] = @CityName2)
and [RoadTypes].Id = (select [Id] from [RoadTypes] where [TypeName] = @RoadType)

-- 3.	����� ���� ��������� ���������� ������, ���� � ��������������� �� ��������.
declare @CityName3 varchar(20);
-- ���������� ����� �������� ������ ������� ������
set @CityName3 = 'Odessa'
declare @RoadType2 varchar(30)
-- ���������� ����� ��� ������ ������� ������
set @RoadType2 = '����������'
-- ��� ������
select [City].[CityName], [Routes].[Title], [Routes].[Description], [RoadTypes].[TypeName], [SocialMedia].Rating
from [Routes]
join [RoadTypes] on [RoadTypes].Id = [Routes].IdType
join [User] on [User].Id = [Routes].IdUser
join [SocialMedia] on [SocialMedia].IdUserSocialMedia = [User].Id
join [City] on [City].Id = [Routes].IdCity 
where [City].Id = (select [Id] from [City] where [CityName] = @CityName3)
and [RoadTypes].Id = (select [Id] from [RoadTypes] where [TypeName] = @RoadType2)
order by [SocialMedia].Rating desc

-- 4.	����� ���� ���������, ������� ������������ ������.
declare @UserId int;
-- ���������� ����� ID user ������� ������
set @UserId = 2
-- ��� ������
select City.CityName, [Title], [Description], [Time], [User].FirstName + ' ' + [User].LastName as [User Name]
from [Routes]
join [City] on [City].Id = [Routes].IdCity
join [User] on [User].Id = [Routes].IdUser where [User].Id = @UserId

-- 5.	����� ���������� � �������� ����������� �������� (�� Id)
declare @RoutesId1 int;
-- ���������� ����� ID  ������� ������
set @RoutesId1 = 1
-- ��� ������
select [Title], [Description]
from [Routes]
where [Routes].Id = @RoutesId1

-- 6.	����� ���� ����� �������� ��� ����������� �� �������
declare @RoutesId2 int;
-- ���������� ����� ID  ������� ������
set @RoutesId2 = 1
select [Routes].Title as 'Route Name', [Route].Title, [Route].[Description]
from [Route]
join [Routes] on [Routes].Id = [Route].IdRoute 
where [Routes].Id = @RoutesId2

-- 7.	����� ���� ����� �������� ��� ����������� �� �� �����
declare @RoutesId3 int;
-- ���������� ����� ID  ������� ������
set @RoutesId3 = 1
select [Routes].Title as 'Route Name', [Route].Coordinates
from [Route]
join [Routes] on [Routes].Id = [Route].IdRoute 
where [Routes].Id = @RoutesId3

-- 8.	����� ���� ������������ � ��������
declare @RoutesId4 int
-- ���������� ����� ID  ������� ������
set @RoutesId4 = 1
-- ��� ������
select [Routes].Title, Commentary
from [SocialMedia]
join [Routes] on [Routes].[Id] = [SocialMedia].[IdRoutesSocialMedia] 
where [SocialMedia].[IdRoutesSocialMedia] = @RoutesId4

-- 9.	������ ��� ����������� ������������ ����� �������� ����
exec CreateUser 'Klark','Kent','superman@super.dc',null

select *
from [User]

-- 10.	������ ��� ����������� ������������ ����� FB
exec CreateUser 'Bruce','Wayne',null,'Batman'

select *
from [User]

-- 11.	������ ��� ���������� ��������
-- ��������� ���� �� ����, ��������� ���� �� ����� �����, �����, 

exec RoutesAdd 6, 2, 1, 0, '5:15', 'Monument of Batman', 'Gotham hero'

select *
from [User]

select *
from [Routes]

-- 12.	������ ��� ���������� ����� � �������
DECLARE @g geography;   
SET @g = geography::Point(47.65100, -122.34900, 4326) 
exec RoutePointAdd 2, 'Route point title 2', 'Route point description', @g

select *
from [Route]
-- 13.	������ ��� ���������� ����������� ��������
exec CommentaryAndRatingAdd 5, 2, 'Superman commentary', 4

select *
from [SocialMedia]

-- 14.	������ ��� ���������� ��������
exec CommentaryAndRatingAdd 5, 2, null, 5

select *
from [SocialMedia]

select *
from [Routes]

-- 15.	�������, ��� ��������� �������� ��������
-- ��� ������� � ����� Turisma ��� ��� �� � ������ ����, �� � ��������� ��� ���, ����� �� ��� ��� �� ������

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