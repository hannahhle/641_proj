clear all

import excel "${data_path}/raw/RY2010 62F0032X Income Quintile_Rev.xls", ///
	cellrange(A10:Q437) sheet("B.C. - C.-B.") clear 
	
drop C D E


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