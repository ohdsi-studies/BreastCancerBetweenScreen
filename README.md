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
- Protocol: **[Protocol](https://github.com/ohdsi-studies/BreastCancerBetweenScreen/blob/master/documents/ProtocolWoo2019.docx)**
- Publications: **-**
- Results explorer: **[Shiny App](https://data.ohdsi.org/WoO2019/)**

This study aims to explore whether we can use observational health data to predict which women will develop breat cancer between mammography screenings.

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

To install this package run :

```r
  # install the network package
  # install.packages('devtools')
  devtools::install_github("OHDSI/OhdsiSharing")
  devtools::install_github("OHDSI/FeatureExtraction")
  devtools::install_github("OHDSI/PatientLevelPrediction")
  devtools::install_github("ohdsi-studies/BreastCancerBetweenScreen")
```

Instructions To Run Package
===================

```r
  library(BreastCancerBetweenScreen)
  # USER INPUTS
#=======================
# The folder where the study intermediate and result files will be written:
outputFolder <- "./BreastCancerBetweenScreenResults"

# Specify where the temporary files (used by the ff package) will be created:
options(fftempdir = "location with space to save big data")

# Details for connecting to the server:
dbms <- "you dbms"
user <- 'your username'
pw <- 'your password'
server <- 'your server'
port <- 'your port'

connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
                                                                server = server,
                                                                user = user,
                                                                password = pw,
                                                                port = port)

# Add the database containing the OMOP CDM data
cdmDatabaseSchema <- 'cdm database schema'
# Add a database with read/write access as this is where the cohorts will be generated
cohortDatabaseSchema <- 'work database schema'

oracleTempSchema <- NULL

# table name where the cohorts will be generated
cohortTable <- 'finalWooCohort'
#=======================

execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        oracleTempSchema = oracleTempSchema,
        outputFolder = outputFolder,
        createProtocol = F,
        createCohorts = T,
        runAnalyses = T,
        createResultsDoc = F,
        packageResults = T,
        createValidationPackage = F,
        minCellCount= 5)
```
