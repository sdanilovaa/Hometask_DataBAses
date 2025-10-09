Drop database if exists HW1;
create database HW1; 
Use HW1; 

drop table if exists economicPerformance;
create table economicPerformance (
Region_ID int primary key auto_increment, 
Oblast_Name varchar(30) not null, 
GRP_2021 decimal(12,2) not null,
Capital_Investment_2021 decimal(12,2) not null DEFAULT 0.00
);

Insert into economicPerformance (Region_ID, Oblast_Name, GRP_2021, Capital_Investment_2021)  values
(1, "Kyiv City", 1326.2, 163.5), 
(2, "Dnipropetrovsk Oblast", 545.7, 56.4), 
(3, "Kharkiv Oblast",	311.5,	29.8),
(4, "Lviv Oblast",	277.6,	28.1 ),
(5, "Kyiv Oblast",	271.8,	49.2),
(6, "Odesa Oblast",	258.9,	23.3),
(7, "Poltava Oblast",	254.4,	31.9),
(8, "Zaporizhzhia Oblast",	204.0,	18.7),
(9, "Donetsk Oblast",	190.1,	21.6),
(10, "Vinnytsia Oblast",	137.9,	15.1),
(11, "Cherkasy Oblast",	126.3,	14.8),
(12, "Mykolaiv Oblast",	114.7,	10.5),
(13, "Ivano-Frankivsk Oblast",	110.2,	12.3),
(14, "Khmelnytskyi Oblast",	105.1,	11.9),
(15, "Zhytomyr Oblast",	99.8,	10.2),
(16, "Sumy Oblast",	94.6,	8.9),
(17, "Kirovohrad Oblast",	89.5,	9.7),
(18, "Chernihiv Oblast",	85.3,	8.1), 
(19, "Volyn Oblast",	81.7,	7.6),
(20, "Rivne Oblast",	79.4,	8.4); 


drop table if exists demografic_Income;
create table demografic_Income (
Region_ID int primary key auto_increment, 
Population_2022 decimal(12,2) not null,
Av_Salary_UAH decimal(12,2) not null DEFAULT 0.00
);

insert into demografic_Income (Region_ID, Population_2022,Av_Salary_UAH) values 
(1, 2952301,	26759), 
(2, 3096485, 	16879), 
(3, 2598961,	14996),
(4, 2478133, 	14888 ),
(5, 1795079,	17698),
(6, 2351392,	14960),
(7, 1352283,	16554),
(8, 1638462,	16988),
(9, 4059372,	18973),
(10, 1509515,	14640),
(11, 1160745,	14511),
(12, 1091821,	16901),
(13, 1351823,	13875),
(14, 1228827,	13766),
(15, 1179032,	13991),
(16, 1035772,	14809),
(17, 903712,	13972),
(18, 959315,	13501), 
(19, 1021356,	13387),
(20, 1141784,	14002); 

drop table if exists social; 
create table social(
Region_ID int primary key auto_increment, 
GDP_perCapita_2021 decimal(12,2) not null,
Unemployment_percent decimal(12,2) not null DEFAULT 0.00
);

insert into social (Region_ID, GDP_perCapita_2021, Unemployment_percent) values
(1, 449219,	7.4), 
(2, 176204,	9.9), 
(3, 120084,	8.8),
(4, 111999,	8.9),
(5, 151412,	8.5),
(6, 110103,	7.9),
(7, 188127,	11.2),
(8, 124505,	11.0),
(9, 46829,	14.1),
(10, 91348,	10.6),
(11, 81520,	10.1),
(12, 105055, 12.1),
(13, 81520,	10.1),
(14, 85529,	9.5),
(15, 84646,	10.8),
(16, 91334,	10.5),
(17, 98040,	12.6),
(18, 88918,	11.5), 
(19, 79997,	11.0),
(20, 69541,	11.8);  

drop table if exists oblast_historical_regions;
create table oblast_historical_regions (
    Region_ID int primary key,
    Oblast_Name varchar(30) not null,
    Historical_region_name varchar(30) not null,
    Historical_region_id int not null
);

insert into oblast_historical_regions (Region_ID, Oblast_Name, Historical_region_name, Historical_region_id) values
(19, 'Volyn oblast', 'Volhynia', 101),
(20, 'Rivne oblast', 'Volhynia', 101),
(15, 'Zhytomyr oblast', 'Volhynia', 101),
(4, 'Lviv oblast', 'Galicia', 102),
(13, 'Ivano-frankivsk oblast', 'Galicia', 102),
(10, 'Vinnytsia oblast', 'Podillia', 103),
(14, 'Khmelnytskyi oblast', 'Podillia', 103),
(5, 'Kyiv oblast', 'Polissia', 105),
(18, 'Chernihiv oblast', 'Polissia', 105),
(16, 'Sumy oblast', 'Slobozhanshchyna', 106),
(3, 'Kharkiv oblast', 'Slobozhanshchyna', 106),
(9, 'Donetsk oblast', 'Slobozhanshchyna', 106),
(7, 'Poltava oblast', 'Middle dnieper', 107),
(11, 'Cherkasy oblast', 'Middle dnieper', 107),
(17, 'Kirovohrad oblast', 'Middle dnieper', 107),
(1, 'Kyiv city', 'Middle dnieper', 107),
(2, 'Dnipropetrovsk oblast', 'Zaporizhzhia (historical)', 108),
(8, 'Zaporizhzhia oblast', 'Zaporizhzhia (historical)', 108),
(6, 'Odesa oblast', 'Black sea littoral', 109),
(12, 'Mykolaiv oblast', 'Black sea littoral', 109);


drop table if exists regional_green_energy;
create table regional_green_energy (
    Historical_region_id int primary key,
    Solar_power_capacity_mw int,
    Wind_power_capacity_mw int,
    Bioenergy_capacity_mw int
);

insert into regional_green_energy (Historical_region_id, Solar_power_capacity_mw, Wind_power_capacity_mw, Bioenergy_capacity_mw) values
(101, 485, 18, 32),
(102, 790, 155, 28),
(103, 950, 25, 75),
(104, 180, 0, 12),
(105, 510, 0, 45),
(106, 855, 210, 15),
(107, 1850, 15, 88),
(108, 1120, 752, 20),
(109, 1510, 595, 25);

select * from economicPerformance; 
select * from demografic_Income; 
select * from social; 
select * from oblast_historical_regions; 
select * from regional_green_energy;



with full_regions_data as(
	select 
		e.Region_ID, 
		e.Oblast_Name, 
		d.Av_Salary_UAH, 
		s.Unemployment_percent,
		o.Historical_region_name,
		o.Historical_region_id, 
        r.Solar_power_capacity_mw
        
from economicPerformance e
	Inner join demografic_Income as d ON e.Region_ID = d.Region_ID
	Inner join social as s on e.Region_ID = s.Region_ID
	Inner join oblast_historical_regions as o on e.Region_ID = o.Region_ID
    Inner join regional_green_energy as r on r.Historical_region_id = o.Historical_region_id
	)
   select f.Historical_region_name, count(f.Oblast_Name) as Quantity_of_Oblast, avg(f.Solar_power_capacity_mw) as average_solar_capacity
from full_regions_data f 
where f.Unemployment_percent > 8.0
group by f.Historical_region_name
having Quantity_of_Oblast > 1
order by average_solar_capacity
limit 4;


select * from full_regions_data

