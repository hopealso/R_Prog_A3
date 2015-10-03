## The best, rankhospital, and rankall functions provide answers to queries 
## against data found at the the Hospital Compare web site 
## (http://hospitalcompare.hhs.gov) run by the U.S. Dept of Health and 
## Human Services. The data provides information about the quality of care 
## at over 4,000 Medicare-certified hospitals in the U.S.

## Prior to running these functions, the files hospital-data.csv
## and outcome-of-care-measures.csv must be downloaded into the working
## directory.

best <- function(state, outcome) {
    ## Read outcome data
    ## Check that state and outcome are valid
    ## Return hospital name in that state with lowest 30-day death
    ## rate.
    
    ## state is a 2-character abbreviated name of a state
    ## outcome is a character matching the value of outcomes in the 
    
}