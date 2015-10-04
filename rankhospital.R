rankhospital <- function(state, outcome, num = "best") {
    ## Read outcome data
    ## Check that state and outcome are valid
    ## Return hospital name in that state with the given rank
    ## 30-day death rate
    
    ## state is a 2-character abbreviated name of a state
    ## outcome is a character matching the values of either 
    ##  'heart attack', 'heart failure', or 'pneumonia', each
    ##  representing column name roots in the source data file.
    ## num can take the character values 'best' or 'worst', or
    ##  an integer representing the ranking of the hospital sought
    
    
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
    #rates <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
    rates <- read.csv("outcome-of-care-measures.csv")
    rates[,Mort.Rate.Name] <- sub("Not Available", NA, rates[,Mort.Rate.Name])
    rates[,Mort.Rate.Name] <- as.numeric(rates[,Mort.Rate.Name])
    
    browser()
    
    # ---- Processing ----
    
    # Validate state
    if (!(state %in% rates$State)) {
        stop("invalid state")
    }

    # Filter data frame to state
    rates <- subset(rates, State == state, c("Hospital.Name", "State", Mort.Rate.Name))
    
    # Validate num
    if (is.numeric(num)) {
        if (num > nlevels(rates$State)) return(NA)
    }
    
    # Check num for result to return
    if (as.character(num)=="worst") {
        
        # Sort by Mortality Rate desc, Hospital Name asc
        rates <- rates[order(-rates[[Mort.Rate.Name]], rates[["Hospital.Name"]]), ]
        return(as.character(rates[1,1]))

    } else {
        
        # Sort by Mortality Rate asc, Hospital Name asc
        rates <- rates[order(rates[[Mort.Rate.Name]], rates[["Hospital.Name"]]), ]
    
        if (as.character(num)=="best") {
            return(as.character(rates[1,1]))
        } else {
            return(as.character(rates[num,1]))
        }
        
        # return(rates[num,1])
    }
    
}
