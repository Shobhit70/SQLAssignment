use upgrad;
SET SQL_SAFE_UPDATES = 0;

#Adding Date column
alter table bajajauto add formatted_date date;
update bajajauto set formatted_date = str_to_date(Date, '%d-%M-%Yformatted_date');

alter table eichermotors add formatted_date date;
update eichermotors set formatted_date = str_to_date(Date, '%d-%M-%Yformatted_date');

alter table heromotocorp add formatted_date date;
update heromotocorp set formatted_date = str_to_date(Date, '%d-%M-%Yformatted_date');


alter table infosys add formatted_date date;
update infosys set formatted_date = str_to_date(Date, '%d-%M-%Yformatted_date');

alter table tcs add formatted_date date;
update tcs set formatted_date = str_to_date(Date, '%d-%M-%Yformatted_date');

alter table tvsmotors add formatted_date date;
update tvsmotors set formatted_date = str_to_date(Date, '%d-%M-%Yformatted_date');



desc bajajauto;
desc eichermotors;
desc heromotocorp;
desc infosys;
desc tcs;
desc tvsmotors;

select * from bajajauto;
select * from eichermotors;
select * from heromotocorp;
select * from infosys;
select * from tcs;
select * from tvsmotors;

#Question 1

create table bajaj1
  as (select formatted_date as 'Date', round(`Close Price`,2) as  'Close Price' , 
  avg(`Close Price`) over (order by formatted_date asc rows 19 preceding) as `20 Day MA`,
  avg(`Close Price`) over (order by formatted_date asc rows 49 preceding) as `50 Day MA`,
  row_number() over (order by formatted_date ) as 'row_number' from `bajajauto`);
  
#Setting Null to first 19 rows
update bajaj1 set `20 Day MA` = NULL limit 19;
 
#Setting Null to first 49 rows 
update bajaj1 set `50 Day MA` = NULL limit 49;

#Checking records 
select * from bajaj1;

##Eicher Motors
create table eicher1
  as (select formatted_date as 'Date', round(`Close Price`,2) as  'Close Price' , 
  avg(`Close Price`) over (order by formatted_date asc rows 19 preceding) as `20 Day MA`,
  avg(`Close Price`) over (order by formatted_date asc rows 49 preceding) as `50 Day MA`,
  row_number() over (order by formatted_date ) as 'row_number' from `eichermotors`);
  
#Setting Null to first 19 rows
update eicher1 set `20 Day MA` = NULL limit 19;

#Setting Null to first 49 rows 
update eicher1 set `50 Day MA` = NULL limit 49;

#Checking records 
select * from eicher1;


#Hero Motocorp
create table hero1
  as (select formatted_date as 'Date', round(`Close Price`,2) as  'Close Price' , 
  avg(`Close Price`) over (order by formatted_date asc rows 19 preceding) as `20 Day MA`,
  avg(`Close Price`) over (order by formatted_date asc rows 49 preceding) as `50 Day MA`,
  row_number() over (order by formatted_date ) as 'row_number' from `heromotocorp`);
  
#Setting Null to first 19 rows
update hero1 set `20 Day MA` = NULL limit 19;

#Setting Null to first 49 rows 
update hero1 set `50 Day MA` = NULL limit 49;

#Checking records 
select * from hero1;


#Infosys
create table infosys1
  as (select formatted_date as 'Date', round(`Close Price`,2) as  'Close Price' , 
  avg(`Close Price`) over (order by formatted_date asc rows 19 preceding) as `20 Day MA`,
  avg(`Close Price`) over (order by formatted_date asc rows 49 preceding) as `50 Day MA`,
  row_number() over (order by formatted_date ) as 'row_number' from infosys);
  
#Setting Null to first 19 rows
update infosys1 set `20 Day MA` = NULL limit 19;

#Setting Null to first 49 rows 
update infosys1 set `50 Day MA` = NULL limit 49;

#Checking records 
select * from infosys1;


#tcs
create table tcs1
  as (select formatted_date as 'Date', round(`Close Price`,2) as  'Close Price' , 
  avg(`Close Price`) over (order by formatted_date asc rows 19 preceding) as `20 Day MA`,
  avg(`Close Price`) over (order by formatted_date asc rows 49 preceding) as `50 Day MA`,
  row_number() over (order by formatted_date ) as 'row_number' from tcs);
  
#Setting Null to first 19 rows
update tcs1 set `20 Day MA` = NULL limit 19;

#Setting Null to first 49 rows 
update tcs1 set `50 Day MA` = NULL limit 49;

#Checking records 
select * from tcs1;


#tvsmotors
create table tvs1
  as (select formatted_date as 'Date', round(`Close Price`,2) as  'Close Price' , 
  avg(`Close Price`) over (order by formatted_date asc rows 19 preceding) as `20 Day MA`,
  avg(`Close Price`) over (order by formatted_date asc rows 49 preceding) as `50 Day MA`,
  row_number() over (order by formatted_date ) as 'row_number' from tvsmotors);
  
#Setting Null to first 19 rows
update tvs1 set `20 Day MA` = NULL limit 19;

#Setting Null to first 49 rows 
update tvs1 set `50 Day MA` = NULL limit 49;

#Checking records 
select * from tvs1;

#Question2

create table master as select b.formatted_date as 'Date', b.`Close Price` as 'Bajaj', t.`Close Price` as 'TCS', 
tv.`Close Price` as 'TVS', i.`Close Price` as 'Infosys', e.`Close Price` as 'Eicher', h.`Close Price` as 'Hero'
from bajajauto as b
inner join tcs as t on t.formatted_date=b.formatted_date
inner join tvsmotors as tv on tv.formatted_date=b.formatted_date
inner join infosys as i on i.formatted_date=b.formatted_date
inner join eichermotors as e on e.formatted_date=b.formatted_date
inner join heromotocorp as h on h.formatted_date=b.formatted_date;

#Displaying whole records
select * from master;

#Question 3

#Bajajauto
create table bajaj2 as
select `Date`,round(`Close price`,2) as 'Close Price',
case 
when `50 Day MA` is NULL then 'NA' 
when `20 Day MA`>`50 Day MA` AND LAG(`20 Day MA`<`50 Day MA`,1) over() then 'BUY'  
when `20 Day MA`<`50 Day MA` AND LAG(`20 Day MA`>`50 Day MA`,1) over()  then 'SELL'
else 'HOLD' 
end 
as 'Signal'
from bajaj1 ;

#Displaying  the records
select * from bajaj2;

#Eicher
create table eicher2 as
select `Date`,round(`Close price`,2) as 'Close Price',
case 
when `50 Day MA` is NULL then 'NA' 
when `20 Day MA`>`50 Day MA` AND LAG(`20 Day MA`<`50 Day MA`,1) over() then 'BUY'  
when `20 Day MA`<`50 Day MA` AND LAG(`20 Day MA`>`50 Day MA`,1) over()  then 'SELL'
else 'HOLD' 
end 
as 'Signal'
from eicher1 ;

#Displaying the records
select * from eicher2;

#tcs
create table tcs2 as
select `Date`,round(`Close price`,2) as 'Close Price',
case 
when `50 Day MA` is NULL then 'NA' 
when `20 Day MA`>`50 Day MA` AND LAG(`20 Day MA`<`50 Day MA`,1) over() then 'BUY'  
when `20 Day MA`<`50 Day MA` AND LAG(`20 Day MA`>`50 Day MA`,1) over()  then 'SELL'
else 'HOLD' 
end 
as 'Signal'
from tcs1 ;

#Displaying the records
select * from tcs2;

#Hero
create table hero2 as
select `Date`,round(`Close price`,2) as 'Close Price',
case 
when `50 Day MA` is NULL then 'NA' 
when `20 Day MA`>`50 Day MA` AND LAG(`20 Day MA`<`50 Day MA`,1) over() then 'BUY'  
when `20 Day MA`<`50 Day MA` AND LAG(`20 Day MA`>`50 Day MA`,1) over()  then 'SELL'
else 'HOLD' 
end 
as 'Signal'
from hero1 ;                        

#Displaying the records
select * from hero2;


#tvs
create table tvs2 as
select `Date`,round(`Close price`,2) as 'Close Price',
case 
when `50 Day MA` is NULL then 'NA' 
when `20 Day MA`>`50 Day MA` AND LAG(`20 Day MA`<`50 Day MA`,1) over() then 'BUY'  
when `20 Day MA`<`50 Day MA` AND LAG(`20 Day MA`>`50 Day MA`,1) over()  then 'SELL'
else 'HOLD' 
end 
as 'Signal'
from tvs1 ;                        


#Displaying 
select * from tvs2;

#infosys
create table infosys2 as
select `Date`,round(`Close price`,2) as 'Close Price',
case 
when `50 Day MA` is NULL then 'NA' 
when `20 Day MA`>`50 Day MA` AND LAG(`20 Day MA`<`50 Day MA`,1) over() then 'BUY'  
when `20 Day MA`<`50 Day MA` AND LAG(`20 Day MA`>`50 Day MA`,1) over()  then 'SELL'
else 'HOLD' 
end 
as 'Signal'
from infosys1;                        


#Dsiplaying records
select * from infosys2


#Question4
DELIMITER $$
create function signal_show(input_date date)
returns varchar(10) deterministic
BEGIN
DECLARE result VARCHAR(10);
Set @result = (select `Signal` from  bajaj2 where bajaj2.Date = input_date);
return result;
END $$
 
##Function call
select signal_show(`formatted_date`) as 'Signal',`Date`  from bajajauto;

#Question5
select count(*) as 'SELL' from bajaj2 where `Signal`='SELL';
select count(*) as  'BUY' from bajaj2 where `Signal`='BUY';

select count(*) as 'SELL' from eicher2 where `Signal`='SELL';
select count(*) as  'BUY' from eicher2 where `Signal`='BUY';

select count(*) as 'SELL' from hero2 where `Signal`='SELL';
select count(*) as  'BUY' from hero2 where `Signal`='BUY';
 
          
select count(*) as 'SELL' from infosys2 where `Signal`='SELL';
select count(*) as  'BUY' from infosys2 where `Signal`='BUY';
 
select count(*) as 'SELL' from tvs2 where `Signal`='SELL';
select count(*) as  'BUY' from tvs2 where `Signal`='SELL'; 
 
 

















