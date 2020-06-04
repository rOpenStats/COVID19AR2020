#' setup Dataviz theme
#' @import RColorBrewer
#' @importFrom grDevices colorRampPalette
#' @import scales
#' @export
setupTheme <- function(ggplot, report.date, x.values, data.provider.abv, total.colors, x.type = "dates", base.size = 6){
 if (!is.null(x.type)){
  if (x.type == "dates"){
   dates    <- x.values
   max.date <- max(dates)
   min.date <- min(dates)
   date.breaks.freq  <- "7 day"
   minor.breaks.freq <- "1 day"
   date.labels.format <- "%y-%m-%d"
   neg.date.breaks.freq <- paste("-", date.breaks.freq, sep ="")
   neg.minor.breaks.freq <- paste("-", minor.breaks.freq, sep ="")
   date.breaks  <- sort(seq(max.date,
                            min.date,
                            by = neg.date.breaks.freq))
   minor.breaks  <- sort(seq(max.date,
                             min.date,
                             by = neg.minor.breaks.freq))
   ggplot <- ggplot + scale_x_date(date_labels = date.labels.format,
                                   breaks  = date.breaks,
                                   minor_breaks = minor.breaks
                                   #,limits = c(min.date, max.date)
   )
  }
  if (x.type == "epidemy.day"){
   max.value <- max(x.values)
   min.value <- min(x.values)
   breaks  <- sort(seq(max.value, min.value,
                       by = -7))
   ggplot <- ggplot + scale_x_continuous(breaks  = breaks,
                                         minor_breaks = x.values)
  }
 }
 if (!is.null(total.colors)){
  #, selected.palette = "Paired"
  #colors.palette <- colorRampPalette(brewer.pal(8, selected.palette))(total.colors)
  colors.palette <- c(brewer.pal(n = 9, name = "Set1"), brewer.pal(n = 8, name = "Set2"), brewer.pal(n = 12, name = "Set3"))
  if ( total.colors > length(colors.palette)){
   colors.palette <- colorRampPalette(colors.palette)(total.colors)
  }
  else{
   colors.palette <- colors.palette[seq_len(total.colors)]
  }
  ggplot <- ggplot +
   #scale_fill_brewer(palette = selected.palette)
   scale_fill_manual(values = colors.palette) +
   scale_color_manual(values = colors.palette)
 }
 ggplot <- ggplot +
      theme_bw(base_size = base.size,
               #base_family = "Courier"
               base_family = "mono",
      ) +
      scale_y_continuous(labels = comma) +
      theme(legend.title = element_blank(),
            plot.caption = element_text(size = 5),
            axis.text.x = element_text(angle = 90)) +
      labs(caption = getCitationNote(report.date = report.date, data.provider = data.provider.abv))
 ggplot
}


#' @noRd
#' @export
getCitationNote <- function(add.date = TRUE, report.date, data.provider.abv){
 ret <- "credit @ken4rab"
 if (add.date){
  ret <- paste(ret, report.date)
 }
 ret <- paste(ret, "\nsource: https://github.com/rOpenStats/COVID19AR/ based on", data.provider.abv)
 ret
}


