#server
.libPaths(c("/usr/lib64/R/shiny_library", .libPaths()))
# appFrame_lib_loc(wd = getwd())
library(appFrame)
library(shiny)
library(ggplot2)
#library(reshape2)
library(grid)
library(scales)
library(dplyr)
#library(mail) #for sending email

options(shiny.sanitize.errors = FALSE)
#options(error=browser) # debugging
source("external/serverHead.R")

shinyServer(
  function(input, output, session) {    
    source("external/explorer/explorer.R", local=T)  
     })

