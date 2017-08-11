/*********************************************/
/*                                           */
/*	clean data set for second career      */
/*				             */
/*********************************************/
%web_drop_table(WORK.IMPORT);


FILENAME REFFILE 'C:/Users/TaoWa/Desktop/SC-Person-14-17.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
	/*guessingrows= 100000;*/
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


%web_open_table(WORK.IMPORT);

data new;
	set import;

	age = round( ('Registration Date'n - 'Date of Birth'n)/365.25,2);
run;

/*****************************************/
/* variables summary without missing value*/
/******************************************/
proc freq data=import order=freq ;
	
	tables  'Preferred Language (En)'n 
		'Preferred Communication Method ('n 
		'Gender (En)'n 
		'Gender Other Desc'n 
		'Marital Status (En)'n 
		'Country of Birth (En)'n 
		'Aboriginal Group (En)'n 
		'First Nations'n 
		Inuit Metis 
		'Canada Status (En)'n 
		'Is Visible Minority?'n 
		'Is Disable?'n 
		'Is Newcomer?'n 
		'Is Francophone?'n 
		'Is Deaf Hearing Impaired?'n 
		'Status (En)'n
		 / plots=(freqplot 
		);
run;

proc freq data=import order=freq;
	
	tables  'Preferred Language (En)'n 
		'Preferred Communication Method ('n 
		'Gender (En)'n 
		'Gender Other Desc'n 
		'Marital Status (En)'n 
		'Country of Birth (En)'n 
		'Aboriginal Group (En)'n 
		'First Nations'n 
		Inuit Metis 
		'Canada Status (En)'n 
		'Is Visible Minority?'n 
		'Is Disable?'n 
		'Is Newcomer?'n 
		'Is Francophone?'n 
		'Is Deaf Hearing Impaired?'n 
		'Status (En)'n
		 / plots=(freqplot 
		) missing;
run;

/**************************************/
/**	      analysis age	   	**/
/**********************************/
ods noproctitle;
ods graphics / imagemap=on;

proc means data=WORK.NEW chartype mean std min max median n nmiss vardef=df 
		qmethod=os;
	var age;
run;

proc univariate data=WORK.NEW vardef=df noprint;
	var age;
	histogram age;
run;

/*var 'PDC Id'n 'Case Reference'n 'Person Id'n 'Reference Number'n 
		'Registration Date'n 'Date of Birth'n 'Canada Arrival Date'n;
		
		
	class 'Person Name'n 'Preferred Language (En)'n 
		'Preferred Communication Method ('n 'Gender (En)'n 'Gender (Fr)'n 
		'Gender Other Desc'n 'Marital Status (En)'n 'Country of Birth (En)'n 
		'Aboriginal Group (En)'n 'First Nations'n Inuit Metis 'Canada Status (En)'n 
		'Deaf Blind Ind'n 'Date of Death'n 'Is Visible Minority?'n 'Is Disable?'n 
		'Is Newcomer?'n 'Is Francophone?'n 'Is Deaf Hearing Impaired?'n 
		'Status (En)'n;
		*/