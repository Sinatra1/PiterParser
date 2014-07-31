
/*
update heat_raw set contract_load_2013 = NULL where contract_load_2013 > 10; --ЮВАО 25

update heat_raw set bticode = NULL where char_length(bticode) < 3;
update house_raw set bticode = NULL where char_length(bticode) < 3;

update house_raw set full_area = NULL 
where (full_area < 50) 
OR (full_area < heating_area) 
OR ((living_area + nonliving_area) <> full_area);

update house_raw set heating_area = NULL 
where (heating_area < 50) 
OR (full_area < heating_area);

update house_raw set living_area = NULL 
where (living_area < 50);

update heat_raw set enter_diametr = NULL 
where (enter_diametr > 200)
OR (enter_diametr < 0);

update heat_raw set enter_pressure = NULL 
where (enter_pressure > 17)
OR (enter_pressure < 0);

update heat_raw set total_2011 = NULL 
where (total_2011 <= total_2013_jan)
OR (total_2011 <= total_2013_feb)
OR (total_2011 <= total_2013_mar)
OR (total_2011 <= total_2013_apr)
OR (total_2011 <= total_2013_oct)
OR (total_2011 <= total_2013_nov)
OR (total_2011 <= total_2013_dec);

update heat_raw set total_2012 = NULL 
where (total_2012 <= total_2013_jan)
OR (total_2012 <= total_2013_feb)
OR (total_2012 <= total_2013_mar)
OR (total_2012 <= total_2013_apr)
OR (total_2012 <= total_2013_oct)
OR (total_2012 <= total_2013_nov)
OR (total_2012 <= total_2013_dec);

update heat_raw set total_2013_jan = NULL 
where (total_2012 <= total_2013_jan)
OR (total_2011 <= total_2013_jan);

update heat_raw set total_2013_feb = NULL 
where (total_2012 <= total_2013_feb)
OR (total_2011 <= total_2013_feb);

update heat_raw set total_2013_mar = NULL 
where (total_2012 <= total_2013_mar)
OR (total_2011 <= total_2013_mar);

update heat_raw set total_2013_apr = NULL 
where (total_2012 <= total_2013_apr)
OR (total_2011 <= total_2013_apr);

update heat_raw set total_2013_oct = NULL 
where (total_2012 <= total_2013_oct)
OR (total_2011 <= total_2013_oct);

update heat_raw set total_2013_nov = NULL 
where (total_2012 <= total_2013_nov)
OR (total_2011 <= total_2013_nov);

update heat_raw set total_2013_dec = NULL 
where (total_2012 <= total_2013_dec)
OR (total_2011 <= total_2013_dec);

  (SELECT (CASE (ho2.heating_area > ho2.full_area)
			WHEN TRUE THEN 'Да' END )
			FROM house_raw AS ho2 
			WHERE ho2.bticode = t."Код БТИ" LIMIT 1) AS "отапливаемая площадь > общей площади",
*/




update heat_raw set total_2011 = NULL where total_2011 = 0;
update heat_raw set total_2012 = NULL where total_2012 = 0;
update heat_raw set total_2013 = NULL where total_2013 = 0;
update heat_raw set total_2013_jan = NULL where total_2013_jan = 0;
update heat_raw set total_2013_feb = NULL where total_2013_feb = 0;
update heat_raw set total_2013_mar = NULL where total_2013_mar = 0;
update heat_raw set total_2013_apr = NULL where total_2013_apr = 0;
update heat_raw set total_2013_may = NULL where total_2013_may = 0;
update heat_raw set total_2013_jun = NULL where total_2013_jun = 0;
update heat_raw set total_2013_jul = NULL where total_2013_jul = 0;
update heat_raw set total_2013_aug = NULL where total_2013_aug = 0;
update heat_raw set total_2013_sep = NULL where total_2013_sep = 0;
update heat_raw set total_2013_oct = NULL where total_2013_oct = 0;
update heat_raw set total_2013_nov = NULL where total_2013_nov = 0;
update heat_raw set total_2013_dec = NULL where total_2013_dec = 0;


update heat_raw set total_2012 = NULL where total_2012 = 0;




