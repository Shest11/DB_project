-- Базовая ед. измерения
create table if not exists base_unit(
	id int primary key,
	name varchar(100) -- Название базовой ед. измерения
);

insert into base_unit(id, name) values(1, 'Длина');
insert into base_unit(id, name) values(2, 'Температура');
insert into base_unit(id, name) values(3, 'Давление');
insert into base_unit(id, name) values(4, 'Угол');
insert into base_unit(id, name) values(5, 'Скорость');


-- Ед. измерения
create table if not exists unit(
	id int primary key,
	name varchar(100), -- Название ед. измерения
	id_base_unit int references base_unit(id) -- Код базовой ед. измерения
);

insert into unit(id, name, id_base_unit) values(1, 'Метр', 1);
insert into unit(id, name, id_base_unit) values(2, '°C', 2);
insert into unit(id, name, id_base_unit) values(3, 'мм рт ст', 3);
insert into unit(id, name, id_base_unit) values(4, 'Деление угломера', 4);
insert into unit(id, name, id_base_unit) values(5, 'м/с', 5);


-- Тип параметров
create table if not exists type_parameter(
	id int primary key,
	name varchar(100), -- Название типа параметра
	id_unit int references unit(id) -- Код ед. измерения
);

insert into type_parameter(id, name, id_unit) values(1, 'Высота метеопоста', 1);
insert into type_parameter(id, name, id_unit) values(2, 'Температура', 2);
insert into type_parameter(id, name, id_unit) values(3, 'Давление', 3);
insert into type_parameter(id, name, id_unit) values(4, 'Направление ветра', 4);
insert into type_parameter(id, name, id_unit) values(5, 'Скорость ветра', 5);
insert into type_parameter(id, name, id_unit) values(6, 'Дальность сноса пуль', 1);


-- Изменение существующей parameters

alter table parameters add column if not exists id_pack int references packs(id);
alter table parameters add column if not exists id_type_parameter int references type_parameter(id);
alter table parameters add column if not exists value decimal(4, 1);

-- Заполняем новые колонки в уже существующих строках
update parameters set id_pack = 1, id_type_parameter = 1, value = height where id = 1;
update parameters set id_pack = 2, id_type_parameter = 1, value = height where id = 2;

-- Добавляем недостающие строки для остальных параметров
insert into parameters(id, id_pack, id_type_parameter, value)
select 3, 1, 2, temperature from parameters where id = 1;
insert into parameters(id, id_pack, id_type_parameter, value)
select 4, 2, 2, temperature from parameters where id = 2;

insert into parameters(id, id_pack, id_type_parameter, value)
select 5, 1, 3, pressure from parameters where id = 1;
insert into parameters(id, id_pack, id_type_parameter, value)
select 6, 2, 3, pressure from parameters where id = 2;

insert into parameters(id, id_pack, id_type_parameter, value)
select 7, 1, 4, wind_direction from parameters where id = 1;
insert into parameters(id, id_pack, id_type_parameter, value)
select 8, 2, 4, wind_direction from parameters where id = 2;

insert into parameters(id, id_pack, id_type_parameter, value)
select 9, 1, 5, wind_speed from parameters where id = 1 and wind_speed is not null;
insert into parameters(id, id_pack, id_type_parameter, value)
select 10, 2, 5, wind_speed from parameters where id = 2 and wind_speed is not null;

insert into parameters(id, id_pack, id_type_parameter, value)
select 11, 1, 6, bullet_drift from parameters where id = 1 and bullet_drift is not null;
insert into parameters(id, id_pack, id_type_parameter, value)
select 12, 2, 6, bullet_drift from parameters where id = 2 and bullet_drift is not null;

-- Удаляем старые колонки
alter table parameters drop column if exists height;
alter table parameters drop column if exists temperature;
alter table parameters drop column if exists pressure;
alter table parameters drop column if exists wind_direction;
alter table parameters drop column if exists wind_speed;
alter table parameters drop column if exists bullet_drift;

-- Убираем колонку связанную со старой связью пачка -> parameters
alter table packs drop column if exists id_parameter;

-- Исправляем дату измерения у тестовых пачек
update packs set created_at = timestamp '2026-09-19 09:30:00' where id = 1;
update packs set created_at = timestamp '2026-09-19 10:10:00' where id = 2;


select
	packs.created_at as measure_date,
	packs.id as pack_number,
	users.full_name,
	type_parameter.name as parameter_name,
	unit.name as unit_name,
	parameters.value
from packs
join users on packs.id_user = users.id
join parameters on parameters.id_pack = packs.id
join type_parameter on type_parameter.id = parameters.id_type_parameter
join unit on unit.id = type_parameter.id_unit;