DROP DATABASE IF EXISTS fly;
CREATE DATABASE fly;
USE fly;

create table flights
(
    id     serial,
    `from` varchar(255),
    `to`   varchar(255)
);
insert into flights
    (`from`, `to`)
values ('moscow', 'omsk'),
       ('novgorod', 'kazan'),
       ('irkutsk', 'moscow'),
       ('omsk', 'irkutsk'),
       ('moscow', 'kazan');


create table cities
(
    `label` varchar(255),
    `name`  varchar(255)
);

insert into cities
VALUES ('moscow', 'Москва'),
       ('irkutsk', 'Иркутск'),
       ('novgorod', 'Новгород'),
       ('kazan', 'Казань'),
       ('omsk', 'Омск');

# Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
# Поля from, to и label содержат английские названия городов, поле name — русское.
# Выведите список рейсов flights с русскими названиями городов.
select c1.name, c2.name
from flights
         join cities as c1 on flights.`from` = c1.label
         join cities as c2 on flights.`to` = c2.label;