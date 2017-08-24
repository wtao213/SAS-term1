/**********************************************/
/* import dataset for oyap and school boards */
/**********************************************/
%web_drop_table(WORK.oyap_master);

FILENAME REFFILE 'C:/Users/TaoWa/Desktop/oyap_master_2017-08-17.csv';

PROC IMPORT DATAFILE=REFFILE 
	DBMS=CSV
	OUT=WORK.oyap_master; 
	GETNAMES=YES;
	guessingrows= 500;
RUN;

PROC CONTENTS DATA=WORK.oyap_master; RUN;


%web_open_table(WORK.oyap_master);

/** import dataset for school board  **/
%web_drop_table(WORK.schoolboard_lookup);

FILENAME REFFILE 'C:/Users/TaoWa/Desktop/schoolboard_lookup.csv';

PROC IMPORT DATAFILE=REFFILE 
	DBMS=CSV
	OUT=WORK.schoolboard_lookup; 
	GETNAMES=YES;
	guessingrows= 500;
RUN;

PROC CONTENTS DATA=WORK.schoolboard_lookup; RUN;


%web_open_table(WORK.schoolboard_lookup);

/******************************************/
/* merge two datasets  */
/******************************/
proc sort data= oyap_master;
	by sb_id;
run;

proc sort data= schoolboard_lookup;
	by sb_id;
run;

data oyap_merge;
	merge oyap_master schoolboard_lookup;
	by sb_id;
run;

/***********************************/
/* check obs in each academic year */
/***********************************/

proc freq data=oyap_master;
 tables acad_year/ plots=freqplot missing;
run;

/*********************************/
/* frequency table by sb_id */
/*******************************/
ods excel file= 'C:/Users/TaoWa/Desktop/sb_count.xlsx' style=pearl
options(sheet_interval= "none" sheet_name= "none");
	
proc freq data=oyap_merge ;
	where acad_year in ("2014-2015");

  	tables sb_id/ missing;
run;

proc freq data=oyap_merge ;
	where acad_year in ("2015-2016");

  	tables sb_id/ missing;
run;

ods excel close;

/*********************************/
/* import our count  */
/*********************/
%web_drop_table(WORK.sb_count);

FILENAME REFFILE 'C:/Users/TaoWa/Desktop/sb_count.csv';

PROC IMPORT DATAFILE=REFFILE 
	DBMS=CSV
	OUT=WORK.sb_count; 
	GETNAMES=YES;
	guessingrows= 500;
RUN;

PROC CONTENTS DATA=WORK.sb_count; RUN;


%web_open_table(WORK.sb_count);

/*********************************/
/* merge sb_count with sb name */
/********************************/
proc sort data= sb_count;
	by sb_id;
run;
proc sort data= schoolboard_lookup;
	by sb_id;
run;

data sb_count_f;
	merge sb_count schoolboard_lookup;
	by sb_id;
run;

/******************************/
/* import records for others */
/*****************************/
%web_drop_table(WORK.others_data);

FILENAME REFFILE 'C:/Users/TaoWa/Desktop/EOIS_OnSis_OYAPdatav2.csv';

PROC IMPORT DATAFILE=REFFILE 
	DBMS=CSV
	OUT=WORK.others_data; 
	GETNAMES=YES;
	guessingrows= 500;
RUN;

PROC CONTENTS DATA=WORK.others_data; RUN;


%web_open_table(WORK.others_data);

/*************************************/
/* merge our data with others */
/********************************/

proc sort data= sb_count_f;
	by ac_year sb_id;
run;
	
proc sort data= others_data(rename=(SCHL_YR=ac_year SB_ID=sb_id));
	by ac_year sb_id;
run;

data final_compar;
 merge others_data sb_count_f;
 by ac_year sb_id;
run;


/*************************************/
/* export final results */
/****************************/
proc export data=final_compar  dbms=csv
	outfile='C:/Users/TaoWa/Desktop/final_comparison.csv' replace;
run;
