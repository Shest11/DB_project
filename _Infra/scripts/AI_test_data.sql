-- Новые сотрудники
insert into users(id, full_name, id_rank) values(3, 'Сидоров Алексей Викторович', 1);
insert into users(id, full_name, id_rank) values(4, 'Кузнецова Мария Ивановна', 2);
insert into users(id, full_name, id_rank) values(5, 'Волков Дмитрий Сергеевич', 2);
-- Пачки измерений (разные пользователи, даты, оборудование)
insert into packs(id, name, id_user, id_equipment_type, created_at) 
values(3, 'Пачка 3', 3, 1, '2026-09-15 08:20:00');
insert into packs(id, name, id_user, id_equipment_type, created_at) 
values(4, 'Пачка 4', 4, 2, '2026-09-22 11:45:00');
insert into packs(id, name, id_user, id_equipment_type, created_at) 
values(5, 'Пачка 5', 5, 1, '2026-10-02 14:10:00');
insert into packs(id, name, id_user, id_equipment_type, created_at) 
values(6, 'Пачка 6', 3, 2, '2026-10-05 09:05:00');
-- Параметры для Пачки 3 (ДМК — со скоростью ветра)
insert into parameters(id, id_pack, id_type_parameter, value) values(13, 3, 1, 120.0);
insert into parameters(id, id_pack, id_type_parameter, value) values(14, 3, 2, 18.5);
insert into parameters(id, id_pack, id_type_parameter, value) values(15, 3, 3, 758.0);
insert into parameters(id, id_pack, id_type_parameter, value) values(16, 3, 4, 22.0);
insert into parameters(id, id_pack, id_type_parameter, value) values(17, 3, 5, 8.0);
-- Параметры для Пачки 4 (ВР — с дальностью сноса пуль)
insert into parameters(id, id_pack, id_type_parameter, value) values(18, 4, 1, -15.0);
insert into parameters(id, id_pack, id_type_parameter, value) values(19, 4, 2, -5.2);
insert into parameters(id, id_pack, id_type_parameter, value) values(20, 4, 3, 712.0);
insert into parameters(id, id_pack, id_type_parameter, value) values(21, 4, 4, 45.0);
insert into parameters(id, id_pack, id_type_parameter, value) values(22, 4, 6, 95.0);
-- Параметры для Пачки 5 (ДМК — со скоростью ветра)
insert into parameters(id, id_pack, id_type_parameter, value) values(23, 5, 1, 340.0);
insert into parameters(id, id_pack, id_type_parameter, value) values(24, 5, 2, 28.0);
insert into parameters(id, id_pack, id_type_parameter, value) values(25, 5, 3, 762.5);
insert into parameters(id, id_pack, id_type_parameter, value) values(26, 5, 4, 5.0);
insert into parameters(id, id_pack, id_type_parameter, value) values(27, 5, 5, 12.5);
-- Параметры для Пачки 6 (ВР — с дальностью сноса пуль)
insert into parameters(id, id_pack, id_type_parameter, value) values(28, 6, 1, 500.0);
insert into parameters(id, id_pack, id_type_parameter, value) values(29, 6, 2, 32.1);
insert into parameters(id, id_pack, id_type_parameter, value) values(30, 6, 3, 775.0);
insert into parameters(id, id_pack, id_type_parameter, value) values(31, 6, 4, 58.0);
insert into parameters(id, id_pack, id_type_parameter, value) values(32, 6, 6, 140.0);
-- Проверка: сводная таблица по новым пачкам
select 
    p.id as pack_id,
    p.name as pack_name,
    p.created_at,
    u.full_name as operator,
    et.name as equipment,
    tp.name as parameter,
    pr.value
from packs p
join users u on p.id_user = u.id
join equipment_types et on p.id_equipment_type = et.id
join parameters pr on pr.id_pack = p.id
join type_parameter tp on pr.id_type_parameter = tp.id
where p.id >= 3
order by p.id, pr.id_type_parameter;