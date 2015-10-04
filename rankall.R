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
    
    # Add rank column
    rates$rank <- 0
    
    # Create function to add ranks to a given df which includes only one state
    setrank <- function(df) {
        #browser()
        #df$rank <- order(df[[Mort.Rate.Name]], df[["Hospital.Name"]])
        df <- df[order(df[[Mort.Rate.Name]], df[["Hospital.Name"]]), ]
        df$rank <- 1:nrow(df)
        browser()
        return(df)
    }
    
    #browser()
    
    stateset <- split(rates, rates$State)
    test <- lapply(stateset, setrank)
    ranked.rates <- do.call("rbind", test)
    #ranked.rates <- do.call("rbind", lapply(split(rates, rates$State), setrank))

    result <- ranked.rates[ranked.rates$rank==num, c("Hospital.Name","State")]
    colnames(result) <- c("hospital","state")
    rownames(result) <- result$state
        
    #browser()
    return(result)

}
