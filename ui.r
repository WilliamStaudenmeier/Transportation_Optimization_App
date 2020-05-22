library(DT)
library(shiny)
library(shinythemes)
library(dplyr)
library(plotly)
library(shinyWidgets)
library(dplyr)
library(networkD3)

navbarPage("B2C Freight Optimization in R",
           tabPanel("Analysis", fluidPage(theme = shinytheme("flatly")
                                          , 
                                          tags$h2("Geo-Spatial Mapping:"),
                                          setBackgroundImage(
                                            src = "Picture1.png"
                                          )
           
                                          ),
                    
                    tags$head(
                      tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                    pageWithSidebar(
                      headerPanel(''),
                     # sidebarPanel(width = 3, 
                     absolutePanel(id = "controls", class = "panel panel-default",
                                   top = 115, left = 1200, width = 350, fixed=TRUE,
                                   draggable = F, height = "auto",
                                  
                                   fileInput("centers", "Fulfillment Locations:"),
                                   fileInput("customers", "Customer Locations:"),
                                   submitButton("Update"),
                                 
                                   radioButtons(inputId="choice", label="Route Options", 
                                                choices = c("Primary" = "Primary Route",
                                                            "Secondary" = "Secondary Route"), 
                                                selected = c("Primary" = "Primary Route"
                                                ),inline=TRUE),
                                  
                                  
                                   downloadButton("downloadData", "Download")
                                   
                                   
                                   
                                   
                                   
                                   
                      ),
                     
                     
                  
                      mainPanel(
                        fluidRow(column(1,
                                   
                        #column(8, 
                               plotlyOutput("plot1", width = "150%", height="100%")
                               
                        )
                        ),
                        
                      
                        
                        fluidRow(
                          column(8,
                                 dataTableOutput('table')
                                 
                          )
                          ),

                        fluidRow(
                          column(8,
                                 forceNetworkOutput(outputId = "net2", width="50%", height = 200)
                          ))
                                 
                                 ,
                        
                        fluidRow(
                         column(8,
                                 p("To determine optimal sourcing with the objective of minimizing freight charges,
                                   upload a csv file with the zipcodes of your fulfillment centers as well as
                                  a csv file with the zipcodes of your customer locations.",
                                   style = "font-size:22px")
                                 
                          )
                       )
                                 
                      # ,
                       
                      # fluidRow(
                       #  column(8,
                        #        forceNetworkOutput(outputId = "net", width="200%", height = 500)
                        # )) 
                       
                        
                        
                        
                        
                        
                      )
                        
                        
                        
                    )),
           
     #############################################################################################
     
     
     
           tabPanel("Fun Fact", fluidPage(theme = shinytheme("flatly")
                                          , 
                                          tags$h2(""),
                                          setBackgroundImage(
                                            src = "Picture1.png"
                                          )
                                          
           ),
           
           
             
             
             
             
             
             mainPanel(
              
               
               fluidRow(
             
                        p("Data science is boring in the same way that watching a printing press print money is boring.",
                          style = "font-size:22px")
                        
                 )
                 )
              
             
               
               
               
               
               
               )
             
             
             
               )



     
                  
      
           
           




