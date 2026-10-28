do $$
begin
	begin
		create sequence calc_constants_id_seq;
		create table calc_constants(
			id int primary key default nextval('calc_constants_id_seq'),
			const_name varchar(100),
			const_value numeric(6,2),
			description text
		);
		comment on table calc_constants is 'Табличные константы для расчёта Метео-11';
		comment on column calc_constants.const_name is 'Имя константы';
		comment on column calc_constants.const_value is 'Значение константы';
		comment on column calc_constants.description is 'Описание';
	exception
		when duplicate_table then null;
	end;

	insert into calc_constants(const_name, const_value, description) values
	('base_pressure', 750, 'Табличное значение наземного давления, мм рт. ст.'),
	('base_virtual_temperature', 15.9, 'Табличное значение приземной виртуальной температуры, °C')

end $$;