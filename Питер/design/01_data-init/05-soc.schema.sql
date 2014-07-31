drop table if exists soc_raw;

CREATE TYPE units2 AS ENUM ('''Гкал''', '''М3''', '''M3''');

create table soc_raw (
	id_in_file 	varchar(10), --1
    	okrug   	varchar(40), --2
    	raion   	varchar(40),--3
    	consumer 	text, --4
    	address 	varchar(200), --5
    	bticode  	varchar(20),--6
    	gp		int,--7
    	service		varchar(50),--8
    	mes_units   	units2, --9
    	total_2009  	float, --10
	total_2010  	float, --11
	total_2011  	float, --12
	total_2012  	float --13
);

CREATE INDEX sc_ind ON soc_raw(bticode);

