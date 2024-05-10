library(shiny)
library(dplyr)
library(ggplot2)

# Duomenų įkėlimas (pritaikykite savo aplinkai)
data <- readRDS("../data/kaunas15.rds")

# Unikalios įmonės
companies <- unique(data$name)

# Shiny aplikacijos karkasas
ui <- fluidPage(
  titlePanel("Atlyginimų dinamika"),
  sidebarLayout(
    sidebarPanel(
      selectInput("company", "Pasirinkite įmonę:", choices = companies)
    ),
    mainPanel(
      plotOutput("salary_plot"),
      plotOutput("avg_salary_plot")
    )
  )
)

server <- function(input, output) {
  # Pasirinktos įmonės duomenys
  selected_data <- reactive({
    filter(data, name == input$company)
  })
  
  # Atlyginimų dinamikos grafikas
  output$salary_plot <- renderPlot({
    ggplot(selected_data(), aes(x = month, y = avgWage)) +
      geom_line() +
      labs(title = paste("Atlyginimų dinamika įmonėje", input$company),
           x = "Mėnuo",
           y = "Vidutinis atlyginimas")
  })
}

shinyApp(ui = ui, server = server)
