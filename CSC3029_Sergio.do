********************************************************************************
************************CSC3029 PROJECT STUDENTS DO FILE************************
********************************************************************************

*1. USEFUL COMMANDS - run these before running the rest of the script
set pformat %5.2e
set maxvar 20000
 

*2. READ IN THE DATA

use "/slade/local/UKBB_students/UKB_Unrelated_Eur_MedSci.dta"

*3. MERGE IN ANY RELEVANT FILES
merge 1:1 n_eid  using "/slade/local/UKBB/cook_archive/mnt/Data10/UKBioBank/Phenotype_data/Mental_health/Jess_O_PhD/UKB_GP_records/UKB_GPdep_TRD_SAIGE.dta"
drop _merge
merge 1:1 n_eid using "/slade/local/UKBB/cook_archive/mnt/Data1/UKBiobank/IV_analysis/grs/alcohol_grs.dta"
keep if valid_BGENIE==1 

merge 1:1 n_eid using "/slade/local/UKBB_students/sergio_snps_diet.dta"
keep if valid_BGENIE==1 

*3. Create and RENAME AND TABULATE THE OUTCOME VARIABLES
rename dep_diagnosis_qc_2 GP_record_MDD
tab TRD
tab GP_record_MDD
tab dep_no_trd


*c) Depression diagnoses
*Depressed ever is equivalent to screening for cases on the CIDI
generate Depressed_Ever=.
replace Depressed_Ever=0 if CIDI_MDD_No_Info==0
replace Depressed_Ever=0 if CIDI_MDD_Screen==0 & PHQ9_Severity<5 & PHQ9_Severity!=. & SRDepression==0 & InterviewDepression==0
replace Depressed_Ever=1 if CIDI_MDD_Screen==1 & CIDI_MDD_Response>4 & CIDI_MDD_Response!=.


tab GAD_Ever
tab Depressed_Ever


*4. DEMOGRAPHICS - COMPARISON OF CASES AND CONTROLS

*A. CONTINUOUS DEMOGRAPHIC SUMMARY
*Legacy
bysort Depressed_Ever: sum age_base alcohol bf brown_bread caffeinated_coffee carbs carotene cereal cig_per_day coffee_cups decaf_coffee energy fat fibre ffq_ca folate fresh_fruit healthy_diet iron lfp limb_fat mg n_dep_ep pcarbs pfat pprotein protein prudent_diet retinol sat_fat sedentary_time starch sugars tea_intake tfp unsat_fat veg_intake vitB12 vitB6 vitC vitD vitE water_intake western_diet white_bread whole_grain_cereal whr yoghurt depression_grs n_22407_2_0 n_22408_2_0 n_22402_2_0 n_30660_0_0 n_30680_0_0 n_30690_0_0 n_30700_0_0 n_30710_0_0 n_30760_0_0 n_30770_0_0 n_30780_0_0 n_30810_0_0 n_30840_0_0 n_30850_0_0 n_30860_0_0 n_30870_0_0 n_30890_0_0

/* Add other continuous variables to the list

*B. BINARY DEMOGRAPHIC SUMMARY
*/


foreach var of varlist sex acr bike_to_work bin_age_veg bin_get_up bin_job bin_sleep breast_fed diet_change depressed_week disinterest_week employed excess_alcohol father_depression fe ffq_veggie ffq_vegan final_depression gain_weight_yr gluten_free hypertension insuff_ex insuff_veg insulin lactose_free laxatives live_rural look_after_home lost_weight_yr mineral_use morbid_obese morning_person mother_depression night_work no_dairy no_eggs no_sugar no_sun no_wheat obese omeprazole oversleeper paracetamol parent_depression parents_depression preterm_birth pub_social_club ranitidine religious_club retired sdep_major se seen_GP seen_psychiatrist sports_club stomach_pain undersleeper vegan vegetarian vitamin_use voluntary_work walk_to_work zn any_coeliac any_depression any_crohns ca coeliac diabetes glucosamine high_cholesterol incident_depression single_major_dep gain_wt_yr_female lost_wt_yr_female gain_wt_yr_male lost_wt_yr_male male_depression SRDepression SRBingeEating SRBulimiaNervosa SRGADandOthers SRAnorexiaNervosa SREatingDisorderAny SRAnxietyAny InterviewDepression DrugDepression_Combined {
tab Depressed_Ever `var', miss col
}

foreach var of varlist sex acr bike_to_work bin_age_veg bin_get_up bin_job bin_sleep breast_fed diet_change depressed_week disinterest_week employed excess_alcohol father_depression fe ffq_veggie ffq_vegan final_depression gain_weight_yr gluten_free hypertension insuff_ex insuff_veg insulin lactose_free laxatives live_rural look_after_home lost_weight_yr mineral_use morbid_obese morning_person mother_depression night_work no_dairy no_eggs no_sugar no_sun no_wheat obese omeprazole oversleeper paracetamol parent_depression parents_depression preterm_birth pub_social_club ranitidine religious_club retired sdep_major se seen_GP seen_psychiatrist sports_club stomach_pain undersleeper vegan vegetarian vitamin_use voluntary_work walk_to_work zn any_coeliac any_depression any_crohns ca coeliac diabetes glucosamine high_cholesterol incident_depression single_major_dep gain_wt_yr_female lost_wt_yr_female gain_wt_yr_male lost_wt_yr_male male_depression SRDepression SRBingeEating SRBulimiaNervosa SRGADandOthers SRAnorexiaNervosa SREatingDisorderAny SRAnxietyAny InterviewDepression DrugDepression_Combined {
tab Depressed_Ever `var', miss row
}


/* Add other binary variables to the foreach list and also try adding chi2 after either col or row

*C. ORDINAL VARIABLES
*/
foreach var of varlist smoker alc_freq {
tab Depressed_Ever `var', miss col
}
foreach var of varlist alc_freq diet_variation fizzy_drink fried_chicken fried_food_intake fried_pots full_fat_yog low_calorie_drink low_fat_yog salt_consumption {
tab Depressed_Ever `var', miss row


*D. CATEGORICAL VARIABLES
foreach var of varlist freq_dep_2wk_ord {
tab Depressed_Ever `var', miss col
}

*E. IS THE DEMOGRAPHIC VARIABLE ASSOCIATED WITH OUTCOME? HERE WE USE LOGISTIC REGRESSION
*for binary threshold variables

*source: https://www.legislation.gov.uk/eur/2011/1169/annex/XIII/data.pdf
*really buried, ridiculous how complicated it was to find these

generate bin_sugar = .
replace bin_sugar = 0 if sugars < 90 & sugars != . 
replace bin_sugar = 1 if sugars >= 90 & sugars != . 

generate bin_carbs = .
replace bin_carbs = 0 if carbs < 260 & carbs != . 
replace bin_carbs = 1 if carbs >= 260 & carbs != . 

generate bin_protein = .
replace bin_protein = 0 if protein < 50 & protein != . 
replace bin_protein = 1 if protein >= 50 & protein != . 

generate bin_fat = .
replace bin_fat = 0 if fat < 70 & fat != . 
replace bin_fat = 1 if fat >= 70 & fat != . 


*tab to look at range of values, biobank to look at unit


*for any n-tile ranges, 4 for quartiles, 10 for deciles, etc
xtile dec_sugar = sugar, nq(10)
xtile dec_carbs = pcarbs, nq(10)
xtile dec_protein = pprotein, nq(10)
xtile dec_fat = pfat, nq(10)


foreach var of varlist bin_sugar bin_carbs bin_protein bin_fat {
logistic Depressed_Ever `var' age_base sex bmi_2016 income_raw parent_depression
*logit Depressed_Ever `var' age_base sex
}

foreach var of varlist dec_carbs dec_fat dec_protein dec_sugar {
logistic Depressed_Ever i.`var' age_base sex bmi_2016 income_raw parent_depression
*logit Depressed_Ever `var' age_base sex
}




*carb snps
foreach var of varlist rs10206338 rs10510554  rs10433500  rs7012637 rs9987289 rs10962121 rs2472297 rs7190396  rs1104608 rs36123991  rs8097672  rs429358  rs838144 {
regress sugars `var' age_base sex pc1-pc5 i.chip
regress pcarbs `var' age_base sex pc1-pc5 i.chip
regress pprotein `var' age_base sex pc1-pc5 i.chip
regress pfat `var' age_base sex pc1-pc5 i.chip
*do all descriptive variables for each snp set
}

*fat snps
foreach var of varlist rs1229984  rs57193069 rs7012814  rs9927317 rs429358  rs33988101 {
regress sugars `var' age_base sex pc1-pc5 i.chip
regress pcarbs `var' age_base sex pc1-pc5 i.chip
regress pprotein `var' age_base sex pc1-pc5 i.chip
regress pfat `var' age_base sex pc1-pc5 i.chip
*do all descriptive variables for each snp set
}

*lactose snps
foreach var of varlist rs4988235 {
logistic lactose_free `var' 
regress pprotein  `var' 
*do all descriptive variables for each snp set
}

*protein snps rs780094 not found?
foreach var of varlist rs445551 rs1603978 rs13146907 rs1461729 rs55872725 rs838133  {
regress sugars `var' age_base sex pc1-pc5 i.chip
regress pcarbs `var' age_base sex pc1-pc5 i.chip
regress pprotein `var' age_base sex pc1-pc5 i.chip
regress pfat `var' age_base sex pc1-pc5 i.chip
*do all descriptive variables for each snp set
}

*sugar snps
foreach var of varlist rs12713415 rs7619139 rs13202107 rs7012814  rs9972653 rs8097672  rs341228 rs429358  rs838144  rs62132802 {
regress sugars `var' age_base sex pc1-pc5 i.chip
regress pcarbs `var' age_base sex pc1-pc5 i.chip
regress pprotein `var' age_base sex pc1-pc5 i.chip
regress pfat `var' age_base sex pc1-pc5 i.chip
*do all descriptive variables for each snp set
}



*protein rs780094 missing
regress pprotein rs445551 rs1603978 rs13146907 rs1461729 rs55872725 rs838133 pc1-pc5 i.chip age_base sex
predict protien_g_val if e(sample), xb
predict protein_g_resid if e(sample), resid
logit Depressed_Ever protien_g_val protein_g_resid sex age_base pc1-pc5 i.chip i.centre, vce(robust)
// drop g*

*carbs
regress pcarbs rs10206338 rs10510554  rs10433500  rs7012637 rs9987289 rs10962121 rs2472297 rs7190396  rs1104608 rs36123991  rs8097672  rs429358  rs838144 pc1-pc5 i.chip age_base sex
predict carbs_g_val if e(sample), xb
predict carbs_g_resid if e(sample), resid
logit Depressed_Ever carbs_g_val carbs_g_resid sex age_base pc1-pc5 i.chip i.centre, vce(robust)
// drop g*

*fat
regress pfat rs1229984  rs57193069 rs7012814  rs9927317 rs429358  rs33988101 pc1-pc5 i.chip age_base sex
predict fat_g_val if e(sample), xb
predict fat_g_resid if e(sample), resid
logit Depressed_Ever fat_g_val fat_g_resid sex age_base pc1-pc5 i.chip i.centre, vce(robust)
// drop g*

*sugar
regress sugars rs12713415 rs7619139 rs13202107 rs7012814  rs9972653 rs8097672  rs341228 rs429358  rs838144  rs62132802 pc1-pc5 i.chip age_base sex
predict sugar_g_val if e(sample), xb
predict sugar_g_resid if e(sample), resid
logit Depressed_Ever sugar_g_val sugar_g_resid sex age_base pc1-pc5 i.chip i.centre, vce(robust)
// drop g*







logistic lactose_free rs4988235 pc1-pc5 i.chip age_base sex
predict lact_g_val if e(sample), xb
predict lact_g_resid if e(sample), resid
logit Depressed_Ever lact_g_val lact_g_resid sex age_base pc1-pc5 i.chip i.centre, vce(robust)

*old version
foreach var of varlist alcohol bf brown_bread caffeinated_coffee carotene cereal coffee_cups decaf_coffee energy fibre ffq_ca folate fresh_fruit healthy_diet iron mg pcarbs pfat pprotein prudent_diet retinol sat_fat starch sugars tea_intake unsat_fat veg_intake vitB12 vitB6 vitC vitD vitE water_intake western_diet white_bread whole_grain_cereal whr yoghurt depression_grs n_30780_0_0 n_30870_0_0 tdi bin_age_veg diet_change employed excess_alcohol fe ffq_veggie ffq_vegan gain_weight_yr gluten_free hypertension insuff_ex insuff_veg insulin lactose_free lost_weight_yr mineral_use no_dairy no_eggs no_sugar no_sun no_wheat obese parent_depression parents_depression se stomach_pain vegan vegetarian vitamin_use zn any_coeliac any_crohns ca coeliac t2d_no_t1d glucosamine high_cholesterol SRBingeEating SRBulimiaNervosa SRAnorexiaNervosa SREatingDisorderAny {
logistic Depressed_Ever `var' age_base sex
*logit Depressed_Ever `var' age_base sex
}

foreach var of varlist age_base bmi_2016 sbp sex obese income_raw {
logistic TRD `var' age_base sex
logit TRD `var' age_base sex
}
foreach var of varlist age_base bmi_2016 sbp sex obese income_raw {
*ologit mdd_trd_status `var' age_base sex
ologit mdd_trd_status `var' age_base sex, or
}

*WHAT ABOUT CATEGORICAL VARIABLES?
foreach var of varlist smoker {
logistic Depressed_Ever i.`var' age_base sex
*logit Depressed_Ever i.`var' age_base sex
}

foreach var of varlist smoker {
logistic TRD i.`var' age_base sex
logit TRD i.`var' age_base sex
}

*5. OBSERVATIONAL ASSOCIATIONS
*A. Alcohol to TRD/MDD
*First look at the alcohol metrics:
foreach var of varlist excess_alcohol alcohol_units alc_freq Alcohol_Use_Disorder Alcohol_Dependence* {
	sum `var'
}
*How many are binary, continuous, categorical?
hist alcohol_units
*look at relationship with TRD and MDD
foreach var of varlist excess_alcohol alcohol_units alc_freq Alcohol_Use_Disorder Alcohol_Dependence* {
logistic TRD `var' age_base sex
logit TRD `var' age_base sex	
}

*B. DIET and MDD/Anxiety
foreach var of varlist healthy_diet prudent_diet western_diet pcarbs pfat pprotein energy {
	sum `var'
	hist `var'
}

foreach var of varlist healthy_diet prudent_diet western_diet pcarbs pfat pprotein energy {
logistic Depressed_Ever `var' age_base sex bmi_2016 tdi smoker if sex==0
* also without and with ==1, for men

*logit Depressed_Ever `var' age_base sex
}


*SAVE SECTION

*Open Save
log using /slade/home/sq227/pvals.log

*RUN COMMANDS YOU WANT TO OUTPUT

*SAVE TO LOG FILE
log close


