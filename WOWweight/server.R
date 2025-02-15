library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(tidyverse)
library(shinyalert)
library(leaflet)
library(leaflet.extras)
library(BEEF2021functions)
library(tidyverse)
library(DT)
# remotes::install_github("anitazoechang/BEEF2021functions@main")

# user <<- as.character(Sys.getenv("user"))
# pass <<- as.character(Sys.getenv("pass"))

# url <- sprintf("mongodb://%s:%s@datamuster-shard-00-00-8mplm.mongodb.net:27017,datamuster-shard-00-01-8mplm.mongodb.net:27017,datamuster-shard-00-02-8mplm.mongodb.net:27017/test?ssl=true&replicaSet=DataMuster-shard-0&authSource=admin",
#                 user, pass)
# db <- mongolite::mongo(collection = "BeefWoWData", db = "DMIoT", url = url, verbose = T)
# weight <- db$find() %>%
#   filter(Wt != 0)
# weight <- weight[which.max(weight$datetime),]
# weight <- weight$Wt
# weight <<- as.numeric(weight)


##### Shiny server #####
Shinyserver <- function(input, output, session) {
  
  user <<- "LaurenOconnor"
  pass <<- "DataMuster"
  
  url <- sprintf("mongodb://%s:%s@datamuster-shard-00-00-8mplm.mongodb.net:27017,datamuster-shard-00-01-8mplm.mongodb.net:27017,datamuster-shard-00-02-8mplm.mongodb.net:27017/test?ssl=true&replicaSet=DataMuster-shard-0&authSource=admin",
                 user, pass)
  db <- mongolite::mongo(collection = "BeefWoWData", db = "DMIoT", url = url, verbose = T)
  weight <- db$find() %>%
    filter(Wt != 0)
  weight <- weight[which.max(weight$datetime),]
  weight <- weight$Wt
  weight <<- as.numeric(weight)
  
  schools <<- get_school(username = user, password= pass)
  
  if(nrow(schools) != 0){
    # Leaderboard text
    leaderboard <- schools[order(schools$weight, decreasing = TRUE),]
    leaderboard$rank <- seq(1:nrow(leaderboard))
    leaderboard <- leaderboard %>%
      select(rank, school, class, weight)
    leaderboard$weight <- paste0(leaderboard$weight, "kg")
    colnames(leaderboard) <- c("Rank", "School", "Class", "Weight")
    leaderboard <<- leaderboard
    
    # Leaderboard
    output$leaderboardtext <- renderDataTable(datatable(tibble(
      Rank = leaderboard$Rank,
      School = leaderboard$School,
      Class = leaderboard$Class,
      Weight = leaderboard$Weight),
      rownames = FALSE))
    
    # Map
    output$map <- renderLeaflet({
      leaflet(schools) %>%
        addProviderTiles(providers$OpenStreetMap) %>%
        setView(lng = 147.842393, lat = -24.000942, zoom = 6) %>% 
        addSearchOSM(options = searchOptions(collapsed = TRUE)) %>%
        addCircleMarkers(radius = 6, stroke = FALSE, fillOpacity = 0.7,
                         fillColor = "#d52a2e",
                         popup = paste(paste(schools$school), 
                                       paste(schools$class),
                                       paste0(schools$weight, "kg"),
                                       sep = "</br>"))
    })
    
  } else {
    # Leaderboard
    output$leaderboardtext <- renderDataTable(datatable(tibble(
      Rank = "",
      School = "",
      Class = "",
      Weight = ""),
      rownames = FALSE))
    
    # Map
    output$map <- renderLeaflet({
      leaflet() %>%
        addProviderTiles(providers$OpenStreetMap) %>%
        setView(lng = 147.842393, lat = -24.000942, zoom = 6) %>% 
        addSearchOSM(options = searchOptions(collapsed = TRUE))
    })
  }



  # Sidebar
  output$sidebar <- renderUI({
    div(width = 500, height = 1, shinyjs::useShinyjs(), id="side-panel",
        fluidRow(align = "center", tags$a(tags$img(src = "logo.png", height = 120, width = 170))),
        fluidRow(h3("BEEF2021 Schools Weight Challenge", color = "#6e6d71"), align = "center"),
        fluidRow(align = "center", actionButton("addschool", label = "Add new entry", style = "color: #6d6e71")),
        fluidRow(h4("Leaderboard", color = "#6e6d71"), align = "center"),
        fluidRow(column(width = 2, div(style = "height:10px"))),
        dataTableOutput("leaderboardtext"),
        fluidRow(align = "center", actionButton("refresh", label = "Refresh session", style = "color: #6d6e71")),
    )
  })
  
  
  addschoolmodal <<- modalDialog(
    title = "Add new school",
    fluidRow(column(width = 3, "School name:"),
             column(width = 7, textInput(inputId = "school", label = NULL, value = NULL))),
    fluidRow(column(width = 3, "Class name:"),
             column(width = 7, textInput(inputId = "class", label = NULL, value = NULL))),
    # fluidRow(column(width = 3, "Weight:"),
    #          column(width = 7, numericInput(inputId = "weight", label = NULL, value = NULL))),
    # fluidRow(column(width = 3, "Latitude:"),
    #          column(width = 7, numericInput(inputId = "lat", label = NULL, value = NULL))),
    # fluidRow(column(width = 3, "Longitude:"),
    #          column(width = 7, numericInput(inputId = "long", label = NULL, value = NULL))),
    footer = fluidRow(column(width = 3),
                      column(width = 2, actionButton("addschooltodb", "Add school", style = "color: #6d6e71")),
                      column(width = 2),
                      column(width = 2, actionButton("cancel", "Close", style = "color: #6d6e71"))),
    easyClose = TRUE
    )
  
  ##### Weight #####
  
  
  ##### Buttons ######
  # Add school modal
  observeEvent(input$addschool, {
    if(input$addschool == 1){
      showModal(addschoolmodal)
    }
  })
  
  
  # Add school modal
  observeEvent(input$refresh, {
    if(input$refresh == 1){
      session$reload()
    }
  })
  
  # Cancel
  observeEvent(c(input$cancel), {
    if(input$cancel == 1){
      removeModal() 
    }
  })
  
  # Add schools
  observeEvent(input$map_center,{
    schoollat <<- input$map_center$lat
    schoollong <<- input$map_center$lng
  })
  
  observeEvent(c(input$addschooltodb, input$school, input$class,
                 input$lat, input$long), {
                   if(input$addschooltodb == 1){
                     if(length(input$class > 0)){
                       add_school(school = input$school, class = input$class,
                                  lat = schoollat, long = schoollong, weight = weight, username = user, password = pass)
                     } else {
                       add_school(school = input$school,
                                  lat = schoollat, long = schoollong, weight = weight, username = user, password = pass)}
                     removeModal()
                     session$reload()
                   }
                 })
  
}