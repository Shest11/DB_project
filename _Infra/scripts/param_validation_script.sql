do $$
begin
	-- Создание Списка параметров
	begin
		create type param_list as (
			equipment_type varchar(10),
			height int, -- Высота метеопоста
			temperature decimal(3, 1), -- Температура
			pressure int, -- Давление
			wind_direction int, -- Направление ветра
			wind_speed int, -- Скорость ветра
			bullet_drift int -- Дальность сноса пуль
		);

		comment on type param_list is 'Список параметров';

	exception
		when duplicate_object then null;
	end;


	-- Созданиe Лимитов для параметров
	begin
		create sequence param_limits_id_seq;
		
		create table param_limits(
			id int primary key default nextval('param_limits_id_seq'),
			param_name varchar(100),
			min_limit numeric(4, 1),
			max_limit numeric(4, 1),
			error_text text
		);

		comment on table param_limits is 'Диапазон параметра';
		comment on column param_limits.param_name is 'Название типа параметра';
		comment on column param_limits.min_limit is 'Минимальный лимит';
		comment on column param_limits.max_limit is 'Максимальный лимит';
		comment on column param_limits.error_text is 'Текст ошибки';
		
	exception
		when duplicate_table then null;
	end;


	-- Заполнение таблицы Лимитов для параметров
	begin
		insert into param_limits(param_name, min_limit, max_limit, error_text) values
		('temperature', -58, 58, 'Температура вне диапазона: должна быть от -58 до 58'),
		('pressure', 500, 900, 'Давление вне диапазона: должно быть от 500 до 900'),
		('wind_direction', 0, 59, 'Направление ветра вне диапазона: должно быть от 0 до 59'),
		('wind_speed', 0, 15, 'Скорость ветра вне диапазона: должна быть от 0 до 15'),
		('bullet_drift', 0, 150, 'Дальность сноса пуль вне диапазона: должна быть от 0 до 150');
	end;
	commit;

	-- Создание функции для проверки параметров
	create or replace function check_param(param_list param_list)
	returns text
	language plpgsql
	as $func$

	declare
		result text = '';
		max_l numeric(4, 1);
		min_l numeric(4, 1);
		err_text text;
	begin
	
		select min_limit, max_limit, error_text
		into min_l, max_l, err_text
		from param_limits
		where param_name = 'temperature';

		if param_list.temperature not between min_l and max_l then
			result := result || err_text || ';';
		end if;

		select min_limit, max_limit, error_text
		into min_l, max_l, err_text
		from param_limits
		where param_name = 'pressure';

		if param_list.pressure not between min_l and max_l then
			result := result || err_text || ';';
		end if;

		select min_limit, max_limit, error_text
		into min_l, max_l, err_text
		from param_limits
		where param_name = 'wind_direction';

		if param_list.wind_direction not between min_l and max_l then
			result := result || err_text || ';';
		end if;

		select min_limit, max_limit, error_text
		into min_l, max_l, err_text
		from param_limits
		where param_name = 'wind_speed';

		if param_list.equipment_type = 'ДМК' and param_list.wind_speed not between min_l and max_l then
			result := result || err_text || ';';
		end if;

		select min_limit, max_limit, error_text
		into min_l, max_l, err_text
		from param_limits
		where param_name = 'bullet_drift';

		if param_list.equipment_type = 'ВР' and param_list.bullet_drift not between min_l and max_l then
			result := result || err_text || ';';
		end if;

		return result;
	end;
	$func$;

	comment on function check_param is 'Проверка Списка параметров';
	
end $$;