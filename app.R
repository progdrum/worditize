library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Get a Quick Text Analysis of a Classic Book"),
   
   # Sidebar with a file input with text to analyze 
   sidebarLayout(
      sidebarPanel(
        # Start with my basic crime and punishment test
        actionButton("generate", "GO!")
      ),
      
      # Show the analysis
      mainPanel(
        plotOutput("count_plt")
      )
   )
)

server <- function(input, output) {
  source("analyze.R")
  
  # Respond to the button and generate the analysis
  observeEvent(input$generate, {
    txt <- get_book("Crime and Punishment")
    tidy_book <- process_text(txt)
    output$count_plt <- renderPlot({
      word_counts(tidy_book)
    })
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

