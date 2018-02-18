library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("sandstone"),
                navbarPage(
                  "Analyzing the Classics",
                  tabPanel("Counts and Feels",
                           sidebarLayout(
                             sidebarPanel(
                               textInput("book", "Enter the name of a book to analyze"),
                               actionButton("gotime", "Go!")
                             ),
                             mainPanel(tabsetPanel(
                               id = "analyses",
                               tabPanel("Top N", plotOutput("plt")),
                               tabPanel("Sentiments", plotOutput("sent"))
                             ))
                           )),
                  tabPanel("Topics",
                           sidebarLayout(
                             sidebarPanel(
                               textInput("book1", "Enter the name of the first book to compare."),
                               textInput("book2", "Enter the name of the second book to compare."),
                               actionButton("topics", "Get Topics")
                             ),
                             mainPanel("Topic Analysis", textOutput("soon"))
                           ))
                ))

server <- function(input, output) {
  source("analyze.R")
  
  # Generate analyses for "counts and feels"
  observeEvent(input$gotime, {
    txt <- get_book(input$book)
    tidy_book <- process_text(txt)
    output$plt <- renderPlot({
      word_counts(tidy_book)
    })
    output$sent <- renderPlot({
      sentiment_counts(tidy_book)
    })
  })
  
  # Generate analysis for "topics"
  observeEvent(input$topics, {
    output$soon <-
      renderText({
        "Some really cool things are about to happen here!"
      })
  })
}

shinyApp(ui = ui, server = server)
