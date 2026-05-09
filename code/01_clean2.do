local sheets `" "NFLD-TN et Lab" "P.E.I. - Î.-P.-É." "N.S. - N.-É." "N.B. - N.-B." "Que. - Qc" "Ontario " "Manitoba" "Saskatchewan" "Alberta" "B.C. - C.-B." "'

local provs 10 11 12 13 24 35 46 47 48 59

tempfile all
local first = 1

forvalues s = 1/10 {
    
    local sheet : word `s' of `sheets'
    local prov  : word `s' of `provs'

    import excel "${data_path}/raw/RY2010 62F0032X Income Quintile_Rev.xls", ///
        cellrange(A10:Q437) sheet("`sheet'") clear

    drop C D E
drop in 2/3
drop in 4/5
drop in 7/8
drop in 9/10
drop in 15
drop in 20
drop in 23/24
drop in 32/36

drop G I K M O Q

drop in 35/71
drop in 40/176
drop in 41/237

drop in 27/31
drop in 28

drop in 4/26

drop in 7/9
drop in 7/8

gen inc_quint = _n-1

gen N_households = "" 

local vars F H J L N P

forvalues i = 0/5 {
    local v : word `=`i'+1' of `vars'
    replace N_households = `v'[2] if inc_quint == `i'
}


levelsof A in 4/6, local(names)

foreach name of local names {
    local clean = strtoname("`name'")
    gen str23 E`clean' = ""
}

local row = 4

foreach name of local names {
    local clean = strtoname("`name'")

    forvalues i = 0/5 {
        local v : word `=`i'+1' of `vars'
        replace E`clean' = `v'[`row'] if inc_quint == `i'
    }
	local row = `row' + 1

}

//////////

rename E_10100_23150 expenditure
rename E_10140_22310 consump
rename E_14210_14270 wfelec

drop A B F H J L N P


    gen year = 2010
    gen prov = `prov'

    if `first' {
        save `all', replace
        local first = 0
    }
    else {
        append using `all'
        save `all', replace
    }
}


use `all', clear

label define provlbl ///
10 "Newfoundland and Labrador" ///
11 "Prince Edward Island" ///
12 "Nova Scotia" ///
13 "New Brunswick" ///
24 "Quebec" ///
35 "Ontario" ///
46 "Manitoba" ///
47 "Saskatchewan" ///
48 "Alberta" ///
59 "British Columbia"

label values prov provlbl
destring expenditure consump wfelec, replace
save "${temp_path}/shs2010", replace

use"${data_path}/clean/shs_all.dta", clear

append using "${temp_path}/shs2010.dta"
erase "${temp_path}/shs2010.dta"

save "${data_path}/shs_all_final.dta", replace