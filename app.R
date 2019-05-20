library(shiny)
library(shinyjs)
library(httr)
library(jsonlite)
library(dplyr)
library(swotr)
library(bamr)

# ---- Declare the UI --------
ui <- fluidPage(
    useShinyjs(),
    h1("USING THE BAM ALGORITHM"),
    actionButton("start_analysis", "Start analysis")
)

# --- Helper function ---
data_access_api <- function(base_url, path){
  url = modify_url(base_url, path=path)
  response = GET(url)
  if (http_type(response) != "application/json") {
    stop("Response not JSON !", call. = FALSE)
  }
  response
}

load_ncdfile <- function(file_name) {
  filepath <- paste(getwd(), "/data/", sep="")
  fullpath_name <- paste(filepath, file_name, sep="")
  river_reaches <- tryCatch(nc_reach(fullpath_name), warning = function(warn){
    print("Error in swot_vec2mat: Doesn't work for square matrices")
  })
  river_reaches
}

convert_to_bamdataformat <- function(river_reaches) {
  bamdata <- tryCatch(swot_bamdata(river_reaches), warning = function(warn){
    print("Error Occured convert dataset to BAM Data Format")
  })
  # print(bamdata)
}

run_bam_algorithm <- function(formatted_bamdata, iterations) {
  estimates <- tryCatch(bam_estimate(formatted_bamdata, variant = "manning", iter = iterations), warning=function(warn){
    print("Error Occured due to data format used..")
  })

  # print(estimates)
}

main_algorithm <- function(river_names){

    for (river_name in river_names){
        iterations <- 2000
        river_reaches <- load_ncdfile(river_name)
        bam_data <- convert_to_bamdataformat(river_reaches)
        bam_estimates = run_bam_algorithm(bam_data, iterations)
        print(bam_estimates)
  }
  print("********************************************")
}
# ---- Declare the server side of the app ---
server <- function(input, output){
    base_url = "http://128.119.82.236:42581"
    path_name = "/fetchdata/5"
    response <- data_access_api(base_url, path_name)
    status_code <- response$status_code # should be 200
    raw_jsondata <- rawToChar(response$content)
    json_data <- fromJSON(raw_jsondata)
    river_names <- json_data$file_names # list of file names

    # start the analysis on button click
    onclick("start_analysis", main_algorithm(river_names))

}

# -- No functional code after this point ---
# --- start the app ----
shinyApp(ui = ui, server = server)
