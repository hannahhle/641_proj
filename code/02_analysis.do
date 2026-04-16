clear all

use "${data_path}/clean/shs_all.dta", clear
drop if prov == 0
drop if prov == .
drop if prov == .a
drop urb_type
drop if urb_size == 0

{
levelsof prov, local(provs)

gen inc_quint = .

foreach p of local provs {
    xtile temp = income if prov == `p', nq(5)
    replace inc_quint = temp if prov == `p'
    drop temp
}

collapse (mean) income wfelec nat_gas other_fuel consump expenditure ///
	[aw=weight], by(inc_quint prov urb_size year)
 
sort prov year inc_quint
}

/*
{
// income by year bc
preserve

keep if prov == 59
collapse (mean) income, by(year urb_size inc_quint)

twoway ///
(connected income year if inc_quint == 1, sort) ///
(connected income year if inc_quint == 2, sort) ///
(connected income year if inc_quint == 3, sort) ///
(connected income year if inc_quint == 4, sort) ///
(connected income year if inc_quint == 5, sort), ///
by(urb_size) ///
title("BC") ///
legend( ///
label(1 "Q1") ///
label(2 "Q2") ///
label(3 "Q3") ///
label(4 "Q4") ///
label(5 "Q5") ///
)

restore

// income by year bc
preserve

keep if prov == 59
collapse (mean) consump, by(year urb_size inc_quint)

twoway ///
(connected consump year if inc_quint == 1, sort) ///
(connected consump year if inc_quint == 2, sort) ///
(connected consump year if inc_quint == 3, sort) ///
(connected consump year if inc_quint == 4, sort) ///
(connected consump year if inc_quint == 5, sort), ///
by(urb_size) ///
title("BC") ///
legend( ///
label(1 "Q1") ///
label(2 "Q2") ///
label(3 "Q3") ///
label(4 "Q4") ///
label(5 "Q5") ///
)

restore
}
*/

drop if urb_size != 1
keep if inlist(prov, 59, 10, 12, 13, 35, 47)
gen event_time = year - 2008
gen treated = (prov == 59)

gen event_time_n = event_time + 3

preserve

forvalues q = 1/5 {
    reghdfe consump ib2.event_time_n##i.treated if inc_quint == `q', ///
        absorb(year) vce(robust)
    estimates store q`q'
}

coefplot ///
(q5, keep(*.event_time_n#1.treated)), ///
coeflabels( ///
    0.event_time_n#1.treated = "-3" ///
    1.event_time_n#1.treated = "-2" ///
    2.event_time_n#1.treated = "-1" ///
	3.event_time_n#1.treated = "0" ///
    4.event_time_n#1.treated = "1" ///
) ///
vertical ///
yline(0) xline(3) ///
baselevels omitted ///
title("Consumption: BC vs other (Q4)")
graph export "${figures_path}/q1_triple.png", replace

restore