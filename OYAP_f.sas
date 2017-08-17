%web_drop_table(WORK.IMPORT);

FILENAME REFFILE 'C:/Users/TaoWa/Desktop/oyap_notda_completions.csv';

PROC IMPORT DATAFILE=REFFILE 
	DBMS=CSV
	OUT=WORK.IMPORT; 
	GETNAMES=YES;
	guessingrows= 500;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


%web_open_table(WORK.IMPORT);

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

/************************************/
/* create acdemic year for data set */
/*      sep to next year auguest    */
/************************************/
data oyap_acdemic;
	set import;
	
	format ac_year  date9.;
	
	ac_year = IntNx("Year.9",oyap_status_date,0,"b");
	
run;

proc export data=oyap_acdemic dbms=csv
	outfile='C:/Users/TaoWa/Desktop/oyap_notda_ac.csv' replace;
run;

proc freq data=oyap_acdemic;
	tables ac_year/plots=freqplot missing;
run;

