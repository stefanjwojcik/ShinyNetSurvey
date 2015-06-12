
#Run this line of code to get the app going---
#runApp("D:/papers/Working Projects/Dissertation/ShinyNetSurvey/NewApp/NewApp")

# Define server logic required to run the survey
shinyServer(function(input, output, session) {

#Define empty alter and intensity vectors that will be filled then plotted for each question   
altq1 <- character(50)
intq1 <- numeric(50)
altq2 <- character(50)
intq2 <- numeric(50)
altq3 <- character(50)
intq3 <- numeric(50)


#######CHOICE RENDERING - CODE CHUNK 1
  
  #q1
    observe({   
    if(input$q1.search>=0)
    
    #Choices - randomized dimensions - choose a dimension     
    c_in <- input$q1.choices; c_options <- list(); c_options <- contact_list[, grepl(c_in, names(contact_list))] 
    updateSelectInput(session, "q1.attribute",
                    choices = c_options, selected=" "                                        
    )} )

    observe({   
    if(input$q1.search>=0)
      
    #Search on the chosen dimension the attribute   
    d_in1 <- input$q1.attribute;  d_in2 <- input$q1.choices; d_options <- list() 
    df <- contact_list[, grepl(d_in2, names(contact_list))]; df <- which(d_in1==df)
    d_options <- contact_list$Name[df]
    #d_options <- contact_list$Name[ which(contact_list[,d_in2]==d_in1) ]
    updateSelectInput(session, "q1.name",
                      choices = d_options, selected=" "                     
    )} )


################################################
  #RESET ALL THE INPUTS AFTER THEY PRESS `apagar' - CODE CHUNK 2
#################################################

    #RESET Q1 after they hit `apagar'
    observe({
      input$q1.reset>=0
  {updateSelectInput(session, "q1.choices",
                     selected=" "                   
  )
  updateSelectInput(session, "q1.attribute",
                    selected=" "                   
  )
  updateSelectInput(session, "q1.name", 
                    selected=" "
  )
  
  }
    })

  
######INPUT RENDERING - CODE CHUNK 3

  #Q1
  
  q1attribute <- reactive({
    input$q1.attribute
  })
      
  q1name <- reactive({
    input$q1.name
  })


###### DATA RENDERING  - CODE CHUNK 4
  
  dataq1 <- reactive({    
    n.alters <- 1+ input$click.q1
    network(matrix(c( rep(1, n.alters), rep(rep(0, n.alters), n.alters-1 ) ), ncol=n.alters, byrow=T) )     
  })



##### PLOT RENDERING - CODE CHUNK 5
  

  output$plotq1 <- renderPlot({ 
  if(input$click.q1>=0){altq1[input$click.q1+1] <<- input$q1.name; save(altq1, file="altq1.Rdata"); 
                        intq1[input$click.q1+1]<<-input$q1.intensity; save(intq1, file="intq1.Rdata")}  
  plot(dataq1(), vertex.col=c("white", rep("red", input$click.q1) ), vertex.cex=2, edge.lwd=c(intq1[1:input$click.q1]), 
       label=c(" ", altq1[1:input$click.q1] ) )
  })   

output$q1.submit <- renderText({  # the `textout' function must be delivered to the ui section where button is clicked. weird.
  
  #Do all below if submit button is clicked - need to write submission data
  if(input$click.q1>=0){
    results[input$click.q1+1, 1:4] <<-c(input$ego.info1, input$ego.info2, input$ego.info3, input$ego.info4)
    #need to configure this section to automatically insert the responses to all questions
    results[input$click.q1+1, 5:(4+n.questions*4)] <<- c(input$q1.choices, input$q1.attribute, input$q1.name, input$q1.intensity)
    #save(results, file="surv.results.Rdata")    
  }
  if(input$click.q1>0){paste0("Submitted!")}
})


  ##############
##### OUTPUT RENDERING ###############################################
  #################
  #Write out files here - when the user clicks `submit', it submits the data in the text box
  output$intro.submit <- renderText({  # the `textout' function must be delivered to the ui section where button is clicked. weird.
    
    #Do all below if submit button is clicked - need to write submission data
    if(input$click.intro>0){            
      old_results <- drop_read_csv("Documents/Survey Results/survey_results.csv") #get existing matrix
      write.table(old_results, file="survey_results.csv", sep=",", row.names=F) #put it in the file so that it exists
      
      paste0("Thanks! Proceed.")
    }
  })


#It seems this section can remain unchanged-------
output$finalsubmit <- renderText({
  if(input$finalsubmit>0){
    keep <- apply(results, 1, function(x) sum(nchar(x))!=0 )
    results <- results[keep, ]
    #results <- results[!duplicated(results), ]
    write.table(results, file="survey_results.csv", append=T, sep=",", col.names=F, row.names=T) #Appends results to existing file
    save(results, file="surv.results.Rdata") #backs up results as an RData file
    drop_upload('survey_results.csv', dest='Documents/Survey Results')
    paste0("Submitted! Thanks!")}
})


})
