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
/***********************************/
/* tabulate */
/**************************/
proc tabulate data=import missing f=8.2;
 	class acad_year oyap_status;
 	var dob;
 	
 	tables acad_year all, (oyap_status all)*(n rowpctn)/rts=8;
 	
 run;