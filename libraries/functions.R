#########################################################################
# 
#
# This is a file that contains all the functions that I use most often.
#
# Luca Sala, PhD
#
#########################################################################


#### 1. normalize ####
# Use this function to normalize data from 0 to 1, where 0 is 
# the MIN and 1 is the MAX of the values of a certain column.

normalize <- function(x){
  (x - min(x))/(max(x)-min(x))
} 

#### 2. reRange ####
# Use this function when you have to overlap two or more df$columns (xy traces) with different scales. 
# One of the columns will be rescaled to the MAX and MIN of the first one and plotted on the scale of the other.
# Useful if you want to overlap multiple signals with different scales, e.g. an AP and a Ca2+ transient.

reRange <- function(x){ 
  (x - min(x))/(max(x)-min(x)) * (newMax - newMin) + newMin 
} 

#Function that allow normalisation from 0 to 1 and rescale to new min and max values. 
#Useful to normalise on the same scale different data.



#### 3. Scale to Baseline ####
# Use this function when you want to scale the data to the Baseline/Control value that will be set as 100. 
# All the other points will be scaled accordingly.
# Useful if you want to fix only one side of the plot to capture relative increases/decreses.

scale.to.baseline <- function(x){
  (x / x[1])
}


#### 4. Delete the Nth row in a dataframe ####
# Use this function if you want to decimate points in a data frame.
# The number put in "n" indicates that the data frame will be reduced by 1 line every "n"

Nth.delete <- function(dataframe, n){
  dataframe[-(seq(n,to=nrow(dataframe),by=n)),]
}


#### 5. Calculates the STV of an APD90 series in 30 consecutive beats (default)  ####
# This function accepts a data frame with 2 columns:
# First column: number of sweeps;
# Second column: APD90 values;

STV.function <- function(x) {
  
  nbeats <- 30 #default number of beats on which STV is calculated
  APD90n <- x[-nrow(x),] # remove the last row and creates the APD90n group
  APD90n1 <- x[-1,] # remove the first row and creates the APD90n-1 group
  APD90mean <- mean(x[,2])# calculates the mean of APD90
  APD90_BVR <- data.frame(APD90n, APD90n1)
  
  for(i in 1:30){
    STV_temp <- data.frame(abs(APD90n[i,2] + APD90n1[i,2] + (2*APD90mean))/((nbeats)*sqrt(2)))
    STV <- smartbind(STV, STV_temp)
  } 
  STV <- mean(STV[,1])
}


#### 6. Sorts the alphanumeric codes used in the Laboratory of Cardiovascular Genetics from AUXO  ####
# used for patients codes.
# This function accepts a list with alphanumeric codes
# The output is a sorted list

sort_AUXO_db <- function(codes){
  
  # First letter
  first_chars <- str_extract(codes, "[A-Z]+") # #first letter
  # removes DNA_codes that do not start with "S" 
  not_common_S_pattern <- sort(codes[which(tolower(first_chars) != "s")])
  uncommon_prefix <- str_extract(not_common_S_pattern, "[A-Z]+") # CAUTION! This does not discriminate between prefixes!
  numbers <- sort(as.integer(str_extract(not_common_S_pattern, "[0-9]+")))
  
  # This loop solves the fact that 
  if(length(uncommon_prefix) == 0){
    codes <- codes
  } else {
    codes <- codes[-which(codes %in% not_common_S_pattern)] # removes DNA_codes that do not start with "S"
  }
  
  # Looks for codes not in "not common pattern" that do not have final letter. These go first.
  last_chars <- str_extract(codes, "(?<=[0-9])[A-Z]") #last letter
  without_last_char_pattern <- codes[which(is.na(last_chars) == TRUE)] # Identifies those w/o last letter
  with_last_char_pattern <- codes[which(is.na(last_chars) == FALSE)] # Identifies those w/ last letter
  last_chars <- str_extract(with_last_char_pattern, "(?<=[0-9])[A-Z]") # Extract the last char from those w/ last letter
  with_last_char_pattern <- with_last_char_pattern[order(last_chars)] # Order the list according to last letter
  
  final <- list.append(without_last_char_pattern,
                       with_last_char_pattern,
                       not_common_S_pattern)
  
  return(final)
}
  

#### 7. Transforms an .ABF file into a dataframe  ####
# with the first colum being the X axis. 
# The final data frame formas is wide. Please use pivot function to have the long version.

library(readABF)
library(magrittr)

abf_to_df_vclamp <- function(path_to_abf, # This is a link to an ABF file
                             format, # This is the format for the output ("wide" or "long")
                             reduce_by = 1){ # This is an optional reduction factor for the row number 
  
  abf <- readABF::readABF(path_to_abf)
  sampling_rate <- abf$samplingIntervalInSec #these are SECONDS
  df <- as.data.frame(abf[["data"]], 
                      col.names = seq(1:length(abf[["data"]])))
  df$`Time (s)` <- seq(0, 
                       (nrow(df)-1) * sampling_rate, 
                       by = sampling_rate)
  
  df <- df %>% filter(row_number() %% reduce_by == 1)
    
  if (format == "wide"){
    return(df) 
  } else if (format == "long") {
    df <- df %>% pivot_longer(!`Time (s)`, names_to = "Step", values_to = "Current")
  } 
  return(df)
}



  
