#### Scraping ####
library(rvest)

url <- "https://www.electromaps.com/pt/estacoes-de-carregamento/portugal/porto/porto"

html_page <- read_html(url)

#Find the div class "chargepoints-stations-container"
page_div <- html_page %>%
  html_nodes(xpath='//*[@id="stations"]')

#Find the elements "a" inside the div
page_a <- page_div %>%
  html_nodes("a")

#Extract the classes "chargepoints-stations-text" and "chargepoints-stations-title" for each element
page_a %>%
  html_nodes(xpath='.//div[@class="chargepoints-stations-text"]') %>%
  html_text()

page_a %>%
  html_nodes(xpath='.//div[@class="chargepoints-stations-title"]') %>%
  html_text()

#### Importing GEOJSON ####
library(jsonlite)
library(leaflet)
library(sf)
library(tidyverse)
stations  = jsonlite::fromJSON("C:\\Users\\belokurowsr\\Downloads\\response.json")
stations
df = st_as_sf(x = stations %>% sample_n(11) ,
         coords = c("longitude", "latitude"),
         crs = projcrs)
projcrs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"


rotaTotal = osrmRoute(src = df[1, ], dst = df[2, ],osrm.profile = "car",overview = "full")
for (i in 3:nrow(df)){
  print(i)
  print(df[i,])
  rota = osrmRoute(src = df[1, ], dst = df[i, ],osrm.profile = "car",overview = "full")
  rotaTotal = bind_rows(rotaTotal,rota)
}

leaflet(rotaTotal) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolylines() %>% addTiles()

# pharmacy <- st_read(system.file("gpkg/apotheke.gpkg", package = "osrm"),
#                     quiet = TRUE)
# travel_time <- osrmTable(loc = pharmacy)
# travel_time$durations[1:5,1:5]
# diag(travel_time$durations) <- NA
# median(travel_time$durations, na.rm = TRUE)
# (route <- osrmRoute(src = pharmacy[1, ], dst = pharmacy[2, ]))
# plot(st_geometry(route))
# plot(st_geometry(pharmacy[1:2,]), pch = 20, add = T, cex = 1.5)
# (trips <- osrmTrip(loc = pharmacy[1:5, ], overview = "full"))
# mytrip <- trips[[1]]$trip
# # Display the trip
# plot(st_geometry(mytrip), col = c("black", "grey"), lwd = 2)
# plot(st_geometry(pharmacy[1:5, ]), cex = 1.5, pch = 21, add = TRUE)
# text(st_coordinates(pharmacy[1:5,]), labels = row.names(pharmacy[1:5,]),
#      pos = 2)


df1 <- st_as_sf(x = stations %>% sample_n(1) ,
               coords = c("longitude", "latitude"),
               crs = projcrs)

#### Tabela de distâncias ####
tt = osrmTable(src = df[1, ],dst = df[2:11, ])
tt$durations
tt$durations[which.min(tt$durations)]
df[which.min(tt$durations),]
(route <- osrmRoute(src = df[1, ], dst = df[4, ],osrm.profile = "car",overview = "full"))
leaflet(rota) %>%
  addTiles() %>%
  addPolylines()
