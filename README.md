# calendaR R package
Ready to print monthly and yearly calendars made with ggplot2


## Installation

``` r
# Install the development version from GitHub:
# install.packages("devtools")
devtools::install_github("R-CoderDotCom/calendaR")
```


## Yearly calendar

``` r
library(calendaR)
calendaR() # Defaults to the current year
```
![Calendar_2020](https://user-images.githubusercontent.com/67192157/90624537-67653580-e218-11ea-80f6-8d329dba4474.png)

## Monthly calendar

``` r
calendaR(month = 1, year = 2028)
```
![Calendar_enero_2028](https://user-images.githubusercontent.com/67192157/90624619-82d04080-e218-11ea-8570-a2c3b0ccab6d.png)

## Start of the week (Monday or Sunday)

``` r
calendaR(month = 3, start = "S") # Week starts on Sunday (default)
calendaR(month = 3, start = "M") # Week starts on Monday
```

## Position

``` r
calendaR(year = 2021, position = "vertical")
calendaR(year = 2021, position = "horizontal")
```

## Save as PDF (as A4 paper size)

``` r
calendaR(year = 2021, position = "vertical", pdf = TRUE)
```

## Further customization

``` r
# Change the title
calendaR(title = "My calendar")

# Add a subtitle (or motivational phrase)
calendaR(motivation = "Have a nice day")

# Change week day names
calendaR(month = 3, weeknames = c("S", "M", "T", "W", "T", "F", "S"))

# Colorize the weekends
calendaR(month = 1, year = 2028, special.days = "weekend", special.col = rgb(0, 0, 1, 0.15))

# Add text
calendaR(month = 10, year = 2020, text = "Running", text.at = c(7, 14, 25))
```
