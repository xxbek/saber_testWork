CREATE TABLE IF NOT EXISTS public."NameLog"
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name text,
    status text COLLATE pg_catalog."default",
    "timestamp" date,
    CONSTRAINT "NameLog_pkey" PRIMARY KEY (id)
)

-- TEST DATA

INSERT INTO public."NameLog"(
    name, status, "timestamp")
	VALUES ('say-hello', 'debug', '2023-03-07');


INSERT INTO public."NameLog"(
	name, status, "timestamp")
	VALUES ('Happy!', 'info', '2023-03-07');


INSERT INTO public."NameLog"(
	name, status, "timestamp")
	VALUES ('Margarita', 'debug', '2023-03-07');


INSERT INTO public."NameLog"(
	name, status, "timestamp")
	VALUES ('say-hello', 'debug', '2023-03-07');


INSERT INTO public."NameLog"(
	name, status, "timestamp")
	VALUES ('LEBOVSKI', 'debug', '2023-03-07');


INSERT INTO public."NameLog"(
	name, status, "timestamp")
	VALUES ('Margarita', 'debug', '2023-03-07');

INSERT INTO public."NameLog"(
	name, status, "timestamp")
	VALUES ('LEBOVSKI', 'info', '2023-03-07');

INSERT INTO public."NameLog"(
	name, status, "timestamp")
	VALUES ('serious sam', 'debug', '2023-03-07');

INSERT INTO public."NameLog"(
	name, status, "timestamp")
	VALUES ('Americano', 'info', '2023-03-07');