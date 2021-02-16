# packages ----
if (!require(librarian)){
  install.packages("librarian")
  library(librarian)
}
shelf(
  dplyr, glue, highcharter, purrr, readr, rmarkdown, tibble)

# variables ----
# edit icons_to_data: https://docs.google.com/spreadsheets/d/1_o8HOiZ_35uajupEsw6xLSsneTBTeLh0bqvFQvMpBNY/edit#gid=0
icons_to_data_csv <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vSAROGVpYB58Zkr8P0iwJdTMRPNLZtJ07IyUn-dQ62C2HMuCEScyl8x7urCD7QbRXQYSIJwDn_wku9G/pub?gid=0&single=true&output=csv"

# create modals ----
icons_to_data <- read_csv(icons_to_data_csv) %>% 
  arrange(icon)

icons_to_data %>% 
  # filter(icon %in% c("registered-vessels", "calcification", "black-grouper", "beach-closures")) %>% 
  filter(icon %in% c("resident-population")) %>% 
  pwalk(
    function(icon, title, data, y_label, ...){
      
      out   <- glue("modals/{icon}.html")
      message(glue("{icon}: {csv}"))
      
      year_max <- read_csv(csv) %>% 
        select(1) %>% 
        pull() %>% 
        max()
      
      knitr::knit_expand(
        file       = "_infographic_modal_template.html", 
        icon       = icon,
        title      = title,
        csv        = csv,
        y_label    = y_label,
        year_max   = year_max, 
        years_band = 5) %>% 
        writeLines(out) })
  
