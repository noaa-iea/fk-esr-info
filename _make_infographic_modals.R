# packages ----
if (!require(librarian)){
  install.packages("librarian")
  library(librarian)
}
shelf(
  dplyr, glue, highcharter, knitr, purrr, readr, rmarkdown, stringr, tibble, tidyr)

# variables ----
# edit icons_to_data: https://docs.google.com/spreadsheets/d/1_o8HOiZ_35uajupEsw6xLSsneTBTeLh0bqvFQvMpBNY/edit#gid=0
icons_to_data_csv <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vSAROGVpYB58Zkr8P0iwJdTMRPNLZtJ07IyUn-dQ62C2HMuCEScyl8x7urCD7QbRXQYSIJwDn_wku9G/pub?gid=0&single=true&output=csv"

# create modals ----
icons_to_data <- read_csv(icons_to_data_csv, col_types = cols()) %>% 
  mutate(across(is_logical, replace_na, F)) %>% 
  filter(!data_skip) %>% 
  arrange(icon)

expand_modal <- function(icon, title, data, provider_link, caption, source, y_label, ...){
  
  # d <- icons_to_data %>%
  #   filter(icon == "hurricane-coastal-protections")
  # attach(d)
  # detach(d)

  out   <- glue::glue("modals/{icon}.html")
  message(out)
  
  year_max <- 0
  
  if (icon != "hurricane-coastal-protections" && icon != "SST"){ # the data for hurricane coastal protections is totally different than everything else and needs to be handled differently
    if (!is.na(data)){
      d        <- read_csv(data, col_types = cols())
      year_rng <- select(d, 1) %>% pull() %>% range()
      year_max <- year_rng[2]
      nrows    <- nrow(d)
        
      if (diff(year_rng) < (nrow(d) - 1))
        message(glue("  Whoah! More rows (n={nrow(d)}) than years [{paste(year_rng, collapse = ' - ')}]"))
    } 
    else{
      nrows    <- 0
      message(glue("  nrows={nrows}, year_max={year_max}"))
    }
  }

  knitr::knit_expand(
    file          = "_infographic_modal_template.html", 
    icon          = icon,
    title         = gsub('"||\'',"",title), # caption <- ifelse(is.na(caption), title, caption),
    csv           = data,
    caption       = gsub('"||\'',"",caption),
    source        = gsub('"||\'',"", source),
    provider_link = provider_link,
    y_label       = gsub('"||\'',"", ifelse(
      !is.na(y_label) && trim(y_label) != "?",
      y_label,
      "")),
    years_band = 5) %>% 
    writeLines(out) 
}

icons_to_data %>% 
  # filter(icon %in% c("registered-vessels", "calcification", "black-grouper", "beach-closures")) %>% 
  #filter(icon %in% c("resident-population")) %>% 
  #filter(!icon %in% c("SST")) %>% 
  # TODO: SST: summarize by min(temp_min), max(temp_max) and mean(temp_min, temp_max), group_by(year)
  pwalk(expand_modal)
  
