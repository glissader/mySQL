use vk;

# Пусть задан некоторый пользователь.
set @user_id = 203;
# Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем
select users.id, count(*)
from users
         join friend_requests fr
              on (users.id = fr.initiator_user_id or users.id = fr.target_user_id) and status = 'approved'
         join messages m on (users.id = m.from_user_id or users.id = m.to_user_id)
where (initiator_user_id = @user_id or target_user_id = @user_id)
  and users.id <> @user_id
group by users.id
order by 2 desc
limit 1;

# Подсчитать общее количество лайков, которые получили пользователи младше 10 лет
select count(*)
from users
         join media m on m.user_id = users.id
         join likes l on l.media_id = m.id
         join profiles p on users.id = p.user_id
where TIMESTAMPDIFF(YEAR, p.birthday, now()) < 10;

# Определить кто больше поставил лайков (всего) - мужчины или женщины?
select (
           case (gender)
               when 'f' then 'female'
               when 'm' then 'male'
               end
           ) as gender,
       count(*)
from profiles
         join likes l on profiles.user_id = l.user_id
group by gender;
