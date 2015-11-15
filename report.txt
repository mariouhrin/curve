
# Curve fitting example


```r
library(htmlTable)
library(broom)
library(pixiedust)
library(dplyr)
library(hash)
library(data.table)
options(scipen = 100000)
```

## Show data

```r
## read data 
df <- fread("./sample_data.csv")

## attribute description simple table
meaning <- c("number of campaign", "number of days", "Cumulative sum of campaigns revenue")
attribute <- c("c1/c2/c3","days", "cumsum_revenue") 
table.df = cbind(attribute, meaning)
htmlTable(table.df, align='c|c')
```

<table class='gmisc_table' style='border-collapse: collapse;' >
<thead>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>attribute</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>meaning</th>
</tr>
</thead>
<tbody>
<tr>
<td style='border-right: 1px solid black; text-align: center;'>c1/c2/c3</td>
<td style='text-align: center;'>number of campaign</td>
</tr>
<tr>
<td style='border-right: 1px solid black; text-align: center;'>days</td>
<td style='text-align: center;'>number of days</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; border-right: 1px solid black; text-align: center;'>cumsum_revenue</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>Cumulative sum of campaigns revenue</td>
</tr>
</tbody>
</table>

```r
kable(head(iris), format = "markdown", align="c")
```



| Sepal.Length | Sepal.Width | Petal.Length | Petal.Width | Species |
|:------------:|:-----------:|:------------:|:-----------:|:-------:|
|     5.1      |     3.5     |     1.4      |     0.2     | setosa  |
|     4.9      |     3.0     |     1.4      |     0.2     | setosa  |
|     4.7      |     3.2     |     1.3      |     0.2     | setosa  |
|     4.6      |     3.1     |     1.5      |     0.2     | setosa  |
|     5.0      |     3.6     |     1.4      |     0.2     | setosa  |
|     5.4      |     3.9     |     1.7      |     0.4     | setosa  |

```r
## show data
htmlTable(df, align='c|c|c|c|c')
```

<table class='gmisc_table' style='border-collapse: collapse;' >
<thead>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>c1</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>c2</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>c3</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>days</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>cumsum_revenue</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: left;'>1</td>
<td style='border-right: 1px solid black; text-align: center;'>1</td>
<td style='border-right: 1px solid black; text-align: center;'>5</td>
<td style='border-right: 1px solid black; text-align: center;'>5</td>
<td style='border-right: 1px solid black; text-align: center;'>1</td>
<td style='text-align: center;'>3.67</td>
</tr>
<tr>
<td style='text-align: left;'>2</td>
<td style='border-right: 1px solid black; text-align: center;'>3</td>
<td style='border-right: 1px solid black; text-align: center;'>6</td>
<td style='border-right: 1px solid black; text-align: center;'>6</td>
<td style='border-right: 1px solid black; text-align: center;'>2</td>
<td style='text-align: center;'>5</td>
</tr>
<tr>
<td style='text-align: left;'>3</td>
<td style='border-right: 1px solid black; text-align: center;'>13.8</td>
<td style='border-right: 1px solid black; text-align: center;'>8</td>
<td style='border-right: 1px solid black; text-align: center;'>33</td>
<td style='border-right: 1px solid black; text-align: center;'>3</td>
<td style='text-align: center;'>18.27</td>
</tr>
<tr>
<td style='text-align: left;'>4</td>
<td style='border-right: 1px solid black; text-align: center;'>20.8</td>
<td style='border-right: 1px solid black; text-align: center;'>18.8</td>
<td style='border-right: 1px solid black; text-align: center;'>37</td>
<td style='border-right: 1px solid black; text-align: center;'>4</td>
<td style='text-align: center;'>25.53</td>
</tr>
<tr>
<td style='text-align: left;'>5</td>
<td style='border-right: 1px solid black; text-align: center;'></td>
<td style='border-right: 1px solid black; text-align: center;'>25.8</td>
<td style='border-right: 1px solid black; text-align: center;'>42</td>
<td style='border-right: 1px solid black; text-align: center;'>5</td>
<td style='text-align: center;'>33.9</td>
</tr>
<tr>
<td style='text-align: left;'>6</td>
<td style='border-right: 1px solid black; text-align: center;'></td>
<td style='border-right: 1px solid black; text-align: center;'>34.8</td>
<td style='border-right: 1px solid black; text-align: center;'>50</td>
<td style='border-right: 1px solid black; text-align: center;'>6</td>
<td style='text-align: center;'>42.4</td>
</tr>
<tr>
<td style='text-align: left;'>7</td>
<td style='border-right: 1px solid black; text-align: center;'></td>
<td style='border-right: 1px solid black; text-align: center;'>41.8</td>
<td style='border-right: 1px solid black; text-align: center;'>57</td>
<td style='border-right: 1px solid black; text-align: center;'>7</td>
<td style='text-align: center;'>49.4</td>
</tr>
<tr>
<td style='text-align: left;'>8</td>
<td style='border-right: 1px solid black; text-align: center;'></td>
<td style='border-right: 1px solid black; text-align: center;'>45.8</td>
<td style='border-right: 1px solid black; text-align: center;'>58</td>
<td style='border-right: 1px solid black; text-align: center;'>8</td>
<td style='text-align: center;'>51.9</td>
</tr>
<tr>
<td style='text-align: left;'>9</td>
<td style='border-right: 1px solid black; text-align: center;'></td>
<td style='border-right: 1px solid black; text-align: center;'>50.8</td>
<td style='border-right: 1px solid black; text-align: center;'></td>
<td style='border-right: 1px solid black; text-align: center;'>9</td>
<td style='text-align: center;'>50.8</td>
</tr>
<tr>
<td style='text-align: left;'>10</td>
<td style='border-right: 1px solid black; text-align: center;'></td>
<td style='border-right: 1px solid black; text-align: center;'>58.8</td>
<td style='border-right: 1px solid black; text-align: center;'></td>
<td style='border-right: 1px solid black; text-align: center;'>10</td>
<td style='text-align: center;'>58.8</td>
</tr>
<tr>
<td style='text-align: left;'>11</td>
<td style='border-right: 1px solid black; text-align: center;'></td>
<td style='border-right: 1px solid black; text-align: center;'>65.8</td>
<td style='border-right: 1px solid black; text-align: center;'></td>
<td style='border-right: 1px solid black; text-align: center;'>11</td>
<td style='text-align: center;'>65.8</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>12</td>
<td style='border-bottom: 2px solid grey; border-right: 1px solid black; text-align: center;'></td>
<td style='border-bottom: 2px solid grey; border-right: 1px solid black; text-align: center;'>66.8</td>
<td style='border-bottom: 2px solid grey; border-right: 1px solid black; text-align: center;'></td>
<td style='border-bottom: 2px solid grey; border-right: 1px solid black; text-align: center;'>12</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>66.8</td>
</tr>
</tbody>
</table>

## Curve fitting functions



```r
## timeseries for all curves
times = seq(0, 60, 0.1)


## CURVE FUNCTIONS 

linear <- function(y) {

    df$cumsum_revenue = y
    lin.lm <- lm(cumsum_revenue ~ days, data = df)
    pred.lin <- predict(lin.lm, list(days=times))
    return(list(lin.lm, pred.lin))
}


logarithmic <- function (y) {
    
    df$cumsum_revenue = y
    log.lm <- lm(cumsum_revenue ~ log(days), data = df)
    pred.log <- predict(log.lm, list(days=times))
    return(list(log.lm, pred.log))
}


exponential <- function (y) {
    
    df$cumsum_revenue = y
    exp.lm <- lm(log(cumsum_revenue) ~ days, data = df)
    pred.exp <- exp(predict(exp.lm, list(days=times)))
    return(list(exp.lm, pred.exp))
}


polynomial_2 <- function (y) {

    df$cumsum_revenue = y
    poly2.lm <- lm(cumsum_revenue ~ poly(days, 2), data = df)
    pred.poly2 <- predict(poly2.lm, list(days=times))
    return(list(poly2.lm, pred.poly2))
}


polynomial_3 <- function (y) {

    df$cumsum_revenue = y
    poly3.lm <- lm(cumsum_revenue ~ poly(days, 3), data = df)
    pred.poly3 <- predict(poly3.lm, list(days=times))
    return(list(poly3.lm, pred.poly3))
}


models = list("linear" = linear, 
              "logarithmic" = logarithmic,
              "exponential" = exponential, 
              "polynomial_2" = polynomial_2, 
              "polynomial_3" = polynomial_3)
```

## Save curves plot into list


```r
## create list for saving plots as object
plots = list()

## create list for assigning models name
name.list = list()


## loop every curve plot and save it as object into list

for (i in seq(models)) {

    # model name
    name = names(models)[i]

    # assign model name into list
    name.list[[i]] = name

    # function of model
    fun.model = models[[name]]

    # assign model coefficients and statistics 
    mod.val = fun.model(df$cumsum_revenue) [[1]]

    # assign prediction values
    pred.val = fun.model(df$cumsum_revenue) [[2]]

    # set the max ylim value
    not.infinite = pred.val[!is.infinite(pred.val)]
    ylim.max = max(not.infinite) + (max(not.infinite) + (-min(not.infinite)))/3

    # set the min ylim value
    not.infinite = pred.val[!is.infinite(pred.val)]
    ylim.min = min(not.infinite)

    # extrapolation plot
    plot(times, pred.val, xaxt='n', type="l", main=paste(name, "curve"), 
         ylab = "Cumulative campaign revenue", xlab="Number of days", 
         cex.lab=1.5, cex.main=1.5, ylim=c(ylim.min, ylim.max),
         xlim=c(0,60), col = '#FF00007F', lwd=4) 

    # add grid
    grid(NA, NULL)

    # add points from original data
    points(df$days, df$cumsum_revenue, col="#0000FF7F", pch = 16, cex = 1.8)

    # modificate the plot axis
    axis(1, at=seq(0,60,10), labels=seq(0,60,10))

    # add legend to a plot
    legend("topright", bty="n", 
           legend=c(paste("Estimation by", name, "function"), "Campaign revenue", 
           as.expression(bquote(
           R^2==.(format(summary(mod.val)$r.squared, digits=3))))),
           pch=c(NA,16),col=c("#FF00007F", "#0000FF7F"), 
           lwd = 4, lty=c(1,0,0), cex = 1.2, pt.cex = 1.8, 
           merge = T, inset=c(-0.1, 0), y.intersp=1.5)

    # save every plot into list 'plots'
    plots[[i]] = recordPlot()
}   
```

```r
## assign model names into plots list
names(plots) = unlist(name.list)
```

## Linear model


```r
plots[["linear"]]
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png) 

## Logarithmic model



```r
plots[["logarithmic"]]
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-1.png) 

## Exponential model



```r
plots[["exponential"]]
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7-1.png) 

## Polynomial (quadratic)


```r
plots[["polynomial_2"]]
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8-1.png) 

## Polynomial (cubic)


```r
plots[["polynomial_3"]]
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9-1.png) 



## Create sorted R squared table


```r
## lists for collecting stats with r.squared value
model.stats = list()
model.r.squared = list()


## loop for creating table with r squared values and models name 

for (i in seq(models)) {
    fun.model = models[[ name.list[[i]] ]]
    model.stats[[i]] = glance( fun.model(df$cumsum_revenue) [[1]] )        
    model.r.squared[[i]]  = round(model.stats[[i]]$r.squared, 3)
    results = data.table(cbind(Curve = unlist(name.list), 
                            R.squared = unlist(model.r.squared)))
}

## sort results data.table by R.squared values
r.squared.table = results[ order(-R.squared) ]

## show r.squared.table 
htmlTable(r.squared.table)
```

<table class='gmisc_table' style='border-collapse: collapse;' >
<thead>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Curve</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>R.squared</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: left;'>1</td>
<td style='text-align: center;'>polynomial_2</td>
<td style='text-align: center;'>0.984</td>
</tr>
<tr>
<td style='text-align: left;'>2</td>
<td style='text-align: center;'>polynomial_3</td>
<td style='text-align: center;'>0.984</td>
</tr>
<tr>
<td style='text-align: left;'>3</td>
<td style='text-align: center;'>linear</td>
<td style='text-align: center;'>0.959</td>
</tr>
<tr>
<td style='text-align: left;'>4</td>
<td style='text-align: center;'>logarithmic</td>
<td style='text-align: center;'>0.939</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>5</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>exponential</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>0.769</td>
</tr>
</tbody>
</table>

## Fit campaigns to the best function



```r
## best function index
#best.index = which.max(results$R.squared)
#
### select campaigns from data
#campaigns = df[, grep("c[0-9]", names(df)), with = F]
#
#models = 
#
#for (i in seq(campaigns)) {
#
#    # assign model coefficients and statistics 
#    mod.val = models[[ names(models)[i] ]] [[1]]
#
#    # assign prediction values
#    pred.val = models[[ names(models)[i] ]] [[2]]
#
#    # assign models name into list
#    name = gsub(".\\.", "", names(models)[i])
#    name.list[[i]] = name
#
#    # set the max ylim value
#    not.infinite = pred.val[!is.infinite(pred.val)]
#    ylim.max = max(not.infinite) + (max(not.infinite) + (-min(not.infinite)))/3
#
#    # set the min ylim value
#    not.infinite = pred.val[!is.infinite(pred.val)]
#    ylim.min = min(not.infinite)
#
#    # extrapolation plot
#    plot(times, pred.val, xaxt='n', type="l", main=paste(name, "curve"), 
#         ylab = "Cumulative campaign revenue", xlab="Number of days", 
#         cex.lab=1.5, cex.main=1.5, ylim=c(ylim.min, ylim.max),
#         xlim=c(0,60), col = '#FF00007F', lwd=4) 
#
#    # add grid
#    grid(NA, NULL)
#
#    # add points from original data
#    points(df$days, df$sum, col="#0000FF7F", pch = 16, cex = 1.8)
#
#    # modificate the plot axis
#    axis(1, at=seq(0,60,10), labels=seq(0,60,10))
#
#    # add legend to a plot
#    legend("topright", bty="n", 
#           legend=c(paste("Estimation by", name, "function"), "Campaign revenue", 
#           as.expression(bquote(
#           R^2==.(format(summary(mod.val)$r.squared, digits=3))))),
#           pch=c(NA,16),col=c("#FF00007F", "#0000FF7F"), 
#           lwd = 4, lty=c(1,0,0), cex = 1.2, pt.cex = 1.8, 
#           merge = T, inset=c(-0.1, 0), y.intersp=1.5)
#
#    # save every plot into list 'plots'
#    plots[[i]] = recordPlot()
#
#}   
```

