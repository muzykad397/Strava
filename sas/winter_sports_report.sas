*************************************************************************************************************;

/* PGM:winter_sports_report.sas */
/* Coder:Daniel Muzyka */
/* Date:2/17/2022 */
/* Description:Simple SQL generated tables telling me how many days I participated in various winter sports. 
	Data sourced from my Strava, retrieved from my Github repository */
*************************************************************************************************************;

/* Call the basic SAS import from my Github - output data is webwork.strava */
filename import url 
	"https://github.com/muzykad397/strava/raw/main/sas/basic_strava_import.sas";
%inc import;

%macro no_run;
		/* I would like to specify up top which sports I want included in my analyis */
		/* First let's check the sports I have in my data using two approaches*/
		/* 	Approach 1 - Proc freq */
		proc freq data=strava n;
			table type / list;
		run;
		
		/* 	Approach 2 - Proc SQL */
		proc sql;
			select distinct type from strava;
		quit;
%mend;

/* Set the sports I am interested in analyzing */
%Let winter_activities="NordicSki", "Snowboard", "AlpineSki", "Snowshoe";
%put &winter_activities;

/* Create a winter sports only data set */
Proc sql;
	create table winter_sports as select a.*, datepart(start_date) as date format 
		date9.
	from strava as a where type in (&winter_activities);
quit;

/* Create a report of total days spent doing winter sports per season */
title "Winter Sport Days";
ods text="Disclaimer - I did not record all snowboarding trips in the 20/21 season";

Proc sql;
	select a.season, count(distinct date) as winter_sport_days 
	from winter_sports as a 
		group by season
		order by season;
quit;

title "Winter Sport Days by Activity";

/* Create a report of days spent on each type of winter sport */
Proc sql;
	select a.season, 
		   a.type,
		   count(distinct date) as winter_sport_days 
	from winter_sports 
		as a group by season, type
		order by season, type;
quit;

proc sort data=winter_sports;
	by date type;
run;

data roll_up;
	set winter_sports;
	by date;
	length combo $50.;
	
	lag_type=lag(type);

	if first.date then
		combo=type;
	else if lag_type=type then
		combo=type;
	else
		combo="Combo "||catx(" and ", lag_type, type);

	if last.date then output;
	drop lag_type;
run;

title "Winter Sport Days by Full Day of Activity";

/* Create a report of days spent on each type of winter sport */
Proc sql;
	select a.season, a.combo, count(distinct date) as winter_sport_days 
	from roll_up as a 
		group by season, combo
		order by season, combo;
quit;