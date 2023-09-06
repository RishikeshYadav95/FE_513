#Name :Rishikesh Yadav, CWID :20007668, Assignment :1

# Part I
# 1.1: Vector

v1 <- sample(0:100, 10, replace=TRUE)
v2 <- sample(0:100, 10, replace=TRUE)
is.vector(v1)
is.vector(v2)

## Appending Vector 2 to Vector 1.
appended.vector <- append(v1,v2)
appended.vector

##Calculate the mean of the new combined vector.
mean.vector <- mean(appended.vector)
mean.vector

## If element is lager than the mean, print ’True’, else print ’False’.

for (x in appended.vector) {
  if (x > mean.vector) {
    print(TRUE)
  } else {
    print(FALSE)
  }
}

# 1.2: Matrix

##1. Create a vector with 100 random numbers.
vector <- round(runif(n = 100, min = 1, max = 100), 0)

##2. Transfer the above vector into a 10 by 10 matrix M.
matrix <- matrix(vector, nrow = 10)
matrix

##3. Find the transposed matrix
transposed.matrix <- t(matrix)
print(transposed.matrix)
print(transposed.matrix[2,1])

##4. Nested loop to calculate the inner product between M.T and M.
InnerProduct <- function(a, b){
  if(ncol(a) != nrow(b)){
    return("can't multiply")
  }
  else{
    c = matrix(rep(0, nrow(a) * ncol(b)), nrow = nrow(a))
    for(i in 1:nrow(a)){
      for(j in 1:ncol(b)){
        for(k in 1:nrow(b)){
          c[i,j] <- c[i,j] + a[i,k] * b[k, j]
        }
      }
    }
  }
  return(c)
}

matrix.product <- InnerProduct(transposed.matrix, matrix)
print(matrix.product)

##5. Calculate the same inner product using operator %∗%.
matrix.operator <- transposed.matrix %*% matrix
print(matrix.operator)

# 1.3 Function

##1. Load the given CSV file
df <- read.csv("stock_data-1.csv", head = TRUE)
df$X <- as.Date(df$X, format = "%Y-%m-%d")
head(df)

##2. Delete the columns containing NA(empty values).
df<- df[ , colSums(is.na(df))==0]
head(df)

##3. Calculate daily log return for each stock.
daily.log.return <- as.data.frame(sapply(df[2:26], function(x) diff(log(x))))
head(daily.log.return)

##4. Calculate the mean and standard deviation of log return for each stock
mean.and.std <- as.data.frame(sapply(daily.log.return, function(x) 
  c("Mean" = mean(x, na.rm=TRUE),
    "Standard.deviation" = sd(x)
  )
))
mean.and.std

##5. Build a graph with two sub-plots.
library(ggplot2)
library(patchwork)
knitr::opts_chunk$set(fig.width=unit(18,"cm"), fig.height=unit(11,"cm"))
p1 <- ggplot() + geom_line(data=df, aes(x=X, y=AAPL, color = "AAPL")) + geom_line(data=df, aes(x=X, y=AMGN, color = "AMGN")) + geom_line(data=df, aes(x=X, y=AXP, color = "AXP")) + theme_bw() + labs(y="Stock Price", x="Date", title="Stock's Daily Price") + 
  scale_color_manual(name = "Stock name", values = c("AAPL" = "blue", "AMGN" = "red", "AXP" = "green"))
p2 <- ggplot() + geom_point(data = stack(mean.and.std[1,]), aes(x = ind, y = values, color = "Mean")) + 
  geom_point(data = stack(mean.and.std[2,]), aes(x = ind, y = values, color = "Standard Deviation")) + labs(x="Stock's Name", y="Statistical Values", title="Statistical Result of each Stock") + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  scale_color_manual(name = "Statistical Values", values = c("Mean" = "blue", "Standard Deviation" = "red"))
p1 / p2


# Part II

##1. Download Amazon daily stock price data from 2021-01-01 to 2021-12-31 and save the data to a csv file.

#install.packages("quantmod")
library(quantmod)

start.date <- as.Date('2021-01-01')
end.date <- as.Date('2021-12-31')
getSymbols('AMZN', src = 'yahoo', from = start.date, to = end.date, warnings = FALSE, auto.assign = TRUE)
amazon.data <- data.frame(AMZN)
amazon.data$date <- rownames(amazon.data)
rownames(amazon.data) <- NULL
write.zoo(amazon.data, "amazon.csv", sep = ",")

##2. Calculate weekly log returns based on adjusted close price.
log.return <- diff(log(AMZN$AMZN.Adjusted))[-1]
weekly.log.return <- apply.weekly(log.return, FUN = sum)
head(weekly.log.return)

##3. Calculate median, mean, standard deviation of log returns.
mean.d <- mean(log.return)
median.d <- median(log.return)
standard.deviation <- sd(log.return)

cat(" Mean:", round(mean.d, 6), "\n",
    "Median:", round(median.d, 6), "\n",
    "Standard Deviation:", round(standard.deviation, 6))

##4. Plot the distribution of stock daily log returns
log.return.plot <- ggplot(data = log.return, aes(x = log.return$AMZN.Adjusted)) + 
  geom_histogram(color = "darkblue", fill = "lightblue", size = 1.2, bins = 100) + 
  ggtitle("Daily Log Returns of the Amazon") + 
  geom_vline(xintercept = quantile(x = as.vector(log.return), probs = 0.05), color = "red", size = 1.2, linetype = "longdash") + 
  xlab("Total Return") + theme_minimal()
log.return.plot

##5. Observation in this series with log return is between 0.01 and 0.015
sum(log.return > 0.01 & log.return < 0.015)
