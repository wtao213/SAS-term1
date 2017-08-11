/******************************************/
/* import dataset	*/
/*****************************/

%web_drop_table(WORK.sc_master);


FILENAME REFFILE 'C:/Users/TaoWa/Desktop/test_sc_master.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.sc_master;
	/*delimiter=',';*/
	GETNAMES=YES;
	/*datarow= 85687;*/
	guessingrows= 5687;
RUN;

PROC CONTENTS DATA=WORK.sc_master; RUN;


%web_open_table(WORK.sc_master);

/*data sc_master1;
	set sc_master;
	format dob date9. program_start_d date9.;
	dob = input (Date_of_Birth, MMDDYY10.);
	program_start_d = input ( Program_Start_Date, MMDDYY10.);
run;*/

data sc_master2;
	set sc_master;

	where program_start_date > '31Mar2014'd and program_start_date <= '31Mar2017'd;

	format age best32.; /*unless wont have format for the variable*/
	age = round( (Program_Start_Date - Date_of_Birth)/365.25,2);
run;

/**********************************/
/*         add age groups        */
/*********************************/
data sc_master1;
	set sc_master2;
	
	format age_group $20.;
	
	age_group = .;
	if      0  <= age <15 then age_group = "14 and under";
	else if 15 <= age <25 then age_group = "15-24";
	else if 25 <= age <35 then age_group = "25-34";
	else if 35 <= age <45 then age_group = "35-44";
	else if 45 <= age <55 then age_group = "45-54";
	else if 55 <= age <65 then age_group = "55-64";
	else if 65 <= age <75 then age_group = "65-74";
	else		           age_group = "75 and higher";
run;

/************************************/
/* add wage annually */
/*********************/
data sc_master_wage;
	set sc_master1;
	
	format annum_wage Best32.;
	
	annum_wage = .;
	if       Wage_per_Type_EN = "Hour"      then annum_wage = Hours_Per_Week * Wage_Amount *52;
	else if  Wage_per_Type_EN = "Weekly"    then annum_wage = Wage_Amount *52 ;
	else if  Wage_per_Type_EN = "Bi-weekly" then annum_wage = Wage_Amount*26 ;
	else if  Wage_per_Type_EN = "Monthly"   then annum_wage = Wage_Amount*12 ;
	else if  Wage_per_Type_EN = "Annum"     then annum_wage = Wage_Amount ;
	else					     annum_wage = .n ;

run;	

/**************************************************/
/* add low income indicator and work-type column */
/***************************************************/
data sc_master_wage_info;
	set sc_master_wage;
	
	format previous_work_type   $10.
	       low_income_indicator $8.;	
	       
	previous_work_type = .;
	if	Hours_Per_Week = .n    then	previous_work_type = .n;
	else if Hours_Per_Week < 30    then	previous_work_type = "Part_Time";
	else    				previous_work_type = "Full_Time";
	
	low_income_indicator =. ;
	if      annum_wage = .n     then low_income_indicator = .n;
	else if annum_wage <= 30000 then low_income_indicator = "yes";
	else 				 low_income_indicator = "no";
	
run;

/*****************************************/
/**	output data set			**/
/*****************************************/
proc export data = sc_master_wage_info dbms=csv
	outfile = 'C:/Users/TaoWa/Desktop/sc_master_wage.csv' replace;
run;	

/***********************************/
/*	var     PDC_Id Case_Reference Person_Id Start_Date Registration_Date_x Open_Date 
		Program_Start_Date Program_End_Date Training_NOC_Code 
		Educational_Institute_Id Duration_in_Weeks SIN_Number Reference_Number 
		Registration_Date_y Date_of_Birth Primary_Address_Id Exit_Closure_Date 
		_12th_Month_Closure_Date Hours_Per_Week_Code Hours_Per_Week Wage_Amount 
		Basic_Living_Allowance_on_Claim Basic_Living_Allowance_not_on_Cl 
		Transportation 'Books_and_Other_Instructio.nl_Co'n Tuition Tuition_ABE 
		Disability_Expenses Dependent_Care Living_Away_From_Home 'Other_(Taxable)'n 
		'Other_(Non-taxable)'n Total_Agreement_Amount Client_Contributions 
		sc_start_date emp_days_ago SIN_Number_y ES_Case_Reference es_suit_date 
		Case_Reference_y Date_Of_Assessment Client_Eligibile Suitability_Score 
		Duration_Of_Unemployment_Score Work_History_Score Lm_Prospects_Score 
		Type_Of_Training_Score 'Exp_Occupatio.nl_Skills_Score'n 
		'Educatio.nl_Attainment_Score'n sc_suit_date age;
	class Product_Type_EN Effective_Date End_Date Closure_Date Status_EN 
		Case_Actual_Outcome_EN Closure_Reason_EN Program_Name Program_Language_EN 
		Full_Time_Status_Code Evidence_Status_EN Preferred_Language_EN 
		Preferred_Communication_Method_E Gender_EN Marital_Status_EN 
		Country_of_Birth_EN Aboriginal_Group_EN First_Nations Inuit Metis 
		Canada_Status_EN Deaf_Blind_Ind Date_of_Death 'Ca.nda_Arrival_Date'n 
		'Is_Visible_Minority?'n 'Is_Disable?'n 'Is_Newcomer?'n 'Is_Francophone?'n 
		'Is_Deaf_Hearing_Impaired?'n Exit_Review_Start_Date Exit_Scheduled_Start_Date 
		Exit_Review_End_Date Exit_Reason_EN Exit_Review_Status_EN 
		Exit_Review_Outcome_EN Exit_Satisfaction_EN Exit_Satisfaction_Level_EN 
		'Exit_-Job_Related_to_Training'n _3rd_Month_Review_Start_Date 
		_3rd_Month_Scheduled_Start_Date _3rd_Month_Review_End_Date 
		_3rd_Month_Reason_EN _3rd_Month_Review_Status_EN _3rd_Month_Review_Outcome_EN 
		_3rd_Month_Satisfaction_EN _3rd_Month_Satisfaction_Level_EN 
		'_3rd_Month_-Job_Related_to_Train'n _6th_Month_Review_Start_Date 
		_6th_Month_Scheduled_Start_Date _6th_Month_Review_End_Date 
		_6th_Month_Reason_EN _6th_Month_Review_Status_EN _6th_Month_Review_Outcome_EN 
		_6th_Month_Satisfaction_EN _6th_Month_Satisfaction_Level_EN 
		_6th_Month_Closure_Date '_6th_Month_-Job_Related_to_Train'n 
		_12th_Month_Review_Start_Date _12th_Month_Scheduled_Start_Date 
		_12th_Month_Review_End_Date _12th_Month_Reason_EN 
		_12th_Month_Review_Status_EN _12th_Month_Review_Outcome_EN 
		_12th_Month_Satisfaction_EN _12th_Month_Satisfaction_Level_E 
		'_12th_Month_-Job_Related_to_Trai'n Source_Employment_Id Employer_Id 
		From_Date To_Date Job_Title Wage_per_Type_EN NOC_EN 
		'NAICS_Non-Registered_Employment_'n Placement_Category_EN Occupation_Type_EN 
		Employment_Type_EN Reason_For_Leaving_EN Country_EN 'Is_Primary_Current?'n 
		Fiscal_Year Region_Name Sub_Region_Name Local_Office_Name 
		Service_Provider_Name SDS_Reference_Number SDS_Name Sub_Goal_Name_Code 
		Sub_Goal_Name_EN Plan_Item_Name_Code Plan_Item_Name_EN Sub_Region_Name__1 
		ES_Start_Date ES_End_Date Person_City Person_Postal_Code ES_Date_of_Birth 
		Education_Level_EN Education_Location_EN Credential_Not_Recognized_EN 
		Employment_Experience_EN Employment_Skills_EN Time_Out_of_School_EN 
		Poor_Work_Retention_EN Job_Search_Skills_EN Source_of_Income_EN 
		Language_Skills_EN Labour_Market_Change_EN Aboriginal_Group_EN_y 
		First_Nations_y Inuit_y Metis_y 'Is_Disable?_y'n Status_EN_y ES_Open_Date 
		ES_Latest_Closure_Date Latest_Closure_Reason_EN Refer_In_EN Owner_Full_Name 
		Client_Name Created_By Updated_By 'Sds_#'n Updated_Date 
		Active_Job_Search_Score	*/



/*************************************/
/*     transfer format     */
/***************************/	


/*************************************************/
/* 		categorical variables		**/
/************************************************/	
proc freq data=sc_master1 order=freq;
	
	tables /* Product_Type_EN Status_EN 
		Case_Actual_Outcome_EN Closure_Reason_EN Program_Language_EN 
		Full_Time_Status_Code Evidence_Status_EN Preferred_Language_EN 
		Preferred_Communication_Method_E Gender_EN Marital_Status_EN 
		Country_of_Birth_EN Aboriginal_Group_EN First_Nations Inuit Metis 
		Canada_Status_EN 
		'Is_Visible_Minority?'n 
		'Is_Disable?'n 
		'Is_Newcomer?'n 
		'Is_Francophone?'n 
		'Is_Deaf_Hearing_Impaired?'n 
		Exit_Reason_EN Exit_Review_Status_EN 
		Exit_Review_Outcome_EN Exit_Satisfaction_EN Exit_Satisfaction_Level_EN 
		'Exit_-Job_Related_to_Training'n */
		/* _3rd_Month_Review_Start_Date 
		_3rd_Month_Scheduled_Start_Date _3rd_Month_Review_End_Date 
		_3rd_Month_Reason_EN _3rd_Month_Review_Status_EN _3rd_Month_Review_Outcome_EN 
		_3rd_Month_Satisfaction_EN _3rd_Month_Satisfaction_Level_EN 
		'_3rd_Month_-Job_Related_to_Train'n _6th_Month_Review_Start_Date 
		_6th_Month_Scheduled_Start_Date _6th_Month_Review_End_Date 
		_6th_Month_Reason_EN _6th_Month_Review_Status_EN _6th_Month_Review_Outcome_EN 
		_6th_Month_Satisfaction_EN _6th_Month_Satisfaction_Level_EN 
		_6th_Month_Closure_Date '_6th_Month_-Job_Related_to_Train'n 
		_12th_Month_Review_Start_Date _12th_Month_Scheduled_Start_Date 
		_12th_Month_Review_End_Date _12th_Month_Reason_EN 
		_12th_Month_Review_Status_EN _12th_Month_Review_Outcome_EN 
		_12th_Month_Satisfaction_EN _12th_Month_Satisfaction_Level_E 
		'_12th_Month_-Job_Related_to_Trai'n */
		 Wage_per_Type_EN NOC_EN 
		'NAICS_Non-Registered_Employment_'n Placement_Category_EN Occupation_Type_EN 
		Employment_Type_EN Reason_For_Leaving_EN Country_EN 
		'Is_Primary_Current?'n 
		Fiscal_Year Region_Name Sub_Region_Name Local_Office_Name 
		Sub_Region_Name__1 
		Education_Level_EN Education_Location_EN Credential_Not_Recognized_EN 
		Employment_Experience_EN Employment_Skills_EN Time_Out_of_School_EN 
		Poor_Work_Retention_EN Job_Search_Skills_EN Source_of_Income_EN 
		Language_Skills_EN Labour_Market_Change_EN Aboriginal_Group_EN_y 
		First_Nations_y Inuit_y Metis_y 'Is_Disable?_y'n Status_EN_y 
		Latest_Closure_Reason_EN Refer_In_EN 
		Created_By Updated_By 'Sds_#'n 
		Active_Job_Search_Score Training_NOC_Code 
		/ plots=(freqplot 
		) missing;
run;	


/**************************************/
/**	      analysis age	   	**/
/**********************************/
ods noproctitle;
ods graphics / imagemap=on;

proc freq data= sc_master1 order = freq;
	table age_group/ plots= (freqplot) missing;
run;

proc means data=WORK.SC_MASTER1 chartype mean std min max median n nmiss mode 
		vardef=df clm alpha=0.05 qmethod=os;		
	  var  Start_Date Registration_Date_x Open_Date 
		Program_Start_Date Program_End_Date Training_NOC_Code 
		Educational_Institute_Id Duration_in_Weeks 
		Registration_Date_y Primary_Address_Id Exit_Closure_Date 
		_12th_Month_Closure_Date Hours_Per_Week_Code Hours_Per_Week Wage_Amount 
		Basic_Living_Allowance_on_Claim Basic_Living_Allowance_not_on_Cl 
		Transportation 'Books_and_Other_Instructio.nl_Co'n Tuition Tuition_ABE 
		Disability_Expenses Dependent_Care Living_Away_From_Home 'Other_(Taxable)'n 
		'Other_(Non-taxable)'n Total_Agreement_Amount Client_Contributions 
		sc_start_date emp_days_ago es_suit_date 
		 Date_Of_Assessment Client_Eligibile Suitability_Score 
		Duration_Of_Unemployment_Score Work_History_Score Lm_Prospects_Score 
		Type_Of_Training_Score 'Exp_Occupatio.nl_Skills_Score'n 
		'Educatio.nl_Attainment_Score'n sc_suit_date age;
run;


proc univariate data=WORK.SC_MASTER1 vardef=df noprint;

	var Start_Date Registration_Date_x Open_Date 
		Program_Start_Date Program_End_Date Training_NOC_Code 
		Educational_Institute_Id Duration_in_Weeks 
		Registration_Date_y Primary_Address_Id Exit_Closure_Date 
		_12th_Month_Closure_Date Hours_Per_Week_Code Hours_Per_Week Wage_Amount 
		Basic_Living_Allowance_on_Claim Basic_Living_Allowance_not_on_Cl 
		Transportation 'Books_and_Other_Instructio.nl_Co'n Tuition Tuition_ABE 
		Disability_Expenses Dependent_Care Living_Away_From_Home 'Other_(Taxable)'n 
		'Other_(Non-taxable)'n Total_Agreement_Amount Client_Contributions 
		sc_start_date emp_days_ago es_suit_date 
		 Date_Of_Assessment Client_Eligibile Suitability_Score 
		Duration_Of_Unemployment_Score Work_History_Score Lm_Prospects_Score 
		Type_Of_Training_Score 'Exp_Occupatio.nl_Skills_Score'n 
		'Educatio.nl_Attainment_Score'n sc_suit_date age;
	histogram Start_Date Registration_Date_x Open_Date 
		Program_Start_Date Program_End_Date Training_NOC_Code 
		Educational_Institute_Id Duration_in_Weeks 
		Registration_Date_y Primary_Address_Id Exit_Closure_Date 
		_12th_Month_Closure_Date Hours_Per_Week_Code Hours_Per_Week Wage_Amount 
		Basic_Living_Allowance_on_Claim Basic_Living_Allowance_not_on_Cl 
		Transportation 'Books_and_Other_Instructio.nl_Co'n Tuition Tuition_ABE 
		Disability_Expenses Dependent_Care Living_Away_From_Home 'Other_(Taxable)'n 
		'Other_(Non-taxable)'n Total_Agreement_Amount Client_Contributions 
		sc_start_date emp_days_ago es_suit_date 
		 Date_Of_Assessment Client_Eligibile Suitability_Score 
		Duration_Of_Unemployment_Score Work_History_Score Lm_Prospects_Score 
		Type_Of_Training_Score 'Exp_Occupatio.nl_Skills_Score'n 
		'Educatio.nl_Attainment_Score'n sc_suit_date age;
run;	

/**********************************/
/* some variables on specific ranges */
/**************************************/
ods noproctitle;
ods graphics / imagemap=on; 
proc freq data= sc_master1 order = freq;
	table age_group/ plots= (freqplot) missing;
run;

proc means data=WORK.SC_MASTER1 chartype mean std min max median n nmiss mode 
		vardef=df clm alpha=0.05 qmethod=os;		
	  var age;
run;

proc univariate data=WORK.SC_MASTER1 vardef=df noprint;

	var age;
	histogram age;
run;

/*************************/
/**   tabulate		**/
/*************************/
proc tabulate data=sc_master1 missing order=freq format=8.2;
	
	class  Product_Type_EN Status_EN 
		Case_Actual_Outcome_EN Closure_Reason_EN Program_Language_EN 
		Full_Time_Status_Code Evidence_Status_EN Preferred_Language_EN 
		Preferred_Communication_Method_E Gender_EN Marital_Status_EN 
		Country_of_Birth_EN Aboriginal_Group_EN First_Nations Inuit Metis 
		Canada_Status_EN 
		'Is_Visible_Minority?'n 
		'Is_Disable?'n 
		'Is_Newcomer?'n 
		'Is_Francophone?'n 
		'Is_Deaf_Hearing_Impaired?'n 
		Exit_Reason_EN Exit_Review_Status_EN 
		Exit_Review_Outcome_EN Exit_Satisfaction_EN Exit_Satisfaction_Level_EN 
		'Exit_-Job_Related_to_Training'n Wage_per_Type_EN NOC_EN 
		'NAICS_Non-Registered_Employment_'n Placement_Category_EN Occupation_Type_EN 
		Employment_Type_EN Reason_For_Leaving_EN Country_EN 
		'Is_Primary_Current?'n 
		Fiscal_Year Region_Name Sub_Region_Name Local_Office_Name 
		Sub_Region_Name__1 
		Education_Level_EN Education_Location_EN Credential_Not_Recognized_EN 
		Employment_Experience_EN Employment_Skills_EN Time_Out_of_School_EN 
		Poor_Work_Retention_EN Job_Search_Skills_EN Source_of_Income_EN 
		Language_Skills_EN Labour_Market_Change_EN Aboriginal_Group_EN_y 
		First_Nations_y Inuit_y Metis_y 'Is_Disable?_y'n Status_EN_y 
		Latest_Closure_Reason_EN Refer_In_EN 
		Created_By Updated_By 'Sds_#'n 
		Active_Job_Search_Score Training_NOC_Code ;
				
	var age  Dependent_Care Living_Away_From_Home ;
	
	table (Marital_Status_EN  all), (Gender_En all)*(n*f=8. colpctn)/rts=10
		box='gender by marital status';
	
	table (Marital_Status_En  all), (Gender_En all)*(n*f=8. rowpctn)/rts=8;
	
	table (Training_NOC_Code all),(Gender_En all)*(n*f=8. colpctn)/rts=10
		box= 'gender by noc code';
		
	table (Gender_En all),(Age*mean*f=8.1)
		/box='average age by gender';

	table (Training_NOC_Code all),(Gender_En all)*(n*f=8. colpctn)/rts=10
		box= 'gender by noc code';
		
	table ('Is_Visible_Minority?'n all),(Gender_En all)*(n*f=8. colpctn)/rts=10
		box= 'visible minority by gender';
		
	table ('Is_Disable?'n  all),(Gender_En all)*(n*f=8. colpctn)/rts=10
		box= 'disable by gender';
		
	table ('Is_Newcomer?'n all),(Gender_En all)*(n*f=8. colpctn)/rts=10
		box= 'newcomer by gender';
		
	table (Exit_Reason_EN all),(Gender_En all)*(n*f=8. colpctn)/rts=10
		box= 'result by gender';
	
	table (Exit_Review_Outcome_EN  all),(Gender_En all)*(n*f=8. colpctn)/rts=10
		box= 'exit reason by gender';
		
		
run;

/***********************************/
/* info on wage and work type */
/***********************************/


proc freq data=sc_master_wage_info  order=freq ;
	
	table /*Training_NOC_Code  NOC_EN*/  previous_work_type   
	       low_income_indicator age_group/plots=(freqplot 
		) missing;;
run;
/**************************************************/
/* dependent care fund, gender and married status */
/**************************************************/
proc tabulate data=sc_master1 missing order=freq format=8.2;
	
	class  Product_Type_EN Status_EN 
		Case_Actual_Outcome_EN Closure_Reason_EN Program_Language_EN 
		Full_Time_Status_Code Evidence_Status_EN Preferred_Language_EN 
		Preferred_Communication_Method_E Gender_EN Marital_Status_EN 
		Country_of_Birth_EN Aboriginal_Group_EN First_Nations Inuit Metis 
		Canada_Status_EN 
		'Is_Visible_Minority?'n 
		'Is_Disable?'n 
		'Is_Newcomer?'n 
		'Is_Francophone?'n 
		'Is_Deaf_Hearing_Impaired?'n 
		Exit_Reason_EN Exit_Review_Status_EN 
		Exit_Review_Outcome_EN Exit_Satisfaction_EN Exit_Satisfaction_Level_EN 
		'Exit_-Job_Related_to_Training'n Wage_per_Type_EN NOC_EN 
		'NAICS_Non-Registered_Employment_'n Placement_Category_EN Occupation_Type_EN 
		Employment_Type_EN Reason_For_Leaving_EN Country_EN 
		'Is_Primary_Current?'n 
		Fiscal_Year Region_Name Sub_Region_Name Local_Office_Name 
		Sub_Region_Name__1 
		Education_Level_EN Education_Location_EN Credential_Not_Recognized_EN 
		Employment_Experience_EN Employment_Skills_EN Time_Out_of_School_EN 
		Poor_Work_Retention_EN Job_Search_Skills_EN Source_of_Income_EN 
		Language_Skills_EN Labour_Market_Change_EN Aboriginal_Group_EN_y 
		First_Nations_y Inuit_y Metis_y 'Is_Disable?_y'n Status_EN_y 
		Latest_Closure_Reason_EN Refer_In_EN 
		Created_By Updated_By 'Sds_#'n 
		Active_Job_Search_Score Training_NOC_Code ;
				
	var age  Dependent_Care Living_Away_From_Home ;
	
	where Dependent_Care ~= .n;
	
	table (Marital_Status_En all),(Gender_En all)*(n*f=8. colpctn)/rts=10;
	
	table (Marital_Status_En  all), (Gender_En all)*(n*f=8. rowpctn)/rts=8;
	
run;
		
		
/*************************************************/
/**		 martirual type & kids   	**/
/*************************************************/
data sc_master_wagef;
	set sc_master_wage_info;
	
	format family_dependent $20.;
	
	family_dependent = .;
	
	if       Marital_Status_En = "Single" and Dependent_Care = .n 
		 then family_dependent = 'single no kids';
	else if  Marital_Status_En = "Single" and Dependent_Care ~= .n
		 then family_dependent = 'single with kids';
	else if  Marital_Status_En = "Married" and Dependent_Care = .n
		 then family_dependent = 'married no kids';
	else if  Marital_Status_En = "Married" and Dependent_Care ~= .n
		 then family_dependent = 'married with kids';
	else     family_dependent = 'others';     
	
run;


proc freq data=sc_master_wagef  order=freq ;
	
	table family_dependent /plots=(freqplot) missing;;
run;