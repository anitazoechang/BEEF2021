  library(glue)
  library(lubridate)
  library(DMMongoDB)
  library(dplyr)
  library(mongolite)
  library(blastula)
  library(qualtRics)
  library(pander)
  library(knitr)
  library(kableExtra)



  qualtrics_api_credentials(base_url = "syd1.qualtrics.com", api_key = "F3hJKXRfDwka2FJV3sqqDGCNZuqm46sJC6dVKCgE", install = TRUE,
                          overwrite = TRUE)
  readRenviron("~/.Renviron")

library(plumber)
r <- plumb("/root/app/rest_controller.R")
r$run(port=8080, host="0.0.0.0")