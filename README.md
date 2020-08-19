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
![Calendar_2020](https://user-images.githubusercontent.com/67192157/90624811-d93d7f00-e218-11ea-97fb-bb42020f792c.png)


## Monthly calendar

``` r
calendaR(month = 1, year = 2028)
```
![Calendar_enero_2028](https://user-images.githubusercontent.com/67192157/90624619-82d04080-e218-11ea-8570-a2c3b0ccab6d.png)

``` r
calendaR(month = 7, year = 2022, 
         special.days = c(1, 5, 12, 28),       # Color days of the month
         text = "Visit\nhttps://r-coder.com/", # Add some text
         text.at = c(1, 5, 12, 28))            # Where to add the text
```

![Calendar_julio_2022](https://user-images.githubusercontent.com/67192157/90627714-a301fe80-e21c-11ea-84ad-e1038d1b1282.png)


## Start of the week (Monday or Sunday)

``` r
# calendaR(month = 1, start = "S") # Week starts on Sunday (default)
calendaR(month = 1, start = "M") # Week starts on Monday
```

![Calendar_enero_2020](https://user-images.githubusercontent.com/67192157/90624910-02f6a600-e219-11ea-8b8e-4b9a00aa7f06.png)


## Position (vertical or horizontal)

``` r
# calendaR(year = 2021, position = "horizontal") # Default
calendaR(year = 2021, position = "vertical")
```

![Calendar_2021](https://user-images.githubusercontent.com/67192157/90625001-291c4600-e219-11ea-9478-7c65accc259a.png)


## Gradient

``` r
calendaR(year = 2021, special.days = 1:365, gradient = TRUE, special.col = rgb(1, 0, 0, alpha = 0.6))
```

![Calendar_2021_GRADIENT](https://user-images.githubusercontent.com/67192157/90626971-ce381e00-e21b-11ea-919a-b5265c415110.png)


## Save as PDF (as A4 paper size)

``` r
calendaR(year = 2021, position = "vertical", pdf = TRUE)
```

## Further customization

``` r

calendaR(title = "My calendar",                            # Change the title
         month = 10,                                       # Month
         year = 2020,                                      # Year
         motivation = "Have a nice day",                   # Add a subtitle (or motivational phrase)
         motivation.col = 3,                               # Color of the subtitle
         weeknames = c("S", "M", "T", "W", "T", "F", "S"), # Change week day names
         special.days = "weekend",                         # Colorize the weekends (you can also set a vector of days)
         special.col = rgb(0, 0, 1, 0.15),                 # Color of the special days
         text = "Running",                                 # Add text (only for monthly calendars)
         text.at = c(7, 14, 25))                           # Days of the month where to put the texts       

# See all the arguments of the function for full customization of the colors, text size and style.
```

![Calendar_octubre_2020](https://user-images.githubusercontent.com/67192157/90625501-f6bf1880-e219-11ea-8c57-e10512d790b6.png)
