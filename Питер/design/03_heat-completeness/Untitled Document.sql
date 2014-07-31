--Процент косячных строк в общей массе
copy(
SELECT 

(SELECT (SELECT COUNT(t2.*) FROM
		(
			SELECT ho.bticode AS "Код БТИ"

				   
				FROM house_raw AS ho
				LEFT JOIN heat_raw AS he ON ho.bticode = he.bticode


				WHERE (
					(ho.bticode IS NOT NULL AND he.bticode IS NULL)
					OR ho.heating_area IS NULL
					OR he.total_2011 IS NULL
					OR he.total_2012 IS NULL
					OR he.total_2013 IS NULL
					OR he.total_2013_jan IS NULL
					OR he.total_2013_jan IS NULL
					OR he.total_2013_jan IS NULL
					OR he.total_2013_feb IS NULL
					OR he.total_2013_mar IS NULL
					OR he.total_2013_apr IS NULL
					OR he.total_2013_sep IS NULL
					OR he.total_2013_oct IS NULL
					OR he.total_2013_nov IS NULL
					OR he.total_2013_dec IS NULL
					OR he.contract_load_2013 IS NULL
					OR he.contract_load_2013 > 10
					OR he.temperature_grafic IS NULL
					OR he.heating_scheme IS NULL
					OR he.count_lift_nodes IS NULL
					OR he.heating_transit IS NULL
					OR he.connection_type IS NULL
					OR he.system_type IS NULL
					OR ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = ho.bticode) > 1)
					) AND (he.supplier NOT LIKE '%управлени%')
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
					AND (
						(
							(ho.category NOT LIKE '%едомственный%')
							AND (ho.category NOT LIKE '%бщежитие%')
							AND (ho.category NOT LIKE '%гостиничног%')
							AND (ho.category NOT LIKE '%часный ж/ф%')
						)	
						OR (ho.category IS NULL)
					)		
			

			
				GROUP BY "Код БТИ"
			    ) AS t2
	)

	+
	(SELECT COUNT(t3.*) FROM
		 (SELECT he5.bticode AS "Код БТИ"

				   
				FROM heat_raw AS he5
				LEFT JOIN house_raw AS ho5 ON he5.bticode = ho5.bticode


				WHERE (
					(ho5.bticode IS NULL AND he5.bticode IS NOT NULL) 
				     )  AND (he5.supplier NOT LIKE '%управлени%')
					AND (he5.supplier NOT LIKE '%договор%')
					AND (he5.supplier NOT LIKE '%на прямых расчетах%')
					AND (he5.supplier NOT LIKE '%овостройка%')
					AND (he5.supplier NOT LIKE '%не начислялось%')
					AND (he5.supplier NOT LIKE '%данных нет%')
					AND (he5.supplier NOT LIKE '%АОГВ%')
					AND (he5.supplier NOT LIKE '%авт. кот.%')
					AND (he5.supplier NOT LIKE '%нежилой%')
					AND (he5.supplier NOT LIKE '%амостоятельный%')
					AND (he5.supplier NOT LIKE '%азовый кател%')
					AND (
						(
							(ho5.category NOT LIKE '%едомственный%')
							AND (ho5.category NOT LIKE '%бщежитие%')
							AND (ho5.category NOT LIKE '%гостиничног%')
							AND (ho5.category NOT LIKE '%часный ж/ф%')
						)	
						OR (ho5.category IS NULL)
					)	
				GROUP BY "Код БТИ"
			    ) AS t3
	)

)

/


(SELECT COUNT(t4.*) FROM
	(
		SELECT ho.bticode as "Код БТИ"

		FROM house_raw AS ho
		JOIN heat_raw AS he ON ho.bticode = he.bticode

		WHERE (he.supplier NOT LIKE '%управлени%')
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
			AND (
				(
					(ho.category NOT LIKE '%едомственный%')
					AND (ho.category NOT LIKE '%бщежитие%')
					AND (ho.category NOT LIKE '%гостиничног%')
					AND (ho.category NOT LIKE '%часный ж/ф%')
				)	
				OR (ho.category IS NULL)
			)

		GROUP BY "Код БТИ"
	) AS t4
	
)::numeric(10,3)*100::numeric(10,3) AS "Процент косячных строк в общей массе"
) to '/home/vlad/reports/ac-data-qual/Процент косячных строк в общей массе.csv'
with csv header delimiter ';' encoding 'win_1251'
;

--Процент косячных ячеек по заполненным данным

copy ( SELECT (
			      (SELECT  SUM(
			      (CASE t."Район" IS NULL WHEN TRUE THEN 1 ELSE 0 END ) +
			      (CASE t."Код БТИ" IS NULL WHEN TRUE THEN 1 ELSE 0 END ) + 
			      (CASE t."Улица" IS NULL WHEN TRUE THEN 1 ELSE 0 END ) +
			      (CASE t."Дом" IS NULL WHEN TRUE THEN 1 ELSE 0 END ) +
			      (CASE (SELECT ho2.korpus FROM house_raw AS ho2 
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) IS NULL WHEN TRUE THEN 1 ELSE 0 END ) +
				(CASE (SELECT ho2.stroenie FROM house_raw AS ho2 
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) IS NULL WHEN TRUE THEN 1 ELSE 0 END ) +
			      (SELECT (CASE ((ho2.bticode IS NOT NULL) AND (he2.bticode IS NULL)) WHEN TRUE THEN 43 ELSE 0 END )
				FROM house_raw AS ho2
				LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) +
			      
			      (SELECT (CASE (ho2.heating_area IS NULL) 
					  
					AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
					WHEN TRUE THEN 1 ELSE 0 END )
				FROM house_raw AS ho2
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) +
			      (SELECT (CASE (he2.connection_type IS NULL) 
					AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
					WHEN TRUE THEN 1 ELSE 0 END )
				FROM house_raw AS ho2
				LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) +
			      (SELECT (CASE (he2.system_type IS NULL)  
					AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
					WHEN TRUE THEN 1 ELSE 0 END )
				FROM house_raw AS ho2
				LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) +
			      (SELECT (CASE (he2.total_2011 IS NULL) 
					AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
					WHEN TRUE THEN 1 ELSE 0 END )
				FROM house_raw AS ho2
				LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) +
			      (SELECT (CASE (he2.total_2012 IS NULL)  
					AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
					WHEN TRUE THEN 1 ELSE 0 END )
				FROM house_raw AS ho2
				LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) +
			      (SELECT (CASE (he2.total_2013 IS NULL) 
					AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
					WHEN TRUE THEN 1 ELSE 0 END )
				FROM house_raw AS ho2
				LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) +
			      (SELECT (CASE (he2.total_2013_jan IS NULL) 
					AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
					WHEN TRUE THEN 1 ELSE 0 END )
				FROM house_raw AS ho2
				LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) +
			      (SELECT (CASE (he2.total_2013_feb IS NULL) 
					AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
					WHEN TRUE THEN 1 ELSE 0 END )
				FROM house_raw AS ho2
				LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) +
			      (SELECT (CASE (he2.total_2013_mar IS NULL)  
					AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
					WHEN TRUE THEN 1 ELSE 0 END )
				FROM house_raw AS ho2
				LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) +
			      (SELECT (CASE (he2.total_2013_apr IS NULL)  
					AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
					WHEN TRUE THEN 1 ELSE 0 END )
				FROM house_raw AS ho2
				LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) +
			      (SELECT (CASE (he2.total_2013_sep IS NULL)  
					AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
					WHEN TRUE THEN 1 ELSE 0 END )
				FROM house_raw AS ho2
				LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) +
			      (SELECT (CASE (he2.total_2013_oct IS NULL) 
					AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
					WHEN TRUE THEN 1 ELSE 0 END )
				FROM house_raw AS ho2
				LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) +
			      (SELECT (CASE (he2.total_2013_nov IS NULL) 
					AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
					WHEN TRUE THEN 1 ELSE 0 END )
				FROM house_raw AS ho2
				LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) +
			      (SELECT (CASE (he2.total_2013_dec IS NULL) 
					AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
					WHEN TRUE THEN 1 ELSE 0 END )
				FROM house_raw AS ho2
				LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) +
			      (SELECT (CASE (he2.contract_load_2013 IS NULL OR he2.contract_load_2013 > 10) 
					AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
					WHEN TRUE THEN 1 ELSE 0 END )
				FROM house_raw AS ho2
				LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) +
			      (SELECT (CASE (he2.temperature_grafic IS NULL) 
					AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
					WHEN TRUE THEN 1 ELSE 0 END )
				FROM house_raw AS ho2
				LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) +
			      (SELECT (CASE (he2.heating_scheme IS NULL) 
					AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
					WHEN TRUE THEN 1 ELSE 0 END )
				FROM house_raw AS ho2
				LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) +
			      (SELECT (CASE (he2.count_lift_nodes IS NULL)  
					AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
					WHEN TRUE THEN 1 ELSE 0 END )
				FROM house_raw AS ho2
				LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1) +
			      (SELECT (CASE (he2.heating_transit IS NULL) 
					AND ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = t."Код БТИ") = 1)
					WHEN TRUE THEN 1 ELSE 0 END ) 
				FROM house_raw AS ho2
				LEFT JOIN heat_raw AS he2 ON ho2.bticode = he2.bticode
				WHERE ho2.raion = t."Район" AND ho2.street = t."Улица" AND ho2.house = t."Дом" AND ho2.bticode = t."Код БТИ" LIMIT 1)
			)

		FROM
		    (SELECT ho.raion as "Район",
			   ho.bticode AS "Код БТИ",
			   ho.street as "Улица",
			   ho.house as "Дом"

			   
			FROM house_raw AS ho
			LEFT JOIN heat_raw AS he ON ho.bticode = he.bticode


			WHERE (
				(ho.bticode IS NOT NULL AND he.bticode IS NULL)
				OR ho.heating_area IS NULL
				OR he.total_2011 IS NULL
				OR he.total_2012 IS NULL
				OR he.total_2013 IS NULL
				OR he.total_2013_jan IS NULL
				OR he.total_2013_jan IS NULL
				OR he.total_2013_jan IS NULL
				OR he.total_2013_feb IS NULL
				OR he.total_2013_mar IS NULL
				OR he.total_2013_apr IS NULL
				OR he.total_2013_sep IS NULL
				OR he.total_2013_oct IS NULL
				OR he.total_2013_nov IS NULL
				OR he.total_2013_dec IS NULL
				OR he.contract_load_2013 IS NULL
				OR he.contract_load_2013 > 10
				OR he.temperature_grafic IS NULL
				OR he.heating_scheme IS NULL
				OR he.count_lift_nodes IS NULL
				OR he.heating_transit IS NULL
				OR he.connection_type IS NULL
				OR he.system_type IS NULL
				OR ((SELECT count(he4.bticode) FROM heat_raw AS he4 WHERE he4.bticode = ho.bticode) > 1)
				) AND (he.supplier NOT LIKE '%управлени%')
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
				AND (
					(
						(ho.category NOT LIKE '%едомственный%')
						AND (ho.category NOT LIKE '%бщежитие%')
						AND (ho.category NOT LIKE '%гостиничног%')
						AND (ho.category NOT LIKE '%часный ж/ф%')
					)	
					OR (ho.category IS NULL)
				)	
			

			
			GROUP BY "Район", "Улица", "Дом", ho.bticode
		    ) AS t
		)
		+
		(
			SELECT SUM(
		      
				      (CASE ((SELECT count(ho2.bticode) 
						FROM house_raw AS ho2 
						WHERE ho2.bticode = t."Код БТИ") = 0) 
						AND (t."Код БТИ" IS NOT NULL) 
					WHEN TRUE THEN 1 ELSE 0 END ) 
				)

			FROM
			    (SELECT he5.bticode AS "Код БТИ"
				   
				FROM heat_raw AS he5
				LEFT JOIN house_raw AS ho5 ON he5.bticode = ho5.bticode


				WHERE (
					(ho5.bticode IS NULL AND he5.bticode IS NOT NULL) 
				     )  AND (he5.supplier NOT LIKE '%управлени%')
					AND (he5.supplier NOT LIKE '%договор%')
					AND (he5.supplier NOT LIKE '%на прямых расчетах%')
					AND (he5.supplier NOT LIKE '%овостройка%')
					AND (he5.supplier NOT LIKE '%не начислялось%')
					AND (he5.supplier NOT LIKE '%данных нет%')
					AND (he5.supplier NOT LIKE '%АОГВ%')
					AND (he5.supplier NOT LIKE '%авт. кот.%')
					AND (he5.supplier NOT LIKE '%нежилой%')
					AND (he5.supplier NOT LIKE '%амостоятельный%')
					AND (he5.supplier NOT LIKE '%азовый кател%')
					AND (
						(
							(ho5.category NOT LIKE '%едомственный%')
							AND (ho5.category NOT LIKE '%бщежитие%')
							AND (ho5.category NOT LIKE '%гостиничног%')
							AND (ho5.category NOT LIKE '%часный ж/ф%')
							
						)	
						OR (ho5.category IS NULL)
					)	
				GROUP BY "Код БТИ"
		    ) AS t
		)
	)
	/
	(SELECT COUNT(t4.*)*44 FROM
		(
			SELECT ho.bticode as "Код БТИ"

			FROM house_raw AS ho
			LEFT JOIN heat_raw AS he ON ho.bticode = he.bticode

			WHERE (he.supplier NOT LIKE '%управлени%')
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
				AND (
					(
						(ho.category NOT LIKE '%едомственный%')
						AND (ho.category NOT LIKE '%бщежитие%')
						AND (ho.category NOT LIKE '%гостиничног%')
						AND (ho.category NOT LIKE '%часный ж/ф%')
					)	
					OR (ho.category IS NULL)
				)

			GROUP BY "Код БТИ"
		) AS t4
	
	)::numeric(10,3)*100::numeric(10,3) AS "Процент косячных ячеек по заполненным данным"

) to '/home/vlad/reports/ac-data-qual/Процент косячных ячеек по заполненным данным.csv'
with csv header delimiter ';' encoding 'win_1251'
;

