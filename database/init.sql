drop database poipet;
create database poipet;
use poipet;

create table users(
       user_id VARCHAR(16) UNIQUE NOT NULL PRIMARY KEY,
       user_name VARCHAR(64) NOT NULL
);

create table tmp_users(
       tmp_id INTEGER(4) UNIQUE NOT NULL PRIMARY KEY,
       felica_id VARCHAR(16),
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
	user_id VARCHAR(16),
	poipet_id INTEGER(10),
	date DATETIME NOT NULL,
	bottle TINYINT(1),
	cap TINYINT(1),
	label TINYINT(1),
	collect TINYINT(1) DEFAULT 0,
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




insert into users(user_id,user_name) values('1','u1');
insert into users(user_id,user_name) values('2','u2');
insert into users(user_id,user_name) values('3','u3');
insert into users(user_id,user_name) values('01120212cc0fff1b','Takada');
insert into users(user_id,user_name) values('01010310c111d206','MA11');


insert into poipets(locate,lat,lng) values('総合研究棟B',36.109023,140.099666);
insert into poipets(locate,lat,lng) values('ゆかりの森',36.109023,140.099666);
insert into poipets(locate,lat,lng) values('つくばエキスポセンター',35.658932,139.703722);



insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',1,'2015-11-25 12:36:41',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',2,'2015-11-26 11:10:18',1,1,0);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',1,'2015-11-27 13:32:56',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',2,'2015-11-28 11:10:18',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',3,'2015-11-28 11:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',1,'2015-11-29 12:36:41',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',2,'2015-11-30 11:10:18',1,1,0);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',1,'2015-11-30 13:32:56',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',2,'2015-12-01 15:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',3,'2015-12-02 15:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',2,'2015-12-02 15:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',3,'2015-12-03 15:10:18',1,1,0);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',2,'2015-12-05 10:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',1,'2015-12-05 15:10:18',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',2,'2015-12-05 18:31:31',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',1,'2015-12-06 12:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',2,'2015-12-07 10:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',3,'2015-12-07 12:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',1,'2015-12-07 15:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',3,'2015-12-07 17:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',1,'2015-12-07 20:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',3,'2015-12-08 10:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('1',2,'2015-12-08 15:57:23',1,1,1);


insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-01 15:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-02 15:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-03 15:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-04 15:10:18',1,1,0);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-05 15:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-06 15:10:18',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-07 15:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-08 12:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-08 15:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-09 11:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-09 15:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-10 15:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-11 15:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-12 15:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-13 11:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-13 12:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',2,'2015-11-13 13:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',3,'2015-11-13 15:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',3,'2015-11-14 15:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',3,'2015-11-16 15:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',2,'2015-11-17 15:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-17 15:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-18 08:50:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',2,'2015-11-18 10:46:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-18 11:10:07',1,1,1);



insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-13 15:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-14 15:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-16 15:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-17 15:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-17 15:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-18 08:50:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-18 10:46:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-18 11:10:07',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-13 15:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-14 15:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-16 15:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-17 15:57:23',1,1,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-17 15:10:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-18 08:50:18',1,0,1);
insert into pois(user_id,poipet_id,date,bottle,cap,label) values('01120212cc0fff1b',1,'2015-11-18 10:46:23',1,1,1);
