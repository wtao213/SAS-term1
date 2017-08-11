/***********************************/
/* import dataset for last result	*/
/*********************************/

%web_drop_table(WORK.COJG);


FILENAME REFFILE 'C:/Users/TaoWa/Desktop/COJG.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.COJG;
	/*delimiter=',';*/
	GETNAMES=YES;
	/*datarow= 85687;*/
	guessingrows= 5687;
RUN;

PROC CONTENTS DATA=WORK.COJG; RUN;


%web_open_table(WORK.COJG);

/************************/
/* add info for wage */
/**********************/
data COJG_wage;
	set COJG;
	
	format annum_wage Best32.
	       previous_work_type   $10.
	       low_income_indicator $8.;	
	       
	annum_wage = .;
	if       Last_Wage_per_Type_EN = "Hour"      then annum_wage = Last_Hours_Per_Week * Last_Wage_Amount *52;
	else if  Last_Wage_per_Type_EN = "Weekly"    then annum_wage = Last_Wage_Amount *52 ;
	else if  Last_Wage_per_Type_EN = "Bi-weekly" then annum_wage = Last_Wage_Amount *26 ;
	else if  Last_Wage_per_Type_EN = "Monthly"   then annum_wage = Last_Wage_Amount *12 ;
	else if  Last_Wage_per_Type_EN = "Annum"     then annum_wage = Last_Wage_Amount ;
	else					     	  annum_wage = .n ;
	       
	previous_work_type = .;
	if	Last_Hours_Per_Week = .     then	previous_work_type = .n;
	else if Last_Hours_Per_Week < 30    then	previous_work_type = "Part_Time";
	else    					previous_work_type = "Full_Time";
	
	low_income_indicator =. ;
	if      annum_wage = .n     then low_income_indicator = .n;
	else if annum_wage <= 30000 then low_income_indicator = "yes";
	else 				 low_income_indicator = "no";
	
run;

/*****************************************/
/**	output data set			**/
/*****************************************/
proc export data = COJG_wage dbms=csv
	outfile = 'C:/Users/TaoWa/Desktop/COJG_wage.csv' replace;
run;

/***************************************/
/* testing duplicate */
/*****************************/
proc sort data=COJG_wage nodupkey dupout=dups;
	by case_reference /*trade*/;
run;

proc sort data= COJG_wage 
	 /* output = import */
	  nodupkey;
     by case_reference ;
run;

/****************************************/
/* import dataset for COJG master	*/
/**************************************/

%web_drop_table(WORK.COJG_master);


FILENAME REFFILE 'C:/Users/TaoWa/Desktop/COJG_master.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.COJG_master;
	/*delimiter=',';*/
	GETNAMES=YES;
	/*datarow= 85687;*/
	guessingrows= 5687;
RUN;

PROC CONTENTS DATA=WORK.COJG_master; RUN;


%web_open_table(WORK.COJG_master);

proc sort data= COJG_master 
	 /* output = import */
	  nodupkey;
     by case_reference ;
run;


/****************************************/
/*   merge cojg_wage and cojg_master   */
/***************************************/
data merge_COJG;
	merge COJG_wage (in= in1) COJG_master (in= in2) end=eof;
	by case_reference ;
	
	/* inner join of two tables */
	/*if in1 and in2;*/
	
	/*if       in1 = 1 and in2 = 0 then id = "no oyap";
	else if  in1 = 0 and in2 = 1 then id = "no tda";
	else				  id = "id";*/
	
run;

/*****************************************/
/**	output data set			**/
/*****************************************/
proc export data = merge_COJG dbms=csv
	outfile = 'C:/Users/TaoWa/Desktop/COJG_merge.csv' replace;
run;


/****************************************/
/**	gender and maritual status    **/
/****************************************/
proc tabulate data=merge_COJG missing order=freq format=8.2;
	class Marital_Status_EN Gender;
	variable age;

table (Marital_Status_EN  all), (Gender all)*(n*f=8. colpctn)/rts=10
		box='gender by marital status';
run;		
run;