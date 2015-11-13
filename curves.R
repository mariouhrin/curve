library(pixiedust)
library(broom)
library(dplyr)


df <- read.csv("./sample_data.csv")


## model linear

lin.lm <- lm(sum ~ days, data = df)

## plot 

plot(df$days, df$sum, pch=16, main="linear", ylab = "Sum of revenue", xlab="days", cex.lab=1.5, cex.main=1.5)
abline(lin.lm, col="red", lwd=3)
legend("topleft", bty="n", legend=paste("R2 is", format(summary(lin.lm)$r.squared,digits=4)), cex = 2.0)

## table of statistics

stats = round(glance(lin.lm), 3)
ftable(stats)

## timeseries for plotting
times <- seq(0, length(df$days), 0.1)


## model quadratic
days2 = (df$days)^2
quad.lm <- lm(sum ~ days + days2, data = df)
pred.quad <- predict(quad.lm, list(days=times, days2=times^2))

## plot
plot(df$days, df$sum, pch=16, main="quadratic", ylab = "Sum of revenue", xlab="days", cex.lab=1.5, cex.main=1.5)
lines(times, pred.quad, col = "red", lwd = 3)
legend("topleft", bty="n", legend=paste("R2 is", format(summary(quad.lm)$r.squared,digits=4)), cex = 2.0)



## model cubic
days2 = (df$days)^2
days3 = (df$days)^3
cube.lm <- lm(sum ~ days + days2 + days3, data = df)
pred.cube <- predict(cube.lm, list(days=times, days2=times^2, days3=times^3))

## plot
plot(df$days, df$sum, pch=16, main="cubic", ylab = "Sum of revenue", xlab="days",cex.lab=1.5, cex.main=1.5)
lines(times, pred.cube, col = "red", lwd = 3)
legend("topleft", bty="n", legend=paste("R2 is", format(summary(cube.lm)$r.squared,digits=4)), cex = 2.0)



## model logarithmic
log.lm <- lm(sum ~ log(days), data = df)
pred.log <- predict(log.lm, list(days=times))

## plot
plot(df$days, df$sum, pch=16, main="logarithmic", ylab = "Sum of revenue", xlab="days",cex.lab=1.5, cex.main=1.5)
lines(times, pred.log, col = "red", lwd = 3)
legend("topleft", bty="n", legend=paste("R2 is", format(summary(log.lm)$r.squared,digits=4)), cex = 2.0)



## model (exponential, power)
exp.lm <- lm(log(sum) ~ days, data =df)
pred.exp <- exp(predict(exp.lm, list(days=times)))

## plot
plot(df$days, df$sum, pch=16, main="exponential", ylab = "Sum of revenue", xlab="days",cex.lab=1.5, cex.main=1.5)
lines(times, pred.exp, col="red", lwd=3)
legend("topleft", bty="n", legend=paste("R2 is", format(summary(exp.lm)$r.squared,digits=4)), cex  = 2.0)



## model polynomial 2th degree
poly2.lm <- lm(sum ~ poly(days, 2), data =df)
pred.poly2 <- predict(poly2.lm, list(days=times))

## plot
plot(df$days, df$sum, pch=16, main="exponential", ylab = "Sum of revenue", xlab="days",cex.lab=1.5, cex.main=1.5)
lines(times, pred.poly2, col="red", lwd=3)
legend("topleft", bty="n", legend=paste("R2 is", format(summary(poly2.lm)$r.squared,digits=4)), cex  = 2.0)


## model polynomial 3th degree
poly3.lm <- lm(sum ~ poly(days, 3), data =df)
pred.poly3 <- predict(poly3.lm, list(days=times))

## plot
plot(df$days, df$sum, pch=16, main="exponential", ylab = "Sum of revenue", xlab="days",cex.lab=1.5, cex.main=1.5)
lines(times, pred.poly3, col="red", lwd=3)
legend("topleft", bty="n", legend=paste("R2 is", format(summary(poly3.lm)$r.squared,digits=4)), cex  = 2.0)



## Extracting R squared and coefficients

mod.list = list(lin.lm, quad.lm, cube.lm, log.lm, exp.lm, poly2.lm, poly3.lm)
mod.names = c("linear", "quadratic", "cubic", "logarithmic", "exponential","polynomial2", "polynomial3")
result.list = list()

for (i in seq(mod.list)) {
    stats = round(glance(mod.list[[i]]), 3)
    coeff = as.data.frame(dust(mod.list[[i]]) %>% sprinkle(round = 3))
    R.squared = stats$r.squared
    Intercept = coeff[1, 'estimate']
    Beta = coeff[2:nrow(coeff), 'estimate']
    Predictor = coeff[2:nrow(coeff), 'term']
    model.values = cbind(model = mod.names[i], Predictor, Beta, Intercept, R.squared)
    result.list[[i]] = model.values
     }


## collect all values  into table
result.table = do.call(rbind, result.list)
print(result.table)



## Best model

result.df = data.frame(result.table)
index.best = which.max(unique(result.df$R.squared))
best.name = as.character(unique(result.df$model)[index.best])

index.select = which(result.df$model %in% best.name)
best = result.df[index.select, ]
ftable(as.matrix(best))



## Final result at 60 days

Intercept = as.numeric(as.character(unique(best$Intercept)))
Beta = as.numeric(as.character(best$Beta))

Max.Day = 60

if (length(Beta) == 1) {
    forecast = Intercept + Beta[1]*Max.Day
}

if (length(Beta) == 2) {
    forecast = Intercept + Beta[1]*Max.Day + Beta[2]*Max.Day
}

if (length(Beta) == 3) {
    forecast = Intercept + Beta[1]*Max.Day + Beta[2]*Max.Day + Beta[3]*Max.Day
}  

print(forecast)



## Polynomial forecast

poly2 = result.df[9:10, ]
Intercept = as.numeric(as.character(unique(poly2$Intercept)))
Beta = as.numeric(as.character(poly2$Beta))
forecast = Intercept + Beta[1]*Max.Day + Beta[2]*Max.Day
print(forecast)

poly3 = result.df[11:13, ]
Intercept = as.numeric(as.character(unique(poly3$Intercept)))
Beta = as.numeric(as.character(poly3$Beta))
forecast = Intercept + Beta[1]*Max.Day + Beta[2]*Max.Day + Beta[3]*Max.Day
print(forecast)

