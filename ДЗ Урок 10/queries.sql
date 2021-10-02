drop database if exists hockey;
create database hockey;
use hockey;

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

drop table if exists seasons;
create table seasons
(
    id         serial primary key,
    timeStart  date      not null comment '08-01',
    timeFinish date      not null comment '07-01',
    created    timestamp not null default now()
);

# команда формируется по возрастам и только профессионалы туда входят
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

drop table if exists hockeyClubs;
create table hockeyClubs
(
    id      serial primary key,
    name    varchar(255) not null,
    created timestamp    not null default now()
);

drop table if exists playerInClub;
create table playerInClub
(
    hockeyPlayerId bigint unsigned not null,
    hockeyClub_id  bigint unsigned not null,
    created        timestamp       not null default now(),
    foreign key (hockeyPlayerId) references hockeyPlayers (id),
    foreign key (hockeyClub_id) references hockeyClubs (id)
);

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

drop table if exists clubsInLeagues;
create table clubsInLeagues
(
    hockeyClub_id   bigint unsigned not null,
    hockeyLeague_id bigint unsigned not null,
    created         timestamp       not null default now(),

    foreign key (hockeyClub_id) references hockeyClubs (id),
    foreign key (hockeyLeague_id) references hockeyLeagues (id)
);

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

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (1, 'Егор', 'Трифонов', date('1998-06-30'), 'goaltender', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (2, 'Михаил', 'Белдин', date('1998-09-17'), 'goaltender', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (3, 'Максим', 'Каляев', date('1998-05-17'), 'goaltender', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (4, 'Дмитрий', 'Алексеев', date('1999-04-07'), 'defender', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (5, 'Павел', 'Рыженьков', date('1998-03-12'), 'defender', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (6, 'Александр', 'Яковенко', date('1999-02-13'), 'defender', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (7, 'Никита', 'Громов', date('1999-01-01'), 'defender', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (8, 'Радик', 'Ахмедгалиев', date('1998-07-17'), 'defender', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (9, 'Василий', 'Беляев', date('1998-04-16'), 'defender', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (10, 'Мак', 'Рубинчик', date('1998-09-03'), 'defender', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (11, 'Никита', 'Макеев', date('1998-08-25'), 'defender', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (12, 'Михаил', 'Мещеряков', date('1999-01-21'), 'forward', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (13, 'Артур', 'Каюмов', date('1999-01-07'), 'forward', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (14, 'Кирилл', 'Слепец', date('1998-07-31'), 'forward', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (15, 'Артём', 'Иванюженко', date('1998-08-16'), 'forward', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (16, 'Вячеслав', 'Шевченко', date('1998-04-17'), 'forward', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (17, 'Глеб', 'Бондарук', date('1998-08-18'), 'forward', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (18, 'Илья', 'Авраменко', date('1998-04-16'), 'forward', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (19, 'Данил', 'Веряев', date('1999-03-03'), 'forward', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (20, 'Герман', 'Рубцов', date('1998-06-16'), 'forward', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (21, 'Игорь', 'Гераськин', date('1998-09-21'), 'forward', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (22, 'Иван', 'Романов', date('1998-06-16'), 'forward', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (23, 'Георгий', 'Иванов', date('1999-09-17'), 'forward', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (24, 'Максим', 'Баин', date('1998-11-18'), 'forward', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (25, 'Павел', 'Колтыгин', date('1998-12-19'), 'forward', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (26, 'Марк', 'Верба', date('1998-07-16'), 'forward', 'male');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (27, 'Анна', 'Гончарова', date('1996-08-16'), 'defender', 'female');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (28, 'Анастасия', 'Водопьянова', date('2000-07-16'), 'defender', 'female');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (29, 'Фануза', 'Кадирова', date('2000-08-16'), 'forward', 'female');

insert into `hockeyPlayers` (id, firstname, lastname, birthday, game_position, gender)
VALUES (30, 'Надежда', 'Морозова', date('1998-12-12'), 'goaltender', 'female');

insert into hockeyClubs (id, name)
values (1, 'ЦСКА');
insert into hockeyClubs (id, name)
values (2, 'СКА');
insert into hockeyClubs (id, name)
values (3, 'Локомотив');
insert into hockeyClubs (id, name)
values (4, 'Сочи');
insert into hockeyClubs (id, name)
values (5, 'Авангард');
insert into hockeyClubs (id, name)
values (6, 'Стальные Лисы');
insert into hockeyClubs (id, name)
values (7, 'Локо-76');
insert into hockeyClubs (id, name)
values (8, 'Реактор');
insert into hockeyClubs (id, name)
values (9, 'Томский Ястреб');
insert into hockeyClubs (id, name)
values (10, 'Мамонты Югры');
insert into hockeyClubs (id, name)
values (11, 'Чайка');
insert into hockeyClubs (id, name)
values (12, 'Авто');
insert into hockeyClubs (id, name)
values (13, 'Сибирские Снайперы');
insert into hockeyClubs (id, name)
values (14, 'Красная Армия');
insert into hockeyClubs (id, name)
values (15, 'Сахалинские Акулы');

insert into hockeyClubs (id, name)
values (16, 'Агидель');
insert into hockeyClubs (id, name)
values (17, 'Скиф');
insert into hockeyClubs (id, name)
values (18, 'Бирюса');
insert into hockeyClubs (id, name)
values (19, 'Торнадо');

insert into hockeyLeagues (id, name, gender, age_type, special_type)
values (1, 'Континентальная Хоккейная Лига', 'male', 'adults', 'professional');
insert into hockeyLeagues (id, name, gender, age_type, special_type)
values (2, 'Высшая Хоккейная Лига', 'male', 'adults', 'professional');
insert into hockeyLeagues (id, name, gender, age_type, special_type)
values (3, 'Молодёжная Хоккейная Лига', 'male', 'juniors', 'professional');
insert into hockeyLeagues (id, name, gender, age_type, special_type)
values (4, 'Женская Хоккейная Лига', 'female', 'adults', 'professional');
insert into hockeyLeagues (id, name, gender, age_type, special_type)
values (5, 'Ночная Хоккейная Лига', 'male', 'adults', 'amateur');

insert into clubsInLeagues (hockeyLeague_id, hockeyClub_id)
values (1, 1);
insert into clubsInLeagues (hockeyLeague_id, hockeyClub_id)
values (1, 2);
insert into clubsInLeagues (hockeyLeague_id, hockeyClub_id)
values (1, 3);
insert into clubsInLeagues (hockeyLeague_id, hockeyClub_id)
values (1, 4);
insert into clubsInLeagues (hockeyLeague_id, hockeyClub_id)
values (1, 5);

insert into clubsInLeagues (hockeyLeague_id, hockeyClub_id)
values (3, 6);
insert into clubsInLeagues (hockeyLeague_id, hockeyClub_id)
values (3, 7);
insert into clubsInLeagues (hockeyLeague_id, hockeyClub_id)
values (3, 8);
insert into clubsInLeagues (hockeyLeague_id, hockeyClub_id)
values (3, 9);
insert into clubsInLeagues (hockeyLeague_id, hockeyClub_id)
values (3, 10);
insert into clubsInLeagues (hockeyLeague_id, hockeyClub_id)
values (3, 11);
insert into clubsInLeagues (hockeyLeague_id, hockeyClub_id)
values (3, 12);
insert into clubsInLeagues (hockeyLeague_id, hockeyClub_id)
values (3, 13);
insert into clubsInLeagues (hockeyLeague_id, hockeyClub_id)
values (3, 14);
insert into clubsInLeagues (hockeyLeague_id, hockeyClub_id)
values (3, 15);

insert into clubsInLeagues (hockeyLeague_id, hockeyClub_id)
values (4, 16);
insert into clubsInLeagues (hockeyLeague_id, hockeyClub_id)
values (4, 17);
insert into clubsInLeagues (hockeyLeague_id, hockeyClub_id)
values (4, 18);
insert into clubsInLeagues (hockeyLeague_id, hockeyClub_id)
values (4, 19);

insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (1, 1);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (2, 2);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (3, 3);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (4, 4);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (5, 5);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (6, 6);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (7, 7);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (8, 8);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (9, 9);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (10, 10);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (11, 11);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (12, 12);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (13, 13);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (14, 14);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (15, 15);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (16, 6);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (17, 7);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (18, 8);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (19, 9);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (20, 10);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (21, 11);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (22, 12);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (23, 13);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (24, 14);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (25, 15);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (26, 6);

insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (27, 16);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (28, 17);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (29, 18);
insert into playerInClub(hockeyPlayerId, hockeyClub_id)
values (30, 19);

insert into seasons(id, timeStart, timeFinish)
values (1, '2015-08-01', '2016-07-01');

insert into nationalHockeyTeam (id, seasonId, age_type, gender)
values (1, 1, '<= 16', 'male');
insert into nationalHockeyTeam (id, seasonId, age_type, gender)
values (2, 1, '<= 17', 'male');
insert into nationalHockeyTeam (id, seasonId, age_type, gender)
values (3, 1, '<= 18', 'male');
insert into nationalHockeyTeam (id, seasonId, age_type, gender)
values (4, 1, '<= 20', 'male');
insert into nationalHockeyTeam (id, seasonId, age_type, gender)
values (5, 1, '> 20', 'male');
insert into nationalHockeyTeam (id, seasonId, age_type, gender)
values (6, 1, '<= 18', 'female');
insert into nationalHockeyTeam (id, seasonId, age_type, gender)
values (7, 1, '> 18', 'female');

insert into users (email, firstname, lastname, password_hash, type, phone)
values ('sv@fhr.ru', 'Владимир', 'Савостьянов', 'f0a02ecad0443ade20b627fed1d73cd2320c51256a665727561f33a2a8a2e7c0',
        'врач', 79104484940);
insert into users (email, firstname, lastname, password_hash, type, phone)
values ('vz@fhr.ru', 'Валерий', 'Знарок', 'a94b7f3b062647895336b3ced58c01df7ec4cdb9220e418d04fa5b1325f382d4',
        'тренер', 79149934940);
insert into users (email, firstname, lastname, password_hash, type, phone)
values ('ab@fhr.ru', 'Анатолий', 'Букатин', '2de7fdff767b209785eb3535c521b3ba85c185d96499915b8347afa528327242',
        'методист', 79149932928);
insert into users (email, firstname, lastname, password_hash, type, phone)
values ('vb@fhr.ru', 'Валерий', 'Брагин', 'b771913308383a777d0162ce893441ace0dd6fd2752b9521cddb5e586e8f8986',
        'тренер', 79103382640);
insert into users (email, firstname, lastname, password_hash, type, phone)
values ('vbukov@fhr.ru', 'Вячеслав', 'Быков', 'b960f1e84cef9a1bd4b1b200234b5b914a1818734a8aad3750850ec7c9821b41',
        'тренер', 79102392087);
insert into users (email, firstname, lastname, password_hash, type, phone)
values ('urup@fhr.ru', 'Николай', 'Урюпин', '1ac9a3641ce53b3de38ad9369cc52afba9e97db8f8d8c07586e7dc47380d3749',
        'методист', 79101993736);
insert into users (email, firstname, lastname, password_hash, type, phone)
values ('kokona@fhr.ru', 'Валерий', 'Конов', 'db3ec585af36524c49c7c8756476cfb96255cdec218a296d519500aaf2159245',
        'врач', 791019294812);


insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (1, 1, 'sv@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (2, 2, 'sv@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (3, 3, 'sv@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (4, 4, 'sv@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (5, 5, 'kokona@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (6, 6, 'sv@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (7, 7, 'sv@fhr.ru', 1, false, false, 'допущен с ограничениями');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (8, 8, 'kokona@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (9, 9, 'sv@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (10, 10, 'sv@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (11, 11, 'sv@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (12, 12, 'sv@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (13, 13, 'sv@fhr.ru', 1, false, true, 'не допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (14, 14, 'kokona@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (15, 15, 'sv@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (16, 16, 'sv@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (17, 17, 'sv@fhr.ru', 1, true, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (18, 18, 'sv@fhr.ru', 1, true, false, 'допущен с ограничениями');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (19, 19, 'sv@fhr.ru', 1, false, false, 'не допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (20, 20, 'sv@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (21, 21, 'kokona@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (22, 22, 'sv@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (23, 23, 'sv@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (24, 24, 'sv@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (25, 25, 'kokona@fhr.ru', 1, false, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (26, 26, 'sv@fhr.ru', 1, false, false, 'не допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (27, 27, 'sv@fhr.ru', 1, false, true, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (28, 28, 'sv@fhr.ru', 1, true, false, 'допущен с ограничениями');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (29, 29, 'sv@fhr.ru', 1, true, false, 'допущен');
insert into medicalConclusions (id, hockeyPlayerId, physicianId, seasonId, injury, disease, result)
values (30, 30, 'kokona@fhr.ru', 1, false, true, 'допущен');


insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (1, 1, 'vz@fhr.ru', 1, 'отлично');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (2, 2, 'vb@fhr.ru', 1, 'хорошо');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (3, 3, 'vbukov@fhr.ru', 1, 'удовлетворительно');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (4, 4, 'vb@fhr.ru', 1, 'неудовлетворительно');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (5, 5, 'vz@fhr.ru', 1, 'отлично');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (6, 6, 'vz@fhr.ru', 1, 'хорошо');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (7, 7, 'vz@fhr.ru', 1, 'отлично');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (8, 8, 'vbukov@fhr.ru', 1, 'удовлетворительно');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (9, 9, 'vb@fhr.ru', 1, 'отлично');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (10, 10, 'vz@fhr.ru', 1, 'отлично');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (11, 11, 'vz@fhr.ru', 1, 'неудовлетворительно');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (12, 12, 'vz@fhr.ru', 1, 'отлично');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (13, 13, 'vb@fhr.ru', 1, 'отлично');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (14, 14, 'vz@fhr.ru', 1, 'хорошо');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (15, 15, 'vbukov@fhr.ru', 1, 'отлично');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (16, 16, 'vz@fhr.ru', 1, 'отлично');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (17, 17, 'vb@fhr.ru', 1, 'отлично');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (18, 18, 'vbukov@fhr.ru', 1, 'неудовлетворительно');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (19, 19, 'vz@fhr.ru', 1, 'отлично');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (20, 20, 'vz@fhr.ru', 1, 'удовлетворительно');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (21, 21, 'vz@fhr.ru', 1, 'отлично');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (22, 22, 'vz@fhr.ru', 1, 'хорошо');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (23, 23, 'vb@fhr.ru', 1, 'отлично');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (24, 24, 'vbukov@fhr.ru', 1, 'отлично');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (25, 25, 'vz@fhr.ru', 1, 'неудовлетворительно');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (26, 26, 'vz@fhr.ru', 1, 'отлично');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (27, 27, 'vz@fhr.ru', 1, 'удовлетворительно');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (28, 28, 'vbukov@fhr.ru', 1, 'отлично');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (29, 29, 'vz@fhr.ru', 1, 'хорошо');
insert into functionalConclusions (id, hockeyPlayerId, coachId, seasonId, status)
values (30, 30, 'vbukov@fhr.ru', 1, 'отлично');

insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (1, 1, 'ab@fhr.ru', 1, 'отлично');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (2, 2, 'urup@fhr.ru', 1, 'удовлетворительно');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (3, 3, 'ab@fhr.ru', 1, 'хорошо');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (4, 4, 'ab@fhr.ru', 1, 'отлично');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (5, 5, 'urup@fhr.ru', 1, 'отлично');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (6, 6, 'ab@fhr.ru', 1, 'неудовлетворительно');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (7, 7, 'ab@fhr.ru', 1, 'отлично');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (8, 8, 'ab@fhr.ru', 1, 'отлично');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (9, 9, 'ab@fhr.ru', 1, 'отлично');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (10, 10, 'ab@fhr.ru', 1, 'хорошо');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (11, 11, 'urup@fhr.ru', 1, 'отлично');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (12, 12, 'ab@fhr.ru', 1, 'отлично');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (13, 13, 'ab@fhr.ru', 1, 'удовлетворительно');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (14, 14, 'urup@fhr.ru', 1, 'отлично');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (15, 15, 'ab@fhr.ru', 1, 'отлично');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (16, 16, 'ab@fhr.ru', 1, 'неудовлетворительно');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (17, 17, 'ab@fhr.ru', 1, 'отлично');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (18, 18, 'urup@fhr.ru', 1, 'отлично');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (19, 19, 'ab@fhr.ru', 1, 'отлично');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (20, 20, 'ab@fhr.ru', 1, 'хорошо');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (21, 21, 'ab@fhr.ru', 1, 'отлично');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (22, 22, 'urup@fhr.ru', 1, 'отлично');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (23, 23, 'ab@fhr.ru', 1, 'удовлетворительно');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (24, 24, 'ab@fhr.ru', 1, 'отлично');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (25, 25, 'ab@fhr.ru', 1, 'отлично');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (26, 26, 'urup@fhr.ru', 1, 'неудовлетворительно');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (27, 27, 'ab@fhr.ru', 1, 'отлично');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (28, 28, 'ab@fhr.ru', 1, 'отлично');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (29, 29, 'urup@fhr.ru', 1, 'хорошо');
insert into statisticsConclusions (id, hockeyPlayerId, scientistId, seasonId, status)
values (30, 30, 'ab@fhr.ru', 1, 'отлично');