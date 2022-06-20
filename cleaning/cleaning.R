
# Setting-up --------------------------------------------------------------

packages = c("devtools",
             "usethis",
             "here",
             "readr",
             "readxl",
             "tidyverse",
             "tidylog",
             "lubridate",
             "ggplot2",
             "tidylog",
             "ggplotgui",
             "ggthemes",
             "scales",
             "gapminder",
             "PNWColors",
             "arsenal",
             "knitr",
             "rmarkdown",
             "tinytex",
             "kableExtra",
             "texreg",
             "flextable",
             "tableone",
             "gt",
             "gtsummary",
             "bookdown",
             "rmdformats",
             "rticles",
             "bslib",
             "thematic",
             "pagedown",
             "xaringan",
             "xaringanExtra",
             "xaringanthemer",
             "blogdown",
             "distill")
package.check <- lapply(packages, FUN = function(x){
  if (!require(x, character.only = TRUE)){
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE)
  }
})

#install_tinytex()

getwd()
rm(list=ls())

# Data import -------------------------------------------------------------

data <- read_csv("input/analysis_data.csv")

data %>% glimpse()

col <- data %>% colnames()

# Table 1 -------------------------------------------------------------------

vars <- c("phase",
          "intervention",
          "grants_cat",
          "citation_number",
          "patients",
          "statistician",
          "consort",
          "interation_pair",
          "interaction_outcome",
          "pre_registration",
          "non_linear_regression",
          "method",
          "multiplicity",
          "sugbroup_significance",
          "spin",
          "interpretation",
          "methodology")
factorVars <- c("phase",
                "intervention",
                "grants_cat",
                "statistician",
                "consort",
                "interaction_outcome",
                "non_linear_regression",
                "method",
                "multiplicity",
                "sugbroup_significance",
                "spin",
                "interpretation",
                "methodology")
table1 <- CreateTableOne(vars = vars,
                         data = data,
                         includeNA = TRUE,
                         factorVars = factorVars)
table1 %>% 
  print(nonnormal = c("citation_number",
                      "patients",
                      "interation_pair")) %>% 
  write.csv("table1.csv")

# Table 2 -----------------------------------------------------------------

data2 <- data %>% 
  mutate(methodology = if_else(methodology == 2 | methodology == 0, 0, 1))  

table2 <- CreateTableOne(vars = vars,
                         data = data2,
                         includeNA = FALSE,
                         strata = "methodology",
                         factorVars = factorVars)
table2 %>% 
  print(nonnormal = c("citation_number",
                      "patients",
                      "interation_pair"))  %>% 
  write.csv("table2.csv")
