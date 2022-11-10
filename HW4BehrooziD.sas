*1a;
filename wolfFile '/home/u62368731/sasuser.v94/Homework/Observation Dates.csv';
data wolf_obs;
   infile wolfFile dlm = ',' dsd firstobs = 2;
   input ID obs_date :mmddyy10. presence;
run;
*When SAS reads in obs_date with the date ranges, only the first date value in the range is taken as the observation date.;

*1b;
filename wolfFile '/home/u62368731/sasuser.v94/Homework/Observation Dates.csv';
data wolf_obs;
  	infile wolfFile dlm = ',' dsd firstobs = 2;
  	input ID obs_date :$21. presence;
  	*if the index position of obs_date at hyphen is greater than 0...;
	if index(obs_date, '-') > 0 then do;
	obs_date = substr(obs_date, index(obs_date, '-')+1, 10);
	*Creating new variable date to put in date range values with new obs_date;
	date = input(obs_date, mmddyy10.);
	end;
	else date = input(obs_date, mmddyy10.);
run;

*1c;
proc print data = wolf_obs (obs=24);
	var ID date presence;
	format date worddate20.;
run;

*1d;
data wolf_sighted no_wolf;
	set wolf_obs;
	if presence = 1 then output wolf_sighted;
	if presence = 0 then output no_wolf;
run;

*2a;
filename saleFile '/home/u62368731/sasuser.v94/Homework/Weekly Sales.csv';
data week_sales;
	infile saleFile dlm = ',' dsd firstobs = 2;
	input week :mmddyy10. sales :comma15.;
run;

*2b;
proc sort data = week_sales;
	by week;
run;

*2c;
data week_sales_new;
	set week_sales;
	month = month(week);
	day = day(week);
	year = year(week);
run;

*2d;
data week_sales_new;
	set week_sales_new;
	retain prevYear;
	*total yearly sales starts over at new year;
	if year ^= prevYear then do;
	prevYear = year;
	totYearSales = 0;
	end;
	retain totYearSales 0;
	*retaining sum of total yearly sales;
	totYearSales = sum(totYearSales, sales);
run;
*The running total yearly sales for 2012 is $556,136.68. The running total yearly sales up to September 2018 is $435,314.00;

*2e;
data sales_2010 sales_2011 sales_2012;
	set week_sales_new;
	if year = 2010 then output sales_2010;
	if year = 2011 then output sales_2011;
	if year = 2012 then output sales_2012;
run;


/*********************************************/
/* STAT 330, Fall 2022						 */
/* Homework #4B							 	 */
/* Donya Behroozi and Grace Trenholme		 */
/*********************************************/

*1a;
data smoking;
	do male=0 to 1;
		do age=1 to 3;
			do degree=0 to 1;
				do i=1 to 200;
					output;
				end;
			end;
		end;
	end;
run;

*1b;
proc freq data = smoking;
	tables male age degree i;
run;

*1c; 
data random_smoking;
	set smoking;
	call streaminit(153224);
	random = rand('uniform');
	random = round(random, 0.01);
	if male = '1' and degree = '0' and random <= 0.35 then smoker = 1;
	else if male = '1' and degree = '1' and random <= 0.15 then smoker = 1;
	else if male = '0' and degree = '0' and random <= 0.25 then smoker = 1;
	else if male = '0' and degree = '1' and random <= 0.10 then smoker = 1;
	else smoker = 0;
run;

proc freq data = random_smoking;
	tables smoker;
run;

*1d;
*The percentage of smokers I would expect to have in my data set is 21.25% of the total records.
The actual percentage of smokers in my data set is 22.29%.;

*2a;
filename wslFile '/home/u62368731/sasuser.v94/Homework/WSL 2022.csv';
data WSL;
	infile wslFile dlm = ',' dsd firstobs = 4;
	input position $ status :$6. surfer :$30. (WCT_1-WCT_11) (:$4.) points :comma6.;
run;

*2b;
data WSL_new (drop = i WCT_1-WCT_11);
	set WSL;
	first_name = scan(surfer, 1, ' ');
	last_name = scan(surfer, -2, ' ');
	country = scan(surfer, -1);
	array WCT_char $ WCT_1-WCT_11;
	array WCT_num WCTnum_1-WCTnum_11;
	do i=1 to dim(WCT_char);
		if WCT_char(i) = '-' then WCT_num(i) = .;
		else if WCT_char(i) = 'INJ' then WCT_num(i) = .;
		else WCT_num(i) = input(WCT_char(i), :2.);
	end;	
run;

*2c;
proc freq data = WSL_new;
	tables country;
run;

*The top countries of origin are Australia (AUS) with 15 surfers, Brazil (BRA) with 12 surfers, 
and the state of Hawaii (HAW) with 8 surfers.;
