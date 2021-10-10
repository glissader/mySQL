drop database if exists hockey;
create database hockey;
use hockey;

# таблица хоккеистов, хранит личные данные
# game_position (игровое амплуа) не меняется в течение всей профессиональной карьеры
drop table if exists hockeyPlayers;
create table hockeyPlayers
(
    id            serial primary key,
    firstname     varchar(255)                               not null default '',
    lastname      varchar(255)                               not null,
    birthday      date                                       not null,
    game_position enum ('forward', 'defender', 'goaltender') not null,
    gender        enum ('male', 'female')                    not null,
    created       timestamp                                  not null default now()
);

# игорвые сезоны обычно начинаются 1 августа ТЕКУЩЕГО ГОДА и заканчиваются 1 июля следующего года
drop table if exists seasons;
create table seasons
(
    id         serial primary key,
    timeStart  date      not null comment '08-01',
    timeFinish date      not null comment '07-01',
    created    timestamp not null default now()
);

# команда формируется по возрастам и только профессионалы туда входят
# задается возраст nationalHockeyTeam.age_type
# задается дата начала мероприятия
# на момент начала даты ДР хоккеиста должно быть после начала мероприятия
# берутся те, которые играют в профессиональных лигах hockeyLeagues
# он должен быть medicalConclusions допущен, не быть травмирован и не быть больным
drop table if exists nationalHockeyTeam;
create table nationalHockeyTeam
(
    id       serial primary key,
    seasonId bigint unsigned not null,
    age_type enum ('<= 16', '<= 17', '<= 18', '> 18', '<= 20', '> 20'),
    gender   enum ('male', 'female'),
    created  timestamp       not null default now(),
    foreign key (seasonId) references seasons (id)
);

# хоккейный клуб со своим названием
drop table if exists hockeyClubs;
create table hockeyClubs
(
    id      serial primary key,
    name    varchar(255) not null,
    created timestamp    not null default now()
);

# хоккеисты перемещаются по клубам в зависимости от заключённого контракта
# таблица реализует связь "многие-ко-многим" между хоккеистами и клубами
drop table if exists playerInClub;
create table playerInClub
(
    hockeyPlayerId bigint unsigned not null,
    hockeyClubId   bigint unsigned not null,
    created        timestamp       not null default now(),
    foreign key (hockeyPlayerId) references hockeyPlayers (id),
    foreign key (hockeyClubId) references hockeyClubs (id)
);

# в зависимости от возраста, пола и уровня профессионализма хоккеистов, клубы объединяются в лиги
drop table if exists hockeyLeagues;
create table hockeyLeagues
(
    id           serial primary key,
    name         varchar(255)                     not null,
    gender       enum ('male', 'female')          not null,
    age_type     enum ('adults', 'juniors')       not null,
    special_type enum ('professional', 'amateur') not null,
    created      timestamp                        not null default now()
);

# таблица, реализующая связь "многие-ко-многим" между клубами и лигами
drop table if exists clubsInLeagues;
create table clubsInLeagues
(
    hockeyClubId   bigint unsigned not null,
    hockeyLeagueId bigint unsigned not null,
    created        timestamp       not null default now(),

    foreign key (hockeyClubId) references hockeyClubs (id),
    foreign key (hockeyLeagueId) references hockeyLeagues (id)
);

# пользователи базы данных, имеют доступ к данным хоккеиста - врачи, тренеры и методисты
drop table if exists users;
create table users
(
    email         varchar(255) unique not null primary key,
    firstname     varchar(255)        not null default '',
    lastname      varchar(255)        not null,
    password_hash varchar(255)        not null unique,
    type          enum ('врач', 'тренер', 'методист'),
    phone         bigint unsigned     not null unique
);

# медицинское заключение готовит врач клуба. Оно содержит в себе данные о травмах, болезнях и результатах УМО
drop table if exists medicalConclusions;
create table medicalConclusions
(
    id             serial primary key,
    hockeyPlayerId bigint unsigned not null,
    physicianId    varchar(255)    not null,
    seasonId       bigint unsigned not null,
    injury         bool            not null default false comment 'не травмирован / травмирован',
    disease        bool            not null default false comment 'не болен / болен',
    result         enum ('допущен', 'не допущен', 'допущен с ограничениями'),
    created        timestamp       not null default now(),
    foreign key (hockeyPlayerId) references hockeyPlayers (id),
    foreign key (physicianId) references users (email),
    foreign key (seasonId) references seasons (id)
);

# триггер, который позволяет вносить медицинское заключение ТОЛЬКО врачу
drop trigger if exists checkMedicalConclusions;
create trigger checkMedicalConclusions
    before insert
    on medicalConclusions
    for each row
begin
    if (select type from users where email = NEW.physicianId) not in ('врач') then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled, user is NOT a physician';
    end if;
end;

# функциональное заключение готовит тренер по ОФП
drop table if exists functionalConclusions;
create table functionalConclusions
(
    id             serial primary key,
    hockeyPlayerId bigint unsigned not null,
    coachId        varchar(255)    not null,
    seasonId       bigint unsigned not null,
    status         enum ('отлично', 'хорошо', 'удовлетворительно', 'неудовлетворительно'),
    created        timestamp       not null default now(),
    foreign key (hockeyPlayerId) references hockeyPlayers (id),
    foreign key (coachId) references users (email),
    foreign key (seasonId) references seasons (id)
);

# триггер, который позволяет вносить функциональное заключение ТОЛЬКО тренеру
drop trigger if exists checkFunctionalConclusions;
create trigger checkFunctionalConclusions
    before insert
    on functionalConclusions
    for each row
begin
    if (select type from users where email = NEW.coachId) not in ('тренер') then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled, user is NOT a тренер';
    end if;
end;

# игровая статистика, готовит методист
drop table if exists statisticsConclusions;
create table statisticsConclusions
(
    id             serial primary key,
    hockeyPlayerId bigint unsigned not null,
    scientistId    varchar(255)    not null,
    seasonId       bigint unsigned not null,
    status         enum ('отлично', 'хорошо', 'удовлетворительно', 'неудовлетворительно'),
    created        timestamp       not null default now(),
    foreign key (hockeyPlayerId) references hockeyPlayers (id),
    foreign key (scientistId) references users (email),
    foreign key (seasonId) references seasons (id)
);

# триггер, который позволяет вносить игровую статистику ТОЛЬКО методисту
drop trigger if exists checkStatisticsConclusions;
create trigger checkStatisticsConclusions
    before insert
    on statisticsConclusions
    for each row
begin
    if (select type from users where email = NEW.scientistId) not in ('методист') then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled, user is NOT a методист';
    end if;
end;

# представление (распределение хоккеистов по клубам, лигам, возрастам)
drop view if exists hockeyPlayersSkills;
create view hockeyPlayersSkills as
select hockeyPlayers.id as hockeyPlayerId,
       hockeyPlayers.birthday,
       hockeyPlayers.lastname,
       hockeyPlayers.firstname,
       hockeyPlayers.game_position,
       hockeyPlayers.gender,
       playerInClub.hockeyClubId,
       hockeyClubs.name as hockeyClubName,
       hockeyLeagues.id as hockeyLeagueId,
       hockeyLeagues.name,
       hockeyLeagues.age_type,
       hockeyLeagues.special_type
from hockeyPlayers
         join playerInClub on hockeyPlayers.id = playerInClub.hockeyPlayerId
         join clubsInLeagues on playerInClub.hockeyClubId = clubsInLeagues.hockeyClubId
         join hockeyLeagues on hockeyLeagues.id = clubsInLeagues.hockeyLeagueId
         join hockeyClubs on clubsInLeagues.hockeyClubId = hockeyClubs.id;

# представление национальной сборной команды на текущую дату
# юниоры до 18 лет
drop view if exists nationalHockeyTeamJuniors17;
create view nationalHockeyTeamJuniors17 as
select birthday, lastname, firstname, game_position, hockeyClubName, name
from hockeyplayersskills
where gender = 'male'
  and special_type = 'professional'
  and YEAR(NOW()) - YEAR(birthday) > 17
  and (YEAR(NOW()) - YEAR(birthday) < 20 or
       (YEAR(NOW()) - YEAR(birthday) = 20 and DAYOFYEAR(birthday) > DAYOFYEAR(NOW())));

# представление национальной сборной команды на текущую дату
# молодежка
drop view if exists nationalHockeyTeam20;
create view nationalHockeyTeam20 as
select birthday, lastname, firstname, game_position, hockeyClubName, name
from hockeyplayersskills
where gender = 'male'
  and age_type = 'adults'
  and special_type = 'professional'
  and YEAR(NOW()) - YEAR(birthday) > 20
order by birthday;

# представление национальной ЖЕНСКОЙ сборной команды на текущую дату
# взрослая национальная
drop view if exists nationalHockeyTeamWoman;
create view nationalHockeyTeamWoman as
select birthday, lastname, firstname, game_position, hockeyClubName, name
from hockeyplayersskills
where gender = 'female'
  and age_type = 'adults'
  and special_type = 'professional'
  and YEAR(NOW()) - YEAR(birthday) > 15
order by birthday;

# хранимая процедура, показывающая статистику, функциональное состояние и состояние здоровья по конкретному хоккеисту
# с учётом всех сезонов
drop procedure if exists showPlayer;
create procedure showPlayer(in id int)
begin
    select seasons.timeStart,
           seasons.timeFinish,
           hockeyPlayers.birthday,
           hockeyPlayers.lastname,
           hockeyPlayers.firstname,
           hockeyPlayers.game_position,
           functionalConclusions.coachId,
           functionalConclusions.status,
           medicalConclusions.physicianId,
           medicalConclusions.disease,
           medicalConclusions.injury,
           medicalConclusions.result,
           statisticsConclusions.scientistId,
           statisticsConclusions.status
    from functionalConclusions
             join hockeyPlayers on hockeyPlayers.id = functionalConclusions.hockeyPlayerId
             join medicalConclusions on hockeyPlayers.id = medicalConclusions.hockeyPlayerId
             join statisticsConclusions on hockeyPlayers.id = statisticsConclusions.hockeyPlayerId
             join seasons on seasons.id = functionalConclusions.seasonId = seasons.id
    where hockeyPlayers.id = id;
end;
