do $$
begin

	-- ед. измерения
	begin
		create sequence seq_dim_ranges;
		
		create table dim_ranges (
			id bigint primary key default nextval('public.seq_dim_ranges'),
			external_id bigint unique,
			name text,
			factor numeric(18,4),
			date_add timestamp default now()
		);

		comment on table dim_ranges is 'Единицы измерения';
		comment on column dim_ranges.id is 'Уникальный код';
		comment on column dim_ranges.external_id is 'Код из исходной БД';
		comment on column dim_ranges.name is 'Название';
		comment on column dim_ranges.factor is 'Коэффициент приведения';
		comment on column dim_ranges.date_add is 'Дата добавления';
	end;

	-- категории
	begin
		create sequence seq_dim_category;
		
		create table dim_category (
			id bigint primary key default nextval('public.seq_dim_category'),
			external_id bigint unique,
			name text,
			parent_external_id bigint,
			parent_id bigint references dim_category(id),
			date_add timestamp default now()
		);

		comment on table dim_category is 'Категории товаров';
		comment on column dim_category.id is 'Уникальный код';
		comment on column dim_category.external_id is 'Код из исходной БД';
		comment on column dim_category.name is 'Название';
		comment on column dim_category.parent_external_id is 'Код родителькой категории из исходной БД';
		comment on column dim_category.parent_id is 'Код родительской категории';
		comment on column dim_category.date_add is 'Дата добавления';

		
	end;

	-- группы поставщиков
	begin
		create sequence seq_dim_vendor_groups;
		
		create table dim_vendor_groups (
			id bigint primary key default nextval('public.seq_dim_vendor_groups'),
			external_id bigint unique,
			name text,
			date_add timestamp default now()
		);

		comment on table dim_vendor_groups is 'Группы поставщиков';
		comment on column dim_vendor_groups.id is 'Уникальный код';
		comment on column dim_vendor_groups.external_id is 'Код из исходной БД';
		comment on column dim_vendor_groups.name is 'Название группы';
		comment on column dim_vendor_groups.date_add is 'Дата добавления';
	end;

	-- поставщики
	begin
		create sequence seq_dim_vendors;
		
		create table dim_vendors (
			id bigint primary key default nextval('public.seq_dim_vendors'),
			external_id bigint unique,
			code text,
			name text,
			group_id bigint references dim_vendor_groups(id),
			date_add timestamp default now()
		);

		comment on table dim_vendors is 'Поставщики';
		comment on column dim_vendors.id is 'Внутренний код';
		comment on column dim_vendors.external_id is 'Код из исходной БД';
		comment on column dim_vendors.code is 'Краткое название';
		comment on column dim_vendors.name is 'Название';
		comment on column dim_vendors.group_id is 'Код группы поставщиков';
		comment on column dim_vendors.date_add is 'Дата добавления';
	end;

	-- склад
	begin
		create sequence seq_dim_storages;
		
		create table dim_storages (
			id bigint primary key default nextval('public.seq_dim_storages'),
			external_id bigint unique,
			name text,
			date_add timestamp default now()
		);

		comment on table dim_storages is 'Склады';
		comment on column dim_storages.id is 'Уникальный код';
		comment on column dim_storages.external_id is 'Код из исходной БД';
		comment on column dim_storages.name is 'Название';
		comment on column dim_storages.date_add is 'Дата добавления';

	end;

	-- продукты
	begin
		create sequence seq_dim_products;
		
		create table dim_products (
			id bigint primary key default nextval('public.seq_dim_products'),
			external_id bigint unique,
			code text,
			name text,
			category_id bigint references dim_category(id),
			range_id bigint references dim_ranges(id),
			vendor_id bigint references dim_vendors(id),
			cost numeric(18,4),
			date_add timestamp default now()
		);

		comment on table dim_products is 'Товары';
		comment on column dim_products.id is 'Внутренний код';
		comment on column dim_products.external_id is 'Код из исходной БД';
		comment on column dim_products.code is 'Внешний код товара';
		comment on column dim_products.name is 'Название';
		comment on column dim_products.category_id is 'Код категории';
		comment on column dim_products.range_id is 'Код единицы измерения';
		comment on column dim_products.vendor_id is 'Код поставщика';
		comment on column dim_products.cost is 'Себестоимость';
		comment on column dim_products.date_add is 'Дата добавления';

	end;

	-- типы складских операций
	begin
		create sequence seq_dim_operation_types;
		
		create table dim_operation_types (
			id bigint primary key default nextval('public.seq_dim_operation_types'),
			external_id bigint unique,
			name text,
			factor integer,
			date_add timestamp default now()
		);

		comment on table dim_operation_types is 'Типы складских операций';
		comment on column dim_operation_types.id is 'Уникальный код';
		comment on column dim_operation_types.external_id is 'Код из исходной БД';
		comment on column dim_operation_types.name is 'Название';
		comment on column dim_operation_types.factor is 'Знак операции: +1 приход, -1 расход';
		comment on column dim_operation_types.date_add is 'Дата добавления';

	end;

	-- типы транзакций продаж
	begin
		create sequence seq_dim_transaction_types;
		
		create table dim_transaction_types (
			id bigint primary key default nextval('public.seq_dim_transaction_types'),
			external_id bigint unique,
		 	name text,
			group_external_id bigint,
			date_add timestamp default now()
		);

		comment on table dim_transaction_types is 'Типы транзакций продаж';
		comment on column dim_transaction_types.id is 'Уникальный код';
		comment on column dim_transaction_types.external_id is 'Код из исходной БД';
		comment on column dim_transaction_types.name is 'Название';
		comment on column dim_transaction_types.group_external_id is 'Код группы транзакций в исходной БД (transgroupid)';
		comment on column dim_transaction_types.date_add is 'Дата добавления';

	end;

	-- виды оплаты
	begin
		create sequence seq_dim_payment_types;
		
		create table dim_payment_types (
			id bigint primary key default nextval('public.seq_dim_payment_types'),
			external_id bigint unique,
			name text,
			date_add timestamp default now()
		);

		comment on table dim_payment_types is 'Виды оплаты';
		comment on column dim_payment_types.id is 'Уникальный код';
		comment on column dim_payment_types.external_id is 'Код в исходной БД (paymenttype.paymenttypeid)';
		comment on column dim_payment_types.name is 'Название';
		comment on column dim_payment_types.date_add is 'Дата добавления';

	end;

	-- причины списания
	begin
		create sequence seq_dim_reasons;
		
		create table dim_reasons (
			id bigint primary key default nextval('public.seq_dim_reasons'),
			external_id bigint unique,
			name text,
			parent_external_id bigint,
			parent_id bigint references dim_reasons(id),
			date_add timestamp default now()
		);

		comment on table dim_reasons is 'Причины списания';
		comment on column dim_reasons.id is 'УНикальный код';
		comment on column dim_reasons.external_id is 'Код из исходной БД';
		comment on column dim_reasons.name is 'Название';
		comment on column dim_reasons.parent_external_id is 'Код родительской причины из исходной БД';
		comment on column dim_reasons.parent_id is 'Код родительской причины';
		comment on column dim_reasons.date_add is 'Дата добавления';

	end;

	-- сотрудники
	begin
		create sequence seq_dim_employees;
		
		create table dim_employees (
			id bigint primary key default nextval('public.seq_dim_employees'),
			external_id bigint unique,
			name text,
			date_add timestamp default now()
		);

		comment on table dim_employees is 'Сотрудники';
		comment on column dim_employees.id is 'Уникальный код';
		comment on column dim_employees.external_id is 'Код из исходной БД';
		comment on column dim_employees.name is 'ФИО';
		comment on column dim_employees.date_add is 'Дата добавления';

	end;

	-- клиенты
	begin
		create sequence seq_dim_clients;
		
		create table dim_clients (
			id bigint primary key default nextval('public.seq_dim_clients'),
			external_id bigint unique,
			code text,
			name text,
			date_add timestamp default now()
		);

		comment on table dim_clients is 'Клиенты';
		comment on column dim_clients.id is 'Уникальный код';
		comment on column dim_clients.external_id is 'Код из исходной БД';
		comment on column dim_clients.code is 'Код карты клиента';
		comment on column dim_clients.name is 'ФИО клиента';
		comment on column dim_clients.date_add is 'Дата добавления';
	end;

	commit;
end $$;