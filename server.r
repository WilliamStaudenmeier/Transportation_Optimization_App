
##fedex zone data created from a workflow

##colclasses character ensures that the leading zeros aren't eliminated

fedex = read.csv("zonelocator.csv", stringsAsFactors = F,  colClasses=c("character"
                                                                        ,"character"
                                                                        
                                                                        ,"character"))

# from .gov zip file
zips = read.csv("zipcodes.csv", stringsAsFactors = F, sep =";", colClasses=c("character"
                                                                             ,"character"
                                                                             ,"character"
                                                                             ,"character"
                                                                             ,"character"
                                                                             ,"character"
                                                                             ,"character"
                                                                             ,"character"))


# for intro animation

network2= data_frame(
  from=c("New York", "New York", "Miami", "Paris", "Miami", "Paris", "Portland", "Portland", "Miami", "Paris", "Seattle", "New York", "Miami"),
  to=c("Miami", "Portland", "Los Angeles", "Portland", "Miami", "New York", "Paris", "Tokyo", "New York", "Miami", "Portland", "Miami", "Chicago")
)

# Plot


function(input, output, session) {
  
  

  
  
  output$net2 <- renderForceNetwork(simpleNetwork(network2, height="10px", width="10px",        
                                                 Source = 1,                 # column number of source
                                                 Target = 2,                 # column number of target
                                                 linkDistance = .1,          # distance between node. Increase this value to have more space between nodes
                                                 charge = -900,                # numeric value indicating either the strength of the node repulsion (negative value) or attraction (positive value)
                                                 fontSize = 10,               # size of the node names
                                                 fontFamily = "serif",       # font og node names
                                                 linkColour = "#666",        # colour of edges, MUST be a common colour for the whole graph
                                                 nodeColour = "#69b3a2",     # colour of nodes, MUST be a common colour for the whole graph
                                                 opacity = 0.5,              # opacity of nodes. 0=transparent. 1=no transparency
                                                 zoom = T                    # Can you zoom on the figure?
  ))
  



  ### create map dataframe by combining with zips and zone data
  
  datasetInput = reactive({
    
    req(input$centers)
    req(input$customers)
    
   
    
    
    
  
    
    centers = read.csv(input$centers$datapath, colClasses=c("character")
    )
    
    
    
    colnames(centers)[1] = "FromZip"
    
    
    
    
    
    
    customers = read.csv(input$customers$datapath, colClasses=c("character")
    )
    
    
    
    colnames(customers)[1] = "ToZip"
    
    
    final = customers
    
    final$FromZip = centers[1, 1]
    
    
    for (i in c(1:nrow(centers))) {
      
      temp = customers
      
      temp$FromZip = centers[i, 1]
      
      
      final = rbind(final, temp)
      
      final = final %>% distinct()
      
    }
    
    
    
    
    final$From = as.character(substr(final$FromZip, 1, 2))
    
    final$To = as.character(substr(final$ToZip, 1, 2))
    
    
    
    
    
    
    final = full_join(fedex, final, by =c("To", "From"))
    
    
    final = na.omit(final)
    
    ###
    final$Zone = as.numeric(final$Zone)
    
    final <- final[order(final$Zone, final$To), ]
    
    
    
  
    
    temp <- by(final, final["ToZip"], head, n=2)
    
    
    temp = Reduce(rbind, temp)
    
    
    final = temp
    
    
    final$Option = NULL
    
    final$Route = "Primary Route"
    
    
    odd_indexes<-seq(1,nrow(final),2)
    
    even_indexes<-seq(2,nrow(final),2)
    
    
    final[odd_indexes, "Priority"] <- "Primary Route"
    
    final[even_indexes, "Priority"] <- "Secondary Route"
    

    
    zipTo = zips
    
    zipFrom = zips
    
    
    colnames(zipTo)[1] = "ToZip"
    
    colnames(zipTo)[2] = "ToCity"
    
    colnames(zipTo)[3] = "ToState"
    
    colnames(zipTo)[4] = "Latitude2"
    
    colnames(zipTo)[5] = "Longitude2"
    
    
    colnames(zipFrom)[1] = "FromZip"
    
    colnames(zipFrom)[2] = "FromCity"
    
    colnames(zipFrom)[3] = "FromState"
    
    colnames(zipFrom)[4] = "Latitude1"
    
    colnames(zipFrom)[5] = "Longitude1"
    
    
    
    ########################
    
    
    
    map = final
    
    map = inner_join(zipTo, map, by = "ToZip")
    
    map = inner_join(zipFrom, map, by ="FromZip")
    
    map$To = NULL
    
    map$From = NULL
    
    map$Route=NULL
    
    return(map)
    
    
  })

  
  
  
  
  ##########################################################################  
  
  # Output plotly using renderPlotly
  output$plot1 <- renderPlotly({
    
    req(input$centers)
    req(input$customers)
    
  
    
    map = datasetInput() %>% filter(Priority == as.character(input$choice)) #only changing this for the map and table
    
    
    
    
    
    
    ##### visual map
    
    
    
    
    geo <- list(
      scope = 'usa',
      #scope = 'usa',
      projection = list(type = 'albers usa'),
      showland = TRUE,
      landcolor = toRGB("gray95"),
      countrycolor = toRGB("gray80")
    )
    
    
    
    
    fig <- plot_geo(locationmode = 'USA-states', color = ~map$FromCity)
    fig <- fig %>% add_markers(
      data = map, x = ~Longitude1, y = ~Latitude1, text = ~FromCity,
      size = 1, hoverinfo = "text", alpha = 0.8
    )
    
    
    
    
    
    
    fig <- fig %>% add_segments(
      
      #data = group_by(flights, id),
      data = map,
      
      x = ~Longitude1, xend = ~Longitude2,
      y = ~Latitude1, yend = ~Latitude2,
      alpha = 0.8, size = I(1), hoverinfo = "none"
    )
    
  
    
    
    
    fig <- fig %>% layout(width =  1000, height =600,  
                          plot_bgcolor  = "transparent",
                          paper_bgcolor = "transparent",
                          fig_bgcolor   = "transparent",
      title = '',
      geo = geo, showlegend = FALSE
    )
    
    fig
    
    
    
  })
  
  
  
  
  ########## Output datatable using DT
  
 output$table =  DT::renderDT({
    
    
    
   
   req(input$centers)
   req(input$customers)
   
   
   
   map = datasetInput() %>% filter(Priority == as.character(input$choice))
   
   table = map %>%
     dplyr::select(FromCity, FromState, FromZip, Latitude1, Longitude1, ToCity, ToState, ToZip, Latitude2, Longitude2, Zone) %>%
     arrange(ToCity, Zone)
   
    
    
    
    datatable(table) %>% formatStyle('Zone',
     
      backgroundColor = styleInterval(3.4, c('gray', 'yellow'))
   
      
      
      
      
      
      
      
      
      
      
      
      
       )
  })
  
  
  
  

 
 
 
 
 
 ################################# Download file using downloadHandler
 

 output$downloadData <- downloadHandler(
   filename = function() { 'returnedData.csv' }, content = function(file) {
     write.csv(datasetInput(), file, row.names = FALSE)
   }
 )

  
  

  
}