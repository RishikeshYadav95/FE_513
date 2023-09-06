#############################
#
# Name: Rishikesh Yadav
# CWID: 20007668
# Description: Homework 3
#
#############################

library(RPostgreSQL)
database_name <- "FE_513"
username <- "postgres"
drv <- dbDriver("PostgreSQL")
con<-dbConnect(drv, dbname = database_name, user = username, password = "root")

res<- dbGetQuery(con, "Select * from banks_total")
nrow(res)

banks_total <- read.csv("C:\Users\psyad\Desktop\Stevens\Sem 4\FE 513\HW-Assignments\Assignment 3\banks_total.csv", header = TRUE, sep = ",")

dbWriteTable(con, "banks_total_new", banks_total, row.names=TRUE, append=TRUE)