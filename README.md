# calendaR R package
Ready to print calendars with ggplot2


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


## Monthly calendar

``` r
calendaR(month = 1, year = 2028)
```

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
