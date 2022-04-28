--create tables

create table users(
	user_id int,
	password varchar(100) not null,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	email varchar(100) not null ,
	account_status varchar(10) default 'valid',
	account_type varchar(10) default 'user',
	profile_photo varchar(50),
	about varchar (200),
	constraint user_pk primary key (user_id),
	constraint users_email_unique unique(email),
	constraint users_status_check check (account_status in ('suspended','banned','valid')),
	constraint users_type_check check (account_type in ('user', 'admin', 'mod'))
);

create table users_phone(
	user_id int,
	phone char(10),
	constraint users_phone_pk primary key (user_id, phone),
	constraint users_phone_fk_users foreign key (user_id) references users(user_id),
	constraint users_phone_check_phone check (phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

create table users_warnings(
	user_id int,
	warning varchar(200),
	constraint users_warnings_pk primary key (user_id, warning),
	constraint users_warnings_fk_users foreign key (user_id) references users(user_id)
);

create table sale_type(
	type_id int,
	description varchar(500),
	price float not null,
	name varchar(50) not null,
	constraint sale_type_pk primary key (type_id)
);

create table request_type(
	type_id int,
	description varchar(500),
	price float not null,
	name varchar(50) not null,
	constraint request_type_pk primary key (type_id)
);

create table request(
	request_id int,
	title varchar(50) not null,
	location varchar(30),
	description varchar(500),
	city varchar(40) not null,
	district varchar(30) not null,
	province varchar(20) not null,
	max_price float,
	min_price float,
	max_area float,
	min_area float,
	distance float,
	cover_photo varchar(50),
	type_id int not null,
	user_id int not null,
	create_date date,
	constraint request_pk primary key (request_id),
	constraint request_fk_request_type foreign key (type_id) references request_type(type_id),
	constraint request_fk_users foreign key (user_id) references users(user_id)

);

create table sale(
	sale_id int,
	title varchar(50) not null,
	location varchar(30),
	description varchar(500),
	city varchar(40) not null,
	district varchar(30) not null,
	province varchar(20) not null,
	price float not null,
	land_area float not null,
	address varchar(100),
	type_id int not null,
	user_id int not null,
	create_date date,
	constraint sale_pk primary key (sale_id),
	constraint sale_fk_request_type foreign key (type_id) references sale_type(type_id),
	constraint sale_fk_users foreign key (user_id) references users(user_id)

);

create table request_phone(
	request_id int,
	phone char(10),
	constraint request_phone_pk primary key (request_id, phone),
	constraint request_phone_fk foreign key (request_id) references request(request_id),
	constraint request_phone_check_phone check (phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

create table sale_phone(
	sale_id int,
	phone char(10),
	constraint sale_phone_pk primary key (sale_id, phone),
	constraint sale_phone_fk foreign key (sale_id) references sale(sale_id),
	constraint sale_phone_check_phone check (phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')

);

create table sale_media(
	sale_id int,
	media varchar(50),
	constraint sale_media_pk primary key (sale_id, media),
	constraint sale_media_fk foreign key (sale_id) references sale(sale_id)
);

create table saved_sale(
	sale_id int,
	user_id int,
	constraint saved_sale_pk primary key (sale_id, user_id),
	constraint saved_sale_fk_sale foreign key (sale_id) references sale(sale_id),
	constraint saved_sale_fk_users foreign key (user_id) references users(user_id)
);

create table saved_request(
	request_id int,
	user_id int,
	constraint saved_request_pk primary key (request_id, user_id),
	constraint saved_request_fk_sale foreign key (request_id) references request(request_id),
	constraint saved_request_fk_users foreign key (user_id) references users(user_id)
);

create table sale_complaints(
	complaint_id int,
	description varchar(500),
	reviewed BIT default 0,
	complaint_type varchar(50) not null,
	sale_id int not null,
	user_id int not null,
	create_date date,
	constraint sale_complaints_pk primary key (complaint_id),
	constraint sale_complaints_fk_sale foreign key (sale_id) references sale(sale_id),
	constraint sale_complaints_fk_users foreign key (user_id) references users(user_id),
	constraint sale_complaints_check_type check (complaint_type in ('false advertisement', 'spam and abuse', 'false imformation', 'transaction denial'))
);


create table request_complaints(
	complaint_id int,
	description varchar(500),
	reviewed BIT default 0,
	complaint_type varchar(50) not null,
	request_id int not null,
	user_id int not null,
	create_date date,
	constraint request_complaints_pk primary key (complaint_id),
	constraint request_complaints_fk_sale foreign key (request_id) references request(request_id),
	constraint request_complaints_fk_users foreign key (user_id) references users(user_id),
	constraint request_complaints_check_type check (complaint_type in ('false advertisement', 'spam and abuse', 'false imformation', 'transaction denial'))
);

--enter sample data

--users
insert into users values (1,'3k54jh5#$3jk','Mark','Bedwell','MarkBedwell@yahoo.com','valid','user','E:\Users\profiles\image\1001','Looking a land for build new house');
insert into users values (2,'53kl5$#%fgv','Eric','Willey','EricWilley@gmail.com','banned','user','E:\Users\profiles\image\1002','Looking a land for build a warehouse');
insert into users values (3,'jh34jh$453','Swett','Kevin','SwettKevin@outlook.com','valid','user','E:\Users\profiles\image\1003','Looking a land for build a shop');
insert into users values (4,'453vV$54334V','Calvin','Walker','CalvinWalker@gmail.com','suspended','user','E:\Users\profiles\image\1004','Looking a land for build new house');
insert into users values (5,'3v534V%54v','Slone','Carol','SloneCarol@outlook.com','valid','user','E:\Users\profiles\image\1005','Looking a land for build a farm');
insert into users values (6,'54343v%$$3v','William','Ness','WilliamNess@gmail.com','valid','admin','E:\Users\profiles\image\1006','Administration task');
insert into users values (7,'45vb#@$gt54','Toby','Ryan','TobyRyan@outlook.com','valid','user','E:\Users\profiles\image\1007','Looking a land for a farm');
insert into users values (8,'t5435#$Gre','Sheena','Manly','SheenaManly@gmail.com','banned','user','E:\Users\profiles\image\1008','Looking a land for build a warehouse');
insert into users values (9,'35v#$@c45v4','Clinton','Gerard','ClintonGerard@outlook.com','valid','mod','E:\Users\profiles\image\1009','Manage users');
insert into users values (10,'v54#53fsf54','Lula','Bundy','LulaVBundy@telegmail.com','suspended','user','E:\Users\profiles\image\1010','Looking a land for build new house');

--user_warnings
insert into users_warnings values (1,'Usage of explicit images on posts is violating the rules and regulations and further use of such content will cause a permanent ban');
insert into users_warnings values (2,'Incorrect type or incomplete data of given details with viewers negative reviews and feedbacks');
insert into users_warnings values (3,'Identity verification error with a similer post which will be deleted before the expire-date');
insert into users_warnings values (4,'Incorrect type or incomplete data of given details viewers unable to reach the seller');
insert into users_warnings values (5,'Usage of abusive or prohibited words may be banded the account without any warnings');
insert into users_warnings values (7,'Consider the negative reviews');

--sale_type
insert into sale_type values(1,'Basic plan is the Free and Standard Package, with a validity period of 30 days',0.00,'Basic')
insert into sale_type values(2,'Budget plan is the Budget Package which is quite similar to the Basic Plan but with a validity period of 60 days',300.00,'Budget')
insert into sale_type values(3,'Premium plan is the Premium Version to make you post featured in the home page with a validity period of 90 days',1000.00,'Premium')

--sale
insert into sale values( 1,'Land for Sale in Maharagama','6.8511N,79.9212E', 'A 20 perches land in the heart of Maharagama is available for sale. Price Negotiable ','Maharagama', 'Colombo', 'Western Province', 750000,20, 'No.47, High Level Road, Maharagama ',1, 1);
insert into sale values( 2,'Valuable land in Ja-ela for Sale ','7.0668N,79.9041E', 'A 15 perches bare land in Ja-ela which is 500m from Highway Exit is available for sale. Price Negotiable ','Ja-ela', 'Gampaha', 'Western Province', 500000,15, 'No.38/9, Seeduwa Road, Ja-ela ',2, 2);
insert into sale values( 3,'25 Perch land for Sale in Kaduwela','6.9291N,79.9828E', 'A 25 perches, flat land in the Residential Area of Kaduwela is available for sale. Price Negotiable ','Kaduwela', 'Colombo', 'Western Province', 800000,25, 'No.13/5, High Level Road, Kaduwela',1, 3);
insert into sale values( 4,'Valuable Scenic Land For Sale in Nuwara Eliya','6.9497N,80.7891E', 'A 8 perches land in the heart of Nuwara Eliya overlooking Gregory Lake is available for sale. Price Not Negotiable ','Nuwara Eliya', 'Nuwara Eliya', 'Central Province', 900000,8, 'No.5, Abepura, Nuwara Eliya ',3, 4);
insert into sale values( 5,'Land for Sale in Pelawatte','6.8906N,79.9249E', 'A 10 perches land in the suburbs of Pelawatte closer to Battaramulla is available for sale. Price Negotiable ','Battaramulla', 'Colombo', 'Western Province', 950000,10, 'No.28, Pannipitiya Road, Pelawatte ',3, 5);

--request_type
insert into sale_type values(1,'Basic plan is the Free and Standard Package, with a validity period of 30 days',0.00,'Basic')
insert into sale_type values(2,'Budget plan is the Budget Package which is quite similar to the Basic Plan but with a validity period of 60 days',300.00,'Budget')
insert into sale_type values(3,'Premium plan is the Premium Version to make you post featured in the home page with a validity period of 90 days',1000.00,'Premium')

--request
insert into request_type values (1, 'Land needed from Kandy', '7.2906N,80.6337E', 'Should be close by to the city and 10mins driving distance to the city maximum', 'Kandy', 'Kandy','Central', 'Negotiable', 'Negotiable', 400, 300, 5, 'data/image/img_34518.jpg', 1, 7);
insert into request_type values (2, '200perch land wanted from Malbe, Colombo', '6.9064N,79.9692E', 'Need a 200purchase land from Malabe, Should be close to the E02 highway', 'Malabe', 'Colombo', 'Western', 30000000, 10000000, 250, 100, 15, 'data/image/img_45679.jpeg', 3, 8);
insert into request_type values (3, 'Small land wanted from mawathagama', '7.4318N,80.4426E', 'Land wanted from Mawathagama area. Should be witin 20km of the city','Mawathagama', 'Kurunegala', 'North Western', 'Negotiable', 'Negotiable', 150, 70, 20, 'data/image/img_89456.jpeg', 2, 10);
insert into request_type values (4, 'Land wanted from Ambalangoda', '6.2442N,80.0585E', 'Should be close to the Sharmashoka college and A2 road', 'Ambalangoda', 'Galle', 'Southern', 80000000, 25000000, 600, 400, 15, 'data/image/img_89345.jpeg', 3, 4);
insert into request_type values (5, 'Land wanted from Peradeniya area', '7.2698N,80.5938E', 'Preferred if the land is close to the main road and the Peradeniya University', 'Peradeniya', 'Kandy', 'Central', 'Negotiable', 'Negotiable', 280, 150, 25, 'data/image/img_44628.jpg', 2, 1);

--request_complaints
insert into request_complaints values(1,'requester is asking for a lower price than advertised minimum price',0,'False advertisment',1, 1); 
insert into request_complaints values(2,'requester seems indecisive and keeps pushing back disscussions for months without no explanation',0,'transaction denial', 2, 2);
insert into request_complaints values(3,'requester is asking for a smaller area of land for a lower price compared to stated requirments',1,'False advertisment', 3, 3);

--sale_complaints
insert into sale_complaints values(1,'seller is asking for a higher price than advertised maximum price',1,'False advertisment', 1, 1);
insert into sale_complaints values(2,'Advertised photos were false ',1,'False advertisment', 2, 2);
insert into sale_complaints values(3,'description about the advertised plot of land is false',0,'False infomation', 3, 3);
insert into sale_complaints values(4,'Addres of the advertised plot of land is false',0,'False infomation', 4, 4);
insert into sale_complaints values(5,'seller do not intend to sell the stated amount of land area',1,'transaction denial', 5, 5);

--user_phone -chathupa

--request_phone -rusira
insert into request_phone values(1,'0772345706');
insert into request_phone values(2,'0714356348');
insert into request_phone values(3,'0728523233');
insert into request_phone values(4,'0312464937');
insert into request_phone values(5,'0115493572');
--sale_phone -nimeth

--sale_save -akmal

insert into sale_save values(1,1)
insert into sale_save values(2,2)
insert into sale_save values(3,3)
insert into sale_save values(4,4)
insert into sale_save values(5,5)



--request_save -ravindu
