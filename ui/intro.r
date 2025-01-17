#Introduction screen module, Designed to be run from app.r,
#not as a standalone Shiny application.

#Author: Graham Home <grahamhome333@gmail.com>

#Introduction screen UI
intro <- function() {
	fixedPanel(class="mainwindow_inactive",
		fixedPanel(class="popup",

			fluidRow(
		  		column(8, offset=2,
		  			h1("Welcome to Power Viewer!", class="windowtitle")
		  		)
		  	),
		  	fluidRow(
				column(12,
		  			h3("Power Viewer is a tool for viewing power grid data with a library of plotting methods.", class="instructions"),
		  			h3("The following screens will allow you to choose from the available data sets, plot styles and display types.", class="instructions"),
		  			h3("Ready to begin?", class="instructions")
		  		)
			),
			actionButton("forward", "Start", class="next")
		)
	)
}