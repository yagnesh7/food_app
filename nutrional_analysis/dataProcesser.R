setwd("~/Desktop/FoodApp")

library(tidyverse)
library(reshape)
library(e1071)
library(tsne)
library(ggbiplot)
# library(caret)

nutrition_def$nutr_unit <- paste0(nutrition_def$nutr_desc,"_",nutrition_def$units)
nutrition_def_trim <- nutrition_def[,c("nutr_no","nutr_unit")]

keepthese <- c(203,204,205,208,269,291,301,303,306,307,318,320,323,324,324,326,328,401,415,418,430,601,605,606,645,646)
nutrition_def_trim = nutrition_def_trim[nutrition_def_trim$nutr_no %in% keepthese,]

food_desc_trim <- food_desc[,c("ndb_no","fdgrp_cd","long_desc")]

nutrition_data_trim <- nutrition_data[,c("ndb_no","nutr_no","nutr_val")]
nutr_data_def <- merge(x = nutrition_def_trim, y = nutrition_data_trim, on = "nutr_no")
nutr_data_def$nutr_no <- NULL

food_groups_trim <- food_groups[,c("fdgrp_cd","fdgrp_descS")]
food_desc_grp <- merge(x = food_groups_trim, y = food_desc_trim, 'fdgrp_cd')

nutr_pivot <- cast(data = nutr_data_def, ndb_no ~ nutr_unit, value = "nutr_val")

food_nutr <- merge(x = food_desc_grp, y = nutr_pivot, on = 'ndb_no')

barplot(table(food_nutr$fdgrp_descS),las=2, col = rainbow(25), cex.axis = 1, cex.names = .5, ylim=c(0,1000))

notSoSparseCols = c()
for(i in names(food_nutr)){

  if(sum(is.na(food_nutr[[i]])) <= .1*nrow(food_nutr)){
    notSoSparseCols = c(notSoSparseCols,i)
  }

}
notSoSparseCols
food_nutr_desparsed = food_nutr[,notSoSparseCols]
food_nutr_desparsed = food_nutr_desparsed[complete.cases(food_nutr_desparsed),]
dim(food_nutr)
dim(food_nutr_desparsed)
print(dim(food_nutr)- dim(food_nutr_desparsed))


food_data <- food_nutr_desparsed[,1:4]
nutr_data <- food_nutr_desparsed[,5:(dim(food_nutr_desparsed)[2])]

hist(nutr_data$ZN_mg)
skewness(nutr_data$ZN_mg)

nutr.pca <- prcomp(x = nutr_data, center = T, scale = T)
plot(nutr.pca, type = "l")
summary(nutr.pca)



g <- ggbiplot(nutr.pca, obs.scale = 1, var.scale = 1,
              groups = food_data$fdgrp_descS, ellipse = TRUE,
              circle = TRUE)
g <- g + scale_color_discrete(name = '')
g <- g + theme(legend.direction = 'horizontal',
               legend.position = 'top')
print(g)


# trans = preProcess(nutr_data,
#                    method=c("BoxCox", "center",
#                             "scale", "pca"))
# PC = predict(trans, nutr_data)
#
# head(PC,3)
# trans$rotation
# trans


foodgrps <- names(table(food_nutr_desparsed$fdgrp_descS))
smpl_food_nutr_desparsed = food_nutr_desparsed[1,]
for(i in foodgrps){
  # print(i)
  # print(nrow(food_nutr_desparsed[food_nutr_desparsed$fdgrp_descS == i,c(1,2)]))
  # 
  # sample(x = food_nutr_desparsed[food_nutr_desparsed$fdgrp_descS == i,],replace = F,size = 100)
  sampledslice <- sample_n(food_nutr_desparsed[food_nutr_desparsed$fdgrp_descS == i,],replace = F,size = min(50,nrow(food_nutr_desparsed[food_nutr_desparsed$fdgrp_descS == i,])))
  smpl_food_nutr_desparsed = rbind(smpl_food_nutr_desparsed,sampledslice)
}

food_data <- smpl_food_nutr_desparsed[,1:4]
nutr_data <- smpl_food_nutr_desparsed[,5:(dim(smpl_food_nutr_desparsed)[2])]


key <- as.numeric(as.factor(food_data$fdgrp_descS))
food_data$fdgrp_descS_k <- paste0(as.character(food_data$fdgrp_descS),".",as.character(key))
ecb <- function(x) {

  key <- as.numeric(as.factor(food_data$fdgrp_descS_k))
  epoc_df <- data.frame(x,Key = key,FoodGroup = food_data$fdgrp_descS_k)


  plt <- ggplot(epoc_df,aes(x = X1, y = X2,label = Key,color = FoodGroup)) + geom_text()

  print(plt)
}



x <- tsne(nutr_data,epoch_callback = ecb, perplexity = 20,max_iter = 500)

foodNames <- substring(food_data$long_desc,first = 0,last = 20)
x_df <- data.frame(x,Key=key,FoodGroup = food_data$fdgrp_descS_k, FoodName = foodNames)

plt <- ggplot(x_df,aes(x = X1, y = X2,label = foodNames,color = FoodGroup)) + geom_text()

print(plt)
