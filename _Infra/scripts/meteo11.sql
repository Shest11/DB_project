do $$
begin
	create or replace function calc_ddchm(par_datetime timestamp)
	returns text
	language plpgsql
	as $func1$
	declare
		v_dd text;
		v_chch text;
		v_m text;
	begin
		v_dd := lpad(extract(day from par_datetime)::text, 2, '0');
		v_chch := lpad(extract(hour from par_datetime)::text, 2, '0');
		v_m := floor(extract(minute from par_datetime) / 10)::text;

		return v_dd || v_chch || v_m;
	end;
	$func1$;
	
	comment on function calc_ddchm is 'ДДЧЧМ: день месяца + часы + десятки минут';


	create or replace function calc_vvvv(par_height int)
	returns text
	language plpgsql
	as $func2$
	begin
		return lpad(par_height::text, 4, '0');
	end;
	$func2$;

	comment on function calc_vvvv is 'ВВВВ: высота метеопоста, 4 знака с ведущими нулями';
	

	create or replace function calc_bbbtt(par_pressure int, par_temperature numeric)
	returns text
	language plpgsql
	as $func3$
	declare
		v_delta_pressure int;
		v_bbb text;
		v_delta_tv numeric;
		v_t0 numeric;
		v_delta_t0 numeric;
		v_tt text;
	begin
		-- БББ
		v_delta_pressure := par_pressure - 750;
		if v_delta_pressure < 0 then
			v_bbb := '5' || lpad(abs(v_delta_pressure)::text, 2, '0');
		else
			v_bbb := lpad(v_delta_pressure::text, 3, '0');
		end if;

		-- ТТ 
		v_delta_tv := calc_interpolation(par_temperature, get_my_points(par_temperature));
		v_t0 := par_temperature + v_delta_tv;
		v_delta_t0 := round(v_t0 - 15.9);
		v_tt := lpad(abs(v_delta_t0)::text, 2, '0');

		return v_bbb || v_tt;
	end;
	$func3$;

	comment on function calc_bbbtt is 'БББТТ: отклонение давления (БББ) + отклонение температуры (ТТ)';


	create or replace function calc_meteo11(
		par_datetime timestamp,
		par_height int,
		par_pressure int,
		par_temperature numeric
	)
	returns text
	language plpgsql
	as $func4$
	begin
		return calc_ddchm(par_datetime) || calc_vvvv(par_height) || calc_bbbtt(par_pressure, par_temperature);
	end;
	$func4$;

	comment on function calc_meteo11 is 'Расчет ДДЧЧМ(День, час, минуты), ВВВВ(высота метеопоста), БББТТ(БББ(отклонение давления),  ТТ(отклонение температуры))';


end $$;