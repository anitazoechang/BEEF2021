#* Echo back the input

#* @get /

function(){


  ##### Run this chunk to retrieve the latest survey response #####
  # To run this chunk, highlight line 8 - line 20 and hit CTRL + Enter
  df <- fetch_survey(surveyID = "SV_6wXoZMOL6A1ww3Y", force_request = TRUE)
  df <- df %>%
    filter(Progress == 100)
  df <- df[which.max(df$StartDate),]

  email <- render_email("/root/supp/GenerateReport.Rmd")
  email %>%
    smtp_send(
      from = "precisionlivestockmanagement@gmail.com",
      to = "t.m.williams@cqu.edu.au", #df$email,
      subject = "CQUniversity's BEEF2021 Technology Audit",
      credentials = creds_file(file = "/root/supp/gmail_creds")
    )


#  ##### Run this chunk to send an email to a specific individual #####
#  # To run this chunk, highlight line 27 - line 40 and hit CTRL + Enter
#  df <- fetch_survey(surveyID = "SV_6wXoZMOL6A1ww3Y", force_request = TRUE)
#  # STOP!!! Before you run this, modify line 30. Put the respondent's email in between the two quotation marks, e.g. "a.chang@cqu.edu.au"
#  df <- df %>%
#    filter(RecipientEmail == "")
#  df <- df[which.max(df$StartDate),]
#
#  email <- render_email("/root/Survey/Qualtrics.Rmd")
#  email %>%
#    smtp_send(
#      from = "precisionlivestockmanagement@gmail.com",
#      to = "t.m.williams@cqu.edu.au", #df$email
#      subject = "CQUniversity's BEEF2021 Technology Audit",
#      credentials = creds_file(file = "/root/supp/gmail_creds")
#    )
  
  
}
