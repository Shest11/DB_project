-- Создание таблиц и счетчиков
do $$
	begin
		-- base_unit
		create sequence base_unit_id_seq;
	
		create table base_unit(
			id int primary key default nextval('base_unit_id_seq'),
			name varchar(100)
		);
	
		alter sequence base_unit_id_seq owned by base_unit.id;

		comment on table base_unit is 'Базовая ед. измерения';
		comment on column base_unit.name is 'Название базовой ед. измерения';

	
		-- equipment_types
		create sequence equipment_types_id_seq;
	
		create table equipment_types(
			id int primary key default nextval('equipment_types_id_seq'),
			name varchar(50)
		);
	
		alter sequence equipment_types_id_seq owned by equipment_types.id;

		comment on table equipment_types is 'Тип измерительного устрой-ва';
		comment on column equipment_types.name is 'Название измерительного устрой-ва';
	
	
		-- packs
		create sequence packs_id_seq;
	
		create table packs(
			id int primary key default nextval('packs_id_seq'),
			name varchar(100),
			measurment_date timestamp
		);
	
		alter sequence packs_id_seq owned by packs.id;
	
		comment on table packs is 'Пачка';
		comment on column packs.name is 'Название пачки';
		comment on column packs.measurment_date is 'Дата измерения';
		
		
		-- parameter_value
		create sequence parameter_value_id_seq;
	
		create table parameter_value(
			id int primary key default nextval('parameter_value_id_seq'),
			value decimal(4, 1)
		);
	
		alter sequence parameter_value_id_seq owned by parameter_value.id;

		comment on table parameter_value is 'Значение параметра';
		
	
		-- ranks
		create sequence ranks_id_seq;
	
		create table ranks(
			id int primary key default nextval('ranks_id_seq'),
			name varchar(100)
		);
	
		alter sequence ranks_id_seq owned by ranks.id;

		comment on table ranks is 'Звания/Должности';
		comment on column ranks.name is 'Название звания/должности';
		
		
		-- type_parameter
		create sequence type_parameter_id_seq;
	
		create table type_parameter(
			id int primary key default nextval('type_parameter_id_seq'),
			name varchar(100)
		);
	
		alter sequence type_parameter_id_seq owned by type_parameter.id;

		comment on table type_parameter is 'Тип параметра';
		comment on column type_parameter.name is 'Название типа параметра';
	
		-- unit
		create sequence unit_id_seq;
	
		create table unit(
			id int primary key default nextval('unit_id_seq'),
			name varchar(100)
		);
	
		alter sequence unit_id_seq owned by unit.id;

		comment on table unit is 'Ед. измерения';
		comment on column unit.name is 'Название ед. измерения';
	
		-- users
		create sequence users_id_seq;
	
		create table users(
			id int primary key default nextval('users_id_seq'),
			full_name varchar(100)
		);
	
		alter sequence users_id_seq owned by users.id;

		comment on table users is 'Пользователь';
		comment on column users.full_name is 'ФИО';

		
		-- temperature_correction
		create sequence temperature_correction_id_seq;
		
		create table temperature_correction(
			id int primary key default nextval('temperature_correction_id_seq'),
			t0 decimal(4, 1),
			delta_tv decimal(4, 1)
		);

		alter sequence temperature_correction_id_seq owned by temperature_correction.id;

		comment on table temperature_correction is 'Температурная коррекция';
		comment on column temperature_correction.t0 is 'Приземная температура воздуха';
		comment on column temperature_correction.delta_tv is 'Виртуальная поправка';
		
	commit;


-- Tестовые данные

		insert into ranks(name) values('Начальник метеопоста');
		insert into ranks(name) values('Метеоролог');
	
		insert into equipment_types(name) values('ДМК');
		insert into equipment_types(name) values('ВР');
	
		insert into base_unit(name) values('Длина');
		insert into base_unit(name) values('Температура');
		insert into base_unit(name) values('Давление');
		insert into base_unit(name) values('Угол');
		insert into base_unit(name) values('Скорость');
	
		insert into unit(name) values('Метр');
		insert into unit(name) values('°C');
		insert into unit(name) values('мм рт ст');
		insert into unit(name) values('Деление угломера');
		insert into unit(name) values('м/с');
	
		insert into type_parameter(name) values('Высота метеопоста');
		insert into type_parameter(name) values('Температура');
		insert into type_parameter(name) values('Давление');
		insert into type_parameter(name) values('Направление ветра');
		insert into type_parameter(name) values('Скорость ветра');
		insert into type_parameter(name) values('Дальность сноса пуль');
	
		insert into users(full_name) values('Иванов Иван Иванович');
		insert into users(full_name) values('Петров Петр Петрович');
	
		insert into packs(name, measurment_date) values('Пачка 1', '2026-09-19 09:30:00');
		insert into packs(name, measurment_date) values('Пачка 2', '2026-09-19 10:10:00');
	
		insert into parameter_value(value) values(100);
		insert into parameter_value(value) values(25);
		insert into parameter_value(value) values(765);
	commit;


-- Связи между таблицами

		-- unit -> base_unit
		alter table unit add column id_base_unit int references base_unit(id);

		comment on column unit.id_base_unit is 'Код базовой ед. измерения';
	
		-- type_parameter -> unit
		alter table type_parameter add column id_unit int references unit(id);

		comment on column type_parameter.id_unit is 'Код ед. измерения';
	
		-- users -> ranks
		alter table users add column id_rank int references ranks(id);

		comment on column users.id_rank is 'Код звания/должности';
	
		-- packs -> users, packs -> equipment_types
		alter table packs add column id_user int references users(id);
		alter table packs add column id_equipment_type int references equipment_types(id);

		comment on column packs.id_user is 'Код пользователя';
		comment on column packs.id_equipment_type is 'Код измерительного устрой-ва';
	
		-- parameter_value -> packs, parameter_value -> type_parameter
		alter table parameter_value add column id_pack int references packs(id);
		alter table parameter_value add column id_type_parameter int references type_parameter(id);

		comment on column parameter_value.id_pack is 'Код пачки';
		comment on column parameter_value.id_type_parameter is 'Код типа параметра';
	
		-- связываем уже существующие тестовые данные
		update users set id_rank = 1 where id = 1;
		update users set id_rank = 2 where id = 2;
	
		update packs set id_user = 1, id_equipment_type = 1 where id = 1;
		update packs set id_user = 2, id_equipment_type = 2 where id = 2;
	
		update type_parameter set id_unit = 1 where id = 1;
		update type_parameter set id_unit = 2 where id = 2;
		update type_parameter set id_unit = 3 where id = 3;
		update type_parameter set id_unit = 4 where id = 4;
		update type_parameter set id_unit = 5 where id = 5;
		update type_parameter set id_unit = 1 where id = 6;
	
		update unit set id_base_unit = 1 where id = 1;
		update unit set id_base_unit = 2 where id = 2;
		update unit set id_base_unit = 3 where id = 3;
		update unit set id_base_unit = 4 where id = 4;
		update unit set id_base_unit = 5 where id = 5;
	commit;
end $$;