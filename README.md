Predicting breast cancer within 3 years of a negative mammography
=============

<img src="https://img.shields.io/badge/Study%20Status-Complete-orange.svg" alt="Study Status: Complete">

- Analytics use case(s): **Patient-Level Prediction**
- Study type: **Clinical Application**
- Tags: **-**
- Study lead: **Maura Beaton, Jill Hardin, Kristin Kostka, Anna Ostropolets, Jenna Reps, Erica Voss**
- Study lead forums tag: **[MauraBeaton](https://forums.ohdsi.org/u/maurabeaton), [Jill_Hardin](https://forums.ohdsi.org/u/jill_hardin) , [krfeeney](https://forums.ohdsi.org/u/krfeeney), [aostropolets](https://forums.ohdsi.org/u/aostropolets),  [jreps](https://forums.ohdsi.org/u/jreps) , [ericaVoss](https://forums.ohdsi.org/u/ericavoss) **
- Study start date: **Aug 9, 2019**
- Study end date: **Sep 16, 2019**
- Protocol: **[Protocol](https://github.com/ohdsi-studies/BreastCancerBetweenScreen/blob/master/documents/protocolWoo2019.docx)**
- Publications: **-**
- Results explorer: **[Shiny App](https://data.ohdsi.org/WoO2019/)**

This study aims to explore whether we can use observational health data to predict which women will develop breat cancer between mammography screenings.

Model Summary
===============
- Target Name: **Screen - Mammography**
- Target Size: **3649198**
- Outcome Name: **Cancer - Breast**
- Outcome Count: **15399 (0.4%)**
- Time-at-risk: **3-years**
- Database: **CCAE (US cLaims)**
- Model Type: **Lasso Logistic Regression**
- Covariates: **Age Group, Gender, Condition/Drug groups**
- AUROC: **0.62**
- AUPRC: **0.007**
- PPV @ 1% sensitivity: **-**
- PPV @ 10% sensitivity: **1**
- PPV @ 50% sensitivity: **0.6**
- Calibration Gradient: **1.00**
- Calibration Intercept: **0.00**
- Atlas T link: **[T Criteria](http://atlas-demo.ohdsi.org/#/cohortdefinition/1771366)**
- Atlas O link: **[O Criteria](http://atlas-demo.ohdsi.org/#/cohortdefinition/1771367)**
- Vocabulary: **-**

The Women of OHDSI Overview
========================================================

OHDSI's mission is to improve health by empowering a community to collaboratively generate the evidence that promotes better health decisions and better care. As a community, we strive promote openness and inclusivity by creating an environment where all voices are heard.

The Women of OHDSI group aims to provide a forum for women within the OHDSI community to come together and discuss challenges they face as women working in science, technology, engineering and mathematics (STEM). We aim to facilitate discussions where women can share their perspectives, raise concerns, propose ideas on how the OHDSI community can support women in STEM, and ultimately inspire women to become leaders within the community and their respective fields. This research investigation is intended to foster collaboration across the OHDSI community about an important clinical question. 

Executive Summary of Study
========================================================

Mammography screening can lead to early detection of cancer but has negative impacts such as causing patients anxiety. Being more informed, such as quantifying your personal risk, can reduce anxiety.  We wish to develop a risk prediction model could be developed to predict future risk of breast cancer at the point in time a patient has a mammography.  This would be implemented at the same time a patient has a screen to not only enable them to know whether they have current breast cancer but to also tell them their 3-year risk.

The objective of this study is to develop and validate patient-level prediction models for patients in 2 target cohort(s) (Target 1: Patients with first mammography in 2 years and no prior neoplasm and Target 2: Patients with first mammography in 2 years and no prior breast cancer) to predict 1 outcome(s) (Outcome: At least two occurrence of Breast cancer in the Time at Risk (TAR Settings: Risk Window Start:  1 day after index, , Risk Window End:  1095 days after index).

The prediction will be implemented using one algorithm (a Lasso Logistic Regression).

Study Milestones
========================================================
- **August 09, 2019:** Study Protocol Published
- **August 09 - Sep 05, 2019:** Call for Sites to Run & Send Results
- **Sep 16, 2019:** Results Presentation at 2019 US OHDSI Symposium
- **September onward:** Manuscript preparations

## Code to Install

To install Strategus run :

```r
  # install the network package
  # install.packages('remotes')
  remotes::install_github("OHDSI/Strategus")
```

Instructions To Run Strategus for this Study:
===================

```r
  library(Strategus)

##=========== START OF INPUTS ==========
# Add your json file location, connection to OMOP CDM data settings and 

# load the json spec
url <- "https://raw.githubusercontent.com/ohdsi-studies/BreastCancerBetweenScreen/master/inst/strategusStudy.json"
json <- readLines(file(url))
json2 <- paste(json, collaplse = '\n')
analysisSpecifications <- ParallelLogger::convertJsonToSettings(json2)

connectionDetailsReference <- "<database ref>"

connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = '<dbms>',
  server ='<server>',
  user = '<user>',
  password = '<password>',
  port = '<port>'
)

workDatabaseSchema <- '<your workDatabaseSchema>'
cdmDatabaseSchema <- '<your cdmDatabaseSchema>'

outputLocation <- '<folder location to run study and output results?'
minCellCount <- 5
cohortTableName <- "strategus_example"

##=========== END OF INPUTS ==========

storeConnectionDetails(
  connectionDetails = connectionDetails,
  connectionDetailsReference = connectionDetailsReference
  )

executionSettings <- createCdmExecutionSettings(
  connectionDetailsReference = connectionDetailsReference,
  workDatabaseSchema = workDatabaseSchema,
  cdmDatabaseSchema = cdmDatabaseSchema,
  cohortTableNames = CohortGenerator::getCohortTableNames(cohortTable = cohortTableName),
  workFolder = file.path(outputLocation, "strategusWork"),
  resultsFolder = file.path(outputLocation, "strategusOutput"),
  minCellCount = minCellCount
)

# Note: this environmental variable should be set once for each compute node
Sys.setenv("INSTANTIATED_MODULES_FOLDER" = file.path(outputLocation, "StrategusInstantiatedModules"))

execute(
  analysisSpecifications = analysisSpecifications,
  executionSettings = executionSettings,
  executionScriptFolder = file.path(outputLocation, "strategusExecution")
  )
```
