library(shiny)
source('coocurNet.R')
source('cooccur.R')
library(igraph)
library(tidyverse)
  
ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        fileInput("file1", "Choose .txt File",
                  accept = c(
                    "text/plain",
                    ".txt")
        ),
        tags$hr(),
      # Button to download data 
      tags$h6('Download formatted data'),
      downloadButton("downloadData", "Download")),
      mainPanel(
        tags$style(type="text/css",
                   ".shiny-output-error { visibility: hidden; }",
                   ".shiny-output-error:before { visibility: hidden; }"), # hide red error messages
        headerPanel("Visualize the coocurrence network of any text!", windowTitle = "coocurNet"),
        tags$h6("Created by", tags$a(href="https://hello.csqsiew.xyz/", "CS"), align="left"),
        tags$hr(),
        fluidRow(
          column(9,
                 plotOutput("plot") # to display the network plot 
                 ),
         ),
        tags$p('Note:'),
        tags$p('If your text data does not work, make sure that (i) it is a .txt file, (ii) there is no rich text formatting and (iii) add an extra hard return on the last line.'),
        tags$p('You can download a simple edge list of this network.')
      )
    )
  )
  
server <- function(input, output) {

    output$plot <- renderPlot({ # network plot here 
      inFile <- input$file1
      
        if (is.null(inFile)) {
          return(NULL) }
      
      network_plot <- coocurNet(inFile$datapath)
      par(mar=c(1,1,1,1))
      plot(network_plot, vertex.color = 'gold', vertex.size = 7, vertex.frame.color = 'white', layout = layout_with_fr, edge.color = 'darkgrey')
    })
      
      # code snippet to get data into a downloadable form 
      # Reactive value for selected dataset ----
      datasetInput <- reactive({
        inFile <- input$file1
        coocurNet(inFile$datapath)
      })
      # Downloadable csv of selected dataset ----
      output$downloadData <- downloadHandler(
        filename = function() {
          paste('output', ".csv", sep = "")
        },
        content = function(file) {
          out_graph <- as_edgelist(graph = datasetInput()) # saves the edge list of the network, unweighted 
          write.csv(out_graph, file, row.names = FALSE)
        }
      )
 }

shinyApp(ui, server)

