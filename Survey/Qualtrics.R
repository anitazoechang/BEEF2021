# install.packages('qualtRics')
library(qualtRics)
library(blastula)

# Do we need an auto script to generate an email for every respondent??
# Maybe add a question at the end asking if they want a copy of the report in the email?

##### Run this chunk to retrieve the latest survey response #####
# To run this chunk, highlight line 8 - line 20 and hit CTRL + Enter
df <- fetch_survey(surveyID = "SV_6wXoZMOL6A1ww3Y", force_request = TRUE)
df <- df %>%
  filter(Progress == 100)
df <- df[which.max(df$StartDate),]

email <- render_email("./Survey/Qualtrics.Rmd")
email %>%
  smtp_send(
    from = "precisionlivestockmanagement@gmail.com",
    to = df$email,
    subject = "CQUniversity's BEEF2021 Technology Audit",
    credentials = creds_file(file = "./Survey/gmail_creds")
  )


##### Run this chunk to send an email to a specific individual #####
# To run this chunk, highlight line 27 - line 40 and hit CTRL + Enter
df <- fetch_survey(surveyID = "SV_6wXoZMOL6A1ww3Y", force_request = TRUE)
# STOP!!! Before you run this, modify line 30. Put the respondent's email in between the two quotation marks, e.g. "a.chang@cqu.edu.au"
df <- df %>%
  filter(RecipientEmail == "")
df <- df[which.max(df$StartDate),]

email <- render_email("./Survey/Qualtrics.Rmd")
email %>%
  smtp_send(
    from = "precisionlivestockmanagement@gmail.com",
    to = df$email,
    subject = "CQUniversity's BEEF2021 Technology Audit",
    credentials = creds_file(file = "./Survey/gmail_creds")
  )