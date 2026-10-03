-- Каждый пользователь имеет одинаковое количество измерений?
select t1.full_name, t2.packs_cnt from public.users as t1
inner join
(
	select 
		count(id) as packs_cnt,
		id_user
	from public.packs
	group by id_user
) as t2
on t1.id = t2.id_user;


-- У нас нет пустых пачек измерения?
select * from public.packs as t1
left join public.parameters as t2 on t1.id = t2.id_pack
where 
	t2.id_pack is null


-- Каждая пачка измерений содержит полное количеситво параметров (5 шт)?
select t1.name, t2.parameters_cnt from public.packs as t1
inner join
(
	select
		count(id) as parameters_cnt,
		id_pack
	from public.parameters
	group by id_pack
) as t2
on t2.id_pack = t1.id


-- Все значения который сформировал корректны и в рамках нужного нам диаппазонов?
select t1.name, t2.value from type_parameter as t1
left join
(
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
) as t2
on t2.id_type_parameter = t1.id


-- Все единицы измерения верны и корректны по отношению к указанным параметрам?
select
	t1.name as parameter_name,
	t2.name as unit_name,
	t3.name as base_unit_name
from type_parameter as t1
inner join unit as t2 on t2.id = t1.id_unit
inner join base_unit as t3 on t3.id = t2.id_base_unit;
