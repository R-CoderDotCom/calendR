# calendR R package<img width = 150px height = 150px src="https://user-images.githubusercontent.com/67192157/97783151-22ee0280-1b96-11eb-9b78-2ba02395c5c8.png" align="right" />
Ready to print monthly and yearly calendars made with ggplot2


📅 The calendars **will be created by default in the system locale**. Change it with `Sys.setlocale(locale = "the_preferred_language")`.

📖 Check the [full calendR package tutorial](https://r-coder.com/calendar-plot-r/).


## Index
- [Installation](#installation)
- [Yearly calendar](#yearly-calendar)
- [Monthly calendar](#monthly-calendar)
- [Custom start and end date](#custom-start-and-end-date)
- [Start of the week](#start-of-the-week-monday-or-sunday)
- [Orientation](#orientation-landscape-or-portrait)
- [Heat map](#calendar-heatmap-gradient)
- [Add several events](#add-several-events)
- [Add week numbers of the year](#add-week-number-only-on-the-github-development-version)
- [Add background image](#add-background-image)
- [Lunar calendar](#lunar-calendar)
- [Save as PDF](#save-as-pdf)
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

![Calendar_2020](https://user-images.githubusercontent.com/67192157/95111727-35fce680-0740-11eb-9193-d61cd10352be.png)


``` r
calendR(year = 2020,           # Year
        mbg.col = 2,           # Background color for the month names
        months.col = "white",  # Text color of the month names
        special.days = c(1, 50, 12, 125, 80,     # Color days of the year
                         99, 102, 205, 266, 360),
        special.col = "pink", # Color of the special.days
        months.pos = 0.5)     # Horizontal alignment of the month names
```

![calendR](https://user-images.githubusercontent.com/67192157/95111865-693f7580-0740-11eb-8b92-959be1315bbc.png)


## Monthly calendar

``` r
calendR(year = 2028, month = 1)
```
![Calendar_January_2028](https://user-images.githubusercontent.com/67192157/97290793-56085d00-1849-11eb-92f9-78f856772961.png)

``` r
calendR(month = 7, year = 2022, 
        special.days = c(1, 5, 12, 28),       # Color days of the month
        text = "Visit\nhttps://r-coder.com/", # Add some text
        text.pos = c(1, 5, 12, 28))           # Where to add the text
```

![calendar_july](https://user-images.githubusercontent.com/67192157/97290979-98ca3500-1849-11eb-9131-b391919a9de8.png)


## Custom start and end date

``` r
calendR(from = "2020-09-01",  # Start date
        to = "2021-05-31",    # End date
        lty = 0,              # Line type
        title = "2020-2021",  # Title
        start = "M",          # Start on Mondays
        months.pos = 0)       # Left-align month names
```

![imagen](https://user-images.githubusercontent.com/67192157/95112213-f2ef4300-0740-11eb-8778-dcdafb5c69ca.png)


## Start of the week (Monday or Sunday)

``` r
# calendR(month = 1, start = "S") # Week starts on Sunday (default)
calendR(month = 1, start = "M")   # Week starts on Monday
```

![Calendar_January_2020](https://user-images.githubusercontent.com/67192157/97291161-d0d17800-1849-11eb-8e04-318918ea485d.png)

## Orientation ("landscape" or "portrait")

``` r
# calendR(year = 2021, orientation = "landscape") # Default
calendR(year = 2021, orientation = "portrait")
```

<p align="center">
 <img src="https://user-images.githubusercontent.com/67192157/95113135-43b36b80-0742-11eb-8668-a6d2844daa4a.png">
</p>


## Calendar heatmap (Gradient)

``` r
calendR(year = 2021, special.days = 1:365,
        gradient = TRUE,        # Needed to create the heat map
        special.col = rgb(1, 0, 0, alpha = 0.6), # Higher color
        low.col = "white")                       # Lower color
```

![Calendar_2021_GRADIENT](https://user-images.githubusercontent.com/67192157/95112323-11edd500-0741-11eb-96f1-34ecf137e8e4.png)


### Gradient for certain days

``` r
# Data
my_data <- runif(20, 10, 20)

# Create a vector where all the values are
# a bit lower than the lowest value of your data
# (This will make the trick)
days <- rep(min(my_data) - 0.05, 365)

# Fill the days you want with your data
days[20:39] <- my_data

calendR(year = 2021,
        special.days = days,
        gradient = TRUE,   # Needed to create the heat map
        special.col = rgb(1, 0, 0, alpha = 0.6), # Higher color
        low.col = "white") # In this case, the color of the values out of the gradient
```
![imagen](https://user-images.githubusercontent.com/67192157/95112558-5f6a4200-0741-11eb-92de-be90274d9a16.png)


## Add several events

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

![imagen](https://user-images.githubusercontent.com/67192157/95112825-be2fbb80-0741-11eb-9a46-61fee509409d.png)


### Colors order

The colors are displayed based on the levels of the factor of the categorical variable.

``` r
# Current order:
levels(factor(myfills)) # "Birthday" "Holidays"

#------
# Way 1
#------
calendR(special.days = myfills,
        special.col = 3:2,     # Change the order to match the desired colors
        legend.pos = "right")

#------
# Way 2
#------

# Desired order and colors
desired_order <- c("Holidays", # (2: red)
                   "Birthday") # (3: green)

# Order the colors based on the desired order
ordered_colors <- c(2, 3)[order(desired_order)]

calendR(special.days = myfills,
        special.col = ordered_colors, # Ordered colors
        legend.pos = "right")  # Add a legend if desired
```
![custom_order](https://user-images.githubusercontent.com/67192157/97010808-3241d000-1546-11eb-9df5-c583f40cf530.png)


### Several events with custom start and end dates

``` r
start_date <- "2020-04-01"
end_date <- "2020-12-31"

custom_dates <- seq(as.Date(start_date), as.Date(end_date), by = "1 day")
events <- rep(NA, length(custom_dates))

# Time difference
dif <- 365 - length(custom_dates)

myfills <- rep(NA, length(custom_dates))

# Specify the dates as in a 365 days calendar and substract the time difference
myfills[c(180:210) - dif] <- "Holidays"
myfills[215 - dif] <- "Birthday"

calendR(from = start_date, to = end_date,
        special.days = myfills, special.col = 2:3, legend.pos = "bottom")

```

![imagen](https://user-images.githubusercontent.com/67192157/97031386-7b068280-1560-11eb-8946-f9decac9b16f.png)

## Add week number (only on the GitHub development version)

``` r
calendR(year = 2021,
        week.number = TRUE,          # Adds the week number of the year for each week 
        week.number.col = "gray30",  # Color of the week numbers
        week.number.size = 8)        # Size of the week numbers
```

![imagen](https://user-images.githubusercontent.com/67192157/95112864-ca1b7d80-0741-11eb-969d-b40476859693.png)


``` r
calendR(year = 2021,
        month = 2,
        week.number = TRUE,      # Adds the week number of the year for each week 
        week.number.col = 2,     # Color of the week numbers
        week.number.size = 14)   # Size of the week numbers
```

![imagen](https://user-images.githubusercontent.com/67192157/97290741-42f58d00-1849-11eb-9398-f2e2d32ed541.png)

## Add background image

``` r
calendR(mbg.col = 4,               # Background color for the month names
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
 <img src="https://user-images.githubusercontent.com/67192157/95113464-cb00df00-0742-11eb-933f-f2a5df55b51c.png">
</p>


## Lunar calendar

``` r
calendR(month = 1,  
        lunar = TRUE,         # Add moons to monthly calendar
        lunar.col = "gray60", # Color of the non-visible area of the moon
        lunar.size = 7)       # Size of the moons
```

![Lunar_Calendar](https://user-images.githubusercontent.com/67192157/97291525-57865500-184a-11eb-9afc-7e52e6fe3fc4.png)


## Save as PDF

``` r
# Defaults to A4 size
calendR(year = 2021, orientation = "portrait", pdf = TRUE)

# Set a paper size (from A6 to A0)
calendR(year = 2021, orientation = "portrait", pdf = TRUE, papersize = "A6")

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
 <img src="https://user-images.githubusercontent.com/67192157/95113514-da802800-0742-11eb-9d94-be5e0096fee9.png">
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

![Custom_colors](https://user-images.githubusercontent.com/67192157/97291394-24dc5c80-184a-11eb-9a41-afa13432bbfe.png)


### Example 3
``` r
calendR(from = "2020-09-01", # Custom start date
        to = "2021-05-31",   # Custom end date
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

### Example 4

``` r
Sys.setlocale(locale = "English")
calendR(month = 10,  # Month
        start = "M", # Week starts on Monday
        orientation = "landscape", # Horizontal
        
        # Size and color of the title
        title.size = 40,
        title.col = "white",
        
        weeknames = c("MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"),
        # Subtitle, color y and size
        subtitle = "I WITCH YOU A HAPPY HALLOWEEN",
        subtitle.col = "red",
        subtitle.size = 16,
        
        # Text, color, size and position
        text = "HALLOWEEN",
        text.col = "red",
        text.size = 5,
        text.pos = 31,
        
        # Color the weekends with gray
        special.days = "weekend",
        special.col = "grey40",
        
        # Color of the lines, of the background
        # and of the days
        col = "white",
        bg.col = "grey20",
        low.col = "transparent", # The same color as the background
        
        # Color and size of the number of the days
        days.col = "white",
        day.size = 4,
        
        # Moon phases and moon sizes
        lunar = TRUE,
        lunar.size = 8,
        lunar.col = "red",
        
        # Color and size of the week names
        weeknames.col = "white",
        weeknames.size = 6,
        
        # Width and line types
        lwd = 0.25,
        lty = 1,
        
        # Background image
        bg.img = "https://user-images.githubusercontent.com/67192157/94996404-cdc5cd80-05a4-11eb-97cb-84a195d9138c.png",
        
        # Font family and font styles
        font.family = "CF Halloween",   # You will need to download and import the font with the extrafont package
        font.style = "plain",
        pdf = TRUE,
        doc_name = "halloween")
```

![halloween](https://user-images.githubusercontent.com/67192157/94996393-bdadee00-05a4-11eb-988d-52eafe72352f.png)


### Example 5

```r
calendR(month = 12,
        start = "M",
        subtitle = "Merry Christmas!",
        subtitle.col = "white", lwd = 0.4,
        title.size = 70, 
        subtitle.size = 40,
        day.size = 9,
        weeknames.size = 10,
        special.col = rgb(0.2, 0.2, 0.2, 0.2),
        days.col = "white",
        title.col = "white",
        bg.col = "red",
        low.col = "transparent",
        col = "white",
        special.days = c(5, 6, 12, 13, 19, 20, 25, 26, 27, 31),
        bg.img = "https://user-images.githubusercontent.com/67192157/100520172-b23e0400-319c-11eb-98a8-10fdc95006fe.png",
        weeknames.col = "white",
        font.family = "perfect",  # https://www.dafont.com/es/the-perfect-christmas.font
        pdf = TRUE)
```

![Christmas_calendar](https://user-images.githubusercontent.com/67192157/100520209-efa29180-319c-11eb-8fb1-c7e0c92eb202.png)


```r
calendR(month = 12,
        start = "M",
        subtitle = "Merry Christmas!",
        subtitle.col = "gray40",
        lwd = 0.4,
	title.size = 70,
        subtitle.size = 40,
        day.size = 9,
        weeknames.size = 10,
	special.days = "weekend",
        special.col = rgb(1, 1, 1, 0.1),
        days.col = "gray20",
	title.col = "gray30",
        bg.col = "gray40",
        low.col = "transparent",
        col = "gray50",
	weeknames.col = "gray20",
        bg.img = "https://user-images.githubusercontent.com/67192157/100520175-b4a05e00-319c-11eb-8733-af9f20b674c8.png",
        font.family = "perfect", # https://www.dafont.com/es/the-perfect-christmas.font
        pdf = TRUE)
```
![Christmas_calendar_2020](https://user-images.githubusercontent.com/67192157/100520249-1a8ce580-319d-11eb-9ff1-0e20d47e15b7.png)


### Example 6

```r
# Dancing Script Font
library(showtext)
font_add_google(name = "Dancing Script",   
                family = "dancing") 
showtext_auto()

Sys.setlocale(locale = "English")

calendR(2021,
	mbg.col = "#73b7fb",      
        months.col = "white",     
        special.days = "weekend",
	title.col= "#103a63",
	weeknames.col= "#103a63",
	days.col = "#14487c",
	special.col = "#bdddfd", 
	lty = 0,   
	monthnames = c("January", "February", "March", "April", "May", "June", 
	                "July", "August", "September", "October", "November", "December"),
	font.family = "dancing",   
	font.style = "bold",        
	weeknames.size = 6,   
	week.number = TRUE,
	week.number.col = "dodgerblue2",
	weeknames = c("Mo", "Tu",  
	              "We", "Th",
	              "Fr", "Sa",
 	             "Su"),        
	title.size = 40,    
	months.size = 20,              
	orientation = "p",  
	bg.col = "#ebf4fe",
	day.size = 4,
	papersize = "A4",
	start = "M") 
```

<p align="center">
 <img src="https://user-images.githubusercontent.com/67192157/103289202-e5b3be80-49e6-11eb-9ef1-ee8e685d9715.png" alt = "Calendar 2021">
</p>

## Social Media
- Facebook: [https://www.facebook.com/RCODERweb](https://www.facebook.com/RCODERweb)
- Twitter: [https://twitter.com/RCoderWeb](https://twitter.com/RCoderWeb)
