
drop type if exists transit;
drop type if exists scheme;

drop type if exists connection;
drop type if exists system;
drop type if exists system2;
drop type if exists nodes;
drop type if exists grafic;
drop type if exists resourcetype;
drop type if exists units;
drop type if exists mr;
drop type if exists connection2;
drop type if exists danet2;

CREATE TYPE mr AS ENUM ('Д', 'Дср', 'Р', 'ОДПУ', 'ОДДУ', 'Нр');

CREATE TYPE units AS ENUM ('Гкал', 'куб.м');

CREATE TYPE resourcetype AS ENUM ('тепловая энергия', 'горячая вода', 'отопление');

CREATE TYPE transit AS ENUM ('разгружен', 'не разгружен', 'отсутствует');
CREATE TYPE scheme AS ENUM ('зависимая', 'независимая', 'зависимая/независимая');

CREATE TYPE connection AS ENUM ('ИТП', 'ЦТП', 'котельная', 'тепловая сеть','Тепловая сеть');


CREATE TYPE connection2 AS ENUM (
'элеватор',
'безэлеватор'
);

CREATE TYPE system AS ENUM ('закрытая', 'открытая');
CREATE TYPE system2 AS ENUM ('местная', 'центральная');

CREATE TYPE grafic AS ENUM ('95-70','105-70','120-70','150-70','125-70','130-70', '70-50', '90-70', '120-90');

DROP TYPE if exists pressure;
CREATE TYPE pressure AS ENUM (
'0',
'1',
'2',
'3',
'4',
'5',
'6',
'7',
'8',
'9',
'10',
'11',
'12',
'13',
'14',
'15',
'16',
'17'
);


CREATE TYPE danet2 AS ENUM (
'да',
'нет'
);


create table heat_raw (
    	id_in_file  		varchar(4), --1
    	bticode     		varchar(50), --2
    	supplier    		varchar(255), --3
    	connection_type 	connection, --4
    	system_type     	system, --5 для СЗАО его нет
    	consumer        	varchar(200), --6
    	resource_type   	resourcetype, --7
    	mes_units       	units, --8
    	number_of_devices 	decimal(10,0), --9
    	system_type2		system2,
    	enter_diametr		decimal(5,2),
    	enter_pressure		decimal(5,2),
    	heating_grafic 		varchar(255), --38
    	gvs_exists		danet2,
    	gvs_necessity		danet2,
    	system_accounting	danet2,
    	dispatch		danet2,
    	heating_connection	connection2,
    	gvs_reserv		danet2,
	notes 			varchar(255),--38
    	total_2011      	decimal, --10
    	total_2012      	decimal, --11
    	total_2013_jan  	decimal, -- 12
    	mr_2013_jan    		mr, --13
    	total_2013_feb  	decimal, --14
    	mr_2013_feb    		mr,  --15
    	total_2013_mar  	decimal,
    	mr_2013_mar    		mr, --17
    	total_2013_apr  	decimal,
    	mr_2013_apr    		mr, --19
    	total_2013_may  	decimal,
    	mr_2013_may    		mr, --21
    	total_2013_jun  	decimal,
    	mr_2013_jun    		mr, --23
    	total_2013_jul  	decimal,
    	mr_2013_jul    		mr, --25
    	total_2013_aug  	decimal,
    	mr_2013_aug    		mr, --27
    	total_2013_sep  	decimal,
    	mr_2013_sep    		mr, --29
    	total_2013_oct  	decimal,
    	mr_2013_oct    		mr, --31
    	total_2013_nov  	decimal,
    	mr_2013_nov    		mr, --33
    	total_2013_dec  	decimal,
    	mr_2013_dec    		mr, --35
    	total_2013      	decimal, --36
    	contract_load_2013	decimal, --37 <=10
    	temperature_grafic 	grafic, --38
    	heating_scheme 		scheme, --39 нет - это не правильно
    	count_lift_nodes 	varchar(50), --40 АУУ верно
    	heating_transit  	transit,--41 да нет
	notes2 			varchar(255)--38 

);

CREATE INDEX he_ind ON heat_raw(bticode);

