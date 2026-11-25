do $$
declare
	date_start date := date '2012-01-01';
	date_end date := date '2023-12-06';
begin
	begin
		create sequence seq_dim_time;

		create table dim_time (
			id bigint primary key default nextval('seq_dim_time'),
			month_start date,
			month_end date,
			month_name varchar(20),
			year int,
			quarter_number int,
			quarter_name text
		);

		comment on table dim_time is 'Время ресурс/метрика';
		comment on column dim_time.id is 'Уникальный код';
		comment on column dim_time.month_start is 'Дата начала месяца';
		comment on column dim_time.month_end is 'Дата окончания месяца';
		comment on column dim_time.month_name is 'Название месяца';
		comment on column dim_time.year is 'Год';
		comment on column dim_time.quarter_number is 'Номер квартала';
		comment on column dim_time.quarter_name is 'Название квартала';

	end;

	begin
		insert into dim_time(month_start, month_end, month_name, year, quarter_number, quarter_name)
		select
			cast(m as date),
			cast(m + interval '1 month' - interval '1 day' as date),
			(array['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'])[cast(extract(month from m) as int)],
			cast(extract(year from m) as int),
			cast(extract(quarter from m) as int),
			cast(extract(quarter from m) as text) || ' квартал'
		from generate_series(date_start, date_end, interval '1 month') as m;
	
	end;
		
end $$;

select * from dim_time