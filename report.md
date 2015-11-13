
# Ximad Curves


```r
library(htmlTable)
library(pixiedust)
library(broom)
library(dplyr)
```

## Show data

```r
## read data 

df <- read.csv("./sample_data.csv")

## table of attributes
meaning <- c("number of campaigns", "Sum of revenue", "number of days")
features <- c("c1/c2/c3", "sum", "days") 
table.df = cbind(features, meaning)
htmlTable(table.df)
```

<table class='gmisc_table' style='border-collapse: collapse;' >
<thead>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>features</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>meaning</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: center;'>c1/c2/c3</td>
<td style='text-align: center;'>number of campaigns</td>
</tr>
<tr>
<td style='text-align: center;'>sum</td>
<td style='text-align: center;'>Sum of revenue</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: center;'>days</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>number of days</td>
</tr>
</tbody>
</table>

```r
## showing  data

htmlTable(df)
```

<table class='gmisc_table' style='border-collapse: collapse;' >
<thead>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>c1</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>c2</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>c3</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>sum</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>days</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: left;'>1</td>
<td style='text-align: center;'>1</td>
<td style='text-align: center;'>5</td>
<td style='text-align: center;'>5</td>
<td style='text-align: center;'>11</td>
<td style='text-align: center;'>1</td>
</tr>
<tr>
<td style='text-align: left;'>2</td>
<td style='text-align: center;'>3</td>
<td style='text-align: center;'>6</td>
<td style='text-align: center;'>6</td>
<td style='text-align: center;'>15</td>
<td style='text-align: center;'>2</td>
</tr>
<tr>
<td style='text-align: left;'>3</td>
<td style='text-align: center;'>13.8</td>
<td style='text-align: center;'>8</td>
<td style='text-align: center;'>33</td>
<td style='text-align: center;'>54.8</td>
<td style='text-align: center;'>3</td>
</tr>
<tr>
<td style='text-align: left;'>4</td>
<td style='text-align: center;'>20.8</td>
<td style='text-align: center;'>18.8</td>
<td style='text-align: center;'>37</td>
<td style='text-align: center;'>76.6</td>
<td style='text-align: center;'>4</td>
</tr>
<tr>
<td style='text-align: left;'>5</td>
<td style='text-align: center;'></td>
<td style='text-align: center;'>25.8</td>
<td style='text-align: center;'>42</td>
<td style='text-align: center;'>67.8</td>
<td style='text-align: center;'>5</td>
</tr>
<tr>
<td style='text-align: left;'>6</td>
<td style='text-align: center;'></td>
<td style='text-align: center;'>34.8</td>
<td style='text-align: center;'>50</td>
<td style='text-align: center;'>84.8</td>
<td style='text-align: center;'>6</td>
</tr>
<tr>
<td style='text-align: left;'>7</td>
<td style='text-align: center;'></td>
<td style='text-align: center;'>41.8</td>
<td style='text-align: center;'>57</td>
<td style='text-align: center;'>98.8</td>
<td style='text-align: center;'>7</td>
</tr>
<tr>
<td style='text-align: left;'>8</td>
<td style='text-align: center;'></td>
<td style='text-align: center;'>45.8</td>
<td style='text-align: center;'>58</td>
<td style='text-align: center;'>103.8</td>
<td style='text-align: center;'>8</td>
</tr>
<tr>
<td style='text-align: left;'>9</td>
<td style='text-align: center;'></td>
<td style='text-align: center;'>50.8</td>
<td style='text-align: center;'></td>
<td style='text-align: center;'>50.8</td>
<td style='text-align: center;'>9</td>
</tr>
<tr>
<td style='text-align: left;'>10</td>
<td style='text-align: center;'></td>
<td style='text-align: center;'>58.8</td>
<td style='text-align: center;'></td>
<td style='text-align: center;'>58.8</td>
<td style='text-align: center;'>10</td>
</tr>
<tr>
<td style='text-align: left;'>11</td>
<td style='text-align: center;'></td>
<td style='text-align: center;'>65.8</td>
<td style='text-align: center;'></td>
<td style='text-align: center;'>65.8</td>
<td style='text-align: center;'>11</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>12</td>
<td style='border-bottom: 2px solid grey; text-align: center;'></td>
<td style='border-bottom: 2px solid grey; text-align: center;'>66.8</td>
<td style='border-bottom: 2px solid grey; text-align: center;'></td>
<td style='border-bottom: 2px solid grey; text-align: center;'>66.8</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>12</td>
</tr>
</tbody>
</table>

## Linear model




```r
## model

times = seq(0, 60, 0.1)
lin.lm <- lm(sum ~ days, data = df)

## plot 

plot(df$days, df$sum, xaxt='n', pch=16, main="linear", ylab = "Sum of revenue", xlab="days", cex.lab=1.5, cex.main=1.5, xlim=c(0,60))
abline(lin.lm, col="red", lwd=3)
abline(v=length(df$days))
axis(1, at=seq(0,60,5), labels=seq(0,60,5))
legend("topright", bty="n", legend=paste("R2 is", format(summary(lin.lm)$r.squared,digits=4)), cex = 2.0)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 

```r
## table of statistics

stats = round(glance(lin.lm), 3)
htmlTable(stats)
```

<table class='gmisc_table' style='border-collapse: collapse;' >
<thead>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>r.squared</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>adj.r.squared</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>sigma</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>statistic</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>p.value</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>df</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>logLik</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>AIC</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>BIC</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>deviance</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>df.residual</th>
</tr>
</thead>
<tbody>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>1</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>0.234</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>0.158</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>26.093</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>3.062</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>0.111</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>2</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>-55.074</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>116.147</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>117.602</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>6808.673</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>10</td>
</tr>
</tbody>
</table>

```r
## table of coefficients

coeff = as.data.frame(dust(lin.lm) %>% sprinkle(round = 3))
htmlTable(coeff)
```

<table class='gmisc_table' style='border-collapse: collapse;' >
<thead>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>term</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>estimate</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>std.error</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>statistic</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>p.value</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: left;'>1</td>
<td style='text-align: center;'>(Intercept)</td>
<td style='text-align: center;'>38.082</td>
<td style='text-align: center;'>16.059</td>
<td style='text-align: center;'>2.371</td>
<td style='text-align: center;'>0.039</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>2</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>days</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>3.818</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>2.182</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>1.75</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>0.111</td>
</tr>
</tbody>
</table>


## Logarithmic model



```r
## model
log.lm <- lm(sum ~ log(days), data = df)
pred.log <- predict(log.lm, list(days=times))

## plot
plot(df$days, df$sum, xaxt='n', pch=16, main="logarithmic", ylab = "Sum of revenue", xlab="days",cex.lab=1.5, cex.main=1.5, xlim=c(0,60))
abline(v=length(df$days))
axis(1, at=seq(0,60,5), labels=seq(0,60,5))
lines(times, pred.log, col = "red", lwd = 3)
legend("topright", bty="n", legend=paste("R2 is", format(summary(log.lm)$r.squared,digits=4)), cex = 2.0)
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4.png) 

## Exponential model



```r
## model (power)
exp.lm <- lm(log(sum) ~ days, data =df)
pred.exp <- exp(predict(exp.lm, list(days=times)))

## plot
plot(df$days, df$sum, xaxt='n', pch=16, main="exponential", ylab = "Sum of revenue", xlab="days",cex.lab=1.5, cex.main=1.5, xlim=c(0,60))
abline(v=length(df$days))
axis(1, at=seq(0,60,5), labels=seq(0,60,5))
lines(times, pred.exp, col="red", lwd=3)
legend("topright", bty="n", legend=paste("R2 is", format(summary(exp.lm)$r.squared,digits=4)), cex  = 2.0)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 

## Polynomial (quadratic)


```r
## model 2th degree
poly2.lm <- lm(sum ~ poly(days, 2), data =df)
pred.poly2 <- predict(poly2.lm, list(days=times))

## plot
plot(df$days, df$sum, xaxt='n', pch=16, main="polynomial - quadratic", ylab = "Sum of revenue", xlab="days",cex.lab=1.5, cex.main=1.5, xlim=c(0,60))
abline(v=length(df$days))
axis(1, at=seq(0,60,5), labels=seq(0,60,5))
lines(times, pred.poly2, col="red", lwd=3)
legend("topright", bty="n", legend=paste("R2 is", format(summary(poly2.lm)$r.squared,digits=4)), cex  = 2.0)
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6.png) 

## Polynomial (cubic)


```r
## model 3th degree
poly3.lm <- lm(sum ~ poly(days, 3), data =df)
pred.poly3 <- predict(poly3.lm, list(days=times))

## plot
plot(df$days, df$sum, xaxt='n', pch=16, main="polynomial - cubic", ylab = "Sum of revenue", xlab="days",cex.lab=1.5, cex.main=1.5, xlim=c(0,60))
abline(v=length(df$days))
axis(1, at=seq(0,60,5), labels=seq(0,60,5))
lines(times, pred.poly3, col="red", lwd=3)
legend("topright", bty="n", legend=paste("R2 is", format(summary(poly3.lm)$r.squared,digits=4)), cex  = 2.0)
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7.png) 

## Extracting R squared and Coefficients from models


```r
mod.list = list(lin.lm, log.lm, exp.lm, poly2.lm, poly3.lm)
mod.names = c("linear","logarithmic", "exponential","polynomial2", "polynomial3")
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
htmlTable(result.table)
```

<table class='gmisc_table' style='border-collapse: collapse;' >
<thead>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>model</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Predictor</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Beta</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Intercept</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>R.squared</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: center;'>linear</td>
<td style='text-align: center;'>days</td>
<td style='text-align: center;'>3.818</td>
<td style='text-align: center;'>38.082</td>
<td style='text-align: center;'>0.234</td>
</tr>
<tr>
<td style='text-align: center;'>logarithmic</td>
<td style='text-align: center;'>log(days)</td>
<td style='text-align: center;'>25.388</td>
<td style='text-align: center;'>20.614</td>
<td style='text-align: center;'>0.455</td>
</tr>
<tr>
<td style='text-align: center;'>exponential</td>
<td style='text-align: center;'>days</td>
<td style='text-align: center;'>0.115</td>
<td style='text-align: center;'>3.227</td>
<td style='text-align: center;'>0.351</td>
</tr>
<tr>
<td style='text-align: center;'>polynomial2</td>
<td style='text-align: center;'>poly(days, 2)1</td>
<td style='text-align: center;'>45.659</td>
<td style='text-align: center;'>62.9</td>
<td style='text-align: center;'>0.714</td>
</tr>
<tr>
<td style='text-align: center;'>polynomial2</td>
<td style='text-align: center;'>poly(days, 2)2</td>
<td style='text-align: center;'>-65.289</td>
<td style='text-align: center;'>62.9</td>
<td style='text-align: center;'>0.714</td>
</tr>
<tr>
<td style='text-align: center;'>polynomial3</td>
<td style='text-align: center;'>poly(days, 3)1</td>
<td style='text-align: center;'>45.659</td>
<td style='text-align: center;'>62.9</td>
<td style='text-align: center;'>0.761</td>
</tr>
<tr>
<td style='text-align: center;'>polynomial3</td>
<td style='text-align: center;'>poly(days, 3)2</td>
<td style='text-align: center;'>-65.289</td>
<td style='text-align: center;'>62.9</td>
<td style='text-align: center;'>0.761</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: center;'>polynomial3</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>poly(days, 3)3</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>20.46</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>62.9</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>0.761</td>
</tr>
</tbody>
</table>
## Best model


```r
result.df = data.frame(result.table)
index.best = which.max(unique(result.df$R.squared))
best.name = as.character(unique(result.df$model)[index.best])

index.select = which(result.df$model %in% best.name)
best = result.df[index.select, ]
htmlTable(as.matrix(best))
```

<table class='gmisc_table' style='border-collapse: collapse;' >
<thead>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>model</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Predictor</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Beta</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Intercept</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>R.squared</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: left;'>6</td>
<td style='text-align: center;'>polynomial3</td>
<td style='text-align: center;'>poly(days, 3)1</td>
<td style='text-align: center;'>45.659</td>
<td style='text-align: center;'>62.9</td>
<td style='text-align: center;'>0.761</td>
</tr>
<tr>
<td style='text-align: left;'>7</td>
<td style='text-align: center;'>polynomial3</td>
<td style='text-align: center;'>poly(days, 3)2</td>
<td style='text-align: center;'>-65.289</td>
<td style='text-align: center;'>62.9</td>
<td style='text-align: center;'>0.761</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>8</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>polynomial3</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>poly(days, 3)3</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>20.46</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>62.9</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>0.761</td>
</tr>
</tbody>
</table>







