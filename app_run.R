require(shiny)
require(shinyjs)
shiny::runApp("app.R", launch.browser=FALSE, port = 8080, host = "0.0.0.0")