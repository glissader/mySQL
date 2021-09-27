# Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
# С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
# с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
# с 18:00 до 00:00 — "Добрый вечер",
# с 00:00 до 6:00 — "Доброй ночи".
create database if not exists shop;
use shop;

drop function if exists hello;

create function hello()
    returns text deterministic
begin
    declare h int;
    set h = HOUR(now());
    if (h >= 6 and h < 12) then
        return 'Доброе утро';
    elseif (h >= 12 and h < 18) then
        return 'Добрый день';
    elseif (h >= 18 and h < 0) then
        return 'Добрый вечер';
    else
        return 'Доброй ночи';
    end if;
end;

select hello();

# В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
# Допустимо присутствие обоих полей или одно из них.
# Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
# Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
# При попытке присвоить полям NULL-значение необходимо отменить операцию.

drop trigger if exists checkProductsOnInsert;
create trigger checkProductsOnInsert
    before insert
    on products
    for each row
begin
    if (NEW.name is null) and (NEW.description is null) then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled, both NAME and DESCRIPTION are NULL';
    end if;
end;

drop trigger if exists checkProductsOnUpdate;
create trigger checkProductsOnUpdate
    before update
    on products
    for each row
begin
    if (NEW.name is null) and (NEW.description is null) then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled, both NAME and DESCRIPTION are NULL';
    end if;
end;