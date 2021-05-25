scaletest  <- function(data,
                            min_item_score,
                            max_item_score) {
  table <-
    as.data.frame(matrix(0, ncol = 8, nrow = ncol(data))) #empty data frame
  colnames(table) <-
    c("mean",
      "sd",
      "floor",
      "ceiling",
      "min",
      "max",
      "item_score_corr",
      "raw_corr")
  rownames(table) <- colnames(data)
  
  #calculate score
  score<-c()
  for (row in 1:nrow(data)){
    score <- c(score, sum(data[row,], na.rm=TRUE))
  }
  
  for (item in colnames(data)) {
    #mean
    table[item, "mean"] <- mean(data[[item]], na.rm=TRUE)
    
    #standard dev.
    table[item, "sd"] <- sd(data[[item]], na.rm=TRUE)
    
    #percentage of observations with floor or ceiling item score
    score_scale <- seq(min_item_score, max_item_score)
    num_floor <- sum(data[[item]] == min(score_scale), na.rm=TRUE)
    num_ceil <- sum(data[[item]] == max(score_scale), na.rm=TRUE)
    num_tot <- sum(is.na(data[[item]]) == FALSE) #don't include NA
    
    table[item, "floor"] <- num_floor / num_tot * 100
    table[item, "ceiling"] <- num_ceil / num_tot * 100
    
    #item-item correlation
    cor_values <- c()
    for (corr_item in colnames(data)) {
      if (item == corr_item) {
      } #Do nothing when corr is with itself
      else{
        cor = cor(data[[item]], data[[corr_item]], use="complete.obs")
        cor_values <- c(cor_values, cor)
      }
    }
    table[item, "min"] <- min(cor_values)
    table[item, "max"] <- max(cor_values)
    
    #item-score correlation
    table[item, "item_score_corr"] <- cor(data[[item]], score, use="complete.obs")
    
    #item-rest score correlation
    rest_score <- score - data[,item]
    table[item, "raw_corr"] <- cor(data[[item]], rest_score, use="complete.obs")
    
  }
  return(table)
}

compute_item_values <- function(data, item, min, max) {
  
  #so input for item can be item column number, or the item name as string
  if (is.numeric(item) == TRUE) {
    item <- colnames(data)[item]
  }
  
  mean <- mean(data[[item]], na.rm=TRUE)
  sd <- sd(data[[item]], na.rm=TRUE)
  
  num_floor <- sum(data[[item]] == min, na.rm=TRUE)
  num_ceil <- sum(data[[item]] == max, na.rm=TRUE)
  num_tot <- sum(is.na(data[[item]]) == FALSE) #don't include NA
  
  floor <- num_floor / num_tot * 100
  ceil <- num_ceil / num_tot * 100
  
  #item-item correlation
  cor_values <- c()
  for (corr_item in colnames(data)) {
    if (item == corr_item) {
    } #Do nothing when corr is with itself
    else{
      cor = cor(data[[item]], data[[corr_item]], use="complete.obs")
      cor_values <- c(cor_values, cor)
    }
  }
  
  min_cor <- min(cor_values)
  max_cor <- max(cor_values)
  
  score<-c()
  for (row in 1:nrow(data)){
    score <- c(score, sum(data[row,], na.rm=TRUE))
  }
  
  rest_score <- score - data[,item]
  
  item_score_corr <- cor(data[[item]], score, use="complete.obs")
  raw_corr <- cor(data[[item]], rest_score, use="complete.obs")
  
  res <- as.data.frame(matrix(NA, nrow = 1, ncol = 9))
  colnames(res) <- c("Item name","Mean", "SD", "Floor (%)", "Ceil (%)", "Min. corr", "Max. corr", "Item-score corr", "Raw corr")
  res[1,] <- c(item ,mean, sd, floor, ceil, min_cor, max_cor, item_score_corr, raw_corr)
  
  return(res)
} 
