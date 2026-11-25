-- Использование ИИ
-- Часть с запросами выборки ресурсов подготовлена с помощью ИИ-ассистента
-- Claude (Anthropic, claude.ai, ноябрь 2026) в ходе диалога, а не одним промптом.
--
-- Что я передал ассистенту:
--   1. Текст ТЗ.
--   2. Примеры dimensions_source.sql и dimensions_destination.sql.
--   3. Схему таблиц Front (диаграммы).
--   4. Результаты проверочных запросов (количество строк, диапазоны дат).
--
-- Основные просьбы к ассистенту:
--   - добавить обычные select в стиле примера (select id, ... as name ... from ...);
--   - сверить выбранные справочники с ER-диаграммами.
--
-- Что я делал сам: выполнил все запросы в MSSQL, сверил число строк
-- с select count(*), исправил ошибки, принял решения
-- о составе справочников (убрал лишние таблицы)

-- 1. Единицы измерения  (закупки, продажи, остатки)
select id, sizeid as name, portionrate as factor
from [size];

-- 2. Категории товаров, иерархия: корень -> parent_id = null  (закупки, продажи, остатки)
select * FROM
(
    select id, description as name,
           case when coalesce(ParentID, 0) = 0 then null else ParentID end as parent_id
    from category
) as t1;

-- 3. Группы поставщиков  (закупки)
select vendorgroupid as id, description as name
from vendorgroup;

-- 4. Поставщики вместе с названием группы  (закупки, остатки)
select v.id,
       v.clientid as code,
       coalesce(nullif(ltrim(rtrim(v.firstname)), ''), v.clientid) as name,
       v.clientgroup as group_external_id,
       g.description as group_name
from vendors v
left join vendorgroup g on g.vendorgroupid = v.clientgroup;

-- 5. Склады  (закупки, остатки)
select id, description as name
from storages;

-- 6. Товары: категория, единица измерения, поставщик  (закупки, продажи, остатки)
select id,
       productid as code,
       description as name,
       nullif(CategoryID, 0) as category_external_id,
       nullif(SizeID, 0) as range_external_id,
       nullif(vendorid, 0) as vendor_external_id,
       cost
from product;

-- 7. Типы складских операций  (закупки)
select ID as id, Description as name, Factor as factor
from bm_StorageOperationsType;

-- 8. Типы транзакций продаж  (продажи)
select transtypeid as id, description as name, transgroupid as group_external_id
from transtype;

-- 9. Виды оплаты  (продажи)
select paymenttypeid as id, description as name
from paymenttype;

-- 10. Причины списания, иерархия  (закупки)
select * from
(
    select ID as id, Description as name,
           case when coalesce(ParentID, 0) = 0 then null else ParentID end as parent_id
    from bm_ReasonDebit
) as t1;

-- 11. Сотрудники  (персонал, продажи)
select personid as id,
       ltrim(rtrim(isnull(lastname, '') + ' ' + isnull(firstname, ''))) as name
from personnel;

-- 12. Клиенты  (продажи). Только код карты и ФИО
select id,
       clientid as code,
       ltrim(rtrim(isnull(lastname, '') + ' ' + isnull(firstname, '') + ' ' + isnull(middlename, ''))) as name
from clients;


-- писал сам запросы на sql-команды:

-- ед. измерения
select 'insert into dim_ranges(external_id, name, factor) values ('
    + cast(id as varchar(max)) + ','''
    + [sizeid] + ''','
    + cast(portionrate as varchar(max)) + ');'
    as [sql]
    from [size];

-- категории
select 'insert into dim_category(external_id, name, parent_external_id) values ('
    + cast(id as varchar(max)) + ','''
    + [description] + ''','
    + isnull(cast(nullif(ParentID, 0) as varchar(max)), 'null') + ');'
    as [sql]
    from [dbo].[category];

-- группы поставщиков
select 'insert into dim_vendor_groups(external_id, name) values ('
    + cast(vendorgroupid as varchar(max)) + ','''
    + [description] + ''');'
    as [sql]
    from [dbo].[vendorgroup];

-- поставщики
select 'insert into dim_vendors(external_id, code, name, group_id) values ('
    + cast(id as varchar(max)) + ','''
    + [clientid] + ''','''
    + [firstname] + ''','
    + '(select id from dim_vendor_groups where external_id = ' + cast(clientgroup as varchar(max)) + '));'
    as [sql]
    from [dbo].[vendors];

-- склады
select 'insert into dim_storages(external_id, name) values ('
    + cast(id as varchar(max)) + ','''
    + [description] + ''');'
    as [sql]
    from [dbo].[storages];

-- продукты
select 'insert into dim_products(external_id, code, name, category_id, range_id, vendor_id) values ('
    + cast(id as varchar(max)) + ','''
    + productid + ''','''
    + [description] + ''','
    + '(select id from dim_category where external_id = ' + cast(categoryid as varchar(max)) + '),'
    + '(select id from dim_ranges where external_id = ' + cast(sizeid as varchar(max)) + '),'
    + '(select id from dim_vendors where external_id = ' + cast(vendorid as varchar(max)) + '));'
    as [sql]
    from [dbo].[product];

-- типы складских операций
select 'insert into dim_operation_types(external_id, name, factor) values ('
    + cast(id as varchar(max)) + ','''
    + [description] + ''','
    + cast(factor as varchar(max)) + ');'
    as [sql]
    from [dbo].[bm_StorageOperationsType];

-- типы транзакций продаж
select 'insert into dim_transaction_types(external_id, name, group_external_id ) values ('
    + cast(transtypeid as varchar(max)) + ','''
    + isnull(description, '') + ''','
    + isnull(cast(transgroupid as varchar(max)), 'null') + ');'
    as [sql]
    from [dbo].[transtype];

-- виды оплаты
select 'insert into dim_payment_types(external_id, name) values ('
    + cast(paymenttypeid as varchar(max)) + ','''
    + [description] + ''');'
    as [sql]
    from [dbo].[paymenttype];

-- причины списания
select 'insert into dim_reasons(external_id, name, parent_external_id) values ('
    + cast(id as varchar(max)) + ','''
    + [description] + ''','
    + isnull(cast(nullif(parentid, 0) as varchar(max)), 'null') + ');'
    as [sql]
    from [dbo].[bm_ReasonDebit];

-- сотрудники
select 'insert into dim_employees(external_id, name) values ('
    + cast(personid as varchar(max)) + ','''
    + concat(lastname, ' ', firstname) + ''');'
    as [sql]
    from [dbo].[personnel];

-- клиенты
select 'insert into dim_clients(external_id, code, name) values ('
    + cast(id as varchar(max)) + ','''
    + clientid + ''','''
    + concat(firstname, ' ', middlename, ' ', lastname) + ''');'
    as [sql]
    from [dbo].[clients];

