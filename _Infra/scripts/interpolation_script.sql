do $outer$
begin
	begin
		create type four_points as(
			x0 numeric(6, 2),
			y0 numeric(6, 2),
			x1 numeric(6, 2),
			y1 numeric(6, 2)
		);
	exception
		when duplicate_object then null;
	end;

	create or replace function get_my_points(par_temperature numeric(6, 2))
	returns four_points
	language plpgsql
	as $func$
	declare
		result four_points;
	begin
		select
			case
				when (select max(t0) from public.temperature_correction where t0 <= par_temperature) is null 
				then 0
				else (select max(t0) from public.temperature_correction where t0 <= par_temperature)
			end,

			case
				when (select delta_tv from public.temperature_correction where t0 = (select max(t0) from public.temperature_correction where t0 <= par_temperature)) is null 
				then 0
				else (select delta_tv from public.temperature_correction where t0 = (select max(t0) from public.temperature_correction where t0 <= par_temperature))
			end,

			case
				when (select min(t0) from public.temperature_correction where t0 >= par_temperature) is null 
				then 40
				else (select min(t0) from public.temperature_correction where t0 >= par_temperature)
			end,

			case
				when (select delta_tv from public.temperature_correction where t0 = (select min(t0) from public.temperature_correction where t0 >= par_temperature)) is null 
				then 4.5
				else (select delta_tv from public.temperature_correction where t0 = (select min(t0) from public.temperature_correction where t0 >= par_temperature))
			end
		into result.x0, result.y0, result.x1, result.y1;

		return result;
	end;
	$func$;


	create or replace function calc_interpolation(x_value numeric(6, 2), points four_points)
	returns numeric(6, 2)
	language plpgsql
	as $func2$
	declare
		y numeric(6, 2);
	begin
		if (points.x1 - points.x0) = 0 or (points.x1 - points.x0) is null then
			return coalesce(points.y1, points.y0);
		end if;
		
		y := points.y0 + (x_value - points.x0) * (points.y1 - points.y0) / (points.x1 - points.x0);

		return y;
	end;
	$func2$;

end $outer$;