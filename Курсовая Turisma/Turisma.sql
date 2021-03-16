use [master]
create database Turisma
go

use Turisma
go

backup database Turisma
to disk = 'D:\IT Step\SQL\Backup folder\Full backup\Full_backup_Turisma1.bak'
with name = N'Full_Backup';
go

create table [dbo].[User](
	[Id] int primary key identity,
	[FirstName] nvarchar (30) not null,
	[LastName] nvarchar (30) not null,
	[Mail] nvarchar(30),
	[FB] nvarchar(30),

	constraint CK_User_FirstName check([FirstName] <> N'' and [FirstName] is not null),
	constraint CK_User_LastName check([LastName] <> N'' and [LastName] is not null),
	constraint CK_User_Mail check([Mail] like N'%@%'),
	constraint CK_FB check(FB <> N'')
);

create table [dbo].[City](
	[Id] int primary key identity,
	[CityName] nvarchar (30) not null unique
);

create table [dbo].[RoadTypes](
	[Id] int primary key identity,
	[TypeName] nvarchar(30) not null unique
);

create table [dbo].[Routes](
	[Id] int primary key identity,
	[IdUser] int not null,
	[IdCity] int not null,
	[IdType] int not null,
	[RoutesRatingSum] int default 0,
	[Time] time(0),
	[Title] nvarchar(max) default null,
	[Description] nvarchar(max) default null

	constraint FK_City_IdCity foreign key ([IdCity]) references [City](Id) on delete cascade on update cascade,
	constraint FK_User_IdUser foreign key ([IdUser]) references [User](Id) on delete cascade on update cascade,
	constraint FK_RoadTypes_IdType foreign key ([IdType]) references [RoadTypes](Id) on delete cascade on update cascade,
);

create table [dbo].[SocialMedia](
	[Id] int primary key identity,
	[IdUserSocialMedia] int not null,
	[IdRoutesSocialMedia] int not null,
	[Commentary] nvarchar(max) default null,
	[Rating] int default null

	constraint CK_SocialMedia_Rating check([Rating] between 0 and 5),
	constraint FK_Routes_IdRoutesSocialMedia foreign key ([IdRoutesSocialMedia]) references [Routes](Id),
	constraint FK_User_IdUserSocialMedia foreign key ([IdUserSocialMedia]) references [User](Id) on delete cascade on update cascade
);

create table [dbo].[Route](
	[IdRoute] int not null,
	[Title] nvarchar(max) default null,
	[Description] nvarchar(max) default null,
	[Coordinates] geography not null

	constraint FK_Routes_IdRoute foreign key ([IdRoute]) references [Routes](Id)
);
go

backup database Turisma
to disk = 'D:\IT Step\SQL\Backup folder\Partial backup\Partial_backup_Turisma1.bak'
with differential,
name = N'Differential_Backup_1';
go

create trigger RatingSum
on SocialMedia
after insert, update
as
begin
	declare @rating int
	select @rating = Rating from inserted

	declare @id_routes int
	select @id_routes = IdRoutesSocialMedia from inserted


	update [Routes] set [RoutesRatingSum] = @rating + [RoutesRatingSum]
	where [Routes].Id = @id_routes
end

go
-- Для добавления юзера триггер проверяет, чтобы был введён либо Email, либо FB, 
-- ну или оба сразу, главное чтобы хоть одно было
create trigger UserAdd
on [User]
instead of insert
as
begin
	begin transaction
		begin try
			if exists(select [Mail], [FB]
			from inserted
			where ([Mail] is null or [Mail] = '') and ([FB] is null or [FB] = ''))
				begin
					RAISERROR('Неправильно заполнили поля!', 16, 1)
					ROLLBACK TRAN
				end	
			else
				begin
					insert into [User] select [FirstName], [LastName], [Mail], [FB] from inserted
					commit transaction
				end
		end try
		begin catch
			RAISERROR('Неправильно заполнили поля!', 16, 1)
			ROLLBACK TRAN
		end catch
end
go

-- Проверяет существование Routes, чтобы идентичный Routes нельзя было добавлять снова и снова
-- Хоть мелкое различие быть должно
create function check_routes_exists(@id_user int, @id_city int, @id_type int, @title nvarchar(max), @description nvarchar(max))
returns bit
as
begin
	if exists(select * 
			  from [Routes] 
			  where IdUser = @id_user and
					IdCity = @id_city and
					IdType = @id_type and
					Title = @title and
					[Description] = @description)
			  begin
				  return 1;
			  end
	return 0;
end

go
-- Проверяет существует ли Email который мы передаём
create function check_user_mail(@mail nvarchar(30))
returns bit 
as
begin
	if exists(select Mail from [User] where Mail = @mail)
	begin
		return 1;
	end

	return 0;		
end

go
-- Проверяет существует ли FB который мы передаём
create function check_user_fb(@fb nvarchar(30))
returns bit 
as
begin
	if exists(select FB from [User] where FB = @fb)
	begin
		return 1;
	end

	return 0;		
end

go
-- Проверяет существует ли User которого мы передаём
create function check_user(@id_user int)
returns bit
as
begin
	if exists(select Id from [User] where Id = @id_user)
	begin
		return 1;
	end

	return 0;
end

go
-- Проверяет существует ли город который мы передаём
create function check_city(@id_city int)
returns bit
as
begin
	if exists(select Id from [City] where Id = @id_city)
	begin
		return 1;
	end

	return 0;

end

go
-- Проверяет существует ли такой тип дороги(пешеходный к примеру) который мы передаём
create function check_road_type(@id_type int)
returns bit
as
begin
	if exists(select Id from [RoadTypes] where Id = @id_type)
	begin
		return 1;
	end

	return 0;

end

go
-- Проверяет существует ли такая точка маршрута которую мы передаём
create function check_route_point(@id_route int)
returns bit
as
begin
	if exists(select IdRoute from [Route] where IdRoute = @id_route)
	begin
		return 1;
	end
	return 0;
end
go
-- Проверяет существование Route, чтобы идентичный Route нельзя было добавлять снова и снова
-- Хоть мелкое различие быть должно
create function check_route_point_exists(@id_route int, @title nvarchar(max), @description nvarchar(max))
returns bit
as
begin
	if exists(select * 
			  from [Route] 
			  where IdRoute = @id_route and
					Title = @title and
					[Description] = @description)
			  begin
				  return 1;
			  end
	return 0;
end
go
-- Проверяет существует ли такой маршрут который мы передаём
create function check_routes(@id_routes int)
returns bit
as
begin
	if exists(select Id from [Routes] where Id = @id_routes)
			  begin
				  return 1;
			  end
	return 0;
end
go
-- Процедура для добавления маршрута
create proc RoutesAdd
	@id_user int,
	@id_city int,
	@id_type int,
	@rating_sum int,
	@time time,
	@title nvarchar(max),
	@description nvarchar(max)
as
begin
	declare @id_user_check bit
	set @id_user_check = dbo.check_user(@id_user)

	declare @id_city_check bit
	set @id_city_check = dbo.check_city(@id_city)

	declare @id_type_check bit
	set @id_type_check = dbo.check_road_type(@id_type)

	declare @routes_exists bit
	set @routes_exists = dbo.check_routes_exists(@id_user, @id_city, @id_type, @title, @description)

	if @routes_exists = 1
		begin
			RAISERROR('Вы уже добавляли такой маршрут', 16, 1)
			ROLLBACK TRAN
		end
	else if @id_user_check = 1 and @id_city_check = 1 and @id_type_check = 1
		begin
			insert into [Routes] values (@id_user, @id_city, @id_type, @rating_sum, @time, @title, @description)
		end
	else
		begin
			RAISERROR('Такого user или города не существует', 16, 1)
			ROLLBACK TRAN
		end
end

go
-- Процедура для добавления user
create proc CreateUser
	@firstname nvarchar (30),
	@lastname nvarchar (30),
	@mail nvarchar (30),
	@fb nvarchar (30)
as
begin
	declare @fb_check bit
	set @fb_check = dbo.check_user_fb(@fb)

	declare @mail_check bit 
	set @mail_check = dbo.check_user_mail(@mail)

	if @fb is null
		begin
			if @mail_check = 0
				begin
					insert into [User] values (@firstname, @lastname, @mail, null)
				end
			else
			begin
				RAISERROR('Такой email уже существует!', 16, 1)
				ROLLBACK TRAN
			end
		end
	else if @mail is null
		begin
			if @fb_check = 0
				begin
					insert into [User] values (@firstname, @lastname, null, @fb)
				end
			else
			begin
				RAISERROR('Такой Facebook аккаунт уже существует!', 16, 1)
				ROLLBACK TRAN
			end
		end
end

go
-- Процедура для добавления точки маршрутка
create proc RoutePointAdd
	@id_route int,
	@title nvarchar(max),
	@description nvarchar(max),
	@coordinates geography
as
begin
	declare @route_check bit
	set @route_check = dbo.check_route_point(@id_route)

	declare @route_exists bit
	set @route_exists = dbo.check_route_point_exists(@id_route, @title, @description)

	if @route_exists = 1
		begin
			RAISERROR('Вы уже добавляли эту точку маршрут', 16, 1)
			ROLLBACK TRAN
		end
	else if @route_check = 1
		begin
			insert into [Route] values (@id_route, @title, @description, @coordinates)
		end
	else
		begin
			RAISERROR('Такого маршрута не существует', 16, 1)
			ROLLBACK TRAN
		end
end

go

-- Процедура для добавления данных в нашу Social Media
create proc CommentaryAndRatingAdd
	@id_user_social_media int,
	@id_routes_social_media int,
	@commentary nvarchar(max),
	@rating int
as
begin
	declare @social_media_user bit
	set @social_media_user = dbo.check_user(@id_user_social_media)

	declare @social_media_routes bit
	set @social_media_routes = dbo.check_routes(@id_routes_social_media)

	if @social_media_user = 1 and @social_media_routes = 1
		begin
			insert into [SocialMedia] values (@id_user_social_media, @id_routes_social_media, @commentary, @rating)
		end
	else 
		begin
			RAISERROR('Такого user или маршрута не существует', 16, 1)
			ROLLBACK TRAN
		end
end
go

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

backup database Turisma
to disk = 'D:\IT Step\SQL\Backup folder\Partial backup\Partial_backup_Turisma2.bak'
with differential,
name = N'Differential_Backup_2';
go

bulk insert [Routes]
from 'C:\Users\Jonathan Kent\Desktop\Курсовая\routes.txt'
with (firstrow = 1, fieldterminator = ',', rowterminator = '\n');

insert into [RoadTypes] values ('Пешеходный')
insert into [RoadTypes] values ('Велосипедный')
insert into [RoadTypes] values ('Автомобильный')

insert into [City] values ('Odessa')
insert into [City] values ('Kiev')
insert into [City] values ('Baku')

insert into [User] values ('Samir','Kerimov','teram@mail.ru', null)
insert into [User] values ('Escanor','Meystar',null,'Sun')
insert into [User] values ('John','Dou','007@mail.ru', null)
insert into [User] values ('Tenavar','Mayderans',null, 'Warcraft')

insert into [SocialMedia] values (1, 1, 'Commentary1', 5)
insert into [SocialMedia] values (2, 2, 'Commentary2', 4)
insert into [SocialMedia] values (1, 1, 'Commentary3', 5)
insert into [SocialMedia] values (3, 1, 'Commentary4', 1)

insert into [Route] values (1, N'Vorontsov monument', N'Vorontsov is Novorossiysk and Bessarabian governor-general. It is the second monument in Odessa, built in 1863.'
, geography::Point(46.484122, 30.731614, 4326))
insert into [Route] values (1, N'Monument to Leonid Utyosov', N'It is a bronze sculpture, erected in memory of the Odessa Soviet artist and singer Leonid Utesov in 2000.'
, geography::Point(46.484739, 30.734435, 4326))
insert into [Route] values (1, N'The sculpture "Laocoon"', N'It is a marble sculpture, a copy of the famous sculpture "Laocoon and His Sons", set in front of the Odessa Archaeological Museum.'
, geography::Point(46.485326, 30.742525, 4326))
insert into [Route] values (1, N'Monument to Alexander Pushkin', N'It was built in 1887-1889 in Odessa on the Primorskiy Boulevard with funds donated by Odessa citizens. It is the third monument in Odessa.'
, geography::Point(46.486105, 30.743592, 4326))
insert into [Route] values (2, N'Potemkin monument', N'The monument shows the scene of shotting of rebellious sailors, set in 1965.'
, geography::Point(46.484938, 30.74705, 4326))
insert into [Route] values (3, N'Flame Tower', N'Something text.'
, geography::Point(46.479804, 30.739711, 4326))

----------
-- Вот функция с регуляркой для email, но я не стал её использовать, так как почитал эту статейку :)
-- https://habr.com/ru/post/175375/
--create function CheckEmail(@email nvarchar(30))
--returns bit
--as
--begin
--    declare @result bit
     
--    if @email is not null
--    begin  
--       if @email like '%[A-Z0-9][@][A-Z0-9]%[.][A-Z0-9]%' and @email not like '%["<>'']%'
--        set @result = 1;
--       else
--        set @result = 0;
--    end
     
--    return @result;
--end


