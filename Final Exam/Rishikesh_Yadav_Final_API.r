#############################
#
# Name: Rishikesh Yadav
# CWID: 20007668
# Description: Final Exam Submission for PostgreSQL API in R
# File: Rishikesh_Yadav_Final_API.r
#
#############################

# 3.1 - Here we make a connection to your local PostgreSQL database
library(RPostgreSQL)
db_name <- "FE_513"
username <- "postgres"
driver <- dbDriver("PostgreSQL")
conn <-dbConnect(driver, dbname = db_name, user = username, password = "root")

# 3.2 - Here we query the PostgreSQL database via API to get the original bank data
result <- dbGetQuery(conn, "SELECT * FROM bank;")

# 3.3 - Here we calculate asset growth rate for each quarter and each bank with the
# given formula and store the result in a data frame.
library(dplyr)
result <- result %>% group_by(id) %>% arrange(id, date) %>% mutate(asset.growth.rate = (asset - lag(asset, n = 1))/ lag(asset, n = 1))

#3.4 - Here we export the data frame of Q 3.3 to the PostgreSQL database via API
dbWriteTable(conn, "bank_data_from_api", result, row.names=FALSE, append=TRUE)