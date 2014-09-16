--drop view heat_raw_uslov_report;
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
				he5.total_2013_dec+
				he5.total_2011+
				) <> he5.total_2013
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
	       
	GROUP BY "Район", "Улица", "Дом", "Код БТИ"
);
