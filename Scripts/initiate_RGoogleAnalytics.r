# Load requirements to pull data from Google Analytics.

library(RGoogleAnalytics)
library(RColorBrewer)
library(scales)
library(lubridate)
library(ProjectTemplate)
library(ggplot2)
library(gridExtra)
library(plyr)
setwd("C:/Users/m.parzakonis/Google Drive/MyCodeRants/")

# CONNECT AND QUERY -----------------------------------------------------------

# Let's initiate a query instance to do the job
query <- QueryBuilder()

# Open Google's OAuth Playground in the default browser.
# You will need to exchange your Authorization Code for an Access Token.
access_token <- query$authorize()
# if you are clever enough to check the AutoRefresh on OAuth Playgournd you can use the following
# access_token <- "ya29.AHES6ZQEeVsVTg7_RcLjsUY_1hj_QfC0ZMVuagfOCgL_mm68AA"

ga <- RGoogleAnalytics()

# Get list of profiles and echo to the console. You will use the left-most number for the
# profile you want to query in the next step.
( ga.profiles <- ga$GetProfileData(access_token) )