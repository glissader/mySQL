# В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
# Переместите запись id = 1 из таблицы shop.users в таблицу sample.users.
# Используйте транзакции.

start transaction;
set @id = 1;

update sample.users
set name = (select shop.users.name from shop.users where shop.users.id = @id)
where id = @id;

update sample.users
set birthday_at = (select shop.users.birthday_at from shop.users where shop.users.id = @id)
where id = @id;

update sample.users
set created_at = (select shop.users.created_at from shop.users where shop.users.id = @id)
where id = @id;

update sample.users
set updated_at = (select shop.users.updated_at from shop.users where shop.users.id = @id)
where id = @id;

delete
from shop.users
where id = @id;

commit;

# Создайте представление, которое выводит название name товарной позиции из таблицы products и
# соответствующее название каталога name из таблицы catalogs.
use shop;

drop view if exists pc;
create view pc as
select products.name as pname, c.name as cname
from products
         join catalogs c on c.id = products.catalog_id;