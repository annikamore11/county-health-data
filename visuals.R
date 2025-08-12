library(shiny)
library(leaflet)
library(tigris)
library(sf)
library(dplyr)
library(htmltools)
#source("health_data.R")

# Get county shapes
options(tigris_use_cache = TRUE)
county_shapes <- counties(cb = TRUE, year = 2023, class = "sf") %>%
  mutate(fips = paste0(STATEFP, COUNTYFP))

# Merge with your data
county_map_data <- county_shapes %>%
  left_join(full_measures, by = "fips")

# Choose the numeric variables you want in the dropdown
measure_choices <- c(
  "% Uninsured" = "pct_uninsured",
  "% Poor Health" = "pct_poor_health",
  "% Obese Adults" = "pct_obese_adults",
  "Life Expectancy" = "life_exectancy",
  "Years of Potential Life Lost Rate" = "years_pot_life_lost_rate"
)

# Shiny app
ui <- fluidPage(
  titlePanel("County Health Measures Map"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("measure", "Select Measure:",
                  choices = measure_choices,
                  selected = "pct_uninsured")
    ),
    mainPanel(
      leafletOutput("map", height = "800px")
    )
  )
)

server <- function(input, output, session) {
  
  output$map <- renderLeaflet({
    leaflet(county_map_data) %>%
      addProviderTiles(providers$CartoDB.Positron)
  })
  
  observe({
    # Get current measure name
    measure <- input$measure
    
    # Create color palette
    pal <- colorNumeric("YlOrRd", domain = county_map_data[[measure]], na.color = "transparent")
    
    # Update map polygons
    leafletProxy("map", data = county_map_data) %>%
      clearShapes() %>%
      clearControls() %>%
      addPolygons(
        fillColor = ~pal(county_map_data[[measure]]),
        weight = 0.5,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlightOptions = highlightOptions(
          weight = 2,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE
        ),
        label = ~paste0(
          county, ", ", state, "<br>",
          input$measure, ": ", round(county_map_data[[measure]], 1)
        ) %>% lapply(htmltools::HTML),
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"
        )
      ) %>%
      addLegend(
        pal = pal,
        values = county_map_data[[measure]],
        opacity = 0.7,
        title = names(measure_choices[measure_choices == measure]),
        position = "bottomright"
      )
  })
}

shinyApp(ui, server)

