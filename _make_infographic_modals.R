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
  arrange(icon) # View(icons_to_data)

icons_to_data %>% 
  #filter(icon == "black-grouper") %>% 
  # pull(data)
  pwalk(
    function(...){
      row <- tibble(...)
      
      icon  <- row$icon
      out   <- glue("modals/{icon}.html")
      title <- row$title
      csv   <- row$data
      
      message(glue("{icon}: {csv}"))
      
      knitr::knit_expand(
        file  = "_infographic_modal_template.html", 
        icon  = icon,
        title = title,
        csv   = csv) %>% 
        writeLines(out) })
  
