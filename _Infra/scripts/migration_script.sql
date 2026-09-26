drop table if exists packs;
drop table if exists users;
drop table if exists ranks;
drop table if exists parameters;
drop table if exists equipment_types;


-- Звания/Должности
create table ranks(
	id int primary key,
	name varchar(100) -- Название должности/звания
);

-- Пользователь
create table users(
	id int primary key,
	full_name varchar(100), -- Полное имя пользователя
	id_rank int references ranks(id) -- Код должности/звания
);

-- Тип оборудования
create table equipment_types(
	id int primary key,
	name varchar(50) -- Название типа оборудования(ДМК или ВР)
);

-- Параметры
create table parameters(
	id int primary key,
	height int, -- Высота метеопоста
	temperature decimal(3, 1), -- Температура
	pressure int, -- Давление
	wind_direction int, -- Направление ветра
	wind_speed int, -- Скорость ветра
	bullet_drift int -- Дальность сноса пуль
);

-- Пачки
create table packs(
	id int primary key,
	name varchar(100), -- Название пачки
	created_at timestamp default current_timestamp, -- Дата и время создания пачки
	id_user int references users(id), -- Код пользователя
	id_equipment_type int references equipment_types(id), -- Код оборудования
	id_parameter int references parameters(id) -- Код параметров
);


-- Тестовые данные
 
insert into ranks(id, name) values(1, 'Начальник метеопоста');
insert into ranks(id, name) values(2, 'Метеоролог');
 
insert into equipment_types(id, name) values(1, 'ДМК');
insert into equipment_types(id, name) values(2, 'ВР');
 
insert into parameters(id, height, temperature, pressure, wind_direction, wind_speed, bullet_drift)
values(1, 100, 25, 765, 15, 6, null);
 
insert into parameters(id, height, temperature, pressure, wind_direction, wind_speed, bullet_drift)
values(2, 60, -10.5, 743, 30, null, 120);
 
insert into users(id, full_name, id_rank) values(1, 'Иванов Иван Иванович', 1);
insert into users(id, full_name, id_rank) values(2, 'Петров Петр Петрович', 2);
 
insert into packs(id, name, id_user, id_equipment_type, id_parameter)
values(1, 'Пачка 1', 1, 1, 1);
 
insert into packs(id, name, id_user, id_equipment_type, id_parameter)
values(2, 'Пачка 2', 2, 2, 2);


select
	packs.name,
	packs.created_at,
	users.full_name,
	ranks.name,
	equipment_types.name,
	parameters.height,
    parameters.temperature,
    parameters.pressure,
    parameters.wind_direction,
    parameters.wind_speed,
	parameters.bullet_drift
from packs
join users on packs.id_user=users.id
join ranks on users.id_rank=ranks.id
join equipment_types on packs.id_equipment_type=equipment_types.id
join parameters on packs.id_parameter=parameters.id

	
	




