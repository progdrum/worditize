#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Get a Quick Readout of Some Text"),
   
   # Sidebar with a file input with text to analyze 
   sidebarLayout(
      sidebarPanel(
         fileInput("file_select", "Select A File")
      ),
      
      # Show the analysis
      mainPanel()
   )
)

server <- function(input, output) {}

# Run the application 
shinyApp(ui = ui, server = server)

