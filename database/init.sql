drop database poipet;
create database poipet;
use poipet;

create table users(
       user_id INTEGER(16) UNIQUE NOT NULL PRIMARY KEY,
       user_name VARCHAR(64) NOT NULL
);

create table tmp_users(
       tmp_id INTEGER(4) UNIQUE NOT NULL PRIMARY KEY,
       felica_id INTEGER(16),
       date DATETIME
);

create table poipets(
       poipet_id INTEGER(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
       locate VARCHAR(64) NOT NULL,
       lat DOUBLE(9,6),
       lng DOUBLE(9,6)
);

create table pois(
	poi_id INTEGER(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_id INTEGER(16),
	poipet_id INTEGER(10),
	date DATETIME NOT NULL,
	cap TINYINT(1),
	FOREIGN KEY(user_id) REFERENCES users(user_id),
	FOREIGN KEY(poipet_id) REFERENCES poipets(poipet_id)
);

delimiter //
create procedure loop_insert_tmp()
begin
	declare i int;
	set i = 0;
	while i < 10000 do
	      insert into tmp_users (tmp_id) values (i);
	      set i = i + 1;
	end while;
end
//
delimiter ;

call loop_insert_tmp();

insert into users(user_id,user_name) values(1,'u1');
insert into users(user_id,user_name) values(2,'u2');
insert into users(user_id,user_name) values(3,'u3');



insert into poipets(locate,lat,lng) values('筑波大学',36.109023,140.099666);
insert into poipets(locate,lat,lng) values('渋谷ヒカリエ',35.658932,139.703722);

insert into pois(user_id,poipet_id,date,cap) values(1,1,'2015-10-25 16:00:00',0);
insert into pois(user_id,poipet_id,date,cap) values(1,1,'2015-10-26 16:00:00',0);
insert into pois(user_id,poipet_id,date,cap) values(1,1,'2015-10-27 16:00:00',0);
insert into pois(user_id,poipet_id,date,cap) values(1,1,'2015-10-27 16:00:00',0);
insert into pois(user_id,poipet_id,date,cap) values(1,1,'2015-10-28 16:00:00',0);
insert into pois(user_id,poipet_id,date,cap) values(1,1,'2015-10-28 16:00:00',1);
insert into pois(user_id,poipet_id,date,cap) values(1,1,'2015-10-28 16:00:00',1);
insert into pois(user_id,poipet_id,date,cap) values(1,1,'2015-10-30 16:00:00',1);
insert into pois(user_id,poipet_id,date,cap) values(1,2,'2015-10-31 16:00:00',1);
insert into pois(user_id,poipet_id,date,cap) values(1,2,'2015-11-01 16:00:00',0);
insert into pois(user_id,poipet_id,date,cap) values(1,2,'2015-11-02 16:00:00',0);
insert into pois(user_id,poipet_id,date,cap) values(1,2,'2015-11-03 16:00:00',1);
insert into pois(user_id,poipet_id,date,cap) values(1,2,'2015-11-04 16:00:00',1);
insert into pois(user_id,poipet_id,date,cap) values(1,2,'2015-11-05 16:00:00',0);
insert into pois(user_id,poipet_id,date,cap) values(1,2,'2015-11-06 16:00:00',0);
insert into pois(user_id,poipet_id,date,cap) values(1,2,'2015-11-07 16:00:00',1);
insert into pois(user_id,poipet_id,date,cap) values(1,2,'2015-11-09 16:00:00',1);
insert into pois(user_id,poipet_id,date,cap) values(1,2,'2015-11-10 16:00:00',0);
insert into pois(user_id,poipet_id,date,cap) values(1,2,'2015-11-10 16:00:00',0);
insert into pois(user_id,poipet_id,date,cap) values(1,2,'2015-11-11 16:00:00',1);
insert into pois(user_id,poipet_id,date,cap) values(1,2,'2015-11-12 16:00:00',0);
insert into pois(user_id,poipet_id,date,cap) values(1,2,'2015-11-12 16:00:00',1);
insert into pois(user_id,poipet_id,date,cap) values(1,2,'2015-11-12 16:00:00',0);
insert into pois(user_id,poipet_id,date,cap) values(1,2,'2015-11-12 16:00:00',1);
insert into pois(user_id,poipet_id,date,cap) values(1,2,'2015-11-13 16:00:00',0);
insert into pois(user_id,poipet_id,date,cap) values(1,2,'2015-11-14 16:00:00',1);

