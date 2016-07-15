#Utility functions for displaying the results of plotting plugins.

#Given a plot, a time value, and a directory, creates an appropriately-sized PNG of the plot named with the time value.
plotpng <- function(g, t, dir) {
  ggsave(file=paste(dir, t, ".png", sep=""), plot=g, width=10, height=4, units="in")
}

#Given a function call (i.e. function name with arguments in parentheses) and a filename, saves the result of the function call with the specified filename.
plot2png <- function(functionCall, fileName) {
	png(filename=fileName, width=1000, height=400, units="px")
	print(eval(parse(text=functionCall)))
	dev.off()
}

#Given a function call (i.e. function name with arguments in parentheses) and a filename, saves the result of the function call with the specified filename.
#Specialized for correlation plots which are of a different type than ggplots.
plotCorr2png <- function(functionCall, fileName) {
	png(filename=fileName, width=500, height=500, units="px")
	eval(parse(text=functionCall))
	dev.off()
}

#Returns the given plot zoomed to the given parameters.
zoomPlot <- function(p, xmin, ymin, xmax, ymax) {
	print(par())
	q <- p + scale_x_continuous(limits=c(xmin, xmax), expand=c(0,0)) + 
		scale_y_continuous(limits=c(ymin, ymax), expand=c(0,0))

	print(par())
	q
}

#Resets the current plot to its original zoom level
resetPlotZoom <- function() {
	buffer <- 2
	g <<- g + scale_x_continuous(limits = c(-90.6, -81.3)) +
		scale_y_continuous(limits = c(34.5, 37))
	# g <<- g + scale_x_continuous(limits=c(min(bus_locs$longitude)-buffer, max(bus_locs$longitude)+buffer)) +
	# 	scale_y_continuous(limits=c(min(bus_locs$latitude)-buffer, max(bus_locs$latitude)+buffer))
}