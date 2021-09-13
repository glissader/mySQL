DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop;
USE shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Название раздела',
    UNIQUE unique_name (name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs
VALUES (NULL, 'Процессоры'),
       (NULL, 'Материнские платы'),
       (NULL, 'Видеокарты'),
       (NULL, 'Жесткие диски'),
       (NULL, 'Оперативная память');

DROP TABLE IF EXISTS users;
CREATE TABLE users
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(255) COMMENT 'Имя покупателя',
    birthday_at DATE COMMENT 'Дата рождения',
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at)
VALUES ('Геннадий', '1990-10-05'),
       ('Наталья', '1984-11-12'),
       ('Александр', '1985-05-20'),
       ('Сергей', '1988-02-14'),
       ('Иван', '1998-01-12'),
       ('Мария', '1992-08-29');

DROP TABLE IF EXISTS products;
CREATE TABLE products
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(255) COMMENT 'Название',
    description TEXT COMMENT 'Описание',
    price       DECIMAL(11, 2) COMMENT 'Цена',
    catalog_id  INT UNSIGNED,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

INSERT INTO products
    (name, description, price, catalog_id)
VALUES ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.',
        7890.00, 1),
       ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.',
        12700.00, 1),
       ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
       ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
       ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX',
        19310.00, 2),
       ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
       ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders
(
    id         SERIAL PRIMARY KEY,
    user_id    INT UNSIGNED,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY index_of_user_id (user_id)
) COMMENT = 'Заказы';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products
(
    id         SERIAL PRIMARY KEY,
    order_id   INT UNSIGNED,
    product_id INT UNSIGNED,
    total      INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
    created_at DATETIME     DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts
(
    id          SERIAL PRIMARY KEY,
    user_id     INT UNSIGNED,
    product_id  INT UNSIGNED,
    discount    FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
    started_at  DATETIME,
    finished_at DATETIME,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY index_of_user_id (user_id),
    KEY index_of_product_id (product_id)
) COMMENT = 'Скидки';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses
(
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(255) COMMENT 'Название',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products
(
    id            SERIAL PRIMARY KEY,
    storehouse_id INT UNSIGNED,
    product_id    INT UNSIGNED,
    value         INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

#
# Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение»
#

# 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем
UPDATE users
SET created_at = NOW(),
    updated_at = NOW()
WHERE id = id;

# 2. Таблица users была неудачно спроектирована.
# Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10.
# Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения
ALTER TABLE users
    CHANGE created_at created_at DATETIME DEFAULT NOW();
ALTER TABLE users
    CHANGE updated_at updated_at DATETIME DEFAULT NOW();

# 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры:
# 0, если товар закончился и выше нуля, если на складе имеются запасы.
# Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
# Однако нулевые запасы должны выводиться в конце, после всех записей.
INSERT INTO `storehouses_products`
VALUES (1, 8, 8, 977, '1978-05-21 00:10:32', '1984-11-29 19:01:17'),
       (2, 4, 1, 319, '1979-03-26 11:04:46', '2000-10-26 19:41:52'),
       (3, 0, 7, 0, '1990-05-21 07:57:09', '1973-01-01 10:06:01'),
       (4, 4, 0, 2074, '2016-06-17 09:04:00', '1971-08-04 03:03:58'),
       (5, 4, 1, 601, '1990-04-04 17:08:23', '1982-12-03 07:59:28'),
       (6, 4, 0, 2329, '2019-07-30 19:03:55', '2021-01-06 23:47:27'),
       (7, 3, 5, 485, '1995-03-27 04:04:25', '2015-05-18 20:00:14'),
       (8, 3, 2, 1454, '1993-01-05 12:25:35', '2018-03-18 11:56:32'),
       (9, 0, 1, 0, '1981-03-14 00:23:51', '1986-03-21 22:31:39'),
       (10, 2, 7, 2086, '1973-01-19 00:01:47', '2015-06-09 11:33:04'),
       (11, 4, 0, 1764, '1984-10-27 05:44:09', '2001-09-10 21:30:22'),
       (12, 2, 8, 730, '1996-07-31 06:27:10', '2015-09-27 19:05:19'),
       (13, 1, 5, 350, '2008-09-14 07:45:08', '2017-09-16 10:34:25'),
       (14, 5, 9, 0, '2011-10-04 16:21:25', '2016-01-05 01:37:33'),
       (15, 2, 2, 742, '1994-03-26 08:55:00', '1973-08-30 19:32:34'),
       (16, 9, 9, 1539, '2005-09-03 02:27:14', '1997-02-07 08:29:08'),
       (17, 0, 2, 652, '2007-10-08 21:31:56', '2017-04-20 15:58:22'),
       (18, 7, 7, 2394, '1973-05-07 13:56:20', '1976-03-26 16:08:25'),
       (19, 4, 8, 1696, '1995-11-13 12:15:10', '1981-07-06 04:23:15'),
       (20, 1, 1, 1449, '1985-04-24 21:40:13', '1975-12-12 21:55:22');

SELECT *
FROM storehouses_products
ORDER BY value > 0 DESC, value;

# 4. Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае.
# Месяцы заданы в виде списка английских названий (may, august)
SELECT *
FROM users
WHERE MONTH(birthday_at) IN (5, 8);

# 5. Из таблицы catalogs извлекаются записи при помощи запроса.
# SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.
SELECT *
FROM catalogs
WHERE id IN (5, 1, 2)
ORDER BY FIELD(id, 5, 1, 2);

#
# Практическое задание теме «Агрегация данных»
#

# 1. Подсчитайте средний возраст пользователей в таблице users.
SELECT AVG(YEAR(NOW()) - YEAR(birthday_at))
FROM users;

# 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
# Следует учесть, что необходимы дни недели текущего года, а не года рождения.

SELECT DAYOFWEEK(MAKEDATE(YEAR(NOW()), DAYOFYEAR(birthday_at))) AS day_of_week, count(*)
FROM users
GROUP BY day_of_week
ORDER BY day_of_week;

# 3. Подсчитайте произведение чисел в столбце таблицы
INSERT INTO `orders_products`
VALUES (1, 19, 0, 6, '2021-06-21 10:35:38', '2000-12-24 12:09:29'),
       (2, 7, 72822, 50, '1991-05-25 14:29:03', '1979-05-03 14:24:04'),
       (3, 2754505, 2104646, 67, '1972-12-03 03:28:56', '1988-04-25 19:49:53');
# 6 * 50 * 67 = 20100
SELECT round(EXP(SUM(LOG(total)))) as value
FROM orders_products;
