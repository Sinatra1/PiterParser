--Дома каторые, должны участвовать в анализе
CREATE OR REPLACE VIEW analyzed_houses AS (

	SELECT ho.bticode

		FROM house_raw AS ho
		LEFT JOIN heat_raw AS he ON ho.bticode = he.bticode


		WHERE   ((
				(he.supplier NOT LIKE '%управлени%')
				AND (he.supplier NOT LIKE '%договор%')
				AND (he.supplier NOT LIKE '%на прямых расчетах%')
				AND (he.supplier NOT LIKE '%овостройка%')
				AND (he.supplier NOT LIKE '%не начислялось%')
				AND (he.supplier NOT LIKE '%данных нет%')
				AND (he.supplier NOT LIKE '%АОГВ%')
				AND (he.supplier NOT LIKE '''газ''')
				AND (he.supplier NOT LIKE '%авт. кот.%')
				AND (he.supplier NOT LIKE '%нежилой%')
				AND (he.supplier NOT LIKE '%амостоятельный%')
				AND (he.supplier NOT LIKE '%азовый кател%')
				AND (he.supplier NOT LIKE '%снесен%')
			)
			OR he.supplier IS NULL)
			AND ho.category IS NULL
			
		GROUP BY ho.bticode
);

--Дома каторые, должны попасть в отчет о корректности полей
CREATE OR REPLACE VIEW houses_for_feeling_report AS (

	SELECT ho.bticode AS "Код БТИ"
		FROM analyzed_houses AS ah
		JOIN house_raw AS ho ON ah.bticode = ho.bticode
		LEFT JOIN heat_raw AS he ON ho.bticode = he.bticode
	WHERE ho.bticode IS NOT NULL
	AND (   ho.okrug IS NULL
		OR ho.raion IS NULL
		OR ho.street IS NULL
		OR ho.house IS NULL
		OR ho.house IS NULL
		OR ho.korpus = '''--'''
		OR ho.mkd_uprav_form IS NULL
		OR ho.house_type IS NULL
		OR ho.series IS NULL
		OR ho.year_built IS NULL
		OR ho.wall_type IS NULL
		OR ho.floors IS NULL
		OR ho.underfloors IS NULL
		OR ho.porches IS NULL
		OR ho.flats IS NULL
		OR ho.full_area IS NULL
		OR ho.heating_area IS NULL
		OR ho.living_area IS NULL
		OR ho.nonliving_area IS NULL
		OR ho.electricity IS NULL
		OR ho.water_hot IS NULL
		OR ho.water_cold IS NULL
		OR ho.sewerage IS NULL
		OR ho.heat_supply IS NULL
		OR ho.gas_supply IS NULL
		OR ho.gas_heaters IS NULL
		OR ho.gas_ovens IS NULL
		OR ho.electro_ovens IS NULL
		OR ho.e_devices_count IS NULL
		OR ho.hw_devices_count IS NULL
		OR ho.cw_devices_count IS NULL
		OR ho.heat_devices_count IS NULL
		OR ho.gas_devices_count IS NULL

		OR he.supplier IS NULL
		OR he.connection_type IS NULL
		OR he.system_type IS NULL
		OR he.consumer IS NULL
		OR he.resource_type IS NULL
		OR he.mes_units IS NULL
		OR he.number_of_devices IS NULL
		OR he.system_type2 IS NULL
		OR he.enter_diametr IS NULL
		OR he.enter_pressure IS NULL
		OR he.heating_grafic IS NULL
		OR he.gvs_exists IS NULL
		OR he.gvs_necessity IS NULL
		OR he.system_accounting	IS NULL
		OR he.dispatch IS NULL
		OR he.heating_connection IS NULL
		OR he.gvs_reserv IS NULL
		OR he.total_2011  IS NULL
		OR he.total_2012  IS NULL
		OR he.total_2013_jan  IS NULL
		OR he.mr_2013_jan   IS NULL
		OR he.total_2013_feb  IS NULL
		OR he.mr_2013_feb    IS NULL
		OR he.total_2013_mar  IS NULL
		OR he.mr_2013_mar    IS NULL
		OR he.total_2013_apr IS NULL
		OR he.mr_2013_apr    IS NULL
		OR he.total_2013_may  IS NULL
		OR he.mr_2013_may    IS NULL
		OR he.total_2013_jun  IS NULL
		OR he.mr_2013_jun    IS NULL
		OR he.total_2013_jul  IS NULL
		OR he.mr_2013_jul    IS NULL
		OR he.total_2013_aug  IS NULL
		OR he.mr_2013_aug    IS NULL
		OR he.total_2013_sep IS NULL
		OR he.mr_2013_sep    IS NULL
		OR he.total_2013_oct IS NULL
		OR he.mr_2013_oct    IS NULL
		OR he.total_2013_nov  IS NULL
		OR he.mr_2013_nov    IS NULL
		OR he.total_2013_dec IS NULL
		OR he.mr_2013_dec   IS NULL
		OR he.total_2013   IS NULL
		OR he.contract_load_2013 IS NULL
		OR he.temperature_grafic IS NULL
		OR he.heating_scheme 	IS NULL
		OR he.count_lift_nodes IS NULL
		OR he.heating_transit IS NULL
	) 
	GROUP BY ho.bticode
);

--Отчет о полноте данных
CREATE OR REPLACE VIEW feeling_report AS (
	SELECT 
	      (SELECT ho2.raion FROM house_raw AS ho2 
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Район",
	      (SELECT ho2.street FROM house_raw AS ho2 
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Улица",
	      (SELECT ho2.house FROM house_raw AS ho2 
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Дом",
	      (SELECT (CASE (ho2.korpus = '''--''') 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Корпус",
	      (SELECT ho2.stroenie FROM house_raw AS ho2 
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Строение",
    	      t."Код БТИ",

	      (SELECT (CASE (ho2.mkd_uprav_form IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Форма управления МКД",

	      (SELECT (CASE (ho2.house_type IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Тип дома",

	      (SELECT (CASE (ho2.series IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Серия дома",

              (SELECT (CASE (ho2.year_built IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Год постройки",

	      (SELECT (CASE (ho2.wall_type IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Тип стен",

	      (SELECT (CASE (ho2.floors IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Количество этажей",

	      (SELECT (CASE (ho2.underfloors IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Количество подземных этажей",

	      (SELECT (CASE (ho2.porches IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Количество парадных",

	      (SELECT (CASE (ho2.flats IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Количество квартир",

	      (SELECT (CASE (ho2.full_area IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Общая площадь дома",

	      (SELECT (CASE (ho2.heating_area IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Общая отапливаемой площадь",

	      (SELECT (CASE (ho2.living_area IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Площадь жилых помещений",

	      (SELECT (CASE (ho2.nonliving_area IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Площадь нежилых помещений",

	      (SELECT (CASE (ho2.electricity IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Электоэнергия",

	      (SELECT (CASE (ho2.water_cold IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "ХВС",

	      (SELECT (CASE (ho2.water_hot IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "ГВС",

	      (SELECT (CASE (ho2.sewerage IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Водоотведение",

	      (SELECT (CASE (ho2.heat_supply IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Отопление",

	      (SELECT (CASE (ho2.gas_supply IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Газоснабжение",

	      (SELECT (CASE (ho2.gas_heaters IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Оснащение газ. колонками",

	      (SELECT (CASE (ho2.gas_ovens IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Оснащение газ.плитами",

	      (SELECT (CASE (ho2.electro_ovens IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Оснащение электроплитами",

	      (SELECT (CASE (ho2.lifts_count IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Кол-во лифтов дома",

	      (SELECT (CASE (ho2.e_devices_count  IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "колич. ЭЭ",

	      (SELECT (CASE (ho2.cw_devices_count  IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "колич. ХВС",

	      (SELECT (CASE (ho2.hw_devices_count  IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "колич. ГВС",

	      (SELECT (CASE (ho2.heat_devices_count  IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "колич. ТЭ",

	      (SELECT (CASE (ho2.gas_devices_count  IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "колич. Газ",

	      (SELECT (CASE (he2.supplier IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Поставщик ресурсов",

	      (SELECT (CASE (he2.connection_type IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Тип подключения дома",

	      (SELECT (CASE (he2.consumer IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Потребитель ресурса",

	      (SELECT (CASE (he2.resource_type IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Вид ресурса",

	      (SELECT (CASE (he2.mes_units IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Ед. изм.",

	      (SELECT (CASE (he2.number_of_devices IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Кол-во приборов учета тепловой энергии",

	      (SELECT (CASE (he2.system_type2 IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Тим системы",

	      (SELECT (CASE (he2.enter_diametr IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Диаметр ввода",

	      (SELECT (CASE (he2.enter_pressure IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Давление на вводе",

	      (SELECT (CASE (he2.heating_grafic IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Температурный график тепловой сети",

	      (SELECT (CASE (he2.gvs_exists IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Наличие ГВС",

	      (SELECT (CASE (he2.gvs_necessity IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Необходимость резерва ГВС",

	      (SELECT (CASE (he2.system_accounting IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Наличие систем учета",

	      (SELECT (CASE (he2.dispatch IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Необходимость дииспетчиризации",

	      (SELECT (CASE (he2.heating_connection IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Схема присоединения к тепловой сети",

	      (SELECT (CASE (he2.gvs_reserv IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Резервирование насосов ГВС",

	      (SELECT (CASE (he2.total_2011 IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Потребление за 2011 год",

	      (SELECT (CASE (he2.total_2012 IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Потребление за 2012 год",

	      (SELECT (CASE (he2.total_2013 IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Потребление за 2013 год",

	      (SELECT (CASE (he2.total_2013_jan IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Всего за 2013 январь",

	      (SELECT (CASE (he2.mr_2013_jan IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "МР 2013 январь",

	      (SELECT (CASE (he2.total_2013_feb IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Всего за 2013 февраль",

		(SELECT (CASE (he2.mr_2013_feb IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "МР 2013 февраль",

	      (SELECT (CASE (he2.total_2013_mar IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Всего за 2013 март",

	      (SELECT (CASE (he2.mr_2013_mar IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "МР 2013 март",

	      (SELECT (CASE (he2.total_2013_apr IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Всего за 2013 апрель",

	      (SELECT (CASE (he2.mr_2013_apr IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "МР 2013 апрель",

	      (SELECT (CASE (he2.total_2013_sep IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Всего за 2013 сентябрь",

		(SELECT (CASE (he2.mr_2013_sep IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "МР 2013 сентябрь",

	      (SELECT (CASE (he2.total_2013_oct IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Всего за 2013 октябрь",

		(SELECT (CASE (he2.mr_2013_oct IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "МР 2013 октябрь",

	      (SELECT (CASE (he2.total_2013_nov IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Всего за 2013 ноябрь",

		(SELECT (CASE (he2.mr_2013_nov IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "МР 2013 ноябрь",

	      (SELECT (CASE (he2.total_2013_dec IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Всего за 2013 декабрь",

		(SELECT (CASE (he2.mr_2013_dec IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "МР 2013 декабрь",

	      (SELECT (CASE (he2.contract_load_2013 IS NULL OR he2.contract_load_2013 > 10) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Договорная нагрузка",

	      (SELECT (CASE (he2.temperature_grafic IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Нормативный температурный график",

	      (SELECT (CASE (he2.heating_scheme IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Схема присоединения системы отопления",

	      (SELECT (CASE (he2.count_lift_nodes IS NULL)  
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END )
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Количество элеваторных узлов",

	      (SELECT (CASE (he2.heating_transit IS NULL) 
			AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
			WHEN TRUE THEN '?' END ) 
		FROM house_raw AS ho2
		LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
		WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "Транзит на отопление"

	FROM houses_for_feeling_report AS t
);

--Дома со вкладки МКД, каторые должны попасть в отчет о выполнении условий
CREATE OR REPLACE VIEW heat_raw_for_uslov_report AS (

SELECT 	   he5.bticode AS "Код БТИ"

	FROM analyzed_houses AS ah
	JOIN heat_raw AS he5 ON ah.bticode = he5.bticode
	LEFT JOIN house_raw AS ho5 ON he5.bticode = ho5.bticode


	WHERE (
		(ho5.bticode IS NULL AND he5.bticode IS NOT NULL) 
		OR (--если есть раздвоение на вкладке МКД по адресу
			(SELECT count(ho2.street) 
				FROM (SELECT ho3.raion, ho3.street, ho3.house, ho3.korpus
					FROM house_raw AS ho3
					WHERE ho3.bticode = he5.bticode

					) AS ho2
				GROUP BY ho2.raion, 
					 ho2.street,
					 ho2.house,
					 ho2.korpus 
					LIMIT 1

				) > 1

		)		
		OR (--если есть раздвоение на вкладке МКД по коду БТИ
			(SELECT count(ho2.street) FROM 

					(SELECT ho3.raion, ho3.street, ho3.house
					FROM house_raw AS ho3
					WHERE ho3.bticode = he5.bticode

					GROUP BY ho3.raion, 
						 ho3.street, 
						 ho3.house

					) AS ho2
				) > 1
		)
		OR he5.enter_diametr IS NULL
		OR he5.enter_pressure IS NULL
		OR he5.total_2011 <= he5.total_2013_jan
		OR he5.total_2011 <= he5.total_2013_feb
		OR he5.total_2011 <= he5.total_2013_mar
		OR he5.total_2011 <= he5.total_2013_apr
		OR he5.total_2011 <= he5.total_2013_oct
		OR he5.total_2011 <= he5.total_2013_nov
		OR he5.total_2011 <= he5.total_2013_dec
		OR he5.total_2012 <= he5.total_2013_jan
		OR he5.total_2012 <= he5.total_2013_feb
		OR he5.total_2012 <= he5.total_2013_mar
		OR he5.total_2012 <= he5.total_2013_apr
		OR he5.total_2012 <= he5.total_2013_oct
		OR he5.total_2012 <= he5.total_2013_nov
		OR he5.total_2012 <= he5.total_2013_dec
		OR (	(he5.total_2013_jan+
			he5.total_2013_feb+
			he5.total_2013_mar+
			he5.total_2013_apr+
			he5.total_2013_may+
			he5.total_2013_jun+
			he5.total_2013_jul+
			he5.total_2013_aug+
			he5.total_2013_sep+
			he5.total_2013_oct+
			he5.total_2013_nov+
			he5.total_2013_dec)
			<> he5.total_2013
		   )
		OR he5.contract_load_2013 IS NULL   
	     )  
	GROUP BY "Код БТИ"
);

drop view heat_raw_uslov_report;
CREATE OR REPLACE VIEW heat_raw_uslov_report AS (

	SELECT he5."Код БТИ"
		,  (CASE ((SELECT count(ho2.bticode) FROM house_raw AS ho2 
			WHERE ho2.bticode = he5."Код БТИ") = 0) AND (he5."Код БТИ" IS NOT NULL) WHEN TRUE THEN 'Да' END ) AS "Нет информации на вкладе МКД",
		(CASE ((SELECT count(ho2.street) FROM 
		
			(SELECT ho3.raion, ho3.street, ho3.house, ho3.korpus
				FROM house_raw AS ho3
				WHERE ho3.bticode = he5."Код БТИ"

			) AS ho2
			GROUP BY ho2.raion, ho2.street, ho2.house, ho2.korpus LIMIT 1
			) > 1
			OR
			(SELECT count(ho2.street) FROM 

			(SELECT ho3.raion, ho3.street, ho3.house
			FROM house_raw AS ho3
			WHERE ho3.bticode = he5."Код БТИ"

			GROUP BY ho3.raion, ho3.street, ho3.house

			) AS ho2
			) > 1) AND (he5."Код БТИ" IS NOT NULL) WHEN TRUE THEN 'Да' END ) 	AS "Раздвоение во вкладке МКД"
		, (CASE (he5.enter_diametr IS NULL) WHEN TRUE THEN 'Да' END) 		AS "Диаметр ввода > 200"
		, (CASE (he5.enter_pressure IS NULL) WHEN TRUE THEN 'Да' END) 		AS "Давление на вводе > 17"
		, (CASE (he5.total_2011 <= he5.total_2013_jan
			OR he5.total_2011 <= he5.total_2013_feb
			OR he5.total_2011 <= he5.total_2013_mar
			OR he5.total_2011 <= he5.total_2013_apr
			OR he5.total_2011 <= he5.total_2013_oct
			OR he5.total_2011 <= he5.total_2013_nov
			OR he5.total_2011 <= he5.total_2013_dec) WHEN TRUE THEN 'Да' END) AS "Итого за 2011 <= чем в месяце за 2013"
		, (CASE (he5.total_2012 <= he5.total_2013_jan
			OR he5.total_2012 <= he5.total_2013_feb
			OR he5.total_2012 <= he5.total_2013_mar
			OR he5.total_2012 <= he5.total_2013_apr
			OR he5.total_2012 <= he5.total_2013_oct
			OR he5.total_2012 <= he5.total_2013_nov
			OR he5.total_2012 <= he5.total_2013_dec) WHEN TRUE THEN 'Да' END) AS "Итого за 2012 <= чем в месяце за 2013"
		, (CASE (he5.total_2011 <= he5.total_2013_jan
			OR he5.total_2012 <= he5.total_2013_jan) WHEN TRUE THEN 'Да' END) AS "Январь 2013 >= итого 2011 или 2012"
		, (CASE (he5.total_2011 <= he5.total_2013_feb
			OR he5.total_2012 <= he5.total_2013_feb) WHEN TRUE THEN 'Да' END) AS "Февраль 2013 >= итого 2011 или 2012"
		, (CASE (he5.total_2011 <= he5.total_2013_mar
			OR he5.total_2012 <= he5.total_2013_mar) WHEN TRUE THEN 'Да' END) AS "Март 2013 >= итого 2011 или 2012"
		, (CASE (he5.total_2011 <= he5.total_2013_apr
			OR he5.total_2012 <= he5.total_2013_apr) WHEN TRUE THEN 'Да' END) AS "Апрель 2013 >= итого 2011 или 2012"
		, (CASE (he5.total_2011 <= he5.total_2013_oct
			OR he5.total_2012 <= he5.total_2013_oct) WHEN TRUE THEN 'Да' END) AS "Октябрь 2013 >= итого 2011 или 2012"
		, (CASE (he5.total_2011 <= he5.total_2013_nov
			OR he5.total_2012 <= he5.total_2013_nov) WHEN TRUE THEN 'Да' END) AS "Ноябрь 2013 >= итого 2011 или 2012"
		, (CASE (he5.total_2011 <= he5.total_2013_dec
			OR he5.total_2012 <= he5.total_2013_dec) WHEN TRUE THEN 'Да' END) AS "Декабрь 2013 >= итого 2011 или 2012"
		, (CASE (	(he5.total_2013_jan+
				he5.total_2013_feb+
				he5.total_2013_mar+
				he5.total_2013_apr+
				he5.total_2013_may+
				he5.total_2013_jun+
				he5.total_2013_jul+
				he5.total_2013_aug+
				he5.total_2013_sep+
				he5.total_2013_oct+
				he5.total_2013_nov+
				he5.total_2013_dec) <> he5.total_2013
	   	) WHEN TRUE THEN 'Да' END) 						AS "Сумма по мес. 2013 не равна Итого 2013"
		, (CASE (he5.contract_load_2013 IS NULL) WHEN TRUE THEN 'Да' END) 	AS "Договор. нагр. не в интервале [0,01: 25]"

	FROM
	(SELECT t2."Код БТИ"
		, he6.*
		
	FROM heat_raw_for_uslov_report AS t2
	JOIN heat_raw AS he6 ON t2."Код БТИ" = he6.bticode
	LEFT JOIN house_raw AS ho6 ON he6.bticode = ho6.bticode
	) AS he5
);

--Дома со вкладки МКД, каторые должны попасть в отчет о выполнении условий
CREATE OR REPLACE VIEW house_raw_for_uslov_report AS (

SELECT 	   ho5.bticode AS "Код БТИ",
	   ho5.raion AS "Район",
	   ho5.street AS "Улица",
	   ho5.house AS "Дом"

	FROM analyzed_houses AS ah
	JOIN house_raw AS ho5 ON ah.bticode = ho5.bticode
	LEFT JOIN heat_raw AS he5 ON ho5.bticode = he5.bticode
	 
	WHERE   (ho5.bticode IS NOT NULL AND he5.bticode IS NULL) 
		OR (--если не каждой строке вкладки ТЭ с данным кодом БТИ соответствует строка с данным кодом БТИ на вкладке МКД
			(SELECT count(he3.bticode) FROM heat_raw AS he3 WHERE he3.bticode = ho5.bticode) <> 
			(SELECT count(ho2.bticode) FROM house_raw AS ho2 WHERE ho2.bticode = ho5.bticode)

		)
		OR ho5.floors IS NULL
		OR ho5.porches IS NULL
		OR ho5.flats IS NULL
		OR ho5.full_area IS NULL
		OR ho5.heating_area IS NULL
		OR ho5.living_area IS NULL
		OR ho5.full_area < ho5.heating_area
		OR ho5.full_area <> (ho5.nonliving_area + ho5.living_area)
	       
	GROUP BY "Район", "Улица", "Дом", "Код БТИ"
);


drop view house_raw_uslov_report;
CREATE OR REPLACE VIEW house_raw_uslov_report AS (

	SELECT ho5."Код БТИ"
		, ho5."Улица"
		, ho5."Дом"
		, (CASE ((SELECT count(he2.bticode) FROM heat_raw AS he2 
			WHERE he2.bticode = ho5."Код БТИ") = 0) AND (ho5."Код БТИ" IS NOT NULL) WHEN TRUE THEN 'Да' END ) AS "Нет информации на вкладе ТЭ"
		, (CASE ((SELECT count(he3.bticode) FROM heat_raw AS he3 WHERE he3.bticode = ho5."Код БТИ") <> 
			(SELECT count(ho2.bticode) FROM house_raw AS ho2 WHERE ho2.bticode = ho5."Код БТИ")
		) WHEN TRUE THEN 'Да' END ) 									AS "Если не каждой строке ТЭ => строка МКД"
		, (CASE (ho5.floors IS NULL) WHEN TRUE THEN 'Да' END) 						AS "Колич. этажей < 1"
		, (CASE (ho5.porches IS NULL) WHEN TRUE THEN 'Да' END) 						AS "Колич. парадных < 1"
		, (CASE (ho5.flats IS NULL) WHEN TRUE THEN 'Да' END) 						AS "Колич. квартир < 1"
		, (CASE (ho5.full_area IS NULL) WHEN TRUE THEN 'Да' END) 						AS "Общ. площадь < 50"
		, (CASE (ho5.heating_area IS NULL) WHEN TRUE THEN 'Да' END) 					AS "Отаплив. площадь < 50"
		, (CASE (ho5.living_area IS NULL) WHEN TRUE THEN 'Да' END) 					AS "Жил. площадь < 50"
		, (CASE (ho5.full_area < ho5.heating_area) WHEN TRUE THEN 'Да' END) 				AS "Общ. площадь < Отаплив. площади"
		, (CASE (ho5.full_area <> (ho5.nonliving_area + ho5.living_area)) WHEN TRUE THEN 'Да' END) AS "Общ. площадь не = (жил. + нежил.)"

	FROM (SELECT t2."Код БТИ"
		, t2."Улица"
		, t2."Дом"
		, ho6.*
		
		FROM house_raw_for_uslov_report AS t2
		JOIN house_raw AS ho6 ON (t2."Код БТИ" = ho6.bticode AND t2."Улица" = ho6.street AND t2."Дом" = ho6.house)
		LEFT JOIN heat_raw AS he6 ON ho6.bticode = he6.bticode
	) AS ho5
);

CREATE OR REPLACE VIEW uslov_report_MKD AS (
	SELECT h."Код БТИ"
		, (SELECT h3."Улица" 
			FROM house_raw_uslov_report AS h3 
			WHERE h3."Код БТИ" = h."Код БТИ" LIMIT 1) AS "Улица" 
		, (SELECT h3."Дом" 
			FROM house_raw_uslov_report AS h3 
			WHERE h3."Код БТИ" = h."Код БТИ" LIMIT 1) AS "Дом" 
		, (SELECT h3."Нет информации на вкладе ТЭ" 
			FROM house_raw_uslov_report AS h3 
			WHERE h3."Код БТИ" = h."Код БТИ" LIMIT 1) AS "Нет информации на вкладе ТЭ"
		, (SELECT h3."Если не каждой строке ТЭ => строка МКД" 
			FROM house_raw_uslov_report AS h3 
			WHERE h3."Код БТИ" = h."Код БТИ" LIMIT 1) AS "Раздвоение во вкладке ТЭ"
		, (SELECT h3."Колич. этажей < 1" 
			FROM house_raw_uslov_report AS h3 
			WHERE h3."Код БТИ" = h."Код БТИ" LIMIT 1) AS "Колич. этажей < 1"
		, (SELECT h3."Колич. парадных < 1" 
			FROM house_raw_uslov_report AS h3 
			WHERE h3."Код БТИ" = h."Код БТИ" LIMIT 1) AS "Колич. парадных < 1"
		, (SELECT h3."Колич. квартир < 1"
			FROM house_raw_uslov_report AS h3 
			WHERE h3."Код БТИ" = h."Код БТИ" LIMIT 1) AS "Колич. квартир < 1"
		, (SELECT h3."Общ. площадь < 50"
			FROM house_raw_uslov_report AS h3 
			WHERE h3."Код БТИ" = h."Код БТИ" LIMIT 1) AS "Общ. площадь < 50"
		, (SELECT h3."Отаплив. площадь < 50"
			FROM house_raw_uslov_report AS h3 
			WHERE h3."Код БТИ" = h."Код БТИ" LIMIT 1) AS "Отаплив. площадь < 50"
		, (SELECT h3."Жил. площадь < 50"
			FROM house_raw_uslov_report AS h3 
			WHERE h3."Код БТИ" = h."Код БТИ" LIMIT 1) AS "Жил. площадь < 50"
		, (SELECT h3."Общ. площадь < Отаплив. площади"
			FROM house_raw_uslov_report AS h3 
			WHERE h3."Код БТИ" = h."Код БТИ" LIMIT 1) AS "Общ. площадь < Отаплив. площади"
		, (SELECT h3."Общ. площадь не = (жил. + нежил.)"
			FROM house_raw_uslov_report AS h3 
			WHERE h3."Код БТИ" = h."Код БТИ" LIMIT 1) AS "Общ. площадь не = (жил. + нежил.)" 
	FROM (SELECT h2."Код БТИ" FROM house_raw_uslov_report AS h2 GROUP BY h2."Код БТИ") AS h
);

CREATE OR REPLACE VIEW uslov_report_TE AS (
	SELECT he."Код БТИ"
		, (SELECT he3."Нет информации на вкладе МКД" 
			FROM heat_raw_uslov_report AS he3 
			WHERE he3."Код БТИ" = he."Код БТИ" LIMIT 1) AS "Нет информации на вкладе МКД"
		, (SELECT he3."Раздвоение во вкладке МКД" 
			FROM heat_raw_uslov_report AS he3 
			WHERE he3."Код БТИ" = he."Код БТИ" LIMIT 1) AS "Раздвоение во вкладке МКД"
		, (SELECT he3."Диаметр ввода > 200" 
			FROM heat_raw_uslov_report AS he3 
			WHERE he3."Код БТИ" = he."Код БТИ" LIMIT 1) AS "Диаметр ввода > 200"
		, (SELECT he3."Давление на вводе > 17" 
			FROM heat_raw_uslov_report AS he3 
			WHERE he3."Код БТИ" = he."Код БТИ" LIMIT 1) AS "Давление на вводе > 17"
		, (SELECT he3."Итого за 2011 <= чем в месяце за 2013" 
			FROM heat_raw_uslov_report AS he3 
			WHERE he3."Код БТИ" = he."Код БТИ" LIMIT 1) AS "Итого за 2011 <= чем в месяце за 2013"
		, (SELECT he3."Итого за 2012 <= чем в месяце за 2013" 
			FROM heat_raw_uslov_report AS he3 
			WHERE he3."Код БТИ" = he."Код БТИ" LIMIT 1) AS "Итого за 2012 <= чем в месяце за 2013"
		, (SELECT he3."Январь 2013 >= итого 2011 или 2012" 
			FROM heat_raw_uslov_report AS he3 
			WHERE he3."Код БТИ" = he."Код БТИ" LIMIT 1) AS "Январь 2013 >= итого 2011 или 2012"
		, (SELECT he3."Февраль 2013 >= итого 2011 или 2012" 
			FROM heat_raw_uslov_report AS he3 
			WHERE he3."Код БТИ" = he."Код БТИ" LIMIT 1) AS "Февраль 2013 >= итого 2011 или 2012"
		, (SELECT he3."Март 2013 >= итого 2011 или 2012" 
			FROM heat_raw_uslov_report AS he3 
			WHERE he3."Код БТИ" = he."Код БТИ" LIMIT 1) AS "Март 2013 >= итого 2011 или 2012"
		, (SELECT he3."Апрель 2013 >= итого 2011 или 2012" 
			FROM heat_raw_uslov_report AS he3 
			WHERE he3."Код БТИ" = he."Код БТИ" LIMIT 1) AS "Апрель 2013 >= итого 2011 или 2012"
		, (SELECT he3."Октябрь 2013 >= итого 2011 или 2012" 
			FROM heat_raw_uslov_report AS he3 
			WHERE he3."Код БТИ" = he."Код БТИ" LIMIT 1) AS "Октябрь 2013 >= итого 2011 или 2012"
		, (SELECT he3."Ноябрь 2013 >= итого 2011 или 2012" 
			FROM heat_raw_uslov_report AS he3 
			WHERE he3."Код БТИ" = he."Код БТИ" LIMIT 1) AS "Ноябрь 2013 >= итого 2011 или 2012"
		, (SELECT he3."Декабрь 2013 >= итого 2011 или 2012" 
			FROM heat_raw_uslov_report AS he3 
			WHERE he3."Код БТИ" = he."Код БТИ" LIMIT 1) AS "Декабрь 2013 >= итого 2011 или 2012"
		, (SELECT he3."Сумма по мес. 2013 не равна Итого 2013" 
			FROM heat_raw_uslov_report AS he3 
			WHERE he3."Код БТИ" = he."Код БТИ" LIMIT 1) AS "Сумма по мес. 2013 не равна Итого 2013"
		, (SELECT he3."Договор. нагр. не в интервале [0,01: 25]" 
			FROM heat_raw_uslov_report AS he3 
			WHERE he3."Код БТИ" = he."Код БТИ" LIMIT 1) AS "Договор. нагр. не в интервале [0,01: 25]"
	FROM (SELECT he2."Код БТИ" FROM heat_raw_uslov_report AS he2 GROUP BY he2."Код БТИ") AS he
);

CREATE OR REPLACE VIEW error_bticodes AS (
	SELECT f."Код БТИ" FROM feeling_report AS f
	UNION
	SELECT mkd."Код БТИ" FROM uslov_report_MKD AS mkd
	UNION
	SELECT te."Код БТИ" FROM uslov_report_TE AS te
);

CREATE OR REPLACE VIEW error_cells AS (
	SELECT SUM(
	      	(CASE t."Район" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
	      	(CASE t."Улица" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Дом" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Корпус" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Строение" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Код БТИ" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Форма управления МКД" IS NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Тип дома" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Серия дома" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Год постройки" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Тип стен" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Количество этажей" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Количество подземных этажей" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Количество парадных" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Количество квартир" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Общая площадь дома" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Общая отапливаемой площадь" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Площадь жилых помещений" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Площадь нежилых помещений" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Электоэнергия" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."ХВС" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."ГВС" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Водоотведение" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Отопление" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Газоснабжение" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Оснащение газ. колонками" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Оснащение газ.плитами" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Оснащение электроплитами" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Кол-во лифтов дома" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."колич. ЭЭ" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."колич. ХВС" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."колич. ГВС" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."колич. ТЭ" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."колич. Газ" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Поставщик ресурсов" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Тип подключения дома" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Потребитель ресурса" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Вид ресурса" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Ед. изм." IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Кол-во приборов учета тепловой энергии" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Тим системы" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Диаметр ввода" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Давление на вводе" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Температурный график тепловой сети" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Наличие ГВС" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Необходимость резерва ГВС" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Наличие систем учета" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Необходимость дииспетчиризации" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Схема присоединения к тепловой сети" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Резервирование насосов ГВС" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Потребление за 2011 год" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Потребление за 2012 год" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Потребление за 2013 год" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Всего за 2013 январь" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."МР 2013 январь" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Всего за 2013 февраль" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."МР 2013 февраль" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Всего за 2013 март" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."МР 2013 март" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Всего за 2013 апрель" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."МР 2013 апрель" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Всего за 2013 сентябрь" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."МР 2013 сентябрь" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Всего за 2013 октябрь" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."МР 2013 октябрь" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Всего за 2013 ноябрь" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."МР 2013 ноябрь" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Всего за 2013 декабрь" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."МР 2013 декабрь" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Договорная нагрузка" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Нормативный температурный график" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Схема присоединения системы отопления" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Количество элеваторных узлов" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END ) +
		(CASE t."Транзит на отопление" IS NOT NULL WHEN TRUE THEN 1 ELSE 0 END )
	     ) AS sum_feeling
		

	FROM feeling_report AS t
);





