/*******************************************/
/* macro for a list of character variables */
/*******************************************/

%web_drop_table(WORK.sc_master);

FILENAME REFFILE 'C:/Users/TaoWa/Desktop/second career/SC_Analysis_File_FY_14-17_v03.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.sc_master;
	/*delimiter=',';*/
	GETNAMES=YES;
	guessingrows= 5687;
RUN;

PROC CONTENTS DATA=WORK.sc_master; RUN;


%web_open_table(WORK.sc_master);

/**********************************/
/* practise */
/****************************/
proc univariate data=sc_master nextrobs=15;
	id PDC_id;
	var Tuition;
	histogram / normal ;
run;

/***************************************/
/* use scan to delete campus info     **/
/* need to pay attention whether      **/
/* original college name include a '-' or not */
/***************************************/
data sc_master_u;
 set sc_master;
 
 format Institute_Name_u $32.;
 
 Institute_Name_u = scan(Institute_Name,1,'-');
 
run;

/****************************************/
/*      use index to check strings      */
/****************************************/
data final_name;
	set sc_master;
	/*format institute_name_u $32.;*/	
	array int_name[4] $50. _temporary_ ("UNIVERSITY OF GUELPH","YORK University",'5TH WHEEL TRAINING INSTITUTE','TRIOS COLLEGE');
	
	do i = 1 to 4;
	
	if  index(Institute_Name,%str(int_name[i])) 
		then  institute_name_u = %str(int_name[i]);			
	else         institute_name_u = Institute_Name ;
	end;

	drop i;	
run;


/****************************************/
/*      use index to check strings    t2  */
/****************************************/
%let name1 = %str(UNIVERSITY OF GUELPH,YORK University,_5TH WHEEL TRAINING INSTITUTE,TRIOS COLLEGE);


data final_name;
	set sc_master;
	/*format institute_name_u $32.;*/
		
	do i = 1 to 4;
	
	if  index(Institute_Name,scan(&name1,&i,','))
		then  institute_name_u = scan(&name1,&i,',');
			
	else         institute_name_u = Institute_Name ;
	end;

	drop i;	
run;

/**********************************/
/* test use of function SCAN    **/
/*********************************/
data parse;
	input long_str $ 1-80;
	array pieces[5] $ 10 piece1 - piece5;
	
	do i = 1 to 5;
	  pieces[i] = scan(long_str, i , ',.! ');
	end;
	drop long_str  i;
datalines;
this line, contains!five.words
abcdefghijkl xxx yyy
;

proc print data=parse noobs;
run;