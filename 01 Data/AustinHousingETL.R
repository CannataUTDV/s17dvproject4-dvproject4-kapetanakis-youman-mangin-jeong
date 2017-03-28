require(readr)
require(plyr)
require("jsonlite")
require("RCurl")


df1 <- read.csv("../01 Data/Austin_Housing_Data.csv")
df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ",'oraclerest.cs.utexas.edu:5000/rest/native/?query="select * from AustinHousingData"')),httpheader=c(DB='jdbc:data:world:sql:stefkaps:s-17-edv-project-3', USER='stefkaps', PASS='eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJwcm9kLXVzZXItY2xpZW50OnN0ZWZrYXBzIiwiaXNzIjoiYWdlbnQ6c3RlZmthcHM6OjFlM2ZmNTQ0LTRlNDctNGM0ZC1hN2Q1LTFkM2U3NTdlNTg3YSIsImlhdCI6MTQ4NDg2ODE4Miwicm9sZSI6WyJ1c2VyX2FwaV93cml0ZSIsInVzZXJfYXBpX3JlYWQiXSwiZ2VuZXJhbC1wdXJwb3NlIjp0cnVlfQ.kMUEnBTNlehf2NuUwKA8UrIx6BPPV7wSSYElwLvsxTPFFczCjJZPQ6LXd38AKjiqfhvZWgUCy43p1Z5v4M0RZA', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

#seperate dimensions and measures
dimensions = c("Zip.Code")
measures = setdiff(names(df), dimensions)

#Clean names
for(n in names(df)) {
  df[n] <- data.frame(lapply(df[n], gsub, pattern="[^ -~]",replacement= ""), stringsAsFactors=FALSE)
  }

na2zero <- function (x) {
  x[is.na(x)] <- 0
  return(0)
  }

#Clean measures
if( length(measures) > 1) {
  for(m in measures) {
    print(m)
    df[m] <- data.frame(lapply(df[m], gsub, pattern="[^--.0-9]",replacement= ""), stringsAsFactors=FALSE)
    df[m] <- data.frame(lapply(df[m], na2zero), stringsAsFactors=FALSE)
    df[m] <- data.frame(lapply(df[m], as.character), stringsAsFactors=FALSE)
      }
}

#Convert percentages

percentToDecimal <- function(x) {
  return(x/100)
}

for (m in measures) {
  if (grepl("Median", m) == FALSE) {
    df[m] <- data.frame(lapply(df[m], as.numeric), stringsAsFactors=FALSE)
    df[m] <- data.frame(lapply(df[m], percentToDecimal), stringsAsFactors=FALSE)
  }
  else {
    df[m] <- data.frame(lapply(df[m], as.character), stringsAsFactors=FALSE)
    df[m] <- data.frame(lapply(df[m], as.numeric), stringsAsFactors=FALSE)
  }
}

#Clean zip code dimension
na2emptyString <- function (x) {
  x[is.na(x)] <- ""
  return(x)
  }

df[1] <- data.frame(lapply(df[1], as.character), stringsAsFactors = FALSE)
df[1] <- data.frame(lapply(df[1], na2emptyString), stringsAsFactors = FALSE)

#Write to csv
write.csv(df1, file = "../01 Data/Austin_Housing_Data.csv")
