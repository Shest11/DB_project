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


-- Значение параметра
create table if not exists parameter_value(
	id int primary key,
	id_pack int references packs(id),
	id_type_parameter int references type_parameter(id),
	value decimal(4, 1)
);


-- Переносим данные из старой parameters в parameter_value


insert into parameter_value(id, id_pack, id_type_parameter, value)
select 1, packs.id, 1, parameters.height
from packs
join parameters on packs.id_parameter = parameters.id
where packs.id = 1;

insert into parameter_value(id, id_pack, id_type_parameter, value)
select 2, packs.id, 1, parameters.height
from packs
join parameters on packs.id_parameter = parameters.id
where packs.id = 2;

insert into parameter_value(id, id_pack, id_type_parameter, value)
select 3, packs.id, 2, parameters.temperature
from packs
join parameters on packs.id_parameter = parameters.id
where packs.id = 1;

insert into parameter_value(id, id_pack, id_type_parameter, value)
select 4, packs.id, 2, parameters.temperature
from packs
join parameters on packs.id_parameter = parameters.id
where packs.id = 2;

insert into parameter_value(id, id_pack, id_type_parameter, value)
select 5, packs.id, 3, parameters.pressure
from packs
join parameters on packs.id_parameter = parameters.id
where packs.id = 1;

insert into parameter_value(id, id_pack, id_type_parameter, value)
select 6, packs.id, 3, parameters.pressure
from packs
join parameters on packs.id_parameter = parameters.id
where packs.id = 2;

insert into parameter_value(id, id_pack, id_type_parameter, value)
select 7, packs.id, 4, parameters.wind_direction
from packs
join parameters on packs.id_parameter = parameters.id
where packs.id = 1;

insert into parameter_value(id, id_pack, id_type_parameter, value)
select 8, packs.id, 4, parameters.wind_direction
from packs
join parameters on packs.id_parameter = parameters.id
where packs.id = 2;

insert into parameter_value(id, id_pack, id_type_parameter, value)
select 9, packs.id, 5, parameters.wind_speed
from packs
join parameters on packs.id_parameter = parameters.id
where packs.id = 1 and parameters.wind_speed is not null;

insert into parameter_value(id, id_pack, id_type_parameter, value)
select 10, packs.id, 5, parameters.wind_speed
from packs
join parameters on packs.id_parameter = parameters.id
where packs.id = 2 and parameters.wind_speed is not null;

insert into parameter_value(id, id_pack, id_type_parameter, value)
select 11, packs.id, 6, parameters.bullet_drift
from packs
join parameters on packs.id_parameter = parameters.id
where packs.id = 1 and parameters.bullet_drift is not null;

insert into parameter_value(id, id_pack, id_type_parameter, value)
select 12, packs.id, 6, parameters.bullet_drift
from packs
join parameters on packs.id_parameter = parameters.id
where packs.id = 2 and parameters.bullet_drift is not null;


-- Удаляем колонку связанную с табл. parameters
alter table packs drop column if exists id_parameter;

-- Удаляем всю таблицу parameters
drop table if exists parameters;

-- Исправляем дату измерения у тестовых пачек
update packs set created_at = timestamp '2026-09-19 09:30:00' where id = 1;
update packs set created_at = timestamp '2026-09-19 10:10:00' where id = 2;


select
	packs.created_at as measure_date,
	packs.id as pack_number,
	users.full_name,
	type_parameter.name as parameter_name,
	unit.name as unit_name,
	parameter_value.value
from packs
join users on packs.id_user = users.id
join parameter_value on parameter_value.id_pack = packs.id
join type_parameter on type_parameter.id = parameter_value.id_type_parameter
join unit on unit.id = type_parameter.id_unit;