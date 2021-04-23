# packages ----
if (!require(librarian)){
  install.packages("librarian")
  library(librarian)
}
shelf(
  dplyr, glue, highcharter, knitr, purrr, readr, rmarkdown, stringr, tibble, tidyr)

# variables ----
icons_to_data_csv <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vSAROGVpYB58Zkr8P0iwJdTMRPNLZtJ07IyUn-dQ62C2HMuCEScyl8x7urCD7QbRXQYSIJwDn_wku9G/pub?gid=0&single=true&output=csv"

# create modals ----
icons_to_data <- read_csv(icons_to_data_csv, col_types = cols()) %>% 
  mutate(across(is_logical, replace_na, F)) %>% 
  filter(!manual_modal) %>% 
  arrange(icon)

expand_modal <- function(icon, title, data, provider_link, caption, source, y_label, ...){

  out   <- glue::glue("modals/{icon}.html")
  message(out)

  SecondYAxis = "nothing"
            
  if (icon == "stonecrab"){
    y_label = 'Stone Crab Pounds Landed'
    SecondYAxis = 'Stone Crab Trips'
  } 
                        
  if (icon == "lobster"){
    y_label = 'Lobster Landings (Pounds)'
    SecondYAxis = 'Lobster Trips'
  }
  
  knitr::knit_expand(
    file          = "_infographic_modal_template.html", 
    icon          = icon,
    title         = title, # caption <- ifelse(is.na(caption), title, caption),
    data_link     = data,
    caption       = caption,
    source        = source,
    provider_link = provider_link,
    y_label       = ifelse(!is.na(y_label) && trim(y_label) != "?", y_label, ""),
    threshold_year = 2011,
    YAxisTitle2 = SecondYAxis, 
    twoYAxes = ifelse(icon == "stonecrab" | icon == "lobster", 'true', 'false'), 
    SST = ifelse(icon == "SST", 'true', 'false')) %>% 
    writeLines(out) 
}

icons_to_data %>% pwalk(expand_modal)
  
