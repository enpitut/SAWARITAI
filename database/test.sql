
drop table pois;
drop table users;
drop table products;

create table users(
	user_id int(8) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_name VARCHAR(64) UNIQUE NOT NULL,
	pass VARCHAR(64) NOT NULL
);

create table products(
	product_id INTEGER(13) UNIQUE NOT NULL PRIMARY KEY,
	product_name VARCHAR(64),
	image VARCHAR(64),
	price INTEGER(10),
	kind INTEGER(2)
);

create table pois(
	poi_id INTEGER(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_id INTEGER(8),
	product_id INTEGER(13),
	date DATETIME NOT NULL,
	cap TINYINT(1),
	FOREIGN KEY(user_id) REFERENCES users(user_id),
	FOREIGN KEY(product_id) REFERENCES products(product_id)
);

insert into users(user_name,pass) values('kimura1','kimu1');
insert into users(user_name,pass) values('kimura2','kimu2');
insert into users(user_name,pass) values('kimura3','kimu3');

insert into products(product_id,product_name,image,price) values(101,'茶',NULL,150);
insert into products(product_id,product_name,image,price) values(102,'ソーダ',NULL,140);

insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-01 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-03 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-03 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-04 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-04 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-05 16:00:00',1);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-06 16:00:00',1);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-06 16:00:00',1);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-06 16:00:00',1);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-07 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-08 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-10 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-11 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-11 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-12 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-12 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-13 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-14 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-14 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-14 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-14 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-16 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-17 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-20 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-21 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-21 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-22 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-22 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-22 16:00:00',0);
insert into pois(user_id,product_id,date,cap) values(1,NULL,'2015-08-23 16:00:00',0);

