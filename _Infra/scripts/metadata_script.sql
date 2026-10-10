select
    row_number() over (order by table_name) AS "№",
    table_name as "Наименование",
    case table_type
		when 'BASE TABLE' then 'Таблица'
		else table_type
	end as "Тип"
from information_schema.tables
where table_schema = 'public' and table_catalog = current_database()