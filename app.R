library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   titlePanel("Get a Quick Text Analysis of a Classic Book"),
   sidebarLayout(
      sidebarPanel(
        textInput("book", "Enter the name of a book to analyze")
      ),
      mainPanel(
        tabsetPanel(
          id = "analyses",
          tabPanel("Top N", plotOutput("plt")),
          tabPanel("Sentiments", plotOutput("sent")),
          tabPanel("Topic Analysis", textOutput("soon"))
        )
      )
   )
)

server <- function(input, output) {
  source("analyze.R")
  txt <- get_book("Crime and Punishment")
  tidy_book <- process_text(txt)
  
  # Respond to the button and generate the analysis
  observeEvent(input$analyses, {
    output$plt <- renderPlot({word_counts(tidy_book)})
    output$sent <- renderPlot({sentiment_counts(tidy_book)})
    output$soon <- renderText({"Some really cool things are about to happen here!"})
  })
}

shinyApp(ui = ui, server = server)
