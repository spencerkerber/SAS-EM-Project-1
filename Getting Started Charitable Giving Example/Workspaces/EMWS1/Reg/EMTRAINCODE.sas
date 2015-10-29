*------------------------------------------------------------*;
* Reg: Create decision matrix;
*------------------------------------------------------------*;
data WORK.TARGET_B;
  length   TARGET_B                         $  32
           COUNT                                8
           DATAPRIOR                            8
           TRAINPRIOR                           8
           DECPRIOR                             8
           DECISION1                            8
           DECISION2                            8
           ;

  label    COUNT="Level Counts"
           DATAPRIOR="Data Proportions"
           TRAINPRIOR="Training Proportions"
           DECPRIOR="Decision Priors"
           DECISION1="1"
           DECISION2="0"
           ;
  format   COUNT 10.
           ;
TARGET_B="1"; COUNT=4843; DATAPRIOR=0.25; TRAINPRIOR=0.25; DECPRIOR=0.05; DECISION1=14.5; DECISION2=0;
output;
TARGET_B="0"; COUNT=14529; DATAPRIOR=0.75; TRAINPRIOR=0.75; DECPRIOR=0.95; DECISION1=-0.5; DECISION2=0;
output;
;
run;
proc datasets lib=work nolist;
modify TARGET_B(type=PROFIT label=TARGET_B);
label DECISION1= '1';
label DECISION2= '0';
run;
quit;
data EM_DMREG / view=EM_DMREG;
set EMWS1.Trans_TRAIN(keep=
CARD_PROM_12 CLUSTER_CODE FILE_CARD_GIFT FREQUENCY_STATUS_97NK HOME_OWNER
IMP_DONOR_AGE IMP_INCOME_GROUP IMP_MONTHS_SINCE_LAST_PROM_RESP IMP_REP_SES
IMP_REP_URBANICITY IMP_WEALTH_RATING IN_HOUSE LG10_FILE_AVG_GIFT
LG10_LAST_GIFT_AMT LG10_LIFETIME_AVG_GIFT_AMT LG10_LIFETIME_GIFT_AMOUNT
LIFETIME_GIFT_RANGE LIFETIME_MAX_GIFT_AMT LIFETIME_MIN_GIFT_AMT LIFETIME_PROM
MONTHS_SINCE_FIRST_GIFT MONTHS_SINCE_LAST_GIFT MONTHS_SINCE_ORIGIN MOR_HIT_RATE
NUMBER_PROM_12 OPT_LIFETIME_CARD_PROM OPT_LIFETIME_GIFT_COUNT
OPT_MEDIAN_HOME_VALUE OPT_MEDIAN_HOUSEHOLD_INCOME OPT_PER_CAPITA_INCOME
OPT_RECENT_RESPONSE_PROP OPT_RECENT_STAR_STATUS OVERLAY_SOURCE PCT_ATTRIBUTE1
PCT_ATTRIBUTE2 PCT_ATTRIBUTE3 PCT_ATTRIBUTE4 PCT_OWNER_OCCUPIED PEP_STAR
PUBLISHED_PHONE RECENCY_STATUS_96NK RECENT_AVG_CARD_GIFT_AMT
RECENT_AVG_GIFT_AMT RECENT_CARD_RESPONSE_COUNT RECENT_CARD_RESPONSE_PROP
RECENT_RESPONSE_COUNT REP_DONOR_GENDER TARGET_B );
run;
*------------------------------------------------------------* ;
* Reg: DMDBClass Macro ;
*------------------------------------------------------------* ;
%macro DMDBClass;
    CARD_PROM_12(ASC) CLUSTER_CODE(ASC) FREQUENCY_STATUS_97NK(ASC) HOME_OWNER(ASC)
   IMP_INCOME_GROUP(ASC) IMP_REP_SES(ASC) IMP_REP_URBANICITY(ASC)
   IMP_WEALTH_RATING(ASC) IN_HOUSE(ASC) OPT_LIFETIME_CARD_PROM(ASC)
   OPT_LIFETIME_GIFT_COUNT(ASC) OPT_MEDIAN_HOME_VALUE(ASC)
   OPT_MEDIAN_HOUSEHOLD_INCOME(ASC) OPT_PER_CAPITA_INCOME(ASC)
   OPT_RECENT_RESPONSE_PROP(ASC) OPT_RECENT_STAR_STATUS(ASC) OVERLAY_SOURCE(ASC)
   PEP_STAR(ASC) PUBLISHED_PHONE(ASC) RECENCY_STATUS_96NK(ASC)
   RECENT_CARD_RESPONSE_COUNT(ASC) RECENT_RESPONSE_COUNT(ASC)
   REP_DONOR_GENDER(ASC) TARGET_B(DESC)
%mend DMDBClass;
*------------------------------------------------------------* ;
* Reg: DMDBVar Macro ;
*------------------------------------------------------------* ;
%macro DMDBVar;
    FILE_CARD_GIFT IMP_DONOR_AGE IMP_MONTHS_SINCE_LAST_PROM_RESP
   LG10_FILE_AVG_GIFT LG10_LAST_GIFT_AMT LG10_LIFETIME_AVG_GIFT_AMT
   LG10_LIFETIME_GIFT_AMOUNT LIFETIME_GIFT_RANGE LIFETIME_MAX_GIFT_AMT
   LIFETIME_MIN_GIFT_AMT LIFETIME_PROM MONTHS_SINCE_FIRST_GIFT
   MONTHS_SINCE_LAST_GIFT MONTHS_SINCE_ORIGIN MOR_HIT_RATE NUMBER_PROM_12
   PCT_ATTRIBUTE1 PCT_ATTRIBUTE2 PCT_ATTRIBUTE3 PCT_ATTRIBUTE4 PCT_OWNER_OCCUPIED
   RECENT_AVG_CARD_GIFT_AMT RECENT_AVG_GIFT_AMT RECENT_CARD_RESPONSE_PROP
%mend DMDBVar;
*------------------------------------------------------------*;
* Reg: Create DMDB;
*------------------------------------------------------------*;
proc dmdb batch data=WORK.EM_DMREG
dmdbcat=WORK.Reg_DMDB
maxlevel = 513
;
class %DMDBClass;
var %DMDBVar;
target
TARGET_B
;
run;
quit;
*------------------------------------------------------------*;
* Reg: Run DMREG procedure;
*------------------------------------------------------------*;
proc dmreg data=EM_DMREG dmdbcat=WORK.Reg_DMDB
validata = EMWS1.Trans_VALIDATE
outest = EMWS1.Reg_EMESTIMATE
outterms = EMWS1.Reg_OUTTERMS
outmap= EMWS1.Reg_MAPDS namelen=200
;
class
TARGET_B
CARD_PROM_12
CLUSTER_CODE
FREQUENCY_STATUS_97NK
HOME_OWNER
IMP_INCOME_GROUP
IMP_REP_SES
IMP_REP_URBANICITY
IMP_WEALTH_RATING
IN_HOUSE
OPT_LIFETIME_CARD_PROM
OPT_LIFETIME_GIFT_COUNT
OPT_MEDIAN_HOME_VALUE
OPT_MEDIAN_HOUSEHOLD_INCOME
OPT_PER_CAPITA_INCOME
OPT_RECENT_RESPONSE_PROP
OPT_RECENT_STAR_STATUS
OVERLAY_SOURCE
PEP_STAR
PUBLISHED_PHONE
RECENCY_STATUS_96NK
RECENT_CARD_RESPONSE_COUNT
RECENT_RESPONSE_COUNT
REP_DONOR_GENDER
;
model TARGET_B =
CARD_PROM_12
CLUSTER_CODE
FILE_CARD_GIFT
FREQUENCY_STATUS_97NK
HOME_OWNER
IMP_DONOR_AGE
IMP_INCOME_GROUP
IMP_MONTHS_SINCE_LAST_PROM_RESP
IMP_REP_SES
IMP_REP_URBANICITY
IMP_WEALTH_RATING
IN_HOUSE
LG10_FILE_AVG_GIFT
LG10_LAST_GIFT_AMT
LG10_LIFETIME_AVG_GIFT_AMT
LG10_LIFETIME_GIFT_AMOUNT
LIFETIME_GIFT_RANGE
LIFETIME_MAX_GIFT_AMT
LIFETIME_MIN_GIFT_AMT
LIFETIME_PROM
MONTHS_SINCE_FIRST_GIFT
MONTHS_SINCE_LAST_GIFT
MONTHS_SINCE_ORIGIN
MOR_HIT_RATE
NUMBER_PROM_12
OPT_LIFETIME_CARD_PROM
OPT_LIFETIME_GIFT_COUNT
OPT_MEDIAN_HOME_VALUE
OPT_MEDIAN_HOUSEHOLD_INCOME
OPT_PER_CAPITA_INCOME
OPT_RECENT_RESPONSE_PROP
OPT_RECENT_STAR_STATUS
OVERLAY_SOURCE
PCT_ATTRIBUTE1
PCT_ATTRIBUTE2
PCT_ATTRIBUTE3
PCT_ATTRIBUTE4
PCT_OWNER_OCCUPIED
PEP_STAR
PUBLISHED_PHONE
RECENCY_STATUS_96NK
RECENT_AVG_CARD_GIFT_AMT
RECENT_AVG_GIFT_AMT
RECENT_CARD_RESPONSE_COUNT
RECENT_CARD_RESPONSE_PROP
RECENT_RESPONSE_COUNT
REP_DONOR_GENDER
/error=binomial link=LOGIT
coding=DEVIATION
nodesignprint
selection=STEPWISE choose=VDECDATA
Hierarchy=CLASS
Rule=NONE
;
;
decision decdata=WORK.TARGET_B
decvars=
DECISION1
DECISION2
priorVar=DECPRIOR
;
code file="C:\Users\sakerb01\Desktop\SAS EM 12.3 Tutorials _ Projects\Getting Started Charitable Giving Example\Workspaces\EMWS1\Reg\EMPUBLISHSCORE.sas"
group=Reg
;
code file="C:\Users\sakerb01\Desktop\SAS EM 12.3 Tutorials _ Projects\Getting Started Charitable Giving Example\Workspaces\EMWS1\Reg\EMFLOWSCORE.sas"
group=Reg
residual
;
run;
quit;