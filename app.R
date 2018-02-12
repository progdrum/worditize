library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Get a Quick Text Analysis of a Classic Book"),
   
   # Sidebar with a file input with text to analyze 
   sidebarLayout(
      sidebarPanel(
        # A selector for choosing the kind of analysis to display
        selectInput("analyses", "Select One",
                    choices = c("Top 10 Words", "Sentiment Analysis"))
      ),
      
      # Show the analysis
      mainPanel(
        plotOutput("count_plt")
      )
   )
)

server <- function(input, output) {
  source("analyze.R")
  txt <- get_book("Crime and Punishment")
  tidy_book <- process_text(txt)
  
  # Respond to the button and generate the analysis
  observeEvent(input$analyses, {
    output$count_plt <- renderPlot({
      if("Top 10 Words" %in% input$analyses) {
        return(word_counts(tidy_book))
      } else if("Sentiment Analysis" %in% input$analyses) {
        return(sentiment_counts(tidy_book))
      }
    })
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
