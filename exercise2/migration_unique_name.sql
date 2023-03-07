
-- 1. Прежде всего создается таблица Name, в которой будут хранится уникальные значения поля name из NameLog.

CREATE TABLE IF NOT EXISTS public."Name"
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name text,
    CONSTRAINT "Name_pkey" PRIMARY KEY (id),
    CONSTRAINT "Name_name_key" UNIQUE (name)
)


-- 2. Останавливаем сервисы типа А.
-- 3. Запускаем процедуру, которая сгруппирует уникальные значения для name и вставит их в таблицу Name.

BEGIN;
INSERT INTO public."Name"(name)
(
	SELECT name
	FROM public."NameLog"
	GROUP BY name
	HAVING name IS NOT NULL
);
COMMIT;

-- 4. Изменяем логику сервиса типа А: при вставке проверяем, есть ли новое name в множестве уникальных значений из таблицы Name.
-- Если оно присутствует в таблице, вставляем в NameLog его внешний ключ.
-- Если отсутствует, вставляем уникальное значение в таблицу Name и его ключ в NameLog.

-- 5. Запускаем сервисы типа А.
-- 6. Остановливаем сервисы типа Б
-- 7. Запускаем процедуру, которая заменит все значения поля name в таблице NameLog внешними ключами таблицы Name.

CREATE OR REPLACE FUNCTION public.get_id_by_name(
	input_name text)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

declare
    result_id integer;
BEGIN
	SELECT id
	INTO result_id
	FROM public."Name"
	WHERE public."Name".name=input_name;

	RETURN result_id;
END;
$BODY$;


BEGIN;
UPDATE public."NameLog"
	SET name = get_id_by_name(name);
COMMIT;

-- 8. Изменяем имя поля name таблицы NameLog на имя name_id.
-- В этот момент важно, чтобы в логике всех сервисов имя поля также было изменено.

BEGIN;
ALTER TABLE IF EXISTS public."NameLog"
    RENAME name TO name_id;
COMMIT;


-- 9. Меняем тип данных и проставляем ограничение целостности ForeignKey для поля name_id таблицы NameLog


BEGIN;
ALTER TABLE public."NameLog"
ALTER COLUMN name_id TYPE integer USING name_id::integer;
COMMIT;

BEGIN;
ALTER TABLE IF EXISTS public."NameLog"
    ADD FOREIGN KEY (name_id)
    REFERENCES public."Name" (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE
    NOT VALID;
COMMIT;

-- 10. Изменяем логику сервиса типа А: теперь в запросах на чтение поля name будет INNER JOIN с таблицей Name по полям name_id и id.

SELECT * from public."NameLog"
JOIN public."Name" ON public."NameLog".name_id = public."Name".id

-- 11. Запускаем сервисы типа А.



