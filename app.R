library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("sandstone"),
                navbarPage(
                  "Analyzing the Classics",
                  tabPanel("Counts and Feels",
                           sidebarLayout(
                             sidebarPanel(
                               selectizeInput("book",
                                              "Select the name of a book to analyze:",
                                              choices = NULL),
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
                               selectizeInput("book1",
                                              "Enter the name of the first book to compare:",
                                              choices = NULL),
                               selectizeInput("book2",
                                              "Enter the name of the second book to compare:",
                                              choices = NULL),
                               sliderInput("topic_slider", "Number of Topics to Find in Books:",
                                           min = 1, max = 10, value = 5),
                               numericInput("top_tops", "N Top Words to Display:",
                                            min = 1, value = 10),
                               selectInput("algorithm", "Select the algorithm to use:",
                                           choices = c("LDA", "Pachinko"),
                                           selected = "LDA"),
                               actionButton("topics", "Get Topics")
                             ),
                             mainPanel(tabsetPanel(
                               id = "topic_analyses",
                               tabPanel("Topic Probabilities", plotOutput("betas")),
                               tabPanel("Document Probabilities", tableOutput("doc_probs"))
                             ))
                           ))
                ))

server <- function(input, output, session) {
  source("analyze.R")
  source("topics.R")
  
  # Keep a list of titles to select from
  book_choices <- gutenberg_metadata$title
  
  # Update the select fields with titles
  updateSelectizeInput(session, "book",
                       choices = book_choices,
                       server = TRUE,
                       options = list(maxOptions = 10,
                                      placeholder = "Select a Document"))
  updateSelectizeInput(session, "book1",
                       choices = book_choices,
                       server = TRUE,
                       options = list(maxOptions = 10,
                                      placeholder = "Select a Document"))
  updateSelectizeInput(session, "book2",
                       choices = book_choices,
                       server = TRUE,
                       options = list(maxOptions = 10,
                                      placeholder = "Select a Document"))
  
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
    pbooks <- process_books(c(input$book1, input$book2))
    
    # Figure out how to selectively work out the models here
    topic_model <- get_books_lda(pbooks, input$topic_slider)

    output$betas <- renderPlot({
      topic_beta_graphs(topic_model, input$top_tops)
    })
    output$doc_probs <- renderTable({
      topic_gamma_info(topic_model)
    })
  })
}

shinyApp(ui = ui, server = server)
