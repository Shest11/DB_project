with pack_params as (
	select
	packs.id as pack_id, 
	public.equipment_types.name as equipment_name,
	max(public.parameter_value.value) filter (where public.type_parameter.name = 'Высота метеопоста') as height,
	max(public.parameter_value.value) filter (where public.type_parameter.name = 'Температура') as temperature,
	max(public.parameter_value.value) filter (where public.type_parameter.name = 'Давление') as pressure,
	max(public.parameter_value.value) filter (where public.type_parameter.name = 'Направление ветра') as wind_direction,
	max(public.parameter_value.value) filter (where public.type_parameter.name = 'Скорость ветра') as wind_speed,
	max(public.parameter_value.value) filter (where public.type_parameter.name = 'Дальность сноса пуль') as bullet_drift
	from packs
	join public.equipment_types on public.packs.id_equipment_type = public.equipment_types.id
	join public.parameter_value on public.parameter_value.id_pack = packs.id
	join public.type_parameter on public.type_parameter.id = public.parameter_value.id_type_parameter
	group by packs.id, equipment_name
)
select
	pack_id as "№",
	equipment_name as "Тип оборудования",
	height as "Высота метеопоста",
	temperature as "Температура",
	pressure as "Давление",
	wind_direction as "Направление ветра",
	wind_speed as "Скорость ветра",
	bullet_drift as "Дальность сноса пуль",
	(check_param(row(equipment_name, height, temperature, pressure, wind_direction, wind_speed, bullet_drift)::param_list) != '') as "Флаг: Есть ошибка",
	check_param(row(equipment_name, height, temperature, pressure, wind_direction, wind_speed, bullet_drift)::param_list) as "Описание ошибки"
from pack_params;