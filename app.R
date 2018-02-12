library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   titlePanel("Get a Quick Text Analysis of a Classic Book"),
   sidebarLayout(
      sidebarPanel(
        textInput("book", "Enter the name of a book to analyze"),
        actionButton("gotime", "Go!")
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
  
  # Respond to the button and generate the analysis
  observeEvent(input$gotime, {
    txt <- get_book(input$book)
    tidy_book <- process_text(txt)
    output$plt <- renderPlot({word_counts(tidy_book)})
    output$sent <- renderPlot({sentiment_counts(tidy_book)})
    output$soon <- renderText({"Some really cool things are about to happen here!"})
  })
}

shinyApp(ui = ui, server = server)
