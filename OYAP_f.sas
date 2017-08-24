%web_drop_table(WORK.IMPORT);

FILENAME REFFILE 'C:/Users/TaoWa/Desktop/oyap_master_2017-08-17.csv';

PROC IMPORT DATAFILE=REFFILE 
	DBMS=CSV
	OUT=WORK.IMPORT; 
	GETNAMES=YES;
	guessingrows= 500;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


%web_open_table(WORK.IMPORT);

/**********************************************************/
/*  change NA in character variables to missing value .n  */
/**********************************************************/
data import2;
	set import;
	
	array chars[*] _character_;
	
	do i= 1 to dim(chars) ;
	
	If trimn(chars[i]) = "NA" then chars[i] = .n;
	else		        chars[i] = propcase(chars[i]);
	end;	
run;

proc export data=import2 dbms=csv
	outfile='C:/Users/TaoWa/Desktop/import2.csv' replace;
run;

%web_drop_table(WORK.IMPORT);

FILENAME REFFILE 'C:/Users/TaoWa/Desktop/import2.csv';

PROC IMPORT DATAFILE=REFFILE 
	DBMS=CSV
	OUT=WORK.IMPORT; 
	GETNAMES=YES;
	guessingrows= 500;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


%web_open_table(WORK.IMPORT);

/***************************/
/* add indicator for ta  */
/**************************/

data oyap1;
	set import;
	
	format oyap_contract $10.;
	
	oyap_contract = .;
	
	If	oyap_status in ("COMP","WTHDRN") and (oyap_status_date - ta_registration_date) >0 
		then oyap_contract ="yes";
	else if oyap_status in ("COMP","WTHDRN") and (oyap_status_date - ta_registration_date) <=0 
		then oyap_contract ="no";
	else if missing(oyap_status_date) or missing(ta_registration_date)
		then oyap_contract ="unknown";
	else         oyap_contract ="unknown";

run;

proc freq data=oyap1 order=freq;
	table oyap_contract/plots=freqplot missing;
run;

proc export data=oyap1 dbms=csv
	outfile='C:/Users/TaoWa/Desktop/oyap_tda_completions_contract.csv' replace;
run;

/***************************/
/* add indicator for ta  */
/**************************/
data oyap1;
	set import;
	
	format first_ta_status_date_n   date9.
	       last_oyap_status_date_n  date9.;
	      
	 first_ta_status_date_n  = input(first_ta_status_date, YYMMDD10.);
	 last_oyap_status_date_n = input (last_oyap_status_date,YYMMDD10.);
run;

data oyap2;
	set oyap1;
	
	format tda_in $6.;
	
	If 	missing(first_ta_status_date_n) or missing(last_oyap_status_date_n) 
		then tda_in = .n;
	else if first_ta_status_date_n <= last_oyap_status_date_n
		then tda_in = "yes";
	else         tda_in = "no";
 	
run;

proc freq data=oyap2 order=freq;
	table tda_in/plots=freqplot missing;
run;

proc export data=oyap2 dbms=csv
	outfile='C:/Users/TaoWa/Desktop/oyap_tda_indicate.csv' replace;
run;
/************************************/
/* create acdemic year for data set */
/*      sep to next year auguest    */
/************************************/
data oyap_acdemic;
	set import;
	
	format ac_year  date9.
		academic_year $10.;
	
	ac_year = IntNx("Year.9",oyap_status_date,0,"b");
	
	
	academic_year = year(ac_year);
run; 

proc export data=oyap_acdemic dbms=csv
	outfile='C:/Users/TaoWa/Desktop/oyap_notda_ac.csv' replace;
run;

proc freq data=oyap_acdemic;
	tables ac_year/plots=freqplot missing;
run;

