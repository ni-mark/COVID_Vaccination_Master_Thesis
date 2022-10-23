# COVID-Vaccination-Master-Thesis
Master Thesis using message interventions to increase attitudes and intention to get the COVID-19 vaccine

Issue
  Vaccines are effective only when a substantial portion of the polution recieves a vaccination 
  Three Main reasons against vaccination
   1. Personal reasons
   2.  Lack of trust in medical experts and/or government
   3.  General anti-vaccination beliefs 

This study focues on using Messages as a nudge to increase COVID-19 vaccination attidudes and uptake. Messages are tailed to either the standard COVID-19 vaccination or Astra Zenica vaccine. The Astra Zenica vaccine is of interest as at the time was a polarizing vaccine with fears of the blood clotting side effects was spread via media.  
  
1. Literature Review 
There are 4 main interventions/nudges in academic literature to promote vaccination beliefs and uptake
  1. Social norms
   - Using prestigious figures as a representive to the community 
   - Letting a person know what others are doing in their community through verbal or visual cues
  3. Using Defaults to Reduce Barriers 
   - Opt-out strategy of having an appoitment as a defualt, rather than the classic Opt-in strategy
  5. Using Reminders and Commitments
   - Aims to remind patients to make them more likely to commit to an appointment
  7. Message Framing
   - Framing messages with various nudges or information to provide behvioral and/or acutal change (uptake)

2. Survey Design
Survey was designed using Limesurvey, where subjects are randomly placed into 6 groups with either the message being about COVID-19 vaccine or specifically on the AstraZeneca vaccine.
  1. Control group
  2. Gain Frame message
  3. Loss Frame message
  4. Empical Evidence 
  5. Countering Myth message 
  6. Moral message 

In total, there are 10 groups. 

All subject particpated in an intial and identical post treatment survey measuring intent, atttitudes, and encouragement to others for the general Covid-19 vaccine and the AstraZeneca vaccine. 

The sample group was gathered using Amazon Mechicnal Turk (MTurk) and focused on the Indian population. India was of interest as the speak english, use MTurk, reduce cost per a response, and most importantly reccently re-authorized the Astra Zenica vaccine for distrobution at the time of the survey in May 2021. 



3. Data Wrangling/Cleaning
As a survey method was used an Exploratory Factor Analysis (EFA) and a Confirmatory Factor Analysis (CFA) was conducted to control for multicollinarity between the survey responses. 

Total sample of 499 subjects, 45 were incomplete and subsquently removed. 

4. Pre-Processing / Factor analysis 
2 frequence graphs representing the survey responses toward COVID-19 and AstraZenica
![Vaccine Acceptance Response Frequency Graph](https://github.com/nicholas-mai/COVID_Vaccination_Master_Thesis/blob/71d99150fd7af2f308ddf00b8257992b29d1fcf8/covidsurveyfrequencygraph.png)?raw=true)

A t-test was made as a pre-test measure for the question on intent and attitude for each treatment compared to the control. 
 - The empircal treament demostrated a significant increase in attitudes with a p-value of .041. 

3. Modeling
A Tobit regression was first used to measure the increase or decrease in attitudes toward COVID-19 vaccine. Tobit regression was chossen as there are multiple categorical variables tin a between-subject design in the experiment. 

Subsequently an OLS regrssion is made to test the outcomes of the Tobit regression and if they are similar will provide a better interpreation of the coefficients. 

4. Summary of the Main Results
![OLS Regression Results](https://github.com/nicholas-mai/COVID_Vaccination_Master_Thesis/blob/9a25131d1416b16272554bd16aa9635e4219c87a/vaccinationOLSresults.png?raw=true)

Empirical framed message was statisically signitive and effictive, increasing attitudes (final 4 response: benefit, keep getting ill, responsibility, and economy). On average attitude increased by 53% with the empircal message. 

The moral frame treatment had non-significant backfire effect. This is expected as the literature found the same. 

The gain frame treatent had a backfire effect on 1 aspect of attitude toward the AstraZeneca vaccine (keeps them from getting ill). This is expected due to the fears of blood-clotting side effect. 
