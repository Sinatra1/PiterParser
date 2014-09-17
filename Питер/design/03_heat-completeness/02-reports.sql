copy ( 
	SELECT t.* 
	FROM feeling_report AS t
	ORDER BY t."Район", t."Улица", t."Дом", t."Корпус", t."Код БТИ"

) to '/home/vlad/reports/ac-data-qual/%raion% Отчет о полноте данных.csv'
with csv header delimiter ';' encoding 'win_1251'
;

--отчет о выполнении условий вкладка МКД
copy ( 
	SELECT t.*
	FROM uslov_report_MKD AS t
	ORDER BY t."Улица", t."Дом", t."Код БТИ"

) to '/home/vlad/reports/ac-data-qual/%raion% Отчет о выполнении условий вкладка МКД.csv'
with csv header delimiter ';' encoding 'win_1251'
;

--отчет о выполнении условий вкладка ТЭ
copy ( 
	SELECT t.*
	FROM uslov_report_TE AS t

	ORDER BY t."Код БТИ"

) to '/home/vlad/reports/ac-data-qual/%raion% Отчет о выполнении условий вкладка ТЭ.csv'
with csv header delimiter ';' encoding 'win_1251'
;

copy ( 
	SELECT (
	(SELECT count(e.*) FROM error_bticodes AS e)::float
	/
	(SELECT count(a.*) FROM analyzed_houses AS a)::float
	*100::float
	) AS "Процент некорректных строк"

) to '/home/vlad/reports/ac-data-qual/%raion% Процент некорректных строк.csv'
with csv header delimiter ';' encoding 'win_1251'
;

copy ( 
	SELECT (
	(SELECT sum_feeling FROM error_cells AS e)::float
	/
	(SELECT count(a.*)::float*75::float FROM analyzed_houses AS a)::float
	*100::float
	) AS "Процент некорректных ячеек"

) to '/home/vlad/reports/ac-data-qual/%raion% Процент некорректных ячеек.csv'
with csv header delimiter ';' encoding 'win_1251'
;

copy ( 
	SELECT (SELECT ho.id_in_file FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1), --1
	    (SELECT ho.okrug FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1), --2
	    (SELECT ho.raion FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--3
	    (SELECT ho.street FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--4
	    (SELECT ho.house FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--5
	    (SELECT ho.korpus FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--6
	    (SELECT ho.stroenie FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--7
	    (SELECT ho.bticode FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--8
	    (SELECT ho.mkd_uprav_form FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--9
	    (SELECT ho.category FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--10

	    (SELECT ho.house_type FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--11
	    (SELECT ho.series FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--12
	    (SELECT ho.year_built FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--13
	    (SELECT ho.wall_type FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--14
	    (SELECT ho.floors FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--15
	    (SELECT ho.underfloors FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--16
	    (SELECT ho.porches FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--17
	    (SELECT ho.flats FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--18

	    (SELECT ho.full_area FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--19	
	    (SELECT ho.heating_area FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--20
	    (SELECT ho.living_area FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--21
	    (SELECT ho.nonliving_area FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--22

	    (SELECT ho.electricity FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--23
	    (SELECT ho.water_cold FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--25
	    (SELECT ho.water_hot FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--24
	    (SELECT ho.sewerage FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--26
	    (SELECT ho.heat_supply FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--27
	    (SELECT ho.gas_supply FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--28
	    (SELECT ho.gas_heaters FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--29
	    (SELECT ho.gas_ovens FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--30
	    (SELECT ho.electro_ovens FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--31
	    (SELECT ho.lifts_count FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--32

	    (SELECT ho.e_devices_count FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--33
	    (SELECT ho.cw_devices_count FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--35
	    (SELECT ho.hw_devices_count FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--34
	    (SELECT ho.heat_devices_count FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1),--36
	    (SELECT ho.gas_devices_count FROM house_raw AS ho2 WHERE ho2.bticode = ho.bticode LIMIT 1)--,--37
	FROM analyzed_houses AS a
	JOIN house_raw AS ho ON a.bticode = ho.bticode
	JOIN heat_raw AS he ON ho.bticode = he.bticode
	ORDER BY   Cast(ho.id_in_file as integer)

) to '/home/vlad/reports/ac-data-qual/%raion% Вкладка МКД.csv'
with csv header delimiter ';' encoding 'win_1251'
;

copy ( 
	SELECT he.* 
	FROM analyzed_houses AS a
	JOIN house_raw AS ho ON a.bticode = ho.bticode
	JOIN heat_raw AS he ON ho.bticode = he.bticode
	ORDER BY   Cast(he.id_in_file as integer)

) to '/home/vlad/reports/ac-data-qual/%raion% Вкладка ТЭ.csv'
with csv header delimiter ';' encoding 'win_1251'
;




