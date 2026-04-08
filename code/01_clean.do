clear all

foreach yr of numlist 2005(1)2009 {
	use "${data_path}/raw/shs-62M0004-E-`yr'_F1.dta", clear
	
	// DROPPING PART TIME HOUSEHOLDS
	if inlist(`yr', 2005, 2009) { 
		destring FYPYFLAG, replace force
		drop if FYPYFLAG == 2 // drop part-time households
	}
	
	else {
		if `yr' != 2008 {
			drop if FYFLAG == .
		}
		else {
			drop if fypyflag == .
		}
		
	}
	
	// RENAMING VARS
	cap rename provincp PROVINCP
    cap rename f001 F001
    cap rename g019 G019
    cap rename g021 G021
    cap rename g023 G023
    cap rename k001 K001
    cap rename weight WEIGHT
    cap rename urbrur URBRUR
    cap rename PCRUR URBRUR
	cap rename urbsizep URBSIZEP
    cap rename PCSIZEP URBSIZEP
    cap rename totexpen TOTEXPEN
    cap rename totcucon TOTCUCON
	cap rename hhinctot HHINCTOT
	

    // rename consistently
	rename PROVINCP prov
    rename F001 food_total
    rename G019 wfelec
    rename G021 nat_gas
    rename G023 other_fuel
    rename K001 transportation
    rename WEIGHT weight
    rename URBRUR urb_type
    rename URBSIZEP urb_size
    rename TOTEXPEN expenditure
    rename TOTCUCON consump
	rename HHINCTOT income
	
	gen year = `yr'

	destring prov wfelec nat_gas other_fuel weight urb_type urb_size expenditure year consump income, replace force
	
	keep prov wfelec nat_gas other_fuel weight urb_type urb_size expenditure year consump income

	tempfile shs`yr'
	save "${temp_path}/shs`yr'"
}

use "${data_path}/raw/shs-62M0004-E-2005_F1.dta", clear

foreach yr of numlist 2006(1)2009 {
	append using "${temp_path}/shs`yr'.dta"
	erase "${temp_path}/shs`yr'.dta"
}

save "${data_path}/clean/shs_all.dta", replace