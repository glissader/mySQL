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

DROP TABLE IF EXISTS rubrics;
CREATE TABLE rubrics
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(255) COMMENT 'Название раздела'
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO rubrics
VALUES (NULL, 'Видеокарты'),
       (NULL, 'Память');

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

INSERT INTO `orders`
VALUES (1, 2, '2011-08-22 15:49:39', '2004-10-11 03:17:25'),
       (2, 3, '2016-10-11 04:31:15', '1999-05-29 02:26:39'),
       (3, 3, '1986-06-28 09:24:50', '1992-04-20 17:13:26'),
       (4, 3, '1995-10-28 21:07:14', '1980-06-21 03:29:25'),
       (5, 5, '1972-12-10 15:31:50', '1984-01-14 10:09:30'),
       (6, 6, '1992-12-12 10:08:30', '2017-12-27 04:15:43'),
       (7, 7, '1997-04-28 12:31:26', '1987-08-16 18:39:27'),
       (8, 7, '2012-01-23 15:45:56', '1977-10-11 09:19:52'),
       (9, 2, '2010-06-07 04:24:19', '2001-04-02 21:05:30');

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

# Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
select *
from users
where id in (select distinct user_id from orders);

# Выведите список товаров products и разделов catalogs, который соответствует товару.
select p.name, c.name
from products p
         join catalogs c on p.catalog_id = c.id;
