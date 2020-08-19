#' @title ggplot2 monthly and yearly calendars
#'
#' @description Create ready to print monthly and yearly calendars with ggplot2. The package allows personalizing colors (even setting a gradient color scale for a full month or year), texts and fonts and adding texts on the days for monthly calendars.
#'
#' @param start `"S"` (default) for starting the week on Sunday or `"M"` for starting the week on Monday.
#' @param month Month of the year or NULL for the yearly calendar.
#' @param year Year of the calendar. By default uses the current year.
#' @param weeknames Names of the days of the week. By default they will be in english.
#' @param position `"vertical"` or `"horizontal"`
#' @param title Title of the the calendar. If not supplied is the year and the month, or the year if `month = NULL`.
#' @param title.size Size of the main title.
#' @param title.col Color of the main title.
#' @param motivation Motivational phrase added as subtitle of the plot.
#' @param motivation.col Color of the motivational phrase.
#' @param text Character vector of texts to be added on the calendar. Only for monthly calendars.
#' @param text.at Number of days where to add the texts of the `text` argument.
#' @param text.size Font size of the texts added with the `text` argument.
#' @param text.style Style of the texts added with the `text` argument.
#' @param text.col Color of the texts added with the `text` argument.
#' @param special.days Numeric vector indicating the days to color or `"weekend"` for coloring all the weekends.
#' @param special.col Color for the days indicated in special.days.
#' @param gradient Boolean. If `special.days` is a numeric vector of the length of the displayed days, `gradient = TRUE` creates a gradient of the `special.col` on the calendar.
#' @param col Color of the lines of the calendar.
#' @param lwd Line width of the calendar.
#' @param lty Line type of the calendar.
#' @param font.family Font family of all the texts except the motivational phrase.
#' @param weekdays.col Color of the names of the days.
#' @param month.col If `month = NULL`, is the color of the month names.
#' @param days.col Color of the number of the days.
#' @param day.size Font size of the number of the days.
#' @param pdf Boolean. If TRUE, saves the calendar in the working directory in A4.
#'
#'
#' @author
#' \itemize{
#' \item{Soage González, José Carlos.}
#' \item{Maintainer: José Carlos Soage González. \email{jsoage@@uvigo.es}}
#' }
#'
#'
#' @examples
#' \dontrun{
#' # Create ready to print monthly calendars for all the months of the current year
#' # with week starting on Sunday
#' invisible(sapply(1:12 , function(i) calendaR(month = i, pdf = T)))
#' }
#' @import ggplot2 dplyr forcats
#' @importFrom grDevices rgb
#' @export
calendaR <- function(start = c("S", "M"),
                     month = NULL,
                     year = format(Sys.Date(), "%Y"),
                     weeknames = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"),
                     position = c("horizontal", "vertical"),

                     title,
                     title.size = 20,
                     title.col = "gray30",

                     motivation = "",
                     motivation.col = "gray30",

                     text = "",
                     text.at = NULL,
                     text.size = 4,
                     text.style = "plain",
                     text.col = "gray30",

                     special.days = NULL,
                     special.col = rgb(0, 0, 1,  alpha = 0.25),
                     gradient = FALSE,

                     col = "gray30",
                     lwd = 0.75,
                     lty = 1,

                     font.family = "sans",

                     weekdays.col = "gray30",
                     month.col = "gray30",
                     days.col = "gray30",

                     day.size = 3,

                     pdf = FALSE) {



  if (length(unique(start)) != 1) {
    start <- "S"
    # cat("~The week will start on Sunday by default. Set start = 'M' if you prefer the week starting on monday\n")
  }

  if (length(unique(position)) != 1) {
    position <- "horizontal"
    # cat("~The calendar will be horizontal by default. Set position = 'vertical' for a vertical calendar")
  }

  match.arg(start, c("S", "M"))
  match.arg(position, c("horizontal", "vertical", "h", "v"))

  months <- format(seq(as.Date("2016-01-01"), as.Date("2016-12-01"), by = "1 month"), "%B")

  if(text != "" && is.null(text.at)){
    warning("Select the number of days for the text with the 'text.at' argument")
  }

  if(text == "" && !is.null(text.at)){
    warning("Add the text with the 'text' argument")
  }

  if(is.null(month)){

    mindate <- as.Date(format(as.Date(paste0(year, "-0", 01, "-01")), "%Y-%m-01"))
    maxdate <- as.Date(format(as.Date(paste0(year, "-12-", 31)), "%Y-%m-31"))
    weeknames <- substring(weeknames, 1, 3)

  } else {

    if(month >= 10){
      mindate <- as.Date(format(as.Date(paste0(year, "-", month, "-01")), "%Y-%m-01"))
    } else {
      mindate <- as.Date(format(as.Date(paste0(year, "-0", month, "-01")), "%Y-%m-01"))
    }

    maxdate <- seq(mindate, length = 2, by = "months")[2] - 1
  }

  # set up tibble with all the dates.
  filler <- tibble(date = seq(mindate, maxdate, by = "1 day"))

  # Filling colors
  dates <- seq(mindate, maxdate, by = "1 day")
  fills <- numeric(length(dates))

  # Texts
  texts <- character(length(dates))
  texts[text.at] <- text


  if(is.character(special.days)){

    if(special.days != "weekend") {
      stop("special.days must be a numeric vector or 'weekend'")
    }

    if(gradient == TRUE){
      warning("Gradient won't be created as 'special.days' parameters are of type character. Set gradient = FALSE in this scenario to avoid this warning")
    }

  } else {

    if(gradient == TRUE & (length(special.days) != length(dates))) {
      stop("If gradient = TRUE, the length of 'special.days' must be the same as the number of days of the month")
    }
  }

  if(start == "M") {

    weekdays <- weeknames

    t1 <- tibble(date = dates, fill = fills) %>%
      right_join(filler, by = "date") %>% # fill in missing dates with NA
      mutate(dow = ifelse(as.numeric(format(date, "%w")) == 0, 6, as.numeric(format(date, "%w")) - 1)) %>%
      mutate(month = format(date, "%B")) %>%
      mutate(woy = as.numeric(format(date, "%W"))) %>%
      mutate(year = as.numeric(format(date, "%Y"))) %>%
      mutate(month = toupper(factor(month, levels = months, ordered = TRUE))) %>%
      # arrange(year, month) %>%
      mutate(monlabel = month)

    if (!is.null(month)) { # multi-year data set
      t1$monlabel <- paste(t1$month, t1$year)
    }

    t2 <- t1 %>%
      mutate(monlabel = factor(monlabel, ordered = TRUE)) %>%
      mutate(monlabel = fct_inorder(monlabel)) %>%
      mutate(monthweek = woy - min(woy),
             y = max(monthweek) - monthweek + 1) %>%
      mutate(weekend = ifelse(dow == 6 | dow == 5, 1, 0))


    if(is.null(special.days)) {
      special.col <- "white"
    } else {

      if(is.character(special.days)) {

        if(special.days == "weekend") {
          fills <- t2$weekend
        }

      } else {

        if(gradient == TRUE) {
          fills <- special.days
        } else {
          fills[special.days] <- 1
        }
      }
    }

  } else {

    weekdays <- c(weeknames[7], weeknames[1:6])

    t1 <- tibble(date = dates, fill = fills) %>%
      right_join(filler, by = "date") %>% # fill in missing dates with NA
      mutate(dow = as.numeric(format(date, "%w"))) %>%
      mutate(month = format(date, "%B")) %>%
      mutate(woy = as.numeric(format(date, "%U"))) %>%
      mutate(year = as.numeric(format(date, "%Y"))) %>%
      mutate(month = toupper(factor(month, levels = months, ordered = TRUE))) %>%
      # arrange(year, month) %>%
      mutate(monlabel = month)

    if (!is.null(month)) { # multi-year data set
      t1$monlabel <- paste(t1$month, t1$year)
    }

    t2 <- t1 %>%
      mutate(monlabel = factor(monlabel, ordered = TRUE)) %>%
      mutate(monlabel = fct_inorder(monlabel)) %>%
      mutate(monthweek = woy - min(woy),
             y = max(monthweek) - monthweek + 1) %>%
      mutate(weekend = ifelse(dow == 0 | dow == 6, 1, 0))


    if(is.null(special.days)) {
      special.col <- "white"
    } else {

      if(is.character(special.days)) {

        if(special.days == "weekend") {
          fills <- t2$weekend
        }
      }

      else {

        fills[special.days] <- 1
      }
    }
  }

  df <- data.frame(week = weekdays,
                   pos.x = 0:6,
                   pos.y = rep(max(t2$monthweek) + 1.75, 7))

  if(missing(title)){
    title <- levels(t2$monlabel)
  }


  if(is.null(month)){

    if(position == "horizontal" | position == "h") {
      print(ggplot(t2, aes(dow, y, fill = fill)) +
              geom_tile(aes(fill = fills), color = col, size = lwd, linetype = lty) +
              scale_fill_gradient(low = "white", high = special.col) +
              facet_wrap( ~ monlabel, ncol = 4, scales = "free") +
              ggtitle(title) +
              labs(subtitle = motivation) +
              scale_x_continuous(expand = c(0.01, 0.01), position = "top",
                                 breaks = seq(0, 6), labels = weekdays) +
              scale_y_continuous(expand = c(0.05, 0.05)) +
              geom_text(data = t2, aes(label = format(date, "%d")),
                        size = day.size, family = font.family,
                        color = days.col, fontface = text.style) +
              theme(panel.background = element_rect(fill = NA, color = NA),
                    strip.background = element_rect(fill = NA, color = NA),
                    strip.text.x = element_text(hjust = 0, face = "bold", color = month.col),
                    legend.title = element_blank(),
                    axis.ticks = element_blank(),
                    axis.title = element_blank(),
                    axis.text.y = element_blank(),
                    axis.text.x = element_text(colour = weekdays.col),
                    plot.title = element_text(hjust = 0.5, size = title.size, colour = title.col),
                    plot.subtitle = element_text(hjust = 0.5, face = "italic", colour = motivation.col),
                    legend.position = "none",
                    plot.margin = unit(c(1, 0.5, 1, 0.5), "cm"),
                    text = element_text(family = font.family, face = text.style),
                    strip.placement = "outsite"))
    } else {
      print(ggplot(t2, aes(dow, y, fill = fill)) +
              geom_tile(aes(fill = fills), color = col, size = lwd, linetype = lty) +
              scale_fill_gradient(low = "white", high = special.col) +
              facet_wrap( ~ monlabel, ncol = 3, scales = "free") +
              ggtitle(year) +
              labs(subtitle = motivation) +
              scale_x_continuous(expand = c(0.01, 0.01), position = "top",
                                 breaks = seq(0, 6), labels = weekdays) +
              scale_y_continuous(expand = c(0.05, 0.05)) +
              geom_text(data = t2, aes(label = format(date, "%d")),
                        size = day.size, family = font.family,
                        color = days.col, fontface = text.style) +
              theme(panel.background = element_rect(fill = NA, color = NA),
                    strip.background = element_rect(fill = NA, color = NA),
                    strip.text.x = element_text(hjust = 0, face = "bold", color = month.col),
                    legend.title = element_blank(),
                    axis.ticks = element_blank(),
                    axis.title = element_blank(),
                    axis.text.y = element_blank(),
                    axis.text.x = element_text(colour = weekdays.col),
                    plot.title = element_text(hjust = 0.5, size = title.size, colour = title.col),
                    plot.subtitle = element_text(hjust = 0.5, face = "italic", colour = motivation.col),
                    legend.position = "none",
                    plot.margin = unit(c(1, 0.5, 1, 0.5), "cm"),
                    text = element_text(family = font.family, face = text.style),
                    strip.placement = "outsite"))
    }

  } else {

    print(ggplot(t2, aes(dow, y)) +
            geom_tile(aes(fill = fills), color = col, size = lwd, linetype = lty) +
            scale_fill_gradient(low = "white", high = special.col) +
            ggtitle(title) +
            labs(subtitle = motivation) +
            geom_text(data = df, aes(label = week, x = pos.x, y = pos.y), size = 4.5, family = font.family, color = weekdays.col) +
            geom_text(aes(label = texts), color = text.col, size = text.size, family = font.family) +
            # scale_x_continuous(expand = c(0.01, 0.01), position = "top",
            #                   breaks = seq(0, 6), labels = weekdays) +
            scale_y_continuous(expand = c(0.05, 0.05)) +
            geom_text(data = t2, aes(label = 1:nrow(filler), x = dow -0.4, y = y + 0.35), size = day.size, family = font.family, color = days.col) +
            theme(panel.background = element_rect(fill = NA, color = NA),
                  strip.background = element_rect(fill = NA, color = NA),
                  strip.text.x = element_text(hjust = 0, face = "bold"),
                  legend.title = element_blank(),
                  axis.ticks = element_blank(),
                  axis.title = element_blank(),
                  axis.text.y = element_blank(),
                  axis.text.x = element_blank(),
                  plot.title = element_text(hjust = 0.5, size = title.size, colour = title.col),
                  plot.subtitle = element_text(hjust = 0.5, face = "italic", colour = motivation.col),
                  legend.position = "none",
                  plot.margin = unit(c(1, 0, 1, 0), "cm"),
                  text = element_text(family = font.family, face = text.style),
                  strip.placement = "outsite"))
  }

  if(pdf == TRUE) {

    if(!is.null(month)) {

      doc_name <- paste0("Calendar_", tolower(t2$month[1]), "_", year, ".pdf")

    } else{

      doc_name <- paste0("Calendar_", year, ".pdf")
    }

    if(position == "horizontal" | position == "h") {
      ggsave(filename = if(!file.exists(doc_name)) doc_name else stop("File does already exist!"),
             height = 210, width = 297, units = "mm")
    } else {
      ggsave(filename = if(!file.exists(doc_name)) doc_name else stop("File does already exist!"),
             width = 210, height = 297, units = "mm")
    }
  }
}





# calendaR(year = 1945)
