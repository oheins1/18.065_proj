install.packages("vtable")
install.packages("tidyverse")
library(tidyverse)
library(ggplot2)
install.packages("stargazer")
library(stargazer)

#load dataset (NNTS survey and gas prices)
data1 = proj_car_data4

#esnures all cars were bought 2008 onward
newdata <- subset(data1, VEHYEAR > 2007)
#filter out "I don't know" fuel types
newdata1 <- subset(newdata, FUELTYPE > 0)
#fiter out "some other fuel"
newdata2 <- subset(newdata1, FUELTYPE < 10)

newdata2 <- subset(newdata1, FUELTYPE != 2)

#summarize data
summary(newdata2)

##create a table oounting the number of observations per state
data.frame ( table ( newdata2$HHSTATE))

data.frame ( table ( newdata2$FUELTYPE))
##create a table counting the number of observations per year of purchase
data.frame ( table ( newdata2$VEHYEAR))

#create a table oounting the number of observations grouped by fuel type and year of purchase
data.frame ( table ( newdata2$VEHYEAR, newdata2$FUELTYPE) )

#create a table oounting the number of observations grouped by fuel type and type of renewable fuel (battery, hybrid, etc.)
data.frame ( table ( newdata2$VEHYEAR, newdata2$HFUEL) )

#find mean electric car share by state
aggregate(x = newdata2$ELECTRIC,                
          by = list(newdata2$HHSTATE),              
          FUN = mean)  


#find mean electric car share for attended college and did not attend college
aggregate(x = newdata2$ELECTRIC,                
          by = list(newdata2$COLLEGE),              
          FUN = mean)  
#find mean electric car share for highest educational attainment
aggregate(x = newdata2$ELECTRIC,                
          by = list(newdata2$EDUC),              
          FUN = mean)  
#find mean gas price based on whether or not the vehcile was electric
aggregate(x = newdata2$GAS_GAL,                
          by = list(newdata2$ELECTRIC),              
          FUN = mean)  



#find length of each subset of data for each highest educational attainment
sub_3 <- subset(newdata2, EDUC == "3")
n_3 <- length(sub_3)

sub_1 <- subset(newdata2, EDUC == "1")
n_1 <- length(sub_1)

sub_2 <- subset(newdata2, EDUC == "2")
n_2 <- length(sub_2)

sub_4 <- subset(newdata2, EDUC == "4")
n_4 <- length(sub_4)

sub_5 <- subset(newdata2, EDUC == "5")
n_5 <- length(sub_5)




#find correlation between different varibales to determine which control variables
# are endogenous 
cor(newdata2$ELECTRIC, newdata2$GAS_GAL)


cor(newdata2$ECORANK, newdata2$GAS_GAL)

cor(newdata2$EDUC, newdata2$HHSTATE)






install.packages("metaphor")
library(metaphor)


res <- rma(ELECTRI, vi, mods = ~ GAS_GAL + ECORANK + VEHYEAR , data=newdata2)

#run addtional linear regression with added controls
lin_model <- lm(ELECTRIC ~ GAS_GAL + VEHYEAR + COLLEGE , data=newdata2)
lin_model_con <- lm(ELECTRIC ~ GAS_GAL + VEHYEAR + COLLEGE +  ECORANK, data=newdata2)
lin_model_lag <- lm(ELECTRIC ~  Lagged_GAS + VEHYEAR + HHSTATE + HHSIZE, data=newdata2)
lin_model_lag_con<- lm(ELECTRIC ~ Lagged_GAS + VEHYEAR + COLLEGE  + HHSIZE + HHSTATE, data=newdata2)
summary(lin_model_lag_con)
stargazer(lin_model, lin_model_con,  title="Results", align=TRUE)


#run logistic regression with added controls 
mylogit <- glm(ELECTRIC ~ GAS_GAL + VEHYEAR +  HHSTATE, data = newdata2)

summary(lin_model2)

summary(mylogit)
