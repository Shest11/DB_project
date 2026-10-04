-- Каждый пользователь имеет одинаковое количество измерений?
select 
	t1.full_name,
	t1.id,
	count(t3.id) as parameters_cnt
from public.users as t1
left join packs as t2 on t1.id = t2.id_user
left join parameters as t3 on t2.id = t3.id_pack
group by t1.id


-- У нас нет пустых пачек измерения?
select t1.name, t2.parameter_cnt from public.packs as t1
left join 
(
	select 
		id_pack, 
		count(id) as parameter_cnt
	from public.parameters
	group by id_pack
) as t2
on t1.id = t2.id_pack
where t2.parameter_cnt is null


-- Каждая пачка измерений содержит полное количеситво параметров (5 шт)?
select t1.name, t2.parameters_cnt from public.packs as t1
left join
(
	select
		count(id) as parameters_cnt,
		id_pack
	from public.parameters
	group by id_pack
) as t2
on t2.id_pack = t1.id
where t2.parameters_cnt < 5 or t2.parameters_cnt is null


-- Все значения который сформировал корректны и в рамках нужного нам диаппазонов?
select * from public.parameters
where
	(id_type_parameter=2 and (value < -58 or value > 58))
	or
	(id_type_parameter=3 and (value < 500 or value > 900))
	or
	(id_type_parameter=4 and (value < 0 or value > 59))
	or
	(id_type_parameter=5 and (value < 0 or value > 15))
	or
	(id_type_parameter=6 and (value < 0 or value > 150))


-- Все единицы измерения верны и корректны по отношению к указанным параметрам?
select * from type_parameter as t1
inner join unit on t1.id_unit = unit.id
where
	(t1.id = 1 and unit.name != 'Метр')
	or
	(t1.id = 2 and unit.name != '°C')
	or
	(t1.id = 3 and unit.name != 'мм рт ст')
	or
	(t1.id = 4 and unit.name != 'Деление угломера')
	or
	(t1.id = 5 and unit.name != 'м/с')
	or
	(t1.id = 6 and unit.name != 'Метр')