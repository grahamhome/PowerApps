#A Shiny module which creates a window for displaying time series plots.
#Created by Graham Home <grahamhome333@gmail.com>

#Proper Name
name <- function() {
	"Time Series Display"
}

#Compatible plot modules
use_plots <- function() {
	list('linear.R','map.R','heatmap.R','correlation.R')
}

#UI
timeSeriesDisplayUI <- function(id) {
	#Create namespace function from id
	ns <- NS(id)
	#Enclose UI contents in a tagList
	tagList(
		fixedPanel(class="mainwindow",
			fluidRow(

				column(2,
					actionLink(ns("back"), "", icon=icon("arrow-left", "fa-2x"), class="icon")
				)
			),
			fluidRow(
				column(12,

					plotOutput(ns("plot"), height="400px", width="100%"), #TODO: Size reactively based on window size
					radioButtons(ns("activeMethod"), "Function:", fnames()[c(2, length(fnames()))], inline=TRUE),
					sliderInput(ns("time"), "Time range to examine",  min = 1, max = nsamples(), value = 1, width = "100%"), #TODO: set max/min reactively
					br(),
					column(4, offset=4,
						div(style="text-align:center", actionLink(ns("play"), "", icon=icon("play", "fa-2x"), class="icon"))
					)
				)
			)	
		)
	)
}

#Server logic
timeSeriesDisplay <- function(input, output, session) {
	print("TS Display is being called")
	output$plot <- renderPlot(eval(parse(text=paste(input$activeMethod, "(", input$time, ")", sep=""))))
	return
}

#TODO: Add real-time animation view back (rolling buffer)