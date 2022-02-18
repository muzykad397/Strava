filename git temp;

proc http url="https://github.com/muzykad397/strava/raw/main/data/strava.csv" 
		method="GET" out=git;
run;

/* This basic proc import works but throws an error on some missing values so I went with an infile */
/* I want a nice clean log */
/* proc import */
/*   file=git */
/*   out=work.strava replace */
/*   dbms=csv; */
/* run; */
data want;
	infile git delimiter=',' MISSOVER DSD firstobs=2;
	informat VAR1 $4.;
	informat distance best32.;
	informat moving_time best32.;
	informat elapsed_time best32.;
	informat total_elevation_gain best32.;
	informat type $11.;
	informat start_date anydtdtm40.;
	informat month $4.;
	informat month_order best32.;
	informat achievement_count best32.;
	informat average_speed best32.;
	informat max_speed best32.;
	informat elev_high best32.;
	informat elev_low best32.;
	informat pr_count best32.;
	informat season $18.;
	format VAR1 $4.;
	format distance best12.;
	format moving_time best12.;
	format elapsed_time best12.;
	format total_elevation_gain best12.;
	format type $11.;
	format start_date datetime.;
	format month $4.;
	format month_order best12.;
	format achievement_count best12.;
	format average_speed best12.;
	format max_speed best12.;
	format elev_high best12.;
	format elev_low best12.;
	format pr_count best12.;
	format season $18.;
	input VAR1  $
                         distance moving_time 
		elapsed_time total_elevation_gain type  $
                         start_date month  $
                         month_order achievement_count 
		average_speed max_speed elev_high elev_low pr_count season  $;
	rename var1=obs;
run;