clear all

import excel "${data_path}/raw/RY2010 62F0032X Income Quintile_Rev.xls", ///
	cellrange(A10:Q437) sheet("B.C. - C.-B.") clear 
	
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

gen inc_quint = _n-1

gen N_households = "" 

local vars F H J L N P

forvalues i = 0/5 {
    local v : word `=`i'+1' of `vars'
    replace N_households = `v'[4] if inc_quint == `i'
}


levelsof A in 49/67, local(names)

foreach name of local names {
    local clean = strtoname("`name'")
    gen E`clean' = ""
}