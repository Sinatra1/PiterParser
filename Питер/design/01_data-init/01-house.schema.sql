drop table if exists house_raw CASCADE;
drop table if exists heat_raw CASCADE;

DROP TYPE if exists korp;
CREATE TYPE korp AS ENUM ('А', 'Б', 'В', 'Г', 'Д', 'Е', 'Ё', 'Ж', 'З', 'И', 'Й', 'К', 'Л', 'М', 'Н', 'О', 'П', 'Р', 'С', 'Т', 'У', 'Ф', 'Х', 'Ц', 'Ч', 'Ш', 'Щ', 'Ъ', 'Ы', 'Ь', 'Э', 'Ю', 'Я', 'А1', '--', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50');

DROP TYPE if exists uprav;
CREATE TYPE uprav AS ENUM (
'ГУП ДЕЗ',
'Частная управляющая организация',
'ТСЖ',
'ЖК',
'ЖСК',
'непосредственное управление',
'орг-ия с гос. участием',
'ЧУО',
'частная управляющая организация',
'ГУЖА',
'гос. учр-ие жилищное агентство',
'РЖА',
'Районное жилищное агентство'
);

DROP TYPE if exists cat;
CREATE TYPE cat AS ENUM (
'ведомственный дом',
'общежитие',
'дом гостиничного типа',
'аварийный',
'под снос',
'сцепка',
'культурного наследия',
'на техническом обслуживании',
'нежилой'
);

DROP TYPE if exists hstype;
CREATE TYPE hstype AS ENUM (
'блочный',
'брежневка',
'индивидуальный',
'кирпично-монолитный',
'монолит',
'панельный',
'сталинка',
'хрущевка',
'кирпичный',
'другое'
);

DROP TYPE if exists ser;
CREATE TYPE ser AS ENUM (
'II-01',
'II-02',
'II-03',
'II-04',
'II-05',
'II-07',
'II-08',
'II-14',
'II-17',
'II-18/12',
'II-18/9',
'II-20',
'II-28',
'II-29',
'II-32',
'II-34',
'II-35',
'II-49',
'II-57',
'II-66',
'II-68',
'II-68-02',
'II-68-03',
'II-68-04',
'III/17',
'121',
'131',
'137',
'1-305',
'1-405',
'1-440',
'1-447',
'1-507',
'1-510',
'1-511',
'1-513',
'1-515/5',
'1-515/9м',
'1-515/9ш',
'1-527',
'1-528',
'1-528КП-40',
'1-528КП-41',
'1-528КП-80',
'1-528КП-82',
'1605/12',
'1605/9',
'1-ЛГ-600-I',
'1-мг-600',
'1-мг-601',
'600 (1-ЛГ-600)',
'602 (1-ЛГ-602)',
'606 (1-ЛГ-606)',
'Бекерон',
'В-2002',
'ГМС-1',
'И-155',
'И-1723',
'И-1724',
'И-2076',
'И-209а',
'И-491а',
'И-521а',
'И-522а',
'И-700',
'И-700А',
'И-760а',
'ИП-46С',
'К-7',
'Колос',
'МГ-1',
'МГ-2',
'П-111',
'П-3',
'П-30',
'П-3М',
'П-42',
'П-43',
'П-44',
'П-44М',
'П-44Т',
'П-46',
'П-55',
'ПД-1',
'ПД-3',
'ПД-4',
'ПП-70',
'ПП-83',
'Ш5733',
'Щ9378',
'Юникон',
'индивидуальный',
'другое',
'нет данных'
);

DROP TYPE if exists wall;
CREATE TYPE wall AS ENUM (
'железобетонные',
'блочные',
'панельные',
'кирпичные',
'монолитные',
'деревянные',
'другое'
);

DROP TYPE if exists nomer;
CREATE TYPE nomer AS ENUM (
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
'17',
'18',
'19',
'20',
'21',
'22',
'23',
'24',
'25',
'26',
'27',
'28',
'29',
'30'
);

DROP TYPE if exists nomer2;
CREATE TYPE nomer2 AS ENUM (
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
'17',
'18',
'19',
'20',
'21',
'22',
'23',
'24',
'25',
'26',
'27',
'28',
'29',
'30'
);

DROP TYPE if exists danet;
CREATE TYPE danet AS ENUM (
'да',
'нет'
);

drop table if exists house_raw;
create table house_raw (
    id_in_file 		varchar(10), --1
    okrug   		varchar(255), --2
    raion   		varchar(255),--3
    street  		varchar(100),--4
    house   		varchar(15),--5
    korpus  		varchar(50),--6
    stroenie 		varchar(15),--7
    bticode  		varchar(50),--8
    mkd_uprav_form 	uprav,--9
    category 		cat,--10

    house_type 		hstype,--11
    series 		ser,--12
    year_built 		decimal(4,0),--13
    wall_type 		wall,--14
    floors 		varchar(255),--15
    underfloors 	int,--16
    porches 		int,--17
    flats 		varchar(50),--18

    full_area 		decimal,--19	
    heating_area 	decimal,--20
    living_area 	decimal,--21
    nonliving_area 	decimal,--22

    electricity 	danet,--23
    water_cold 		danet,--25
    water_hot 		danet,--24
    sewerage 		danet,--26
    heat_supply 	danet,--27
    gas_supply 		danet,--28
    gas_heaters 	danet,--29
    gas_ovens 		danet,--30
    electro_ovens 	danet,--31
    lifts_count 	decimal(4,0),--32

    e_devices_count 	decimal(4,0),--33
    cw_devices_count 	decimal(4,0),--35
    hw_devices_count 	decimal(4,0),--34
    heat_devices_count 	decimal(4,0),--36
    gas_devices_count 	decimal(4,0)--,--37

    --notes varchar(255)--38
);

CREATE INDEX ho_ind ON house_raw(bticode);


