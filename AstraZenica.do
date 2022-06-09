gen covid_attitude = covid_benefitgreaterthanrisk+ covid_keepmefromgettingill+ covid_responsibility+ covid_economy
gen covid_attitude_all = covid_benefitgreaterthanrisk+ covid_keepmefromgettingill+ covid_responsibility+ covid_economy+ covid_family+ covid_friend
gen az_attitude = az_benefitgreaterthanrisk+ az_keepmefromgettingill+ az_responsibility+ az_economy
gen az_attitude_all = az_benefitgreaterthanrisk+ az_keepmefromgettingill+ az_responsibility+ az_economy+ az_family+ az_friend

gen cl = treatment==1
gen t1 = treatment==6
gen t2 = treatment==2
gen t3 = treatment==3
gen t4 = treatment==4
gen t5 = treatment==5

encode education, generate(edu)
gen sex1 = sex==

corr covid_intent covid_available
corr covid_benefitgreaterthanrisk covid_keepmefromgettingill covid_responsibility covid_economy
corr covid_benefitgreaterthanrisk covid_keepmefromgettingill covid_responsibility covid_economy covid_family covid_friend
corr covid_family covid_friend

factor covid_benefitgreaterthanrisk covid_keepmefromgettingill covid_responsibility covid_economy
factor covid_benefitgreaterthanrisk covid_keepmefromgettingill covid_responsibility covid_economy covid_family covid_friend

// random draw a sample for EFA
gen halfdraw = uniform() < .5
tab halfdraw

//Principal Component Analysis and Factor Analysis from youtube
global xlist covid_intent covid_available covid_benefitgreaterthanrisk covid_keepmefromgettingill covid_responsibility covid_economy covid_family covid_friend
global id treatment 
global ncomp 1

describe $xlist
summarize $xlist
corr $xlist

pca $xlist // PCA

screeplot  // Scree plot of the eigenvalues
screeplot, yline(1)

pca $xlist, minigen(1) // PCA
pca $xlist, comp($ncomp)
pca $xlist, comp($ncomp) blanks(.3)

rotate, varimax //component rotations
rotate, varimax blanks(.3)
rotate, clear

loadingplot //scatter plot of the loadings and score variables
scoreplot
scoreplot, mlabel($id)

estat loadings //loadings/scores of the components 
predict pc1 pc2 pc3, score

estat kmo // kmo measure of sampling adequacy 

//factor analysis
factor $xlist 

screeplot
screeplot, yline(1)
factor $xlist, minigen(1)
factor, factor($nocomp)
factor, factor($nocomp) blanks(0.3)

rotate, varimax
rotate, varimax blanks(.3)
rotate, clear

rotate, promax
rotate promax blanks(.3)
rotate, clear

estat common

loadingplot
scoreplot

predict f1 f2 f3 f4 f5 f6 f7 f8

estat kmo 
alpha $xlist

// use factor loadings on excel, i have 1 factor loaded for oblique rotation (oblimin) 
// having one factor is good because I have the difference just between intent and belief
// 


//Kaiser–Meyer–Olkin measure of sampling adequacy(KMO test)
factor covid_intent covid_available covid_benefitgreaterthanrisk covid_keepmefromgettingill covid_responsibility covid_economy covid_family covid_friend, pcf
estat kmo 
scree
rotate, orthogonal varimax blanks(.5)
rotate, promax(4) blanks(.5)

factor covid_intent covid_available covid_benefitgreaterthanrisk covid_keepmefromgettingill covid_responsibility covid_economy covid_family covid_friend, mineigen(1.2)


//Bartlett test of sphercity 
oneway covid_intent treatment, t
oneway covid_available treatment, t
oneway covid_family treatment, t
oneway covid_friend treatment, t
oneway covid_benefitgreaterthanrisk treatment, t
oneway covid_keepmefromgettingill treatment, t
oneway covid_responsibility treatment, t
oneway covid_economy treatment, t
oneway covid_attitude treatment, t
oneway covid_attitude_all treatment, t

// bartlet test of sphercity - this is what I need for my EFA came out statistically significant 
ssc install factortest
factortest covid_intent covid_available covid_benefitgreaterthanrisk covid_keepmefromgettingill covid_responsibility covid_economy covid_family covid_friend

// eigen values states that there is 1 factor, but the efa shows that there are 2 latent variables which my items load on to. covid_availble item did load on any factor, thus, it can be removed from the scale 

//CFA - continous variables 
sem (covid_family covid_friend covid_benefitgreaterthanrisk covid_keepmefromgettingill covid_responsibility covid_economy <- covid_intent), method(ml) standardized
estat eqgof
estat gof, stats(all)

sem (covid_benefitgreaterthanrisk covid_keepmefromgettingill covid_responsibility covid_economy <- covid_intent), method(ml) standardized
estat eqgof
estat gof, stats(all)

sem (covid_family covid_friend covid_benefitgreaterthanrisk covid_keepmefromgettingill covid_responsibility covid_economy <- covid_attitude), method(ml) standardized
estat eqgof
estat gof, stats(all)

sem (covid_intent<- covid_intent), method(ml) standardized //covid intent can not be measured on itself 
estat eqgof
estat gof, stats(all)
// CFA should be above .9, i got .69 not good results redo later

//histogram of variables by treatment group

histogram covid_intent , frequency by( treatment ) gap(10) xlabel(1 2 3 4 5 6 7 8 9 10, valuelabel) scheme(s1omo)
histogram az_intent , frequency by( treatment ) gap(10) xlabel(1 2 3 4 5 6 7 8 9 10, valuelabel) scheme(s1mono)
ttest covidattitude , by(cl) unequal
di (exp(coef)-1)*100 //code suppsoed to give percent change

tobit covid_intent age sex1 edu i.treatment, ul(10) ll(1) cluster(day)
reg covid_intent age sex1 edu i.treatment, cluster(day)

//Regression - FIGURE OUT HOW TO DO INTERACTION TERM

gen covidattitudesnorm = 1 if covidattitude <=2 
replace covidattitudesnorm = 2 if covidattitude>2 & covidattitude <= 4 
replace covidattitudesnorm = 3 if covidattitude>4 & covidattitude <= 6 
replace covidattitudesnorm = 4 if covidattitude>6 & covidattitude <= 8 
replace covidattitudesnorm = 5 if covidattitude>8 & covidattitude <= 10 

gen covidffnorm = 1 if covidff <=2 
replace covidffnorm = 2 if covidff>2 & covidff <= 4 
replace covidffnorm = 3 if covidff>4 & covidff <= 6 
replace covidffnorm = 4 if covidff>6 & covidff <= 8 
replace covidffnorm = 5 if covidff>8 & covidff <= 10 


tobit covid_intent sex1 age edu i.treatment, ul(10) ll(1)
tobit covid_intent age edu sex1 i.treatment# covidattitudesnorm, ul(10) ll(1)
tobit covidattitudesnorm sex1 age edu i.treatment, ul(10) ll(1)

tobit covid_intent sex1 age edu 

////
tobit covid_intent sex age edu i.treatment, ul(10) ll(1)
tobit covid_intent age edu sex i.treatment covidattitude, ul(10) ll(1)
tobit covid_intent age edu sex i.treatment covidattitudesnorm, ul(10) ll(1)
tobit covid_intent age edu sex i.treatment i.covidattitudesnorm, ul(10) ll(1)
tobit covid_intent age edu sex i.treatment#covidattitudesnorm, ul(10) ll(1)
tobit covidattitudesnorm sex age edu i.treatment, ul(5) ll(1)

reg covid_intent sex age edu i.treatment
reg covid_intent age edu sex i.treatment covidattitude
reg covid_intent age edu sex i.treatment covidattitudesnorm
reg covid_intent age edu sex i.treatment i.covidattitudesnorm
reg covid_intent age edu sex i.treatment#covidattitudesnorm
reg covidattitudesnorm sex age edu i.treatment

// factoral specification of A##B = A B A#B
tobit covid_intent age edu sex treatment##covidattitudesnorm, ul(10) ll(1)
reg covid_intent age edu sex treatment##covidattitudesnorm


tobit covid_intent sex1 edu age i.treatment covid_benefitgreaterthanrisk covid_keepmefromgettingill covid_responsibility covid_economy covid_family covid_friend, ul(10) ll(1)

// Interact continous variables by putting c. command before variable -> defiently show Rustam
tobit covid_intent age edu sex treatment#c.covidattitude, ul(10) ll(1)
tobit covid_intent age edu sex treatment##c.covidattitude, ul(10) ll(1)
reg covid_intent age edu sex treatment#c.covidattitude
reg covid_intent age edu sex treatment##c.covidattitude

tobit covid_intent age edu sex treatment#c.covidattitudesnorm, ul(10) ll(1)
tobit covid_intent age edu sex treatment##c.covidattitudesnorm, ul(10) ll(1)
reg covid_intent age edu sex treatment#c.covidattitudesnorm
reg covid_intent age edu sex treatment##c.covidattitudesnorm


/////////////////////////////////////////////////////////////////////////////

// Astra Zeneca analysis 
corr az_intent az_available
corr az_benefitgreaterthanrisk az_keepmefromgettingill az_responsibility az_economy
corr az_benefitgreaterthanrisk az_keepmefromgettingill az_responsibility az_economy az_family az_friend
corr az_family az_friend

factor az_benefitgreaterthanrisk az_keepmefromgettingill az_responsibility az_economy
factor az_benefitgreaterthanrisk az_keepmefromgettingill az_responsibility az_economy az_family az_friend

// random draw a sample for EFA
gen halfdraw = uniform() < .5
tab halfdraw

//Principal Component Analysis and Factor Analysis from youtube
global xlist az_intent az_available az_benefitgreaterthanrisk az_keepmefromgettingill az_responsibility az_economy az_family az_friend
global id treatment 
global ncomp 1

describe $xlist
summarize $xlist
corr $xlist

pca $xlist // PCA

screeplot  // Scree plot of the eigenvalues
screeplot, yline(1)

pca $xlist, minigen(1) // PCA
pca $xlist, comp($ncomp)
pca $xlist, comp($ncomp) blanks(.3)

rotate, varimax //component rotations
rotate, varimax blanks(.3)
rotate, clear

loadingplot //scatter plot of the loadings and score variables - only one retained, thus, is dropped
scoreplot
scoreplot, mlabel($id)

estat loadings //loadings/scores of the components 
predict pc1 pc2 pc3, score

estat kmo // kmo measure of sampling adequacy 

//factor analysis
factor $xlist 

screeplot
screeplot, yline(1)
factor $xlist, minigen(1)
factor, factor($nocomp)
factor, factor($nocomp) blanks(0.3)

rotate, varimax
rotate, varimax blanks(.3)
rotate, clear

rotate, promax
rotate promax blanks(.3)
rotate, clear

estat common

loadingplot
scoreplot

predict f1 f2 f3 f4 f5 f6 f7 f8

estat kmo 
alpha $xlist

// use factor loadings on excel, i have 1 factor loaded for oblique rotation (oblimin) 
// having one factor is good because I have the difference just between intent and belief
// 


//Kaiser–Meyer–Olkin measure of sampling adequacy(KMO test)
factor az_intent az_available az_benefitgreaterthanrisk az_keepmefromgettingill az_responsibility az_economy az_family az_friend, pcf
estat kmo 
scree
rotate, orthogonal varimax blanks(.5)
rotate, promax(4) blanks(.5)

factor az_intent az_available az_benefitgreaterthanrisk az_keepmefromgettingill az_responsibility az_economy az_family az_friend, mineigen(1.2)


//Bartlett test of sphercity 
oneway az_intent treatment, t
oneway az_available treatment, t
oneway az_family treatment, t
oneway az_friend treatment, t
oneway az_benefitgreaterthanrisk treatment, t
oneway az_keepmefromgettingill treatment, t
oneway az_responsibility treatment, t
oneway az_economy treatment, t
oneway az_attitude treatment, t
oneway az_attitude_all treatment, t

// bartlet test of sphercity - this is what I need for my EFA came out statistically significant 
ssc install factortest
factortest az_intent az_available az_benefitgreaterthanrisk az_keepmefromgettingill az_responsibility az_economy az_family az_friend

// eigen values states that there is 1 factor, but the efa shows that there are 2 latent variables which my items load on to. covid_availble item did load on any factor, thus, it can be removed from the scale 

//CFA - continous variables 
sem (az_family az_friend az_benefitgreaterthanrisk az_keepmefromgettingill az_responsibility az_economy <- az_intent), method(ml) standardized
estat eqgof
estat gof, stats(all)
// CFA should be above .9, i got .69 not good results redo later


//Regression - FIGURE OUT HOW TO DO INTERACTION TERM
gen azattitude = az_attitude/4
gen azff = (az_family + az_friend)/2

gen azattitudesnorm = 1 if azattitude <=2 
replace azattitudesnorm = 2 if azattitude>2 & azattitude <= 4 
replace azattitudesnorm = 3 if azattitude>4 & azattitude <= 6 
replace azattitudesnorm = 4 if azattitude>6 & azattitude <= 8 
replace azattitudesnorm = 5 if azattitude>8 & azattitude <= 10 

gen azffnorm = 1 if azff <=2 
replace azffnorm = 2 if azff>2 & azff <= 4 
replace azffnorm = 3 if azff>4 & azff <= 6 
replace azffnorm = 4 if azff>6 & azff <= 8 
replace azffnorm = 5 if azff>8 & azff <= 10 


tobit az_intent sex age edu i.treatment, ul(10) ll(1)
tobit az_intent age edu sex i.treatment azattitude, ul(10) ll(1)
tobit az_intent age edu sex i.treatment azattitudesnorm, ul(10) ll(1)
tobit az_intent age edu sex i.treatment i.azattitudesnorm, ul(10) ll(1)
tobit az_intent age edu sex i.treatment#azattitudesnorm, ul(10) ll(1)
tobit azattitudesnorm sex age edu i.treatment, ul(5) ll(1)

tobit azintent sex age edu i.treatment, ul(10) ll(1)
tobit azintent age edu sex i.treatment azattitude, ul(10) ll(1)
tobit azintent age edu sex i.treatment azattitudesnorm, ul(10) ll(1)
tobit azintent age edu sex i.treatment i.azattitudesnorm, ul(10) ll(1)
tobit azintent age edu sex i.treatment#azattitudesnorm, ul(10) ll(1)
tobit azattitudesnorm sex age edu i.treatment, ul(5) ll(1)


reg az_intent sex age edu i.treatment
reg az_intent age edu sex i.treatment azattitude
reg az_intent age edu sex i.treatment azattitudesnorm
reg az_intent age edu sex i.treatment i.azattitudesnorm
reg az_intent age edu i.sex i.treatment i.azattitudesnorm
reg az_intent age edu sex i.treatment#azattitudesnorm
reg azattitudesnorm sex age edu i.treatment

// factoral specification of A##B = A B A#B
tobit az_intent age edu sex treatment##azattitudesnorm, ul(10) ll(1)
reg az_intent age edu sex treatment##azattitudesnorm

tobit azintent age edu sex treatment##azattitudesnorm, ul(10) ll(1)
reg azintent age edu sex treatment##azattitudesnorm

// Interact continous variables by putting c. command before variable -> defiently show Rustam
tobit az_intent age edu sex treatment#c.azattitude, ul(10) ll(1)
tobit az_intent age edu sex treatment##c.azattitude, ul(10) ll(1)
reg az_intent age edu sex treatment#c.azattitude
reg az_intent age edu sex treatment##c.azattitude

tobit az_intent age edu sex azff treatment#c.azattitude, ul(10) ll(1)

tobit az_intent age edu sex i.treatment az_friend az_family az_benefitgreaterthanrisk az_keepmefromgettingill az_responsibility az_economy, ul(10) ll(1)

tobit az_intent age edu sex treatment##c.azattitude, ul(10) ll(1)
reg az_intent age edu sex treatment#c.azattitude
reg az_intent age edu sex treatment##c.azattitude

tobit azintent age edu sex treatment#c.azattitudesnorm, ul(10) ll(1)
tobit azintent age edu sex treatment##c.azattitudesnorm, ul(10) ll(1)
reg azintent age edu sex treatment#c.azattitudesnorm
reg azintent age edu sex treatment##c.azattitudesnorm


/////////////////////////////////////////////

//Final EFA and CFA code 




/////////////////////////////////////////////

// First Try 
tab treatment_group
corr COVID_Intent COVID_Available AZ_Intent AZ_Available COVID_BenefitRisk COVID_Avoid_ill COVID_Responsibility COVID_Economy COVID_Family COVID_Friend AZ_BenefitRisk AZ_Avoid_ill AZ_Responsibility AZ_Economy AZ_Family AZ_Friend
corr COVID_Available AZ_Available
corr COVID_Intent AZ_Intent COVID_BenefitRisk COVID_Avoid_ill COVID_Responsibility COVID_Economy COVID_Family COVID_Friend AZ_Avoid_ill AZ_Responsibility AZ_Economy AZ_Family AZ_Friend
corr COVID_Intent AZ_Intent
corr COVID_BenefitRisk COVID_Avoid_ill COVID_Responsibility COVID_Economy AZ_BenefitRisk AZ_Avoid_ill AZ_Responsibility AZ_Economy
corr COVID_Family COVID_Friend AZ_Family AZ_Friend


// Intent, COVID_Intent is a 10 pt scale and COVID_available is 4 point scale
alpha COVID_Intent COVID_Available 
alpha COVID_Intent AZ_Intent 
alpha COVID_Available AZ_Available 
alpha COVID_Intent AZ_Intent COVID_Available AZ_Available, item 
// Attitudes, all are on a 10 pt scale
alpha COVID_Family COVID_Friend AZ_Family AZ_Friend, item
alpha COVID_Family COVID_Friend
alpha COVID_BenefitRisk COVID_Avoid_ill COVID_Responsibility COVID_Economy AZ_BenefitRisk AZ_Avoid_ill AZ_Responsibility AZ_Economy, item 
alpha AZ_BenefitRisk AZ_Avoid_ill AZ_Responsibility AZ_Economy, item 
alpha COVID_BenefitRisk COVID_Avoid_ill COVID_Responsibility COVID_Economy, item 

//getting errors for the first 4 "more than 2 groups found"?
ttest COVID_Available, by (COVID_Intent) unequal
ttest COVID_Available, by (AZ_Intent) unequal
ttest AZ_Available, by (COVID_Intent) unequal
ttest AZ_Available, by (AZ_Intent) unequal

ttest COVID_Available==AZ_Available 
ttest COVID_Intent == AZ_Intent 

ttest COVID_Attitudes== AZ_Attitudes
ttest COVID_Family==COVID_Friend
ttest AZ_Family==AZ_Friend
ttest COVID_Family==AZ_Family 
ttest AZ_Friend==COVID_Friend
ttest COVID_Attitudes== AZ_Family 
ttest COVID_Attitudes== AZ_Friend
ttest AZ_Attitudes== AZ_Family 
ttest AZ_Attitudes== AZ_Friend
ttest COVID_Attitudes== COVID_Family 
ttest COVID_Attitudes== COVID_Friend
ttest AZ_Attitudes== COVID_Family 
ttest AZ_Attitudes== COVID_Friend

ttest COVID_Attitudes== COVID_Intent
ttest AZ_Attitudes== COVID_Intent
ttest COVID_Attitudes== AZ_Intent
ttest AZ_Attitudes== AZ_Intent

ttest COVID_Family== COVID_Intent
ttest AZ_Family== COVID_Intent
ttest COVID_Family== AZ_Intent
ttest AZ_Family== AZ_Intent
ttest COVID_Friend== COVID_Intent
ttest AZ_Friend== COVID_Intent
ttest COVID_Friend== AZ_Intent
ttest AZ_Friend== AZ_Intent


sum COVID_Intent COVID_Available AZ_Intent AZ_Available
sum COVID_BenefitRisk COVID_Avoid_ill COVID_Responsibility COVID_Economy COVID_Family COVID_Friend AZ_
Family AZ_Friend AZ_BenefitRisk AZ_Avoid_ill AZ_Responsibility AZ_Economy

histogram COVID_Attitudes, normal bin(10) xline(800)
graph matrix COVID_Attitudes AZ_Attitudes COVID_Family COVID_Friend AZ_Family AZ_Friend COVID_Available AZ_Available, half jitter(2)
graph matrix COVID_Attitudes AZ_Attitudes COVID_Family COVID_Friend AZ_Family AZ_Friend, half jitter(2)

tobit COVID_Intent i.treatment gender_code age education2, ul(10)
tobit AZ_Intent i.treatment gender_code age education2, ul(10)
tobit COVID_Available i.treatment gender_code age education2, ul(73)
tobit AZ_Available i.treatment gender_code age education2, ul(73)


tobit COVID_Attitudes i.treatment gender_code age education2, ul(10)
tobit AZ_Attitudes i.treatment gender_code age education2, ul(10)
tobit COVID_Family i.treatment gender_code age education2, ul(73)
tobit COVID_Friend i.treatment gender_code age education2, ul(73)
tobit AZ_Family i.treatment gender_code age education2, ul(73)
tobit AZ_Friend i.treatment gender_code age education2, ul(73)
