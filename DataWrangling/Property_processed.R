# sale price processing
library(sf)
library(tidyverse)
property <- st_read("E:/Spring/Practicum/DataAnalysis/Chinatown/DataWrangling/data/opa_properties_public.geojson") %>%
  st_transform('EPSG:2272')
property_data <- property%>%
  mutate(sale_date = as.Date(sale_date, format = "%Y-%m-%d")) %>%
   filter(sale_date >= as.Date("2020-01-01"))%>%
  filter(!is.na(sale_price))

mean_price <- mean(property_data$sale_price, na.rm = TRUE)
sd_price <- sd(property_data$sale_price, na.rm = TRUE)
extreme_outlier <- mean_price + 5 * sd_price

property_data <- property_data %>%
  filter(sale_price > 30000, sale_price < extreme_outlier)

cpi_data <- st_read("E:/Spring/Practicum/DataAnalysis/Chinatown/Dataset/cpi_data.csv")
colnames(cpi_data) <- c("half1", "half2", "cpi_date")
cpi_long <- cpi_data %>%
  mutate(
    Jan = `half1`, Feb = `half1`, Mar = `half1`, Apr = `half1`, May = `half1`, Jun = `half1`,
    Jul = `half2`, Aug = `half2`, Sep = `half2`, Oct = `half2`, Nov = `half2`, Dec = `half2`
  ) %>%
  select(-half1, -half2) %>%
  pivot_longer(cols = -cpi_date, names_to = "Month", values_to = "CPI") %>%
  mutate(
    Month = match(Month, month.abb),
    date = as.Date(paste(cpi_date, Month, "01", sep = "-"))  
  ) %>%
  select(date, CPI)

property_data <- property_data %>%
  filter(sale_date <= as.Date("2024-12-31"))%>%
  mutate(
    sale_date = as.Date(sale_date, format = "%Y-%m-%d"), 
    sale_month = floor_date(sale_date, "month"))%>%
  left_join(cpi_long, by = c("sale_month" = "date"))%>%
  mutate(CPI = as.numeric(CPI))%>%
  mutate(adj_sale_price = sale_price * (340.331/CPI)) %>%
  select(-sale_month)%>%
  select(-recording_date,  -other_building, 
         -assessment_date, -mailing_address_2, -market_value_date)%>%
  relocate(sale_price, adj_sale_price, .after = 2)

property_data <- st_transform(property_data, crs = 2272)