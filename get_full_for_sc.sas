/********************************************/
/*     import two data sets          */
/**************************************/

%web_drop_table(WORK.test_sc_master);

FILENAME REFFILE 'C:/Users/TaoWa/Desktop/test_sc_master.csv';

PROC IMPORT DATAFILE=REFFILE 
	DBMS=CSV
	OUT=WORK.test_sc_master; 
	GETNAMES=YES;
	guessingrows= 500;
RUN;

PROC CONTENTS DATA=WORK.test_sc_master; RUN;


%web_open_table(WORK.test_sc_master);

%web_drop_table(WORK.institute_OSAP);

FILENAME REFFILE 'C:/Users/TaoWa/Desktop/educational_institute_OSAP.csv';

PROC IMPORT DATAFILE=REFFILE 
	DBMS=CSV
	OUT=WORK.institute_OSAP; 
	GETNAMES=YES;
	guessingrows= 500;
RUN;

PROC CONTENTS DATA=WORK.institute_OSAP; RUN;

%web_open_table(WORK.institute_OSAP);


/*******************************************/
/*	 sort the two data sets 	*/
/******************************************/
proc sort data= WORK.TEST_SC_MASTER;
	by Educational_Institute_Id;
run;

proc sort data=  WORK.INSTITUTE_OSAP(rename=('Educational Institute Id'n=Educational_Institute_Id));
	by Educational_Institute_Id;
run;

data sc_master_full;
	merge TEST_SC_MASTER(in=a) INSTITUTE_OSAP(in=b) end=eof;
	by Educational_Institute_Id ;
	
	IF a;
run;
proc export data=sc_master_full dbms=csv
	outfile='C:/Users/TaoWa/Desktop/sc_master_full.csv' replace;
run;
/*************************************************************/
/** note: around 8000 records don't have institute name      **/
/*************************************************************/