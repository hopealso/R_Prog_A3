best <- function(state, outcome) {
    ## Read outcome data
    ## Check that state and outcome are valid
    ## Return hospital name in that state with lowest 30-day death
    ## rate.
    
    ## state is a 2-character abbreviated name of a state
    ## outcome is a character matching the values of either 
    ##  'heart attack', 'heart failure', or 'pneumonia', each
    ##  representing column name roots in the source data file.

    
    # Validate outcome
    if (!(outcome %in% c("heart attack", "heart failure", "pneumonia"))) {
        stop("invalid outcome")
    }
    
    # ---- Import ----
    
    # Turn outcome input into relevant column name 
    x <- strsplit(outcome," ")[[1]]
    Outcome.Title <- paste(toupper(substring(x,1,1)), substring(x,2), sep="", collapse = ".")
    
    Mort.Rate.Name <- paste("Hospital.30.Day.Death..Mortality..Rates.from.", Outcome.Title, sep = "")
    
    # Read file and clean strings in relevant column, converting to NA values
    rates <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
    #rates <- read.csv("outcome-of-care-measures.csv")
    rates[,Mort.Rate.Name] <- sub("Not Available", NA, rates[,Mort.Rate.Name])
    rates[,Mort.Rate.Name] <- as.numeric(rates[,Mort.Rate.Name])

    # browser()
        
    # ---- Processing ----

    # Validate state
    if (!(state %in% rates$State)) {
        stop("invalid state")
    }
    
    # Filter data frame to state
    rates <- subset(rates, State == state, c("Hospital.Name", "State", Mort.Rate.Name))
    
    # Sort by Mortality Rate, Hospital Name
    rates <- rates[order(rates[[Mort.Rate.Name]], rates[["Hospital.Name"]]), ]
    
    #return(as.character(rates[1,1]))
    return(rates[1,1])
}