-- Домашняя работа от 2026-11-02
do $$
begin

	-- Создаем новые структуры
	begin
		
		-- Таблица стандартных высот
		create sequence calc_correction_height_seq;
		create table calc_correction_heights
		(
		        id integer primary key not null default nextval('public.calc_correction_height_seq'),
		        height integer not null
		);
		
		
		insert into calc_correction_heights(height)
		values(200),(400),(800),(1200),(1600),(2000),(2400),(3000),(4000);
	
		comment on table calc_correction_heights is 'Таблица стандартных высот';
		comment on column calc_correction_heights.id is 'Уникальный код';
		comment on column calc_correction_heights.height is 'Высота';
	
		-- Справочник типов таблиц корректировок
		create sequence calc_correction_types_seq;
		create table calc_correction_types
		(
		        id integer not null primary key default nextval('public.calc_correction_types_seq'),
		        parent_id integer,
		        measurment_equipment_id integer,
		        description text not null,
		        header_values integer[]
		);
	
		comment on table calc_correction_types is 'Справочник типов таблиц с собственными заголовками';
		comment on column calc_correction_types.id is 'Уникальный код';
		comment on column calc_correction_types.parent_id is 'Уникальный код владельца - тип таблицы';
		comment on column calc_correction_types.measurment_equipment_id is 'Тип оборудования';
		comment on column calc_correction_types.description is 'Описание к таблице';
		comment on column calc_correction_types.header_values is 'Значения в заголовке таблице';

		-- Универсальная таблица корректировок
		create sequence calc_correction_seq;
		create table calc_correction
		(
		        id integer not null primary key default nextval('public.calc_correction_seq'),
		        height_id integer not null,
		        type_id integer not null,
		        row_values integer[]
		);

		comment on table calc_correction is 'Универсальная таблица корректировок';
		comment on column calc_correction.id is 'Уникальный код';
		comment on column calc_correction.height_id is 'Код высоты';
		comment on column calc_correction.type_id is 'Код типа таблиц';
		comment on column calc_correction.row_values is 'Значения с корректировками';

	end;	

	-- Добавляем данные
	begin

		
		insert into calc_correction_types(  description, header_values)
		values( 'Таблица 2', array[0, 1, 2, 3, 4, 5, 6, 7, 8, 8, 10, 20, 30, 40, 50]),  -- 1
		( 'Таблица 3, скорость среднего ветра', null), -- 2
		( 'Таблица 3, направление среднего ветра', null);       -- 3

		insert into calc_correction_types( description, parent_id, measurment_equipment_id, header_values)
		values
		('Таблица 3, Скорость среднего ветра (ВР)', 2, 2, array[40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150]), -- 4
		('Таблица 3, Направление среднего ветра (ВР)',3, 2, array[40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150]), -- 5
		('Таблица 3, Скорость среднего ветра (ДМК)',2, 1, array[3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]), -- 6
		('Таблица 3, Направление среднего ветра (ДМК)',3, 1, array[3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]); -- 7
		
		insert into calc_correction_types( description, parent_id)
		values('Таблица 2, Положительные температуры', 1 ), -- 8
		('Таблица 2, Отрицательные температуры', 1 ) --9
		;

		
		insert into calc_correction(height_id, type_id, row_values )
		-- Таблица 2, отрицптельные значения
		values(1, 8, array[-1, -2, -3, -4, -5, -6, -7, -8, -8, -9, -20, -29, -39, -49]), -- 200
		(2, 8, array[-1, -2, -3, -4, -5, -6, -6, -7, -8, -9, -19, -29, -39, -48]), -- 400
		(3, 8, array[-1, -2, -3, -4, -5, -6, -6, -7, -7, -8, -18, -28, -37, -46]), -- 800
		(4, 8, array[-1, -2, -3, -4, -4, -5, -5, -6, -7, -8, -17, -26, -35, -44]), -- 1200
		-- Таблица 2, положитеьные значения
		(1, 7, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 200
		(2, 7, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 400
		(3, 7, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 800
		(4, 7, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]), -- 1200
		-- Таблица 3, Скорость среднего ветра (ВР)
		(1, 4, array[3, 4, 5, 6, 7, 7, 8, 9, 10, 11, 12, 12]), -- 200
		(2, 4, array[4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 ,15]), -- 400
		(3, 4, array[4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15 ,16]), -- 800
		(4, 4, array[4, 5, 7, 8, 8, 9, 11, 12, 13, 15 ,15, 16]), -- 1200
		-- Таблица 3, Направление среднего ветра (ВР)
		(1, 5, array[0]), -- 200
		(2, 5, array[1]), -- 400
		(3, 5, array[2]), -- 800
		(4, 5, array[2]), -- 1200
		-- Таблица 3,Скорость среднего ветра (ДМК)
		(1, 6, array[4,6,8,9,10,12,14,15,16,18,20,21,22]), -- 200
		(2, 6, array[5,7,10,11,12,14,17,18,20,22,23,25,27]), -- 400
		(3, 6, array[5,8,10,11,13,15,18,19,21,23,25,27,28]), -- 800
		(4, 6, array[5,8,11,12,13,16,19,20,23,24,26,28,30]), -- 1200
		-- 'Таблица 3, Направление среднего ветра (ДМК)
		(1, 7, array[1]), -- 200
		(2, 7, array[2]), -- 400
		(3, 7, array[3]), -- 800
		(4, 7, array[3]) -- 1200
		;
		
	end;

	-- Прочее
	begin


		
				
		CREATE OR REPLACE FUNCTION public.fn_calc_temperature_interpolation(
		par_temperature numeric)
		RETURNS numeric
		LANGUAGE 'plpgsql'
		COST 100
		VOLATILE PARALLEL UNSAFE
		AS $BODY$
				        declare 
				                var_interpolation four_points;
				                var_result numeric(8,2) default 0;
				                var_min_temparure numeric(8,2) default 0;
				                var_max_temperature numeric(8,2) default 0;
				                var_denominator numeric(8,2) default 0;
				        begin
				
				                                raise notice 'Расчет интерполяции для температуры %', par_temperature;
				
				                -- Проверим, возможно температура совпадает со значением в справочнике
				                if exists (select 1 from public.temperature_correction where t0 = par_temperature ) then
				                begin
				                        select delta_tv 
				                        into  var_result 
				                        from  public.temperature_correction
				                        where 
				                                t0 = par_temperature;
				                end;
				                else    
				                begin
				                        -- Получим диапазон в котором работают поправки
				                        select min(t0), max(t0) 
				                        into var_min_temparure, var_max_temperature
				                        from public.temperature_correction;
				
				                        if par_temperature < var_min_temparure or   
				                           par_temperature > var_max_temperature then
				
				                                raise exception 'Некорректно передан параметр! Невозможно рассчитать поправку. Значение должно укладываться в диаппазон: %, %',
				                                        var_min_temparure, var_max_temperature;
				                        end if;   
				
				                        -- Получим граничные параметры
				
				                        select x0, y0, x1, y1 
				                                                 into var_interpolation.x0, var_interpolation.y0, var_interpolation.x1, var_interpolation.y1
				                        from
				                        (
				                                select t1.t0 as x0, t1.delta_tv as y0
				                                from public.temperature_correction as t1
				                                where t1.t0 <= par_temperature
				                                order by t1.t0 desc
				                                limit 1
				                        ) as leftPart
				                        cross join
				                        (
				                                select t1.t0 as x1, t1.delta_tv as y1
				                                from public.temperature_correction as t1
				                                where t1.t0 >= par_temperature
				                                order by t1.t0 
				                                limit 1
				                        ) as rightPart;
				
				                        raise notice 'Граничные значения %', var_interpolation;
				                        var_result :=  calc_interpolation( par_temperature,  var_interpolation);
				                                                 
				                end;
				                end if;
				
				                                return var_result;
				
				end;
				
		$BODY$;
		
		COMMENT ON FUNCTION public.fn_calc_temperature_interpolation(numeric)
		    IS 'Функция для расчета интерполяции для метео приближенный';
	end;


	-- создаем отдельную таблицу заголовков
	begin

		create sequence header_values_seq;

		create table header_values(
			id int primary key default nextval('header_values_seq'),
			type_id int not null references calc_correction_types(id) on delete cascade,
			position int,
			head_value numeric(6, 2)
		);

		comment on table header_values is 'Таблица хранения заголовков';
		comment on column header_values.id is 'Уникальный код';
		comment on column header_values.type_id is 'Код типа таблицы';
		comment on column header_values.position is 'Позиция заголовка';
		comment on column header_values.head_value is 'Значение заголовка';
		
	end;

	-- правим данные
	begin

		update calc_correction set type_id = 9 where type_id = 8;
		update calc_correction set type_id = 8 where type_id = 7 and cardinality(row_values) > 1;

		update calc_correction set row_values[13] = -38 where height_id = 2 and type_id = 9;
		update calc_correction set row_values[9] = 22 where height_id = 4 and type_id = 6;

		update calc_correction_types
		set header_values = array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, 40, 50]
		where id = 1;

	end;

	-- заполняем таблицу заголовков 
	begin

		insert into header_values (type_id, position, head_value)
		select id, pos, val
		from calc_correction_types, 
	    unnest(header_values) with ordinality as t(val, pos);

		alter table calc_correction_types drop column header_values;
		
	end;


	-- добавляем недостоющие данные
	begin 
		insert into calc_correction (height_id, type_id, row_values)
		values 
		-- Высота 1600 (height_id = 5)
		-- Тип 9: Таблица 2, Отрицательные (14 элементов)
		(5, 9, array[-1, -2, -3, -3, -4, -4, -5, -6, -7, -7, -17, -25, -34, -42]),
		-- Тип 8: Таблица 2, Положительные (12 элементов, так как 40 и 50 прочерки)
		(5, 8, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]),
		-- Тип 4: Таблица 3, Скорость ВР (12 элементов)
		(5, 4, array[4, 6, 7, 8, 9, 10, 11, 13, 14, 15, 17, 17]),
		-- Тип 5: Таблица 3, Направление ВР (1 элемент - приращение)
		(5, 5, array[3]),
		-- Тип 6: Таблица 3, Скорость ДМК (13 элементов)
		(5, 6, array[6, 8, 11, 13, 14, 17, 20, 21, 23, 25, 27, 29, 32]),
		-- Тип 7: Таблица 3, Направление ДМК (1 элемент)
		(5, 7, array[4]),
		
		-- Высота 2000 (height_id = 6)
		(6, 9, array[-1, -2, -3, -3, -4, -4, -5, -6, -6, -7, -16, -24, -32, -40]),
		(6, 8, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]),
		(6, 4, array[4, 6, 7, 8, 9, 10, 11, 13, 14, 16, 17, 18]),
		(6, 5, array[3]),
		(6, 6, array[6, 9, 11, 13, 14, 17, 20, 21, 24, 26, 28, 30, 32]),
		(6, 7, array[4]),
		
		-- Высота 2400 (height_id = 7)
		(7, 9, array[-1, -2, -2, -3, -4, -4, -5, -5, -6, -7, -15, -23, -31, -38]),
		(7, 8, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]),
		(7, 4, array[4, 6, 8, 9, 9, 10, 12, 14, 15, 16, 18, 19]),
		(7, 5, array[3]),
		(7, 6, array[6, 9, 12, 14, 15, 18, 21, 22, 25, 27, 29, 32, 34]),
		(7, 7, array[4]),
		
		-- Высота 3000 (height_id = 8)
		(8, 9, array[-1, -2, -2, -3, -4, -4, -4, -5, -5, -6, -15, -22, -30, -37]),
		(8, 8, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]),
		(8, 4, array[5, 6, 8, 9, 10, 11, 12, 14, 15, 17, 18, 19]),
		(8, 5, array[4]),
		(8, 6, array[6, 9, 12, 14, 15, 18, 21, 23, 25, 28, 30, 32, 36]),
		(8, 7, array[5]),
		
		-- Высота 4000 (height_id = 9)
		(9, 9, array[-1, -2, -2, -3, -4, -4, -4, -4, -5, -6, -14, -20, -27, -34]),
		(9, 8, array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30]),
		(9, 4, array[5, 6, 8, 9, 10, 11, 12, 14, 16, 18, 19, 20]),
		(9, 5, array[4]),
		(9, 6, array[6, 10, 12, 14, 16, 19, 22, 24, 26, 29, 32, 34, 36]),
		(9, 7, array[5]);

	end;

	-- создаем процедуру
	begin
		create or replace procedure public.proc_calc_meteo_by_heights(par_params public.param_list)
		language plpgsql
		as $proc$
		declare
		    var_table_temp numeric;
		    var_input numeric;
		    var_type_speed integer;
		    var_type_dir integer;
		    var_type_temp integer;
		    var_type_temp_head integer;
		    
		    var_delta_tv numeric;
		    var_delta_t0 integer;
		    var_tens integer;
		    var_units integer;
		    
		    var_x0 numeric;
		    var_x1 numeric;
		    var_zero_wind boolean;
		    
		    var_sum numeric;
		    var_y0 numeric;
		    var_y1 numeric;
		    var_speed numeric;
		    var_shift integer;
		    
		    var_pos integer;
		    var_row integer[];

		    var_const_circle integer;
		    var_const_tens integer;
		    var_const_offset integer;
		    
		    rec record;
		begin
		    -- проверка входных данных
		    if public.check_param(par_params) != '' then
		        raise exception 'Ошибка параметров: %', public.check_param(par_params);
		    end if;
		
		    -- получаем константы из БД
		    select const_value into var_table_temp from public.calc_constants where const_name = 'base_virtual_temperature';
		    select const_value into var_const_circle from public.calc_constants where const_name = 'goniometer_circle';
		    select const_value into var_const_tens from public.calc_constants where const_name = 'temp_tens_base';
		    select const_value into var_const_offset from public.calc_constants where const_name = 'negative_temp_offset';
		    
		    if var_table_temp is null or var_const_circle is null or var_const_tens is null or var_const_offset is null then
		        raise exception 'В таблице calc_constants не хватает необходимых констант для расчета';
		    end if;
		
		    -- временная таблица для результатов
		    create temp table if not exists temp_meteo_out (
		        height_m integer, h text, tt text, hh text, cc text
		    ) on commit preserve rows;
		    
		    truncate table temp_meteo_out;
		
		    -- настройка под оборудование
		    if par_params.equipment_type = 'ДМК' then
		        var_type_speed := 6;
		        var_type_dir := 7;
		        var_input := par_params.wind_speed::numeric;
		    elsif par_params.equipment_type = 'ВР' then
		        var_type_speed := 4;
		        var_type_dir := 5;
		        var_input := par_params.bullet_drift::numeric;
		    else
		        raise exception 'Неизвестный тип оборудования: %', par_params.equipment_type;
		    end if;
		
		    -- расчет отклонения температуры
		    var_delta_tv := public.calc_interpolation(
		        par_params.temperature, 
		        public.get_my_points(par_params.temperature)
		    );
		    
		    var_delta_t0 := round(par_params.temperature + var_delta_tv - var_table_temp)::integer;
		
		    -- используем константу для десятков
		    var_tens  := (abs(var_delta_t0) / var_const_tens) * var_const_tens;
		    var_units := abs(var_delta_t0) % var_const_tens;
		    
		    var_type_temp := case when var_delta_t0 < 0 then 9 else 8 end;
		    
		    -- ищем родителя для заголовков
		    select coalesce(parent_id, id) into var_type_temp_head 
		    from public.calc_correction_types where id = var_type_temp;
		
		    -- проверка ветра на ноль
		    select min(head_value) into var_x0 from public.header_values where type_id = var_type_speed;
		    var_zero_wind := var_input < var_x0;
		
		    if not var_zero_wind then
		        select max(head_value) into var_x0 from public.header_values where type_id = var_type_speed and head_value <= var_input;
		        select min(head_value) into var_x1 from public.header_values where type_id = var_type_speed and head_value >= var_input;
		        var_x1 := coalesce(var_x1, var_x0);
		    end if;
		
		    -- цикл по высотам
		    for rec in select id, height from public.calc_correction_heights order by height
		    loop
		        -- температура
		        var_sum := 0;
		        if var_tens > 0 then 
		            select hv.position into var_pos from public.header_values hv where hv.type_id = var_type_temp_head and hv.head_value = var_tens;
		            select c.row_values into var_row from public.calc_correction c where c.type_id = var_type_temp and c.height_id = rec.id;
		            var_sum := var_sum + coalesce(var_row[var_pos], 0);
		        end if;
		
		        if var_units > 0 then 
		            select hv.position into var_pos from public.header_values hv where hv.type_id = var_type_temp_head and hv.head_value = var_units;
		            select c.row_values into var_row from public.calc_correction c where c.type_id = var_type_temp and c.height_id = rec.id;
		            var_sum := var_sum + coalesce(var_row[var_pos], 0);
		        end if;
		
		        -- ветер
		        if var_zero_wind then
		            var_speed := 0;
		            var_shift := 0;
		        else
		            select hv.position into var_pos from public.header_values hv where hv.type_id = var_type_speed and hv.head_value = var_x0;
		            select c.row_values into var_row from public.calc_correction c where c.type_id = var_type_speed and c.height_id = rec.id;
		            var_y0 := coalesce(var_row[var_pos], 0);
		
		            select hv.position into var_pos from public.header_values hv where hv.type_id = var_type_speed and hv.head_value = var_x1;
		            select c.row_values into var_row from public.calc_correction c where c.type_id = var_type_speed and c.height_id = rec.id;
		            var_y1 := coalesce(var_row[var_pos], 0);
		
		            if var_x0 = var_x1 then
		                var_speed := var_y0;
		            else
		                var_speed := round(public.calc_interpolation(
		                    var_input, row(var_x0, var_y0, var_x1, var_y1)::public.four_points
		                ));
		            end if;
		
		            select row_values[1] into var_shift from public.calc_correction where type_id = var_type_dir and height_id = rec.id;
		            var_shift := coalesce(var_shift, 0);
		        end if;
		
		        -- запись результата
		        insert into temp_meteo_out (height_m, h, tt, hh, cc) values (
		            rec.height,
		            lpad((rec.height / 100)::text, 2, '0'),
		            case when var_delta_t0 < 0 then lpad((abs(var_sum) + var_const_offset)::text, 2, '0') else lpad(var_sum::text, 2, '0') end,
		            case when var_zero_wind then '00' else lpad((((par_params.wind_direction + var_shift) % var_const_circle + var_const_circle) % var_const_circle)::text, 2, '0') end,
		            case when var_zero_wind then '00' else lpad(var_speed::text, 2, '0') end
		        );
		    end loop;
		end;
		$proc$;
	end;
		
end $$;