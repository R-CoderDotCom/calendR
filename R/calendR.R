#' @title Monthly and yearly calendars
#'
#' @description Create ready to print monthly and yearly calendars. The function allows personalizing colors (even setting a gradient color scale for a full month or year), texts and fonts. In addition, for monthly calendars you can also add text on the days.
#'
#' @param year Calendar year. By default uses the current year.
#' @param month Month of the year or `NULL` (default) for the yearly calendar.
#' @param start_date Custom start date of the calendar. If `start_date != NULL`, `year` and `month` arguments won't be taken into account.
#' @param end_date Custom end date of the calendar.
#' @param start `"S"` (default) for starting the week on Sunday or `"M"` for starting the week on Monday.
#' @param orientation The calendar orientation: `"portrait"` or `"landscape"` (default). Also accepts `"p"` and `"l"`.
#' @param title Title of the the calendar. If not supplied is the year and the month, or the year if `month = NULL`.
#' @param title.size Size of the main title.
#' @param title.col Color of the main title.
#' @param subtitle Subtitle of the calendar in italics (optional).
#' @param subtitle.col Color of the subtitle.
#' @param subtitle.size Font size of the subtitle.
#' @param text Character vector of texts to be added on the calendar. Only for monthly calendars.
#' @param text.pos Numeric vector containing the number of days of the month where to add the texts of the `text` argument.
#' @param text.size Font size of the texts added with the `text` argument.
#' @param text.col Color of the texts added with the `text` argument.
#' @param special.days Numeric vector indicating the days to color or `"weekend"` for coloring all the weekends.
#' @param special.col Color for the days indicated in special.days. If `gradient = TRUE`, is the higher color of the gradient.
#' @param gradient Boolean. If `special.days` is a numeric vector of the length of the displayed days, `gradient = TRUE` creates a gradient of the `special.col` on the calendar.
#' @param low.col If `gradient = TRUE`, is the lower color of the gradient. If `gradient = FALSE` is the background color of the days. Defaults to `"white"`.
#' @param col Color of the lines of the calendar.
#' @param lwd Line width of the calendar.
#' @param lty Line type of the calendar. If `lty = 0` no lines are drawn.
#' @param font.family Font family of all the texts.
#' @param font.style Style of all the texts and numbers except the subtitle. Possible options are `"plain"` (default), `"bold"`, `"italic"` and `"bold.italic"`.
#' @param day.size Font size of the number of the days.
#' @param days.col Color of the number of the days.
#' @param weeknames Character vector with the names of the days of the week starting on Monday. By default they will be in the system locale.
#' @param weeknames.col Color of the names of the days.
#' @param weeknames.size Size of the names of the days.
#' @param months.size Font size of the names of the months.
#' @param months.col If `month = NULL`, is the color of the month names.
#' @param months.pos Horizontal align of the month names. Defaults to 0.5 (center).
#' @param mbg.col Background color of the month names. Defaults to "white".
#' @param legend.pos If `gradient = TRUE`, is the position of the legend. It can be set to `"none"` (default), `"top"`, `"bottom"`, `"left"` and `"right"`.
#' @param legend.title If `legend.pos != "none"` and  `gradient = TRUE`, is the title of the legend.
#' @param bg.col Background color of the calendar. Defaults to "white".
#' @param bg.img Character string containing the URL or the local directory of a image to be used as background.
#' @param margin Numeric. Allows controlling the margin of the calendar.
#' @param lunar Boolean. If `TRUE`, draws the lunar phases. Only available for monthly calendars.
#' @param lunar.col If `lunar = TRUE`, is the color of the hide part of the moons.
#' @param lunar.size If `lunar = TRUE`, is the size of the representation of the moons.
#' @param pdf Boolean. If `TRUE`, saves the calendar in the working directory in A4 format.
#' @param doc_name If `pdf = TRUE`, is the name of the generated file (without the file extension). If not specified, creates files of the format: `Calendar_year.pdf` for yearly calendars and `Calendar_month_year.pdf` for monthly calendars.
#' @param papersize PDF paper size. Possible options are `"A6"`, `"A5"`, `"A4"` (default), `"A3"`, `"A2"`, `"A1"` and `"A0"`. Depending on the size you will need to fine-tune some arguments, like the font sizes.
#'
#' @author
#' \itemize{
#' \item{Soage González, José Carlos.}
#' \item{Maintainer: José Carlos Soage González. \email{jsoage@@uvigo.es}}
#' }
#'
#' @examples
#' # Calendar of the current year
#' calendR()
#'
#' # Calendar of July, 2005, starting on Monday
#' calendR(year = 2005, month = 7, start = "M", subtitle = "Have a nice day")
#'
#' \donttest{
#' # Create ready to print monthly calendars for all the months of the current year
#' # with week starting on Sunday
#' invisible(sapply(1:12 , function(i) calendR(month = i, pdf = TRUE,
#'  doc_name = file.path(tempdir(), paste0("myCalendar", i , ".pdf")))))
#' }
#'
#' @import ggplot2 dplyr forcats suncalc ggimage gggibbous
#' @importFrom grDevices rgb
#' @importFrom stats na.omit
#' @export
calendR <- function(year = format(Sys.Date(), "%Y"),
                    month = NULL,

                    start_date = NULL,
                    end_date = NULL,

                    start = c("S", "M"),
                    orientation = c("portrait", "landscape"),

                    title,
                    title.size = 20,
                    title.col = "gray30",

                    subtitle = "",
                    subtitle.size = 10,
                    subtitle.col = "gray30",

                    text = "",
                    text.pos = NULL,
                    text.size = 4,
                    text.col = "gray30",

                    special.days = NULL,
                    special.col = "gray90",
                    gradient = FALSE,
                    low.col = "white",

                    col = "gray30",
                    lwd = 0.5,
                    lty = 1,

                    font.family = "sans",
                    font.style = "plain",

                    day.size = 3,
                    days.col = "gray30",

                    weeknames,
                    weeknames.col = "gray30",
                    weeknames.size = 4.5,

                    months.size = 10,
                    months.col = "gray30",
                    months.pos = 0.5,
                    mbg.col = "white",

                    legend.pos = "none",
                    legend.title = "",

                    bg.col = "white",
                    bg.img = "",

                    margin = 1,

                    lunar = FALSE,
                    lunar.col = "gray60",
                    lunar.size = 7,

                    pdf = FALSE,
                    doc_name = "",
                    papersize = "A4") {

  if(year < 0) {
    stop("You must be kidding. You don't need a calendar of a year Before Christ :)")
  }

  wend <- TRUE
  l <- TRUE

  if((!is.null(start_date) & is.null(end_date))) {
    stop("Provide an end date with the 'end_date' argument")
  }

  if((is.null(start_date) & !is.null(end_date))) {
    stop("Provide a start date with the 'start_date' argument")
  }

  if(is.character(special.days) & length(unique(na.omit(special.days))) != length(special.col)) {
    stop("The number of colors supplied on 'special.col' argument must be the same of length(unique(na.omit(special.days)))")
  }

  if (length(unique(start)) != 1) {
    start <- "S"
  }

  if (length(unique(orientation)) != 1) {
    orientation <- "landscape"
  }

  match.arg(start, c("S", "M"))
  match.arg(orientation, c("landscape", "portrait", "l", "p"))
  match.arg(papersize, c("A6", "A5", "A4", "A3", "A2", "A1", "A0"))


  if(!is.null(month)){
    if(month > 12) {
      stop("There are no more than 12 months in a year")
    }

    if(month <= 0) {
      stop("Months must be between 1 and 12")
    }

    if(is.character(month)) {
      stop("You must provide a month in a numeric format, between 1 and 12")
    }
  }

  months <- format(seq(as.Date("2016-01-01"), as.Date("2016-12-01"), by = "1 month"), "%B")

  if(text != "" && is.null(text.pos)){
    warning("Select the number of days for the text with the 'text.pos' argument")
  }

  if(text == "" && !is.null(text.pos)){
    warning("Add the text with the 'text' argument")
  }

  if(missing(weeknames)) {

    up <- function(x) {
      substr(x, 1, 1) <- toupper(substr(x, 1, 1))
      x
    }

    Day <- seq(as.Date("2020-08-23"), by = 1, len=7)
    weeknames <- c(up(weekdays(Day))[2:7], up(weekdays(Day))[1])
  }


  if(!is.null(start_date) & !is.null(end_date)){

    if(lunar == TRUE) {
      l <- FALSE
      warning("Lunar phases are only available for monthly calendars")
    }

    mindate <- as.Date(start_date)
    maxdate <- as.Date(end_date)
    weeknames <- substring(weeknames, 1, 3)

  } else {

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
  }

  # set up tibble with all the dates.
  filler <- tibble(date = seq(mindate, maxdate, by = "1 day"))

  # Filling colors
  dates <- seq(mindate, maxdate, by = "1 day")
  fills <- numeric(length(dates))

  # Texts
  texts <- character(length(dates))
  texts[text.pos] <- text

  moon_m <- getMoonIllumination(date = dates, keep = c("fraction", "phase", "angle"))
  moon <- moon_m[, 2]
  right <- ifelse(moon_m[, 4] < 0, TRUE, FALSE)

  if(is.character(special.days)) {

    if(length(special.days) != length(dates)){

      if(special.days != "weekend") {
        stop("special.days must be a numeric vector, a character vector of the length of the number of days of the year or month or 'weekend'")
      } else {
        wend <- FALSE
      }
    }


    if(gradient == TRUE){
      warning("Gradient won't be created as 'special.days' is of type character. Set gradient = FALSE in this scenario to avoid this warning")

      if(legend.title != "" & legend.pos == "none"){
        warning("Legend title specified, but legend.pos == 'none', so no legend will be plotted")
      }

    } else {
      if(length(special.days) != length(dates) & (legend.pos != "none" | legend.title != "")) {
        legend.pos = "none"
        warning("gradient = FALSE, so no legend will be plotted")
      }
    }

  } else {

    if(gradient == FALSE){
      if(length(special.days) != length(dates) & (legend.pos != "none" | legend.title != "")) {
        legend.pos = "none"
        warning("gradient = FALSE, so no legend will be plotted")
      }
    } else {

      if(legend.title != "" & legend.pos == "none"){
        warning("Legend title specified, but legend.pos == 'none', so no legend will be plotted")
      }
    }

    if(any(special.days > length(dates))) {

      stop("No element of the 'special.days' vector can be greater than the number of days of the corresponding month or year")
    }

    if(gradient == TRUE & (length(special.days) != length(dates))) {
      stop("If gradient = TRUE, the length of 'special.days' must be the same as the number of days of the corresponding month or year")
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

        if (length(special.days) == length(dates)) {
          fills <- special.days
        } else {
          if (special.days == "weekend") {
            fills <- t2$weekend
          }
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

    if (!is.null(month)) { # Multi-year data set
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
        if (length(special.days) == length(dates)) {
          fills <- special.days
        } else {
          if (special.days == "weekend") {
            fills <- t2$weekend
          }
        }
      } else {

        if(gradient == TRUE) {
          fills <- special.days
        } else {
          fills[special.days] <- 1
        }
      }
    }
  }

  df <- data.frame(week = weekdays,
                   pos.x = 0:6,
                   pos.y = rep(max(t2$monthweek) + 1.75, 7))

  if(missing(title)) {

    if(!is.null(start_date) & !is.null(end_date)) {

      title <- paste0(format(as.Date(start_date), "%m"), "/", format(as.Date(start_date), "%Y"), " - ",
                      format(as.Date(end_date), "%m"), "/", format(as.Date(end_date), "%Y"))

    }else{

      if(is.null(month)) {
        title <- year
      } else {
        title <- levels(t2$monlabel)
      }
    }
  }


  if(is.null(month)) {

    if(lunar == TRUE & l != FALSE) {
      warning("Lunar phases are only available for monthly calendars")
    }

   p <- ggplot(t2, aes(dow, y)) +
      geom_tile(aes(fill = fills), color = col, size = lwd, linetype = lty)


    if(is.character(special.days) & wend & length(unique(special.days) == length(dates))) {
      p <- p + scale_fill_manual(values = special.col, labels = levels(as.factor(fills)), na.value = "white", na.translate = FALSE)
    } else {
      p <- p + scale_fill_gradient(low = low.col, high = special.col)
    }

    p <- p + facet_wrap( ~ monlabel, ncol = ifelse(orientation == "landscape" | orientation == "l", 4, 3), scales = "free") +
      ggtitle(title) +
      labs(subtitle = subtitle) +
      scale_x_continuous(expand = c(0.01, 0.01), position = "top",
                         breaks = seq(0, 6), labels = weekdays) +
      scale_y_continuous(expand = c(0.05, 0.05)) +
      geom_text(data = t2, aes(label = gsub("^0+", "", format(date, "%d"))),
                size = day.size, family = font.family,
                color = days.col, fontface = font.style) +
      labs(fill = legend.title) +
      theme(panel.background = element_rect(fill = NA, color = NA),
            strip.background = element_rect(fill = mbg.col, color = mbg.col),
            plot.background = element_rect(fill = bg.col),
            panel.grid = element_line(colour = ifelse(bg.img ==  "", bg.col, "transparent")),
            strip.text.x = element_text(hjust = months.pos, face = font.style, color = months.col, size = months.size),
            legend.title = element_text(),
            axis.ticks = element_blank(),
            axis.title = element_blank(),
            axis.text.y = element_blank(),
            axis.text.x = element_text(colour = weeknames.col, size = weeknames.size * 2.25),
            plot.title = element_text(hjust = 0.5, size = title.size, colour = title.col),
            plot.subtitle = element_text(hjust = 0.5, face = "italic", colour = subtitle.col, size = subtitle.size),
            legend.position = legend.pos,
            plot.margin = unit(c(1 * margin, 0.5 * margin, 1 * margin, 0.5 * margin), "cm"),
            text = element_text(family = font.family, face = font.style),
            strip.placement = "outsite")

    if(bg.img != "") {
      p <- ggbackground(p, bg.img)
    }

  # print(p)

  } else {

    tidymoons <- data.frame(
      x = t2$dow + 0.35,
      y =  t2$y + 0.3,
      ratio = moon,
      right = right
    )

    tidymoons2 <- data.frame(
      x = t2$dow + 0.35,
      y =  t2$y + 0.3,
      ratio = 1 - moon,
      right = !right
    )

    p <- ggplot(t2, aes(dow, y)) +
      geom_tile(aes(fill = fills), color = col, size = lwd, linetype = lty)

    if(lunar == TRUE){
      p <- p + geom_moon(data = tidymoons, aes(x, y, ratio = ratio, right = right), size = lunar.size, fill = "white") +
               geom_moon(data = tidymoons2, aes(x, y, ratio = ratio, right = right), size = lunar.size, fill = lunar.col)
    }


      if(is.character(special.days) & wend & length(unique(special.days) == length(dates))) {
        p <- p + scale_fill_manual(values = special.col, labels = levels(as.factor(fills)), na.value = "white", na.translate = FALSE)
      } else {
        p <- p + scale_fill_gradient(low = low.col, high = special.col)
      }

      p <- p + ggtitle(title) +
        labs(subtitle = subtitle) +
        geom_text(data = df, aes(label = week, x = pos.x, y = pos.y), size = weeknames.size, family = font.family, color = weeknames.col, fontface = font.style) +
        geom_text(aes(label = texts), color = text.col, size = text.size, family = font.family) +
        # scale_x_continuous(expand = c(0.01, 0.01), position = "top",
        #                   breaks = seq(0, 6), labels = weekdays) +
        scale_y_continuous(expand = c(0.05, 0.05)) +
        geom_text(data = t2, aes(label = 1:nrow(filler), x = dow -0.4, y = y + 0.35), size = day.size, family = font.family, color = days.col, fontface = font.style) +
        labs(fill = legend.title) +
        theme(panel.background = element_rect(fill = NA, color = NA),
              strip.background = element_rect(fill = NA, color = NA),
              plot.background = element_rect(fill = bg.col),
              panel.grid = element_line(colour = ifelse(bg.img ==  "", bg.col, "transparent")),
              strip.text.x = element_text(hjust = 0, face = "bold", size = months.size),
              legend.title = element_text(),
              axis.ticks = element_blank(),
              axis.title = element_blank(),
              axis.text.y = element_blank(),
              axis.text.x = element_blank(),
              plot.title = element_text(hjust = 0.5, size = title.size, colour = title.col),
              plot.subtitle = element_text(hjust = 0.5, face = "italic", colour = subtitle.col, size = subtitle.size),
              legend.position = legend.pos,
              plot.margin = unit(c(1 * margin,  0.5 * margin, 1 * margin,  0.5 * margin), "cm"),
              text = element_text(family = font.family, face = font.style),
              strip.placement = "outsite")

      if(bg.img != "") {
        p <- ggbackground(p, bg.img)
      }

   # print(p)

  }

  if(pdf == FALSE & doc_name != ""){
    warning("Set pdf = TRUE to save the current calendar")
  }

  if(pdf == TRUE) {

    switch (papersize,
      A6 = {
        a <- 148
        b <- 105

      },
      A5 = {
        a <- 210
        b <- 148

      },
      A4 = {
        a <- 297
        b <- 210
      },
      A3 = {
        a <- 420
        b <- 297
      },
      A2 = {
        a <- 594
        b <- 420
      },
      A1 = {
        a <- 841
        b <- 594
      },
      A0 = {
        a <- 1189
        b <- 841
      },
    )


    if(doc_name == "") {
      if(!is.null(month)) {

        doc_name <- paste0("Calendar_", tolower(t2$month[1]), "_", year, ".pdf")

      } else {
        if(!is.null(start_date) & !is.null(end_date)) {
          doc_name <- paste0("Calendar_", start_date, "_", end_date, ".pdf")
        } else {
          doc_name <- paste0("Calendar_", year, ".pdf")
        }
      }


    } else {
      doc_name <- paste0(doc_name, ".pdf")
    }

    if(orientation == "landscape" | orientation == "l") {
      ggsave(filename = if(!file.exists(doc_name)) doc_name else stop("File does already exist!"),
             height = b, width = a, units = "mm")
    } else {
      ggsave(filename = if(!file.exists(doc_name)) doc_name else stop("File does already exist!"),
             width = b, height = a, units = "mm")
    }
  }

  return(p)
}
