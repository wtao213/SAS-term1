/***********************************/
/* import dataset for last result */
/*********************************/

%web_drop_table(WORK.OSAP1617);


FILENAME REFFILE 'C:/Users/TaoWa/Desktop/OSAP-2016-17.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.OSAP1617;
	/*delimiter=',';*/
	GETNAMES=YES;
	/*datarow= 85687;*/
	guessingrows= 700;
RUN;

PROC CONTENTS DATA=WORK.OSAP1617; RUN;


%web_open_table(WORK.OSAP1617);

/*		variable name
	var 'Study.nperiod.nweeks.n(associate'n 'Tuitio.n'n Fees 
		'Books.n&.nEquipme.nt'n '% of full course load'n 
		'Study period weeks (associated w'n 'Age at Study Period Start'n 
		'Number of dependents'n 'Child care costs'n 
		'Student prior year income - line'n RRSPs 'Other assets'n 
		'Scholarships/ awards/ bursaries'n 'Government income - Employment I'n 
		'Government income - WSIB'n 'Government income - ODSP'n 
		'Government income - Ontario Work'n 'Government income - Post-Sec Stu'n 
		'Government income - CPP'n 'Government income - Second Caree'n 
		'Government income - Other'n 'Spouse''s prior year income - lin'n 
		'Parents'' prior year income - lin'n 'Total grant funding issued (CSG'n 
		'Total loan funding issued (COISL'n 'Total OSAP funding issued'n;
	class 'Inst Type'n 'Institution name'n 'Program of study description'n 
		'Level of study'n 'Student status'n 'Living Situation During Study Pe'n;
*/

/*****************************************/
/* changes something in data  */
/*****************************/
data osap_1617;
	set osap1617;
	
	format duration $20.;
	
	duration=.;
	
	If      'Study.nperiod.nweeks.n(associate'n <31 then duration = "< 31 weeks";
	else if 'Study.nperiod.nweeks.n(associate'n <38 then duration = "31-37 weeks";
	else 						     duration = "> 37 weeks";
run;




proc freq data= osap1617 order=freq;
	table 'Inst Type'n 
	      'Institution name'n 
	      'Level of study'n 
	      'Student status'n 
	      'Living Situation During Study Pe'n/
		 missing plots=freqplot;
run;

ods noproctitle;
ods graphics / imagemap=on;


proc means data=osap1617 chartype mean std min max median n nmiss mode 
		vardef=df clm alpha=0.05 qmethod=os;		
	  var  'Study.nperiod.nweeks.n(associate'n 'Tuitio.n'n Fees 
		'Books.n&.nEquipme.nt'n '% of full course load'n 
		'Study period weeks (associated w'n 'Age at Study Period Start'n 
		'Number of dependents'n 'Child care costs'n 
		'Student prior year income - line'n RRSPs 'Other assets'n 
		'Scholarships/ awards/ bursaries'n 'Government income - Employment I'n 
		'Government income - WSIB'n 'Government income - ODSP'n 
		'Government income - Ontario Work'n 'Government income - Post-Sec Stu'n 
		'Government income - CPP'n 'Government income - Second Caree'n 
		'Government income - Other'n 'Spouse''s prior year income - lin'n 
		'Parents'' prior year income - lin'n 'Total grant funding issued (CSG'n 
		'Total loan funding issued (COISL'n 'Total OSAP funding issued'n;

run;


proc univariate data=osap1617 vardef=df noprint;

	var 'Study.nperiod.nweeks.n(associate'n 'Tuitio.n'n Fees 
		'Books.n&.nEquipme.nt'n '% of full course load'n 
		'Study period weeks (associated w'n 'Age at Study Period Start'n 
		'Number of dependents'n 'Child care costs'n 
		'Student prior year income - line'n RRSPs 'Other assets'n 
		'Scholarships/ awards/ bursaries'n 'Government income - Employment I'n 
		'Government income - WSIB'n 'Government income - ODSP'n 
		'Government income - Ontario Work'n 'Government income - Post-Sec Stu'n 
		'Government income - CPP'n 'Government income - Second Caree'n 
		'Government income - Other'n 'Spouse''s prior year income - lin'n 
		'Parents'' prior year income - lin'n 'Total grant funding issued (CSG'n 
		'Total loan funding issued (COISL'n 'Total OSAP funding issued'n;

	histogram 'Study.nperiod.nweeks.n(associate'n 'Tuitio.n'n Fees 
		'Books.n&.nEquipme.nt'n '% of full course load'n 
		'Study period weeks (associated w'n 'Age at Study Period Start'n 
		'Number of dependents'n 'Child care costs'n 
		'Student prior year income - line'n RRSPs 'Other assets'n 
		'Scholarships/ awards/ bursaries'n 'Government income - Employment I'n 
		'Government income - WSIB'n 'Government income - ODSP'n 
		'Government income - Ontario Work'n 'Government income - Post-Sec Stu'n 
		'Government income - CPP'n 'Government income - Second Caree'n 
		'Government income - Other'n 'Spouse''s prior year income - lin'n 
		'Parents'' prior year income - lin'n 'Total grant funding issued (CSG'n 
		'Total loan funding issued (COISL'n 'Total OSAP funding issued'n;

run;


/***************************************************/
/*	tabulate	*/
/**********************************/
proc tabulate data=osap_1617 missing order=freq format=8.2;
	class 'Inst Type'n 
	      'Institution name'n 
	      'Level of study'n 
	      'Student status'n 
	      'Living Situation During Study Pe'n
	      'Number of dependents'n 
	      duration;
	
	var  'Study.nperiod.nweeks.n(associate'n 'Tuitio.n'n Fees 
		'Books.n&.nEquipme.nt'n '% of full course load'n 
		'Study period weeks (associated w'n 'Age at Study Period Start'n 
		/*'Number of dependents'n*/ 'Child care costs'n 
		'Student prior year income - line'n RRSPs 'Other assets'n 
		'Scholarships/ awards/ bursaries'n 'Government income - Employment I'n 
		'Government income - WSIB'n 'Government income - ODSP'n 
		'Government income - Ontario Work'n 'Government income - Post-Sec Stu'n 
		'Government income - CPP'n 'Government income - Second Caree'n 
		'Government income - Other'n 'Spouse''s prior year income - lin'n 
		'Parents'' prior year income - lin'n 'Total grant funding issued (CSG'n 
		'Total loan funding issued (COISL'n 'Total OSAP funding issued'n;
	
	
	/*table (Marital_Status_EN  all), (Gender_En all)*(n*f=8. colpctn)/rts=10
		box='gender by marital status';*/
		
	table ('Inst Type'n  all),(('Tuitio.n'n Fees 'Books.n&.nEquipme.nt'n 'Total grant funding issued (CSG'n 'Total loan funding issued (COISL'n 'Total OSAP funding issued'n) *mean*f=8.1)
		/box='average by inst type';
		
	table ('Student status'n  all),(('Tuitio.n'n Fees 'Books.n&.nEquipme.nt'n 'Total grant funding issued (CSG'n 'Total loan funding issued (COISL'n 'Total OSAP funding issued'n) *mean*f=8.1)
		/box='average age by gender';
	
	table ('Level of study'n   all),(('Tuitio.n'n Fees 'Books.n&.nEquipme.nt'n 'Total grant funding issued (CSG'n 'Total loan funding issued (COISL'n 'Total OSAP funding issued'n) *mean*f=8.1)
		/box='average age by gender';
		
	table ('Number of dependents'n   all),(('Tuitio.n'n Fees 'Books.n&.nEquipme.nt'n 'Total grant funding issued (CSG'n 'Total loan funding issued (COISL'n 'Total OSAP funding issued'n) *mean*f=8.1)
		/box='average age by gender';
			
	table (duration  all),(('Tuitio.n'n Fees 'Books.n&.nEquipme.nt'n 'Total grant funding issued (CSG'n 'Total loan funding issued (COISL'n 'Total OSAP funding issued'n) *mean*f=8.1)
		/box='average by inst type';
		
		
	table ('Inst Type'n*'Student status'n all),(('Tuitio.n'n Fees 'Books.n&.nEquipme.nt'n 'Total grant funding issued (CSG'n 'Total loan funding issued (COISL'n 'Total OSAP funding issued'n) *mean*f=8.1)
		/box='average age by gender';
		
	table ('Inst Type'n*'Level of study'n all),(('Tuitio.n'n Fees 'Books.n&.nEquipme.nt'n 'Total grant funding issued (CSG'n 'Total loan funding issued (COISL'n 'Total OSAP funding issued'n) *mean*f=8.1)
		/box='average age by gender';
		
	table ('Inst Type'n*'Number of dependents'n   all),(('Tuitio.n'n Fees 'Books.n&.nEquipme.nt'n 'Total grant funding issued (CSG'n 'Total loan funding issued (COISL'n 'Total OSAP funding issued'n) *mean*f=8.1)
		/box='average age by gender';
		
	table ('Student status'n*'Level of study'n  all),(('Tuitio.n'n Fees 'Books.n&.nEquipme.nt'n 'Total grant funding issued (CSG'n 'Total loan funding issued (COISL'n 'Total OSAP funding issued'n) *mean*f=8.1)
		/box='average age by gender';
		
	table ('Student status'n*'Number of dependents'n  all),(('Tuitio.n'n Fees 'Books.n&.nEquipme.nt'n 'Total grant funding issued (CSG'n 'Total loan funding issued (COISL'n 'Total OSAP funding issued'n) *mean*f=8.1)
		/box='average age by gender';
run;	

proc glm data= osap_1617;
	class 'Inst Type'n 
	      'Institution name'n 
	      'Level of study'n 
	      'Student status'n 
	      'Living Situation During Study Pe'n
	      'Number of dependents'n 
	      duration;
	model 'Total OSAP funding issued'n = 'Inst Type'n  'Institution name'n 
	      'Level of study'n  'Student status'n 'Spouse''s prior year income - lin'n 
	      'Living Situation During Study Pe'n 'Number of dependents'n 
	      'Study.nperiod.nweeks.n(associate'n 'Tuitio.n'n Fees 
		'Books.n&.nEquipme.nt'n '% of full course load'n 
		'Study period weeks (associated w'n 'Age at Study Period Start'n 
		'Number of dependents'n 'Child care costs'n 
		'Student prior year income - line'n RRSPs 'Other assets'n 
		'Scholarships/ awards/ bursaries'n 'Government income - Employment I'n 
		'Government income - WSIB'n 'Government income - ODSP'n 
		'Government income - Ontario Work'n 'Government income - Post-Sec Stu'n 
		'Government income - CPP'n 'Government income - Second Caree'n 
		'Government income - Other'n 'Spouse''s prior year income - lin'n 
		'Parents'' prior year income - lin'n 
	      duration/ss1 ss3 solution ;
run;
/***********************************/
/* import dataset for EI info */
/*********************************/

%web_drop_table(WORK.EO_info);


FILENAME REFFILE 'C:/Users/TaoWa/Desktop/EO-info.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.EO_info;
	/*delimiter=',';*/
	GETNAMES=YES;
	/*datarow= 85687;*/
	guessingrows= 700;
RUN;

PROC CONTENTS DATA=WORK.EO_info; RUN;


%web_open_table(WORK.EO_info);

/* var name
var EI_Rate EI_Rate2 EI_Rate3 'Employment_Insurance_Benefits_-_'n 
		Gross_Monthly_Employment_Income Gross_Monthly_Employment_Income2 
		Gross_Monthly_Employment_Income_ VAR9 Number_of_People_in_Household 
		Other_Sources_of_Income Other_Sources_of_Income2 
		'Other_Sources_of_Income_-_Spouse'n Total_Monthly_Income_in_Training 
		Estimated_prior_annual_income PDC_No 'Rent__Mortgage_(incl_tax)_or_Roo'n 
		Person_Id Training_NOC_Code Duration_in_Weeks Reference_Number Date_of_Birth 
		Date_of_Death Canada_Arrival_Date 'Exit_-_Satisfaction_Level_(En)'n 
		'Exit_-_Closure_Date'n '_3rd_Month_-_Satisfaction_Level_'n 
		'_6th_Month_-_Satisfaction_Level_'n '_12th_Month_-_Satisfaction_Level'n 
		From_Date To_Date Hours_Per_Week Wage_Amount 'Is_Primary_Current?'n 
		Basic_Living_Allowance_on_Claim Basic_Living_Allowance_not_on_Cl 
		Transportation Books_and_Other_Instructional_Co Tuition Tuition_ABE 
		Disability_Expenses Dependent_Care Living_Away_From_Home 'Other_(Taxable)'n 
		'Other_(Non-taxable)'n Total_Agreement_Amount Client_Contributions 
		ES_Case_Reference Client_Eligibile Suitability_Score Active_Job_Search_Score 
		Duration_Of_Unemployment_Score Work_History_Score Lm_Prospects_Score 
		Type_Of_Training_Score Exp_Occupational_Skills_Score 
		Educational_Attainment_Score;
	class 'Spousal_Income?'n 'Product_Type_(En)'n 'Status_(En)'n 
		'Case_Actual_Outcome_(En)'n 'Closure_Reason_(En)'n Program_Name 
		'Program_Language_(En)'n Full_Time_Status_Code 'Preferred_Language_(En)'n 
		'Gender_(En)'n 'Marital_Status_(En)'n 'Country_of_Birth_(En)'n 
		'Aboriginal_Group_(En)'n First_Nations Inuit Metis 'Canada_Status_(En)'n 
		Deaf_Blind_Ind 'Is_Visible_Minority?'n 'Is_Disable?'n 'Is_Newcomer?'n 
		'Is_Francophone?'n 'Is_Deaf_Hearing_Impaired?'n 'Exit_-_Review_Outcome_(En)'n 
		'Exit_-_Satisfaction_(En)'n 'Exit_-Job_Related_to_Training'n 
		'_3rd_Month_-_Review_Outcome_(En)'n '_3rd_Month_-_Satisfaction_(En)'n 
		'_3rd_Month_-Job_Related_to_Train'n '_6th_Month_-_Review_Outcome_(En)'n 
		'_6th_Month_-_Satisfaction_(En)'n '_6th_Month_-Job_Related_to_Train'n 
		'_12th_Month_-_Review_Outcome_(En'n '_12th_Month_-_Satisfaction_(En)'n 
		'_12th_Month_-Job_Related_to_Trai'n Job_Title 'Wage_per_Type_(En)'n 
		'NOC_(En)'n 'NAICS_-_Non-Registered_Employmen'n 'Placement_Category_(En)'n 
		'Reason_For_Leaving_(En)'n 'Country_(En)'n Fiscal_Year Region_Name 
		Sub_Region_Name Local_Office_Name Service_Provider_Name SDS_Reference_Number 
		SDS_Name 'Sub_Goal_Name_(En)'n Person_City Person_Postal_Code 
		'Education_Level_(En)'n 'Education_Location_(En)'n 
		'Credential_Not_Recognized_(En)'n 'Employment_Experience_(En)'n 
		'Employment_Skills_(En)'n 'Time_Out_of_School_(En)'n 
		'Poor_Work_Retention_(En)'n 'Job_Search_Skills_(En)'n 
		'Source_of_Income_(En)'n 'Language_Skills_(En)'n 'Labour_Market_Change_(En)'n 
		'Refer_In_(En)'n Owner_Full_Name
		*/
		
proc univariate data=EO_info vardef=df noprint;
	var Gross_Monthly_Employment_Income_;
	histogram Gross_Monthly_Employment_Income_;
run;

data eo_info1;
	set EO_info;
	
	format spouse_income_group $20.;
	
	spouse_income_group =.;
	
	If       Gross_Monthly_Employment_Income_ < 1500 then spouse_income_group = "<1500";
	else if  Gross_Monthly_Employment_Income_ < 2500 then spouse_income_group = "1500-2499";
	else if  Gross_Monthly_Employment_Income_ < 3500 then spouse_income_group = "2500-3499";
	else if  Gross_Monthly_Employment_Income_ < 4500 then spouse_income_group = "3500-4499";
	else if  Gross_Monthly_Employment_Income_ < 5500 then spouse_income_group = "4500-5499";
	else 						      spouse_income_group = ">5500";
run;
	
proc freq data=eo_info1  order=freq;
	where Number_of_People_in_Household >0 and Number_of_People_in_Household <10;
	table spouse_income_group Number_of_People_in_Household Fiscal_Year 'Education_Level_(En)'n/ missing plots=freqplot;
run; 
ods output close;


proc tabulate data=eo_info1 missing f=8.2;
	class spouse_income_group Number_of_People_in_Household ;
	table (Number_of_People_in_Household all),(spouse_income_group all)*n*f=8. /;
run;

ods noproctitle;
ods graphics / imagemap=on;

proc sgplot data= EO_info ;
	where Number_of_People_in_Household >1 and Number_of_People_in_Household <10;
	VBAR Number_of_People_in_Household /group=spouse_income_group ;
run;
	
