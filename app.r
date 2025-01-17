#PowerViewer: A tool for visualizing power grid data.
#This is the starting point for the application. Please see the README file
#located in the same directory as this file for more information.

#Author: Graham Home <grahamhome333@gmail.com>

#Dependencies
library(shiny)
library(shinythemes)

#Basic imports needed for the app to function
baseImports <- function() {

	#Import UI render functions
	source("ui/intro.r")
	source("ui/dataPicker.r")
	source("ui/plotPicker.r")
	source("ui/displayPicker.r")

	#Import tools
	source("utils/pluginTools.r")
	source("utils/moduleTools.r")
	source("utils/plotTools.r")
}
baseImports()

#Reactive values for plugins. plugins are function collections for collecting, plotting or displaying data
plugins <- reactiveValues()
plugins$data <- list() 		#List of import plugin proper names mapped to filenames
plugins$displays <- list() 	#List of display plugin proper names linked to list(filename, plots). plots = compatible plot plugin filenames
plugins$compatPlots <- list() #Set of plot plugins compatible with the available data import plugins. Maps plugin filenames to proper names.
plugins$compatDisplays <- list() #Set of display plugins compatible with the selected plot plugin
plugins$launchedDisplays <- list() #List of display plugins which have previously been launched

#Initialize plugin reactive values once on app startup
isolate(loadplugins())

#Reactive value for current UI function 
window <- reactiveValues()
window$content <- NULL #Name of the current user interface function

#Start the intro activity when the app starts
launchUI("intro()")

#Application UI function
ui <- fluidPage(title="Power Viewer",

	theme=shinytheme("spacelab"),
	includeCSS("styles/blue.css"), #Stylesheet for custom divs and other elements
  	uiOutput("content") #All UI elements are rendered reactively
)

#R functionality
server <- function(input, output, session) {
	#Run the current UI function
	output$content <- renderUI({ eval(parse(text=window$content)) })

	#Respond to button presses by running a different UI function

	#"Next" button
	observeEvent(input$forward, {
		if (window$content == "intro()") {
			launchUI("dataPicker()")
		} else if (window$content == "dataPicker()") {
			#Reset environment
			rm(list=ls())
			baseImports()
			#Import data plugin chosen by user and switch to plot picker activity.
			source(paste("data/", input$data, sep=""))
			#Import the data
			import_data()
			#Update compatible plots list now that a dataset has been selected
			updateCompatiblePlots()
			launchUI("plotPicker()")
		} else if (window$content == "plotPicker()") {
			#Import plot plugin chosen by user
			source(paste("plots/", input$plot, sep=""))
			#Set "selected plot" variable
			plugins$selectedPlot <- input$plot

			#Update display list
			updateCompatibleDisplays()

			#Switch to display picker activity if the number of compatible displays is >1, otherwise load the compatible display.
			if (length(plugins$compatDisplays) == 1) {
				#Set "selected display" variable
				plugins$selectedDisplay <- plugins$compatDisplays[[1]]
				launchDisplayModule(plugins$selectedDisplay)
			} else {
				#Launch display chooser activity
				launchUI("displayPicker()")
			}
		} else if (window$content == "displayPicker()") {
			#Set "selected display" variable
			plugins$selectedDisplay <- input$display
			#Launch display activity
			launchDisplayModule(plugins$selectedDisplay)
		}
	})

	#"Back" button
	observeEvent(input$back, {
		if (window$content == "dataPicker()") {
			launchUI("intro()")
		} else if (window$content == "plotPicker()") {
			launchUI("dataPicker()") 
		} else if (window$content == "displayPicker()") {
			launchUI("plotPicker()")
		}
	})
}

#Start the app at runtime
mainApp <- shinyApp(ui=ui, server=server)
runApp(mainApp, port=5678)