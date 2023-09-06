#############################
#
# Name: Rishikesh Yadav
# CWID: 20007668
# Description: Final Exam Submission for User-defined Function in R
# File: Rishikesh_Yadav_Final_Submission.r
#
#############################
library(quantmod)
library(roll)
library(ggplot2)
library(data.table)

stock_data <- function(stock.ticker, start.date, end.date, rolling.size) {
  
  # 2.1
  # Here we download the daily stock data and convert it to a dataframe for further 
  # processing
  stock.data <- as.data.frame(getSymbols(stock.ticker, src = 'yahoo', from = start.date, to = end.date, warnings = FALSE, auto.assign = TRUE, env = NULL))
  
  # 2.2
  # Here we get the adjusted close price
  adjusted.Close.Price <- stock.data[tail(names(stock.data), 1)]
  
  # 2.3
  # Here we calculate the the mean and standard deviation by performing a rolling 
  # window estimation on stock price vector.
  mean <- rollapply(adjusted.Close.Price, rolling.size, by = 1, FUN = mean, by.column = FALSE)
  std.Dev <- rollapply(adjusted.Close.Price, rolling.size, FUN = sd, fill=0, align="r", by.column = FALSE)
  std.Dev <- tail(std.Dev, -(rolling.size - 1))
  
  
  # 2.4
  # Here we store the statistical result of Q 2.3 into a dataframe
  statistical <- do.call(rbind, Map(data.frame, A = mean, B = std.Dev))
  colnames(statistical) <- c('Mean','Standard Deviation')
  
  # Here we transform the dataframe for our plot
  statistical.Transpose <- transpose(statistical)
  colnames(statistical.Transpose) <- rownames(statistical)
  rownames(statistical.Transpose) <- colnames(statistical)
  
  # Here we pot statistical dataframe using scatter plot
  statistical.plot <- ggplot() + geom_point(data = stack(statistical.Transpose[1,]), aes(x = ind, y = values, color = "Mean")) + 
    geom_point(data = stack(statistical.Transpose[2,]),aes(x = ind, y = values, color = "Standard Deviation")) + 
    labs(x = "Index", y = "Statistical Values", title = "Statistical Result") + 
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
    scale_color_manual(name = "Statistical Values", values = c("Mean" = "yellow","Standard Deviation" = "green"))
  
  print(statistical.plot)
  
  # 2.5 
  # Here we return the statistical dataframe result
  return(statistical)
}


# 2.6
# Testing the above created function

stock.ticker <- 'SNAP'
start.date <- as.Date('2019-12-31')
end.date <- as.Date('2022-12-31')
rolling.size <- 20

statistical.stock.dataframe <- stock_data(stock.ticker, start.date, end.date, rolling.size)
print(statistical.stock.dataframe)
