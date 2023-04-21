
# How does leaflet work? --------------------------------------------------

library(leaflet)

oxford <-
  data.frame(
    lat = c(51.754474, 51.758900),
    lng = c(-1.260699, -1.259626),
    label = c("White Rabbit Pizza Restaurant", "Department of Statistics"),
    popup = c("Where all the tasty pizza comes from!", "The home of OxfordR!")
  )

leaflet(oxford) %>%
  addTiles() %>%
  addMarkers(lat = ~lat,
             lng = ~lng,
             label = ~label,
             popup = ~popup)


# What's a nested data frame? ---------------------------------------------

library(dplyr)

# nest
leaflet_data <-
  openairmaps::polar_data %>%
  nest_by(lat, lon) %>%
  mutate(
    path = paste0(lat, "_", lon, ".png"),
    plot = list(openair::polarPlot(data, plot = FALSE)$plot)
  )

# save
purrr::walk2(
  .x = leaflet_data$path,
  .y = leaflet_data$plot,
  .f = ~{
    png(.x)
    plot(.y)
    dev.off()
  }
)

# map
leaflet(leaflet_data) %>%
  addTiles() %>%
  addMarkers(
    icon = ~ makeIcon(
      path,
      iconWidth = 200,
      iconHeight = 200,
      iconAnchorX = 100,
      iconAnchorY = 100
    )
  )
 