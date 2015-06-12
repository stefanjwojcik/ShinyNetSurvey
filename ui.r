
# Define UI for application that draws a histogram
shinyUI(navbarPage("Study of Legislative Networks",
                        
############################ INTRODUCTION                   
  tabPanel("Welcome",     
    titlePanel("Legislative Network Survey") ,
    sidebarLayout(      
      sidebarPanel(
        h4("Please fill out the boxes below:"),
        textInput("ego.info1", "Office Number", ""),
        textInput("ego.info2", "Building Number", ""),
        textInput("ego.info3", "Name of Deputy", ""),
        textInput("ego.info4", "Name of Participant", ""),
        
        br(),
        br(),
        actionButton("click.intro", "Submit"),
        textOutput("intro.submit")  #This appears to be a requirement in order to get the output file to submit
      ),
      
      # Put consent information here
      mainPanel(                
        img(src="consent1.png", height=720 , width=1280),
        img(src="consent2.png", height=720 , width=1280)
      )
    )
           ),

####################### FIRST QUESTION  
  tabPanel("Question 1",
  # Application title
  titlePanel(
    h2("Communication Ties")),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      h4("Search using the tools below:"),       
      selectInput("q1.choices", "Search By:",
                  sample(colnames(contact_list)), selected=" "),
      #h4("Ou Aqui"),

      selectInput("q1.attribute", "Select Attribute:",
                  sort(contact_list$State), selected=" "),
      #h4("Ou Aqui"),
      actionButton("q1.search", "Search"),
      actionButton("q1.reset", "Clear"),
      
      br(),
      br(),
      p("Select a name:"),
      selectInput("q1.name", "Name:",
                  sort(contact_list$Name), selected=" "),
      sliderInput("q1.intensity",
                  "Intensity (10=most intense)",
                  min = 1,
                  max = 10,
                  value = 5),      
      br(),
      br(),
      actionButton("click.q1", "Submit"),
      textOutput("q1.submit"),
      br()
    ),
    # Show a plot of the generated distribution
    mainPanel(
      h3("With whom do you communicate about important legislation?"),
      #img(src="question1.png", height=201/1.5 , width=1511/1.5),
      plotOutput("plotq1")
      )
    )
  ),

###################  Conclusion
tabPanel("Finish and Submit",
         # Application title
         titlePanel("Thanks!"),
         
         # Sidebar with a slider input for the number of bins
         sidebarLayout(
           sidebarPanel(
             #img(src="cu_symbol.png", height=195 , width=389),
             h4("If you have questions, please send an email to: stefan.wojcik@colorado.edu"),
             h4("Or Call: 61-8142-7369")
           ),
           
           # Show a plot of the generated distribution
           mainPanel(
             h2("Thank you for participating in this survey. Please click the button below to finalize your responses."),
             br(),
             actionButton("finalsubmit", "FINALIZE SURVEY"),
             textOutput("finalsubmit")                          
           )
         )
)

))
