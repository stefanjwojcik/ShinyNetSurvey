library(shiny)
library(rdrop2)
library(network)

#For using dropbox, make sure your WD is set to the app, so your auth token is saved to the right plac. you then need to run 
#drop_auth() # give access. 
#If access is denied, set wd then run drop_auth(new_user=T)
#setwd("D:/papers/Working Projects/Dissertation/ShinyNetSurvey/NewApp/NewApp")
n.questions <- 1

#Read in the contact list
contact_list <- read.csv("contact_list.csv", colClasses="character") #Loading in a new contact list - minimal here

#Defining objects that will persist throughout the session
n.alters <- 1
results <- matrix("", ncol=(4+n.questions*4), nrow=50)  
