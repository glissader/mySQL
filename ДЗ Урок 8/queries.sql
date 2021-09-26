use vk;

# Пусть задан некоторый пользователь.
# Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем
set @user_id = 201;

select count(*) top_friend_messages_count, user_id
from (
         select messages.id, messages.from_user_id as user_id
         from messages
         where (messages.from_user_id in (select initiator_user_id
                                          from friend_requests
                                          where target_user_id = @user_id
                                            and status = 'approved'
                                          union
                                          select target_user_id
                                          from friend_requests
                                          where initiator_user_id = @user_id
                                            and status = 'approved'))
         union
         select messages.id, messages.to_user_id as user_id
         from messages
         where (messages.to_user_id in (select initiator_user_id
                                        from friend_requests
                                        where target_user_id = @user_id
                                          and status = 'approved'
                                        union
                                        select target_user_id
                                        from friend_requests
                                        where initiator_user_id = @user_id
                                          and status = 'approved'))
     ) as top
group by user_id
order by top_friend_messages_count desc
limit 1;

# Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
select count(*)
from (
         select user_id,
                (select TIMESTAMPDIFF(YEAR, profiles.birthday, now())
                 from profiles
                 where profiles.user_id = likes.user_id) as age
         from likes
         where media_id in (select id
                            from media
                            where user_id in (
                                select user_id
                                from profiles
                                order by TIMESTAMPDIFF(YEAR, profiles.birthday, now())
                            ))
         order by age
         limit 10
     ) as top10;

# Определить кто больше поставил лайков (всего) - мужчины или женщины?
select count(gender),
       (
           case (gender)
               when 'f' then 'female'
               when 'm' then 'male'
               end
           ) as gender
from profiles
where user_id in (select user_id from likes)
group by gender;

# Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
select *
from users
where id in (
    select from_user_id
    from (
             select count(*), from_user_id
             from messages
             group by from_user_id
             order by 1
             limit 10
         ) as loosers10
);