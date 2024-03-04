
CREATE DATABASE DEFORESTATION;
USE DEFORESTATION;

SELECT * FROM Forest_Area
SELECT * FROM Land_Area
SELECT * FROM Region

SELECT DISTINCT COUNTRY_NAME FROM Forest_Area
WHERE FOREST_AREA_SQKM IS NULL;

delete from Forest_Area where COUNTRY_NAME = 'world';

SELECT FOREST_AREA_SQKM, CASE WHEN  FOREST_AREA_SQKM IS NULL THEN 0 ELSE FOREST_AREA_SQKM END FROM Forest_Area;

UPDATE Forest_Area SET forest_area_sqkm = CASE WHEN  FOREST_AREA_SQKM IS NULL THEN 0 ELSE FOREST_AREA_SQKM END;



SELECT DISTINCT COUNTRY_NAME,TOTAL_AREA_SQ_MI  FROM Land_Area;
delete from Land_Area where COUNTRY_NAME = 'world';

SELECT * FROM Land_Area
SELECT DISTINCT COUNTRY_CODE, country_name NAME, YEAR, TOTAL_AREA_SQ_MI FROM Land_Area;

SELECT DISTINCT TOTAL_AREA_SQ_MI FROM Land_Area
WHERE TOTAL_AREA_SQ_MI IS NULL;

SELECT TOTAL_AREA_SQ_MI, CASE WHEN TOTAL_AREA_SQ_MI IS NULL THEN 0 ELSE TOTAL_AREA_SQ_MI END FROM Land_Area;

UPDATE Land_Area SET TOTAL_AREA_SQ_MI = CASE WHEN TOTAL_AREA_SQ_MI IS NULL THEN 0 ELSE TOTAL_AREA_SQ_MI END;

SELECT * FROM Land_Area
SELECT * FROM Forest_Area
SELECT * FROM Region

/*TOTAL NUMBER OF COUNTRIES INVOLVES IN DEFORESTATION*/

SELECT COUNT(distinct COUNTRY_NAME) AS TOTAL_NO_OF_COUNTRIES_INVL_DEFORESTATION FROM Forest_Area
where forest_area_sqkm != 0;


/*Show the income groups of countries having total area ranging from 75,000 to 150,000 square meter*/

SELECT  DISTINCT L.COUNTRY_NAME, R.income_group
FROM Region R join Land_Area L
on r.country_code = L.country_code
where total_area_sq_mi between '75000' and '150000';

/*Calculate average area in square miles for countries in the 'upper middle income region'. 
Compare the result with the rest of the income categories*/

select income_group, avg(total_area_sq_mi) Average_Area_in_Suqare_Miles from
(select  R.country_name, R.income_group,R.Region, L.total_area_sq_mi from Region R join Land_Area L on R.country_code = L.country_code) as T
group by income_group 
having income_group in ('upper middle income','low income','high income','lower middle income');

/*Determine the total forest area in square km for countries in the 'high income' group. 
Compare result with the rest of the income categories*/

select income_group, sum(forest_area_sqkm) as Total_forest_area_in_sqm from
(select R.country_name, R.income_group, F.forest_area_sqkm from Forest_Area F join Region R on F.country_code = R.country_code) as T
group by income_group
having income_group in ('high income','low income','upper middle income','lower middle income');


/*Show countries from each region(continent) having the highest total forest areas*/

with main_cte as
(select distinct r.country_name, Region, f.forest_area_sqkm,
dense_rank() over(partition by r.region order by f.forest_area_sqkm desc) as rank
from region r join Forest_area f on r.country_code = f.country_code)
select * from main_cte
where rank = 1;

