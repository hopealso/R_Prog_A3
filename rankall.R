rankall <- function(outcome, num = "best") {
    ## Read outcome data
    ## Check that state and outcome are valid
    ## For each state, find the hospital of the given rank
    ## Return a data frame with the hospital names and the
    ## (abbreviated) state name
    
    # Validate outcome
    if (!(outcome %in% c("heart attack", "heart failure", "pneumonia"))) {
        stop("invalid outcome")
    }
    
    # ---- Import ----
    
    # Turn outcome input into relevant column name 
    x <- strsplit(outcome," ")[[1]]
    Outcome.Title <- paste(toupper(substring(x,1,1)), substring(x,2), sep="", collapse = ".")
    
    Mort.Rate.Name <- paste("Hospital.30.Day.Death..Mortality..Rates.from.", Outcome.Title, sep = "")
    
    # Specify data types and columns to skip
    Spec <- c(rep("character", 2), rep("NULL", 4), "factor", rep("NULL", 3),
              rep(c("character", rep("NULL", 5)),3), rep("NULL", 6*3))

    # Read file and clean strings in relevant column, converting to NA values
    #rates <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
    #rates <- read.csv("outcome-of-care-measures.csv")
    rates <- read.csv("outcome-of-care-measures.csv", colClasses = Spec)
    rates[,Mort.Rate.Name] <- sub("Not Available", NA, rates[,Mort.Rate.Name])
    rates[,Mort.Rate.Name] <- as.numeric(rates[,Mort.Rate.Name])
    
    # ---- Processing ----
    
    # Initialize result data file
    numstates <- nlevels(rates$State)
    result <- data.frame(hospital=character(numstates), state=character(numstates))
    
    # Create function to return nth row of given data set or NA
    nthstate <- function(df) {
        #browser()
        nthrow <- switch(as.character(num), "best"=1, "worst"=nrow(na.omit(df)), num)

        if (nthrow > nrow(df)) {
            return(data.frame(Hospital.Name=NA, State=df$State[1]))
        } else {    
            hold <- df[order(df[[Mort.Rate.Name]], df[["Hospital.Name"]])[nthrow], c("Hospital.Name","State")]
        }
        #browser()
    }
    
    #stateset <- split(rates, rates$State)
    #test <- lapply(stateset, nthstate)
    #result <- do.call("rbind", test)
    result <- do.call("rbind", lapply(split(rates, rates$State), nthstate))
    
    return(result)

}
