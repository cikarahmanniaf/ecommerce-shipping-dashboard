library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinythemes)
library(DT)  # For interactive tables
library(ggplot2)
library(corrplot)
library(dplyr)

shipping_data <- read.csv("e-comshipdata.csv", 
                          sep = ",", header = TRUE)

numeric_vars <- c("Customer_care_calls", "Cost_of_the_Product", "Prior_purchases", "Discount_offered", "Weight_in_gms")
categorical_vars <- c("Warehouse_block", "Mode_of_Shipment", "Customer_rating", "Product_importance", "Gender", "Reached.on.Time_Y.N")

# UI (User Interface)
ui <- dashboardPage(
  dashboardHeader(title = "E-Commerce Shipping Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Descriptive Statistics I", tabName = "statistics1", icon = icon("chart-bar")),
      menuItem("Descriptive Statistics II", tabName = "statistics2", icon = icon("line-chart")),
      menuItem("Insight Cards", tabName = "cards", icon = icon("table"))
    )
  ),
  dashboardBody(
    tabItems(
      # Tab Home
      tabItem(tabName = "home",
              fluidPage(
                theme = shinytheme("sandstone"),  
                box(
                  title = "Welcome to the Dashboard",
                  status = "primary",
                  solidHeader = TRUE,
                  width = 12,
                  h2("E-Commerce Shipping Dashboard", align = "center", style = "color: #2C3E50; font-weight: bold;"),
                  p("The dashboard provides key data insights, descriptive statistics, and visualizations.",
                    align = "center", style = "color: #7F8C8D; font-size: 15px; font-style: italic;")
                ),
                box(
                  title = "Dataset Information", 
                  status = "warning", 
                  solidHeader = TRUE, 
                  width = 12,
                  p(paste("This dataset consists of", nrow(shipping_data), "observations and 12 variables:"),
                    style = "color: #7F8C8D;"),
                  tags$ul(
                    tags$li("ID: Unique identifier for customers."),
                    tags$li("Warehouse Block: Divided into blocks A, B, C, D, and E."),
                    tags$li("Mode of Shipment: Shipping methods - Ship, Flight, or Road."),
                    tags$li("Customer Care Calls: Number of calls made for shipment inquiries."),
                    tags$li("Customer Rating: Rating given by customers (1-5)."),
                    tags$li("Cost of Product: Product cost in US Dollars."),
                    tags$li("Prior Purchases: Number of prior purchases by the customer."),
                    tags$li("Product Importance: Importance categorized as Low, Medium, or High."),
                    tags$li("Gender: Male or Female."),
                    tags$li("Discount Offered: Discount applied to the product."),
                    tags$li("Weight in Grams: Weight of the product."),
                    tags$li("Reached on Time: Whether the product was delivered on time (1 = Late, 0 = On Time).")
                  )
                ),
                box(
                  title = "Select Columns to Display", 
                  status = "primary", 
                  solidHeader = TRUE, 
                  width = 12,
                  checkboxGroupInput("columns", "Choose columns to display:", 
                                     choices = colnames(shipping_data), 
                                     selected = colnames(shipping_data))
                ),
                box(
                  title = "Dataset Overview", 
                  status = "info", 
                  solidHeader = TRUE, 
                  width = 12,
                  DTOutput("table")
                ),
                hr(),
                p("Oleh: Cika Rahmannia Febrianti (5003221081) | Sumber Dataset: https://www.kaggle.com/datasets/prachi13/customer-analytics/data", 
                  align = "center", style = "color: #BDC3C7; font-size: 14px;")
              )
      ),
      # Tab Descriptive Statistics I
      tabItem(tabName = "statistics1",
              fluidPage(
                box(
                  title = "Select Variable for Visualization", 
                  status = "primary", 
                  solidHeader = TRUE, 
                  width = 12,
                  selectInput("desc_var", "Choose a variable:", 
                              choices = colnames(shipping_data), 
                              selected = numeric_vars[1])
                ),
                box(
                  title = "Descriptive Statistics", 
                  status = "primary", 
                  solidHeader = TRUE,
                  width = 12,
                  DTOutput("desc_stats")
                ),
                box(
                  title = "Visualizations", 
                  status = "primary", 
                  solidHeader = TRUE,
                  width = 12,
                  fluidRow(
                    column(6, plotOutput("histogram"), uiOutput("histogram_note")),
                    column(6, plotOutput("density_plot"), uiOutput("density_note"))
                  ),
                  fluidRow(
                    column(6, plotOutput("countplot"), uiOutput("countplot_note")),
                    column(6, plotOutput("boxplot"), uiOutput("boxplot_note"))
                  )
                )
              )
      ),
      # Tab Descriptive Statistics II
      tabItem(tabName = "statistics2",
              fluidPage(
                box(
                  title = "Scatter Plot Analysis", 
                  status = "primary", 
                  solidHeader = TRUE,
                  width = 12,
                  selectInput("scatter_x", "Choose X-axis:", 
                              choices = colnames(shipping_data), selected = numeric_vars[1]),
                  selectInput("scatter_y", "Choose Y-axis:", 
                              choices = colnames(shipping_data), selected = numeric_vars[2])
                ),
                box(
                  title = "Scatter Plot", 
                  status = "primary", 
                  solidHeader = TRUE,
                  width = 12,
                  plotOutput("scatter_plot")
                ),
                box(
                  title = "Correlation Heatmap", 
                  status = "primary", 
                  solidHeader = TRUE,
                  width = 12,
                  plotOutput("heatmap")
                )
              )
      ),
      # Tab Insight Cards
      tabItem(tabName = "cards",
              fluidPage(
                box(
                  title = "Select Insight Question", 
                  status = "primary", 
                  solidHeader = TRUE, 
                  width = 12,
                  selectInput("summary_question", "Choose a question:", 
                              choices = list(
                                "Which mode of shipment carries most weights?" = "shipment_weight",
                                "Effect of warehouse on cost of product" = "warehouse_cost",
                                "Relation between product importance and discount offered" = "importance_discount",
                                "Which product importance category receives the highest discount?" = "importance_high_discount",
                                "Does gender affect the on-time delivery?" = "gender_delivery",
                                "Which warehouse block has the highest cost per product?" = "warehouse_high_cost",
                                "What is the distribution of customer ratings across different shipment modes?" = "ratings_shipment_modes",
                                "Which weight range contributes most to delayed shipments?" = "weight_delay",
                                "How does the number of customer care calls relate to delivery time?" = "calls_delivery",
                                "What is the relationship between prior purchases and customer ratings?" = "purchases_ratings"
                              ))
                ),
                box(
                  title = "Summary Analysis", 
                  status = "info", 
                  solidHeader = TRUE, 
                  width = 12,
                  uiOutput("summary_output")
                )
              )
      )
    )
  )
)

# Server Logic
server <- function(input, output) {
  # Render the shipping data as an interactive table
  output$table <- renderDT({
    selected_data <- shipping_data[, input$columns, drop = FALSE]
    datatable(selected_data, options = list(pageLength = 10, scrollX = TRUE))
  })
  
  # Descriptive statistics table
  output$desc_stats <- renderDT({
    stats <- data.frame(
      Variable = numeric_vars,
      Mean = sapply(shipping_data[, numeric_vars], mean, na.rm = TRUE),
      Median = sapply(shipping_data[, numeric_vars], median, na.rm = TRUE),
      Variance = sapply(shipping_data[, numeric_vars], var, na.rm = TRUE),
      SD = sapply(shipping_data[, numeric_vars], sd, na.rm = TRUE),
      Min = sapply(shipping_data[, numeric_vars], min, na.rm = TRUE),
      Max = sapply(shipping_data[, numeric_vars], max, na.rm = TRUE)
    )
    datatable(stats, options = list(pageLength = 10, scrollX = TRUE))
  })
  
  # Plot: Histogram
  output$histogram <- renderPlot({
    req(input$desc_var)
    if (input$desc_var %in% numeric_vars) {
      ggplot(shipping_data, aes_string(x = input$desc_var)) + 
        geom_histogram(bins = 30, fill = "blue", color = "black", alpha = 0.7) +
        ggtitle(paste("Histogram of", input$desc_var)) +
        theme_minimal()
    }
  })
  
  # Plot: Density
  output$density_plot <- renderPlot({
    req(input$desc_var)
    if (input$desc_var %in% numeric_vars) {
      ggplot(shipping_data, aes_string(x = input$desc_var)) + 
        geom_density(fill = "green", alpha = 0.6) +
        ggtitle(paste("Density Plot of", input$desc_var)) +
        theme_minimal()
    }
  })
  
  # Plot: Countplot
  output$countplot <- renderPlot({
    req(input$desc_var)
    if (input$desc_var %in% categorical_vars) {
      ggplot(shipping_data, aes_string(x = input$desc_var)) + 
        geom_bar(fill = "purple", color = "black") +
        ggtitle(paste("Count Plot of", input$desc_var)) +
        theme_minimal()
    }
  })
  
  # Plot: Boxplot
  output$boxplot <- renderPlot({
    req(input$desc_var)
    if (input$desc_var %in% numeric_vars) {
      ggplot(shipping_data, aes_string(y = input$desc_var)) +
        geom_boxplot(fill = "orange", color = "black") +
        ggtitle(paste("Boxplot of", input$desc_var)) +
        theme_minimal()
    }
  })
  
  # Notes for invalid plots
  output$histogram_note <- renderUI({
    if (!(input$desc_var %in% numeric_vars)) {
      HTML("<p style='color:red;'>Histogram only available for numeric variables.</p>")
    }
  })
  
  output$density_note <- renderUI({
    if (!(input$desc_var %in% numeric_vars)) {
      HTML("<p style='color:red;'>Density plot only available for numeric variables.</p>")
    }
  })
  
  output$countplot_note <- renderUI({
    if (!(input$desc_var %in% categorical_vars)) {
      HTML("<p style='color:red;'>Count plot only available for categorical variables.</p>")
    }
  })
  
  output$boxplot_note <- renderUI({
    if (!(input$desc_var %in% numeric_vars)) {
      HTML("<p style='color:red;'>Boxplot only available for numeric variables.</p>")
    }
  })
  
  # Scatter Plot
  output$scatter_plot <- renderPlot({
    req(input$scatter_x, input$scatter_y)
    ggplot(shipping_data, aes_string(x = input$scatter_x, y = input$scatter_y)) + 
      geom_point(color = "blue") +
      ggtitle("Scatter Plot") +
      theme_minimal()
  })
  
  # Correlation Heatmap
  output$heatmap <- renderPlot({
    correlation_matrix <- cor(shipping_data[, numeric_vars], use = "complete.obs")
    corrplot(correlation_matrix, method = "color", type = "lower", order = "hclust", tl.col = "black", addCoef.col = "black")
  })
  # Render summary analysis output
  output$summary_output <- renderUI({
    req(input$summary_question)
    
    switch(input$summary_question,
           shipment_weight = plotOutput("shipment_weight_plot"),
           warehouse_cost = plotOutput("warehouse_cost_plot"),
           importance_discount = plotOutput("importance_discount_plot"),
           importance_high_discount = DTOutput("importance_high_discount_table"),
           gender_delivery = plotOutput("gender_delivery_plot"),
           warehouse_high_cost = plotOutput("warehouse_high_cost_plot"),
           ratings_shipment_modes = plotOutput("ratings_shipment_modes_plot"),
           weight_delay = plotOutput("weight_delay_plot"),
           calls_delivery = plotOutput("calls_delivery_plot"),
           purchases_ratings = plotOutput("purchases_ratings_plot")
    )
  })
  # Individual output logic for each summary question
  output$shipment_weight_plot <- renderPlot({
    ggplot(shipping_data, aes(x = Mode_of_Shipment, y = Weight_in_gms, fill = Mode_of_Shipment)) +
      geom_bar(stat = "identity") +
      ggtitle("Total Weight by Mode of Shipment") +
      theme_minimal()
  })
  
  output$warehouse_cost_plot <- renderPlot({
    ggplot(shipping_data, aes(x = Warehouse_block, y = Cost_of_the_Product, fill = Warehouse_block)) +
      geom_boxplot() +
      ggtitle("Cost of Product by Warehouse Block") +
      theme_minimal()
  })
  
  output$importance_discount_plot <- renderPlot({
    ggplot(shipping_data, aes(x = Product_importance, y = Discount_offered, fill = Product_importance)) +
      geom_boxplot() +
      ggtitle("Discount Offered by Product Importance") +
      theme_minimal()
  })
  
  output$importance_high_discount_table <- renderDT({
    high_discount <- shipping_data %>%
      group_by(Product_importance) %>%
      summarize(Average_Discount = mean(Discount_offered)) %>%
      arrange(desc(Average_Discount))
    datatable(high_discount)
  })
  output$gender_delivery_plot <- renderPlot({
    ggplot(shipping_data, aes(x = Gender, fill = as.factor(Reached.on.Time_Y.N))) +
      geom_bar(position = "fill") +
      labs(y = "Proportion", fill = "On-Time Delivery") +
      ggtitle("Delivery Timeliness by Gender") +
      theme_minimal()
  })
  
  output$warehouse_high_cost_plot <- renderPlot({
    ggplot(shipping_data, aes(x = Warehouse_block, y = Cost_of_the_Product, fill = Warehouse_block)) +
      geom_col(stat = "summary", fun = mean) +
      ggtitle("Average Cost per Product by Warehouse Block") +
      theme_minimal()
  })
  
  output$ratings_shipment_modes_plot <- renderPlot({
    ggplot(shipping_data, aes(x = Mode_of_Shipment, fill = as.factor(Customer_rating))) +
      geom_bar(position = "stack") +
      ggtitle("Customer Ratings by Shipment Mode") +
      theme_minimal()
  })
  
  output$weight_delay_plot <- renderPlot({
    ggplot(shipping_data %>% filter(Reached.on.Time_Y.N == 1),
           aes(x = Weight_in_gms)) +
      geom_histogram(fill = "red", bins = 30) +
      ggtitle("Weight Distribution for Delayed Shipments") +
      theme_minimal()
  })
  output$calls_delivery_plot <- renderPlot({
    ggplot(shipping_data, aes(x = Customer_care_calls, fill = as.factor(Reached.on.Time_Y.N))) +
      geom_bar(position = "dodge") +
      labs(fill = "On-Time Delivery") +
      ggtitle("Customer Care Calls vs Delivery Timeliness") +
      theme_minimal()
  })
  
  output$purchases_ratings_plot <- renderPlot({
    ggplot(shipping_data, aes(x = Prior_purchases, y = Customer_rating)) +
      geom_point() +
      geom_smooth(method = "lm", se = FALSE, color = "blue") +
      ggtitle("Prior Purchases vs Customer Ratings") +
      theme_minimal()
  })
}

shinyApp(ui = ui, server = server)
