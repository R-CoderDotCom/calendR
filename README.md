# calendR R package
Ready to print monthly and yearly calendars made with ggplot2


📅 The calendars will be created by default in the system locale.

📖 Check the [full calendR package tutorial](https://r-coder.com/calendar-plot-r/).

NOTE: additional functionalities (background colors, several events, lunar calendar and academic calendar) will be available on CRAN soon.

## Index
- [Installation](#installation)
- [Yearly calendar](#yearly-calendar)
- [Monthly calendar](#monthly-calendar)
- [Custom start and end date](#custom-start-and-end-date--only-on-the-github-development-version)
- [Start of the week](#start-of-the-week-monday-or-sunday)
- [Orientation](#orientation-landscape-or-portrait)
- [Heat map](#calendar-heatmap-gradient)
- [Add several events](#add-several-events-only-on-the-github-development-version)
- [Add background image](#add-background-image)
- [Lunar calendar](#lunar-calendar)
- [Save as PDF](#save-as-pdf-as-a4-paper-size)
- [More examples](#further-customization)


## Installation

### GitHub
``` r
# Install the development version from GitHub:
# install.packages("devtools")
devtools::install_github("R-CoderDotCom/calendR")
```

### CRAN
``` r
install.packages("calendR")
```

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/calendR)](https://cran.r-project.org/package=calendR)
[![CRAN_Downloads](https://cranlogs.r-pkg.org/badges/grand-total/calendR)](https://cran.r-project.org/package=calendR)

## Yearly calendar

``` r
library(calendR)
calendR() # Defaults to the current year
```

![Calendar_2020](https://user-images.githubusercontent.com/67192157/90884872-db3a4600-e3b0-11ea-8259-31f9c373fc74.png)


``` r
calendR(mbg.col = 2,           # Background color for the month names
        months.col = "white",  # Text color of the month names
        special.days = c(1, 50, 12, 125, 80,     # Color days of the year
                         99, 102, 205, 266, 360),
        special.col = "pink", # Color of the special.days
        months.pos = 0.5)      # Horizontal alignment of the month names
```

![calendR](https://user-images.githubusercontent.com/67192157/92282070-331e9400-eefd-11ea-83c9-0b6d7b5dc6e5.png)


## Monthly calendar

``` r
calendR(year = 2028, month = 1)
```
![Calendar_enero_2028](https://user-images.githubusercontent.com/67192157/90624619-82d04080-e218-11ea-8570-a2c3b0ccab6d.png)

``` r
calendR(month = 7, year = 2022, 
        special.days = c(1, 5, 12, 28),       # Color days of the month
        text = "Visit\nhttps://r-coder.com/", # Add some text
        text.pos = c(1, 5, 12, 28))           # Where to add the text
```

![Calendar_julio_2022](https://user-images.githubusercontent.com/67192157/90627714-a301fe80-e21c-11ea-84ad-e1038d1b1282.png)


## Custom start and end date  (only on the GitHub development version)

``` r
calendR(start_date = "2020-09-01", end_date = "2021-05-31", lty = 0, title = "2020-2021", start = "M")
```

![imagen](https://user-images.githubusercontent.com/67192157/91883430-b5505380-ec84-11ea-88bf-df7a6fad0dba.png)


## Start of the week (Monday or Sunday)

``` r
# calendR(month = 1, start = "S") # Week starts on Sunday (default)
calendR(month = 1, start = "M")   # Week starts on Monday
```

![Calendar_enero_2020](https://user-images.githubusercontent.com/67192157/90624910-02f6a600-e219-11ea-8b8e-4b9a00aa7f06.png)


## Orientation ("landscape" or "portrait")

``` r
# calendR(year = 2021, orientation = "landscape") # Default
calendR(year = 2021, orientation = "portrait")
```

![Calendar_2021](https://user-images.githubusercontent.com/67192157/90625001-291c4600-e219-11ea-9478-7c65accc259a.png)


## Calendar heatmap (Gradient)

``` r
calendR(year = 2021, special.days = 1:365,
        gradient = TRUE,        # Needed to create the heat map
        special.col = rgb(1, 0, 0, alpha = 0.6), # Higher color
        low.col = "white")                       # Lower color
```

![Calendar_2021_GRADIENT](https://user-images.githubusercontent.com/67192157/90626971-ce381e00-e21b-11ea-919a-b5265c415110.png)


# Add several events (only on the GitHub development version)

``` r
# Vector of NA which length is the number of days of the year or month
myfills <- rep(NA, 366)

# Add the events to the desired days
myfills[c(1:4, 50, 300:315)] <- "Holidays"
myfills[16] <- "Birthday"


calendR(special.days = myfills,
        special.col = 2:3,     # Add as many colors as events
        legend.pos = "right")  # Add a legend if desired
```

![imagen](https://user-images.githubusercontent.com/67192157/91709531-2dceeb80-eb83-11ea-8b07-89a84e69ec2d.png)


## Add background image

``` r
calendR(mbg.col = 4,                # Background color for the month names
        months.col = "white",      # Text color of the month names
        special.days = "weekend",  # Color the weekends
        special.col = "lightblue", # Color of the special.days
        lty = 0,                   # Line type
        weeknames = c("Mo", "Tu",  # Week names
                      "We", "Th",
                      "Fr", "Sa",
                      "Su"),
        title.size = 30,   # Title size
        orientation = "p", # Portrait orientation
        start = "M",       # Start the week on Mondays
        bg.img = "https://i.pinimg.com/originals/10/1e/f6/101ef6a9e146b23de28fa2cd568ad17b.jpg")  # Image
```

<p align="center">
 <img src="https://user-images.githubusercontent.com/67192157/92508606-366d9480-f209-11ea-8303-fa11ba984eb7.png">
</p>

## Lunar calendar

``` r
calendR(month = 1,  
        lunar = TRUE,         # Add moons to monthly calendar
        lunar.col = "gray60", # Color of the non-visible area of the moon
        lunar.size = 7)       # Size of the moons
```

![imagen](https://user-images.githubusercontent.com/67192157/92913288-ea019f00-f42a-11ea-956b-c84619058d41.png)


## Save as PDF (as A4 paper size)

``` r
calendR(year = 2021, orientation = "portrait", pdf = TRUE)

# Specify a custom document name
calendR(year = 2021, orientation = "portrait", pdf = TRUE, doc_name = "My_calendar")
```

## Further customization

### Example 1
``` r
calendR(year = 2022,                             # Year
        mbg.col = 2,                             # Background color for the month names
        months.col = "white",                    # Text color of the month names
        special.days = c(1, 50, 12, 125, 80,     # Color days of the year
                          99, 102, 205, 266, 359),
        special.col = "pink",                    # Color of the special.days
        months.pos = 0.5,                        # Center the month names
        lty = 0,                                 # Line type
        weeknames = c("Mo", "Tu", "We", "Th",    # Week names
                      "Fr", "Sa","Su"), 
        bg.col = "#f4f4f4",                      # Background color
        title.size = 60,                         # Title size
        orientation = "p")                       # Orientation
```
<p align="center">
 <img src="https://user-images.githubusercontent.com/67192157/92388597-da771300-f117-11ea-8c9b-baaa68cf8a41.png">
</p>


### Example 2
``` r
calendR(year = 2020,                        # Year
        month = 10,                         # Month
        title = "My calendar",              # Change the title
        subtitle = "Have a nice day",       # Add a subtitle (or motivational phrase)
        subtitle.col = 3,                   # Color of the subtitle
        weeknames = c("S", "M", "T", "W",   # Change week day names
                      "T", "F", "S"), 
        bg.col = "white",                   # Background color
        special.days = "weekend",           # Colorize the weekends (you can also set a vector of days)
        special.col = rgb(0, 0, 1, 0.15),   # Color of the special days
        text = "Running",                   # Add text (only for monthly calendars)
        text.pos = c(7, 14, 25))            # Days of the month where to put the texts       


```

![Calendar_octubre_2020](https://user-images.githubusercontent.com/67192157/90625501-f6bf1880-e219-11ea-8c57-e10512d790b6.png)


### Example 3 (only on the GitHub development version)
``` r
calendR(start_date = "2020-09-01", # Custom start date
        end_date = "2021-05-31",   # Custom end date
        mbg.col = 4,               # Background color for the month names
        months.col = "white",      # Text color of the month names
        special.days = "weekend",  # Color the weekends
        special.col = "lightblue", # Color of the special.days
        lty = 0,                   # Line type
        weeknames = c("Mo", "Tu",  # Week names
                      "We", "Th",
                      "Fr", "Sa",
                      "Su"),
        bg.col = "#f4f4f4",         # Background color
        title = "Academic calendar 2020-2021", # Title
        title.size = 30,                       # Title size
        orientation = "p", # Portrait orientation
        start = "M")       # Start of the week
# See all the arguments of the function for full customization of the colors, text size and style.
```
<p align="center">
 <img src="https://user-images.githubusercontent.com/67192157/92406650-dc050300-f138-11ea-938b-18f418cb1180.png">
</p>


