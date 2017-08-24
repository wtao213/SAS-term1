/**********************************************************/
/**   check for second career outcomes   */
/**   import data set first              */
/*******************************************/
%web_drop_table(WORK.sc_master);

FILENAME REFFILE 'C:/Users/TaoWa/Desktop/second career/sc_master_full.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.sc_master;
	/*delimiter=',';*/
	GETNAMES=YES;
	guessingrows= 5687;
RUN;

PROC CONTENTS DATA=WORK.sc_master; RUN;


%web_open_table(WORK.sc_master);


/********************************************************/
/* data manipulate, create variables to indicate groups */
/*******************************************************/

/** check the program name with certain name inside **/
data sc_job;
	set sc_master;
	
	where index(Program_Name,"PSW") ;
run;

/** add groups for institute,osap eligible,duration**/
data sc_master1;
	set sc_master;
		
	format group_type     $8.
	       work_type      $10.
	       employed_type6 $8.
	       duration       $15.
	       Program_End_Date date9.;
	
	where Closure_Reason_EN ~= "NA" and '01APR2014'd <=Program_End_Date <= '31MAR2016'd;

	
	group_type =.;
	
	If      Institute_Type = "College of Applied Arts and Technology" then group_type = "CAAT";
	else if Institute_Type = "Private College" and OSAP_Eligible ="Y" then group_type = "PCC-Y";
	else if Institute_Type = "Private College" and OSAP_Eligible ="N" then group_type = "PCC-N";
	else                                                                   group_type = "others";
	
	work_type = .;
	If	Training_NOC_Code = 7511 or Training_NOC_Code = 7521 then work_type = "truck_equi";
	else if Training_NOC_Code = 3413 or Training_NOC_Code = 4412 or Training_NOC_Code = 4212 
								     then work_type = "PSW";
	else							     	  work_type = "others";
	
	employed_type6 = .;
	If      index(_6th_Month_Review_Outcome_EN,"Employed")   then employed_type6 = "Employed" ;
	else if index(_6th_Month_Review_Outcome_EN,"education") then employed_type6 = " In education" ;
	else if index(_6th_Month_Review_Outcome_EN,"Unemployed") then employed_type6 = "unemployed" ;
	else if index(_6th_Month_Review_Outcome_EN,"training") then employed_type6 = "In training" ;
	else if index(_6th_Month_Review_Outcome_EN,"Unknown") then employed_type6 = "Unknown" ;
	else if _6th_Month_Review_Outcome_EN in ("Independent","Unable to work","Volunteer") then employed_type6 = "other" ;
	else							      employed_type6 = "NA" ;
	
	duration = .;
	If      Duration_in_weeks <= 12  then duration = "<=12 weeks";
	else if Duration_in_weeks <= 16 then duration = "3< months <=4";
	else if Duration_in_weeks <= 32 then duration = "4< months <=8";
	else if Duration_in_weeks <= 52 then duration = "8< months <=12";
	else				     duration = "greater than 1 year";
run;


/*******************************/
/** clean institute name **/
/** this is not efficient, next time add a loop on school list */
/**************************/
data sc_master_c;
	set sc_master1;
	
	format institute_name_u $32.;
	
	institute_name_u = .;
	
	If 	index(Institute_Name,"5TH WHEEL TRAINING INSTITUTE") 
		then institute_name_u = "5TH WHEEL TRAINING INSTITUTE";
	else If index(Institute_Name,"ACADEMY OF LEARNING CAREER AND BUSINESS COLLEGE") 
		then institute_name_u = "ACADEMY OF LEARNING CAREER AND BUSINESS COLLEGE";
	else If index(Institute_Name,"ALGONQUIN CAREERS ACADEMY") 
		then institute_name_u = "ALGONQUIN CAREERS ACADEMY";
	else If index(Institute_Name,"ALGONQUIN COLLEGE") 
		then institute_name_u = "ALGONQUIN COLLEGE";
	else If index(Institute_Name,"ALLANTI SCHOOL OF HAIRSTYLING AND AESTHETICS") 
		then institute_name_u = "ALLANTI SCHOOL OF HAIRSTYLING AND AESTHETICS";	
	else If index(Institute_Name,"ANDERSON COLLEGE OF HEALTH, BUSINESS, AND TECHNOLOGY") 
		then institute_name_u = "ANDERSON COLLEGE OF HEALTH, BUSINESS, AND TECHNOLOGY";
	else If index(Institute_Name,"ART & TECHNIQUE ACADEMY OF HAIRSTYLING AND ESTHETICS") 
		then institute_name_u = "ART & TECHNIQUE ACADEMY OF HAIRSTYLING AND ESTHETICS";
	else If index(Institute_Name,"BEAUTY ACADEMY") 
		then institute_name_u = "BEAUTY ACADEMY";
	else If index(Institute_Name,"BUSINESS EDUCATION COLLEGE") 
		then institute_name_u = "BUSINESS EDUCATION COLLEGE";
	else If index(Institute_Name,"CANADA ALL CARE COLLEGE") 
		then institute_name_u = "CANADA ALL CARE COLLEGE";
	else If index(Institute_Name,"CANADIAN BEAUTY COLLEGE") 
		then institute_name_u = "CANADIAN BEAUTY COLLEGE";	
	else If index(Institute_Name,"CANADIAN BUSINESS COLLEGE") 
		then institute_name_u = "CANADIAN BUSINESS COLLEGE";
	else If index(Institute_Name,"CANADIAN CAREER COLLEGE OF INNOVATIVE TECHNOLOGY & MANAGEMENT") 
		then institute_name_u = "CANADIAN CAREER COLLEGE OF INNOVATIVE TECHNOLOGY & MANAGEMENT";
	else If index(Institute_Name,"CANADIAN COLLEGE OF BUSINESS, SCIENCE & TECHNOLOGY") 
		then institute_name_u = "CANADIAN COLLEGE OF BUSINESS, SCIENCE & TECHNOLOGY";
	else If index(Institute_Name,"CANADIAN COLLEGE OF MASSAGE AND HYDROTHERAPY") 
		then institute_name_u = "CANADIAN COLLEGE OF MASSAGE AND HYDROTHERAPY";	
	else If index(Institute_Name,"CANADIAN INSTITUTE OF MANAGEMENT AND TECHNOLOGY") 
		then institute_name_u = "CANADIAN INSTITUTE OF MANAGEMENT AND TECHNOLOGY";
	else If index(Institute_Name,"CANADIAN MONTESSORI TEACHER EDUCATION INSTITUTE") 
		then institute_name_u = "CANADIAN MONTESSORI TEACHER EDUCATION INSTITUTE";	
	else If index(Institute_Name,"CANADIAN SCHOOL OF NATURAL NUTRITION") 
		then institute_name_u = "CANADIAN SCHOOL OF NATURAL NUTRITION";
	else If index(Institute_Name,"CAREER COLLEGE GROUP") 
		then institute_name_u = "CAREER COLLEGE GROUP";
	else If index(Institute_Name,"CDI COLLEGE OF BUSINESS, TECHNOLOGY & HEALTHCARE") 
		then institute_name_u = "CDI COLLEGE OF BUSINESS, TECHNOLOGY & HEALTHCARE";	
	else If index(Institute_Name,"CITI COLLEGE OF CANADIAN CAREERS") 
		then institute_name_u = "CITI COLLEGE OF CANADIAN CAREERS";
	else If index(Institute_Name,"COLLEGE BOREAL") 
		then institute_name_u = "COLLEGE BOREAL";	
	else If index(Institute_Name,"COMPUTEK COLLEGE OF BUSINESS, HEALTHCARE & TECHNOLOGY") 
		then institute_name_u = "COMPUTEK COLLEGE OF BUSINESS, HEALTHCARE & TECHNOLOGY";
	else If index(Institute_Name,"CONFEDERATION COLLEGE") 
		then institute_name_u = "CONFEDERATION COLLEGE";
	else If index(Institute_Name,"CROSSROADS TRUCK TRAINING ACADEMY") 
		then institute_name_u = "CROSSROADS TRUCK TRAINING ACADEMY";	
	else If index(Institute_Name,"CTS CANADIAN CAREER COLLEGE") 
		then institute_name_u = "CTS CANADIAN CAREER COLLEGE";
	else If index(Institute_Name,"DURHAM BUSINESS AND COMPUTER COLLEGE") 
		then institute_name_u = "DURHAM BUSINESS AND COMPUTER COLLEGE";
	else If index(Institute_Name,"DURHAM COLLEGE") 
		then institute_name_u = "DURHAM COLLEGE";
	else If index(Institute_Name,"DURHAM CONTINUING EDUCATION") 
		then institute_name_u = "DURHAM CONTINUING EDUCATION";
	else If index(Institute_Name,"EASTERN ONTARIO EDUCATION AND TRAINING CENTRE") 
		then institute_name_u = "EASTERN ONTARIO EDUCATION AND TRAINING CENTRE";
	else If index(Institute_Name,"EVEREST COLLEGE OF BUSINESS, TECHNOLOGY AND HEALTH CARE") 
		then institute_name_u = "EVEREST COLLEGE OF BUSINESS, TECHNOLOGY AND HEALTH CARE";
	else If index(Institute_Name,"EVERGREEN COLLEGE") 
		then institute_name_u = "EVERGREEN COLLEGE";
	else If index(Institute_Name,"FANSHAWE COLLEGE") 
		then institute_name_u = "FANSHAWE COLLEGE";
	else If index(Institute_Name,"GEORGE BROWN COLLEGE") 
		then institute_name_u = "GEORGE BROWN COLLEGE";
	else If index(Institute_Name,"GEORGIAN COLLEGE") 
		then institute_name_u = "GEORGIAN COLLEGE";
	else If index(Institute_Name,"GINA'S COLLEGE OF ADVANCED AESTHETICS") 
		then institute_name_u = "GINA'S COLLEGE OF ADVANCED AESTHETICS";
	else If index(Institute_Name,"GRADE LEARNING") 
		then institute_name_u = "GRADE LEARNING";
	else If index(Institute_Name,"GRAND HEALTH ACADEMY") 
		then institute_name_u = "GRAND HEALTH ACADEMY";
	else If index(Institute_Name,"HERZING COLLEGE") 
		then institute_name_u = "HERZING COLLEGE";
	else If index(Institute_Name,"HI-MARK OCCUPATIONAL SKILLS TRAINING CENTRE") 
		then institute_name_u = "HI-MARK OCCUPATIONAL SKILLS TRAINING CENTRE";
	else If index(Institute_Name,"HUMBER COLLEGE") 
		then institute_name_u = "HUMBER COLLEGE";
	else If index(Institute_Name,"INSTITUTE OF HOLISTIC NUTRITION") 
		then institute_name_u = "INSTITUTE OF HOLISTIC NUTRITION";
	else If index(Institute_Name,"KLC COLLEGE") 
		then institute_name_u = "KLC COLLEGE";
	else If index(Institute_Name,"LEARNING CENTRE") 
		then institute_name_u = "LEARNING CENTRE";
	else If index(Institute_Name,"LIAISON COLLEGE") 
		then institute_name_u = "LIAISON COLLEGE";
	else If index(Institute_Name,"LOYALIST COLLEGE") 
		then institute_name_u = "LOYALIST COLLEGE";
	else If index(Institute_Name,"MAPLE LEAF COLLEGE OF BUSINESS AND TECHNOLOGY") 
		then institute_name_u = "MAPLE LEAF COLLEGE OF BUSINESS AND TECHNOLOGY";
	else If index(Institute_Name,"MARCA COLLEGE OF HAIR & ESTHETICS") 
		then institute_name_u = "MARCA COLLEGE OF HAIR & ESTHETICS";	
	else If index(Institute_Name,"MARVEL BEAUTY SCHOOLS") 
		then institute_name_u = "MARVEL BEAUTY SCHOOLS";
	else If index(Institute_Name,"MEDIX SCHOOL") 
		then institute_name_u = "MEDIX SCHOOL";
	else If index(Institute_Name,"MODERN COLLEGE OF HAIRSTYLING & ESTHETIC") 
		then institute_name_u = "MODERN COLLEGE OF HAIRSTYLING & ESTHETIC";
	else If index(Institute_Name,"MOHAWK COLLEGE") 
		then institute_name_u = "MOHAWK COLLEGE";
	else If index(Institute_Name,"NATIONAL ACADEMY OF HEALTH") 
		then institute_name_u = "NATIONAL ACADEMY OF HEALTH & BUSINESS";
	else If index(Institute_Name,"NORTH AMERICAN COLLEGE OF INFORMATION TECHNOLOGY") 
		then institute_name_u = "NORTH AMERICAN COLLEGE OF INFORMATION TECHNOLOGY";
	else If index(Institute_Name,"NORTH AMERICAN TRANSPORT DRIVING ACADEMY") 
		then institute_name_u = "NORTH AMERICAN TRANSPORT DRIVING ACADEMY";
	else If index(Institute_Name,"NORTHERN COLLEGE") 
		then institute_name_u = "NORTHERN COLLEGE";
	else If index(Institute_Name,"ONTARIO TRUCK DRIVING SCHOOL") 
		then institute_name_u = "ONTARIO TRUCK DRIVING SCHOOL";
	else If index(Institute_Name,"ONTARIO TRUCK TRAINING ACADEMY") 
		then institute_name_u = "ONTARIO TRUCK TRAINING ACADEMY";
	else If index(Institute_Name,"OXFORD COLLEGE OF ARTS, BUSINESS AND TECHNOLOGY") 
		then institute_name_u = "OXFORD COLLEGE OF ARTS, BUSINESS AND TECHNOLOGY";
	else If index(Institute_Name,"PRE-APPRENTICESHIP TRAINING INSTITUTE") 
		then institute_name_u = "PRE-APPRENTICESHIP TRAINING INSTITUTE";
	else If index(Institute_Name,"PROGRESSIVE TRAINING COLLEGE OF BUSINESS & HEALTH") 
		then institute_name_u = "PROGRESSIVE TRAINING COLLEGE OF BUSINESS & HEALTH";
	else If index(Institute_Name,"SENECA COLLEGE") 
		then institute_name_u = "SENECA COLLEGE";			
	else If index(Institute_Name,"SHERIDAN COLLEGE") 
		then institute_name_u = "SHERIDAN COLLEGE";
	else If index(Institute_Name,"SIR SANDFORD FLEMING COLLEGE") 
		then institute_name_u = "SIR SANDFORD FLEMING COLLEGE";
	else If index(Institute_Name,"ST. CLAIR COLLEGE") 
		then institute_name_u = "ST. CLAIR COLLEGE";
	else If index(Institute_Name,"ST. LAWRENCE COLLEGE") 
		then institute_name_u = "ST. LAWRENCE COLLEGE";
	else If index(Institute_Name,"ST. LOUIS ADULT LEARNING CENTRE") 
		then institute_name_u = "ST. LOUIS ADULT LEARNING CENTRE";
	else If index(Institute_Name,"STANFORD INTERNATIONAL COLLEGE OF BUSINESS AND TECHNOLOGY") 
		then institute_name_u = "STANFORD INTERNATIONAL COLLEGE OF BUSINESS AND TECHNOLOGY";
	else If index(Institute_Name,"TRANSPORT TRAINING CENTRES OF CANADA") 
		then institute_name_u = "TRANSPORT TRAINING CENTRES OF CANADA";
	else If index(Institute_Name,"TRILLIUM COLLEGE") 
		then institute_name_u = "TRILLIUM COLLEGE";		
	else If index(Institute_Name,"TRIOS COLLEGE") 
		then institute_name_u = "TRIOS COLLEGE";
	else If index(Institute_Name,"UNIVERSITY OF GUELPH") 
		then institute_name_u = "UNIVERSITY OF GUELPH";
	else If index(Institute_Name,"WILLIS COLLEGE OF BUSINESS, HEALTH & TECHNOLOGY") 
		then institute_name_u = "WILLIS COLLEGE OF BUSINESS, HEALTH & TECHNOLOGY";
			
	else         institute_name_u = Institute_Name ;
run;


/********************************/
/* get clean final dataset      */
/* delete the records in others */
/********************************/	
data sc_master_clean;
	set sc_master1;
	
	where employed_type6 ~= "NA" and group_type ~="others";
run;

/***********************************/
/* output dataset */
/***********************/
proc export data=sc_master_c dbms=csv
	outfile='C:/Users/TaoWa/Desktop/sc_master_c.csv' replace;
run;

/*********************************/
/* check variables  */
/************************/
ods noproctitle;
ods graphics / imagemap=on;

proc freq data= sc_master_c order = freq;
	table group_type work_type employed_type6 duration
	      _6th_Month_Review_Outcome_EN _12th_Month_Review_Outcome_EN Case_Actual_Outcome_EN
	       Institute_Type OSAP_Eligible Training_NOC_Code Gender_EN 
	      Closure_Reason_EN
	/ plots= (freqplot) missing;
run;

proc means data=sc_master_c chartype mean std min max median n nmiss mode 
		vardef=df clm alpha=0.05 qmethod=os;		
	  var Duration_in_weeks Suitability_Score;
run;
	 
proc univariate data=sc_master_c vardef=df noprint;
	var Duration_in_weeks Suitability_Score;
	histogram Duration_in_weeks Suitability_Score;
run;

/*************************************************/
/* check variables for the clean final dataset   */
/*************************************************/	
proc freq data=sc_master_c order=freq;
	table institute_name_u/plots=freqplot missing;
run;

/*******************************************/
/* check employed outcome by institue type */
/*******************************************/
proc sort data=sc_master_c;

proc tabulate data=sc_master_c missing f=8.2 order=freq;
	class group_type work_type employed_type6 duration Gender_EN Closure_Reason_EN institute_name_u;
	var Duration_in_weeks Suitability_Score;
	
	tables institute_name_u all,(employed_type6='employed ruslts' all)*(n rowpctn)/rts=8;
	
	tables group_type, institute_name_u all,(employed_type6='employed ruslts' all)*(n rowpctn)/rts=8;
run;


/***************************/
/* tabulate results */
/*********************/
ods excel file= 'C:/Users/TaoWa/Desktop/sc_outcome_tables.xlsx' style=pearl
options(sheet_interval= "table" sheet_name= "none");

proc tabulate data=sc_master_clean missing f=8.2;
	class group_type work_type employed_type6 duration Gender_EN Closure_Reason_EN;
	var Duration_in_weeks Suitability_Score;
	
	where Gender_EN ="Female" or Gender_EN = "Male";
	
	/***** tables for one factor *****/
	table group_type all ,(employed_type6='employed outcomes' all)*(n rowpctn)/rts=8;
	
	table Gender_EN all ,(employed_type6='employed outcomes' all)*(n rowpctn)/rts=8;
	
	table work_type all , (employed_type6='employed outcomes' all) *(n rowpctn)/rts=8;
	
	table duration all , (employed_type6='employed outcomes' all) *(n rowpctn)/rts=8;
	
	/***** tables for two factors *****/
	
	table group_type*(Gender_En all) all , (employed_type6='employed outcomes' all) *(n rowpctn)/rts=8;
	
	table group_type*(work_type all) all , (employed_type6='employed outcomes' all) *(n rowpctn)/rts=8;

	table group_type*(duration all) all , (employed_type6='employed outcomes' all) *(n rowpctn)/rts=8;
	
	table work_type * Gender_EN  all , (employed_type6='employed outcomes' all) *(n rowpctn)/rts=8;
	
	table work_type* (duration all) all , (employed_type6='employed outcomes' all) *(n rowpctn)/rts=8;
	
	table duration* (Gender_EN all) all , (employed_type6='employed outcomes' all) *(n rowpctn)/rts=8;
	
	/***** tables for three factors ****/
	
	table work_type* (group_type all)*duration all , (employed_type6='employed outcomes' all) *(n rowpctn)/rts=8;

	table work_type* (group_type all)*Gender_EN all , (employed_type6='employed outcomes' all) *(n rowpctn)/rts=8;

	table group_type* (duration all)*Gender_EN all , (employed_type6='employed outcomes' all) *(n rowpctn)/rts=8;

run;

ods excel close;

/********************************/
/* dataset on certain noc code */
/********************************/
data sc_master_noc;
	set sc_master_c;
	
	where Training_NOC_Code in (4212,4214,3233,1431,7511,4412,4211,1221,1243,2281,7521,7237) 
	      and  employed_type6 ~= "others" ;
run;

/******************************/
/*	 tabulate results     */
/******************************/
ods excel file= 'C:/Users/TaoWa/Desktop/sc_noc_tables.xlsx' style=pearl
options(sheet_interval= "table" sheet_name= "none");

proc tabulate data=sc_master_noc order=freq f=8.2;
	class group_type work_type employed_type6 duration Gender_EN Closure_Reason_EN 
	      Training_NOC_Code Institute_Type;
	var   Duration_in_weeks Suitability_Score;
	
	where (Institute_Type = "Private College" or Institute_Type ="College of Applied Arts and Technology")
		and employed_type6 ~="NA" ;
	
	tables (Training_NOC_Code all) * Institute_Type all, (employed_type6='employed outcomes' all)*(n rowpctn)/ rts=8;
	
	tables (Training_NOC_Code all) * group_type all, (employed_type6='employed outcomes' all)*(n rowpctn)/ rts=8;
	
	tables Training_NOC_Code all, (employed_type6='employed outcomes'*group_type  all)*(n rowpctn)/ rts=8;
	
run;

ods excel close;