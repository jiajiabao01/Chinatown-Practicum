library(sf)
library(tidyverse)
library(ggplot2)

assessment <- st_read('Dataset/property/assessments.csv')
assessment_2025 <- assessment %>%
  filter(year == 2025)
assessment_2024 <- assessment %>%
  filter(year == 2024)
studyarea <- st_read("Dataset/studyarea/StudyArea.shp") %>%
  st_transform('EPSG:2272')
property <- st_read("DataWrangling/data/opa_properties_public.geojson") %>%
  st_transform('EPSG:2272')
landuse <- st_read("Dataset/landuse_clip/Land_Use_ClipLayer.shp") %>%
  st_transform('EPSG:2272')


assessment_geom <- left_join(assessment_unique, property[, c("parcel_number", "geometry", "sale_price")], by = "parcel_number")
property_marketvalue <- left_join(property, assessment_unique[, c("parcel_number", "market_value")], by = "parcel_number")
property_marketvalue_organized <- property_marketvalue %>%
  select(market_value.y, objectid) %>%
  rename(market_value_2025 = market_value.y)

write.csv(property_marketvalue_organized, "Dataset/property/property_marketvalue_2025.csv", row.names = FALSE)

property_marketvalue_check <- property_marketvalue %>%
  filter(market_value.x != as.numeric(market_value.y)) %>%
  select(market_value.x, market_value.y, sale_price)
property_marketvalue_studyarea <- st_intersection(property_marketvalue, studyarea)
property_marketvalue_studyarea_check <- property_marketvalue_studyarea %>%
  filter(market_value.x != as.numeric(market_value.y)) %>%
  select(market_value.x, market_value.y, sale_price) %>%
  mutate(difference = as.numeric(market_value.y) - market_value.x)



ggplot() +
  geom_sf(data = landuse, fill = "white", color = "gray90", size = 0.05) +
  geom_sf(data = studyarea, fill = "transparent") +
  geom_sf(data = property_marketvalue_studyarea, color = "black") +
  geom_sf(data = property_marketvalue_studyarea_check, color = "red") +
  theme_void()
  
duplicates <- assessment_2025[duplicated(assessment_2025$parcel_number), ]
duplicates_property <- property[duplicated(property$parcel_number), ]
assessment_unique <- assessment_2025[!duplicated(assessment_2025$parcel_number), ]

