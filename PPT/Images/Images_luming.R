library(ggplot2)
library(sf)
library(tidyverse)


landuse <- st_read("E:/Spring/Practicum/DataAnalysis/Chinatown/Dataset/landuse_clip/Land_Use_ClipLayer.shp") %>%
  st_transform('EPSG:2272')

discontinuity <- st_read("E:/Spring/Practicum/DataAnalysis/Chinatown/Dataset/studyarea-sub/discontinuity.shp") %>%
  st_transform('EPSG:2272')

Chinatown_Stitch <- st_read("E:/Spring/Practicum/DataAnalysis/Chinatown/Dataset/Chinatown_Stitch/Chinatown_Stitch.shp") %>%
  st_transform('EPSG:2272')

p1_2 <- ggplot() +
  geom_sf(data = landuse, fill = "transparent", color = "gray85", size = 0.05) +
  # geom_sf(data = studyarea, fill = "transparent", color = "grey", linetype = "dashed", linewidth = 2) +
  # geom_sf(data = discontinuity, fill = "#eb5600", color = "transparent") +
  # geom_sf(data = Chinatown_Stitch, fill = "#1a9988", alpha = 0.8) +
  theme_void()
ggsave(filename = "E:/Spring/Practicum/DataAnalysis/Chinatown/PPT/Images/p1-2.png", plot = p1_2, height = 5, width = 10, units = "in", dpi = 300)

p <- ggplot() +
  # geom_sf(data = landuse, fill = "white", color = "gray85", size = 0.05) +
  # geom_sf(data = studyarea, fill = "transparent", color = "grey", linetype = "dashed", linewidth = 2) +
  geom_sf(data = discontinuity, fill = "#eb5600", color = "transparent") +
  geom_sf(data = Chinatown_Stitch, fill = "#1a9988", alpha = 0.8) +
  theme_void()
ggsave(filename = "E:/Spring/Practicum/DataAnalysis/Chinatown/PPT/Images/p1.png", plot = p, height = 5, width = 10, units = "in", dpi = 300)