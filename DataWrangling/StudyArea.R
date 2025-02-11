# https://tigerweb.geo.census.gov/tigerwebmain/TIGERweb_restmapservice.html

# install.packages("arcgislayers")
# install.packages("mapview")
library(arcgislayers)
library(mapview)
library(tidyverse)
library(dplyr)
library(sf)

Pennsylvania_blockgroup <- arcgislayers::arc_read("https://tigerweb.geo.census.gov/arcgis/rest/services/TIGERweb/Tracts_Blocks/MapServer/5",
                                            where = "STATE = '42'")
Philly_blockgroup <- Pennsylvania_blockgroup %>%
  dplyr::filter(COUNTY == 101)
mapview::mapview(Philly_blockgroup)
# Save as a shapefile
st_write(Philly_blockgroup, "data/Philly_blockgroup.shp", driver = "ESRI Shapefile")

StudyArea_blockgroup_tract <- Philly_blockgroup %>%
  filter(GEOID %in% c("421010376002","421010376001","421010376002","421010376003",
                      "421010003003", "421010002002", "421010002001","421010002003", "421010002004",
                      "421010125013", "421010125014")) %>%
  dplyr::select(GEOID, STATE, COUNTY, TRACT, NAME, OBJECTID, geometry)
st_write(StudyArea_blockgroup_tract, "data/StudyArea_blockgroup_tract.shp", driver = "ESRI Shapefile")

StudyArea <- StudyArea_blockgroup_tract %>%
  st_union()
mapview::mapview(StudyArea_blockgroup_tract)
st_write(StudyArea, "data/StudyArea.shp", driver = "ESRI Shapefile")