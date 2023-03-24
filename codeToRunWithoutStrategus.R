# To run without Strategus:
outputLocation <- file.path('C:/Documents/PLPstudies/breastCancer')

database <- 'optum ehr'
cdmDatabaseName <- database
connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = keyring::key_get('dbms', 'all'),
  server = keyring::key_get('server', database),
  user = keyring::key_get('user', 'all'),
  password = keyring::key_get('pw', 'all'),
  port = keyring::key_get('port', 'all')#,
) 
cohortDatabaseSchema <- keyring::key_get('workDatabaseSchema', 'all')
cdmDatabaseSchema <- keyring::key_get('cdmDatabaseSchema', database)

# first define your ATLAS webapi:
baseUrl <- 'https://api.ohdsi.org/WebAPI'

# now we extract the two cohorts
# note: if you used cohorts as predictors you need to add them here as well
cohortDefinitionSet <- ROhdsiWebApi::exportCohortDefinitionSet(
  baseUrl = baseUrl, 
  cohortIds = c(1782266,1782267,1782265), 
  generateStats = F # set this to T if you want stats
)

cohortNames <- CohortGenerator::getCohortTableNames(cohortTable = 'example_plp_bc')
CohortGenerator::createCohortTables(
  connectionDetails = connectionDetails, 
  cohortDatabaseSchema = cohortDatabaseSchema, 
  cohortTableNames = cohortNames, 
  incremental = T
)

CohortGenerator::generateCohortSet(
  connectionDetails = connectionDetails, 
  cdmDatabaseSchema = cdmDatabaseSchema, 
  cohortDatabaseSchema = cohortDatabaseSchema, 
  cohortTableNames = cohortNames, 
  cohortDefinitionSet = cohortDefinitionSet, 
  incremental = F
)

# two targets: 10631,10845 -- 1782266,1782267 
# one outcome: 10082  -- 1782265 
modelDesignList <- lapply(
  c(1782266,1782267), 
  function(tarId){
    PatientLevelPrediction::createModelDesign(
      targetId = tarId, 
      outcomeId = 1782265, 
      restrictPlpDataSettings = PatientLevelPrediction::createRestrictPlpDataSettings(),
      populationSettings = PatientLevelPrediction::createStudyPopulationSettings(
        includeAllOutcomes = T, 
        firstExposureOnly = FALSE,
        washoutPeriod = 1095,
        removeSubjectsWithPriorOutcome = TRUE,
        priorOutcomeLookback = 99999, 
        requireTimeAtRisk = F, 
        minTimeAtRisk = 364, #not used as requireTimeAtRisk = F but copying from old json
        riskWindowStart = 1,
        startAnchor = 'cohort start',
        riskWindowEnd = 1095,
        endAnchor = 'cohort start'
      ),
      covariateSettings = FeatureExtraction::createCovariateSettings(
        useDrugGroupEraLongTerm = T,
        useDrugGroupEraAnyTimePrior = T, 
        useDemographicsAgeGroup = T,
        useDemographicsGender = T,
        useConditionGroupEraAnyTimePrior = T,
        useConditionGroupEraLongTerm = T,
        endDays = 0
      ),
      featureEngineeringSettings = PatientLevelPrediction::createFeatureEngineeringSettings(type = 'none'),
      sampleSettings = PatientLevelPrediction::createSampleSettings(type = 'none'),
      preprocessSettings = PatientLevelPrediction::createPreprocessSettings(
        minFraction = 5.0E-4, 
        normalize = T
      ),
      modelSettings = PatientLevelPrediction::setLassoLogisticRegression(),
      splitSettings = PatientLevelPrediction::createDefaultSplitSetting(
        splitSeed = 1004, 
        nfold = 3, 
        testFraction = 0.25,
        type = 'stratified' # this is the old person split
      ),
      runCovariateSummary = T
    )
  }
)


PatientLevelPrediction::runMultiplePlp(
  databaseDetails = PatientLevelPrediction::createDatabaseDetails(
    connectionDetails = connectionDetails,
    cdmDatabaseSchema = cdmDatabaseSchema, 
    cdmDatabaseName = cdmDatabaseName, 
    cdmDatabaseId = cdmDatabaseName,
    cohortTable = cohortNames$cohortTable, 
    cohortDatabaseSchema = cohortDatabaseSchema, 
    outcomeDatabaseSchema = cohortDatabaseSchema, 
    outcomeTable = cohortNames$cohortTable
    ), 
  modelDesignList = modelDesignList, 
  cohortDefinitions = cohortDefinitionSet, 
  saveDirectory = outputLocation
  )
