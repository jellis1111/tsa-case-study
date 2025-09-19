*******************************;
/* Section: Accessing Data */
*******************************;

libname TSA '/home/u59936471/ECRB94/data';

options validvarname=V7;

proc import datafile="/home/u59936471/ECRB94/data/TSAClaims2002_2017.csv"
    out=TSA.TSAClaims2002_2017
    dbms=csv
    replace;
    guessingrows=max;
run;

*******************************;
/* Section: Exploring Data */
*******************************;

/* 1. Preview the data */
proc print data=TSA.TSAClaims2002_2017(obs=20);
run;

/* 2. Explore columns */
proc freq data=TSA.TSAClaims2002_2017;
    tables Claim_Site Disposition Claim_Type / missing;
run;

proc means data=TSA.TSAClaims2002_2017 n nmiss min max;
    var Date_Received Incident_Date;
run;

*******************************;
/* Section: Preparing Data */
*******************************;

/* Remove duplicates and sort by Incident_Date */
proc sort data=TSA.TSAClaims2002_2017
          out=work.TSAClaims_cleaned
          nodupkey;
    by Claim_Number;
run;

proc sort data=work.TSAClaims_cleaned;
    by Incident_Date;
run;

/* Clean columns, fix state, create Date_Issues, add labels and formats */
data work.TSAClaims_prepared;
    set work.TSAClaims_cleaned;

    /* Clean Claim_Site, Disposition, Claim_Type */
    if missing(Claim_Site) or Claim_Site in ('', ' ') then Claim_Site='Unknown';
    if missing(Disposition) or Disposition in ('', ' ') then Disposition='Unknown';
    if missing(Claim_Type) or Claim_Type in ('', ' ') then Claim_Type='Unknown';

    /* State and StateName */
    State = upcase(State);
    StateName = propcase(StateName);

    /* Date issues */
    Date_Issues = '';
    if missing(Incident_Date) or missing(Date_Received) then Date_Issues='Needs Review';
    else if year(Incident_Date) < 2002 or year(Incident_Date) > 2017 then Date_Issues='Needs Review';
    else if Incident_Date > Date_Received then Date_Issues='Needs Review';

    /* Labels */
    label Claim_Number="Claim Number"
          Date_Received="Date Received"
          Incident_Date="Incident Date"
          Claim_Site="Claim Site"
          Disposition="Disposition"
          Claim_Type="Claim Type"
          Close_Amount="Close Amount"
          State="State"
          StateName="State Name"
          Date_Issues="Date Issues";

    /* Formats */
    format Date_Received Incident_Date mmddyy10.;
    format Close_Amount dollar12.2;

    /* Exclude County and City */
    drop County City;
run;

/* Create Incident_Year variable */
data work.TSAClaims_prepared2;
    set work.TSAClaims_prepared;
    Incident_Year = year(Incident_Date);
run;

*******************************;
/* Section: Analyzing Data */
*******************************;

/* Overall data - Claims per year (frequency table) */
title "Number of Claims per Year";
proc freq data=work.TSAClaims_prepared2;
    tables Incident_Year / nocum;
run;

/* Overall data - Claims per year (frequency plot) */
proc sgplot data=work.TSAClaims_prepared2;
    vbar Incident_Year / datalabel;
    title "Frequency of Claims per Year (2002–2017)";
    xaxis label="Incident Year";
    yaxis label="Number of Claims";
run;

/* State-level analysis - Claim_Type, Claim_Site, Disposition */
title "Claim_Type, Claim_Site, and Disposition Frequencies for &state_selected";
proc freq data=work.TSAClaims_prepared2;
    where StateName="&state_selected" and Date_Issues='';
    tables Claim_Type Claim_Site Disposition / missing;
run;

/* State-level analysis - Close_Amount summary */
title "Close_Amount Summary for &state_selected";
proc means data=work.TSAClaims_prepared2 n mean min max sum maxdec=0;
    where StateName="&state_selected" and Date_Issues='';
    var Close_Amount;
run;

*******************************;
/* Section: Exporting Reports */
*******************************;

ods pdf file="/home/u59936471/ECRB94/ClaimReports.pdf" style=Journal;

ods noproctitle;

/* Date Issues Frequency Table */
ods proclabel "Date Issues Frequency";
proc freq data=work.TSAClaims_prepared2;
    tables Date_Issues / missing;
run;

/* Claims per Year Table */
ods proclabel "Claims per Year";
proc freq data=work.TSAClaims_prepared2;
    tables Incident_Year / nocum;
run;

/* Claims per Year Frequency Plot */
ods proclabel "Claims per Year Frequency Plot";
proc sgplot data=work.TSAClaims_prepared2;
    vbar Incident_Year / datalabel;
    title "Frequency of Claims per Year (2002–2017)";
    xaxis label="Incident Year";
    yaxis label="Number of Claims";
run;

/* State-Level Frequencies */
ods proclabel "State-Level Frequencies for &state_selected";
proc freq data=work.TSAClaims_prepared2;
    where StateName="&state_selected" and Date_Issues='';
    tables Claim_Type Claim_Site Disposition / missing;
run;

/* State-Level Close_Amount Summary */
ods proclabel "State-Level Close_Amount Summary for &state_selected";
proc means data=work.TSAClaims_prepared2 n mean min max sum maxdec=0;
    where StateName="&state_selected" and Date_Issues='';
    var Close_Amount;
run;

ods pdf close;

************************************************************;

