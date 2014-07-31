drop table if exists bti_raw;

create table bti_raw (
	bticode  	varchar(20),--1
    	unad		int,--2
	kp		int,--3
	raion   	varchar(255),--4
	street  	varchar(255),--5
	house   	varchar(255),--6
	korpus  	varchar(255),--7
	stroenie 	varchar(255),--8
	status_address 	varchar(255),--9
	ownership 	varchar(255),--10
	construction	varchar(255),--1
	class		varchar(255),--12
	basic_type	varchar(255),--13
	function	varchar(255),--14
	project		varchar(255),--15
	walls		varchar(255),--16
	floor		int,--17
	min_floor 	int,--18
	year		int,--19
	area_nar	decimal,--20
	area_private	decimal,--21
	area_useful	decimal,--22
	area_living_pom	decimal,--23
	area_living	decimal,--24
	volume		decimal,--25
	plumbing	varchar(255),--26
	sewerage	varchar(255),--27
	hot_water	varchar(255),--28
	heating		varchar(255),--29
	gas_stove	decimal,--30
	electric_stove	decimal,--31
	porch		decimal,--32
	passenger_lift	decimal,--33
	service_lift	decimal,--34
	service_passenger_lift	decimal,--35
	living_premises	decimal,--36
	rooms		decimal--37
);

CREATE INDEX bt_ind ON bti_raw(bticode);

