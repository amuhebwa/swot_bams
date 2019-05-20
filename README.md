# swot_bams
Instructions for creating a new docker container
1. Clone this repository and cd to swot_bams
2. Change the path inside the 'query_all_rivers' in the data_query.py file to full path where data is located
3. Make sure that the data you want to analyze is in the 'data' folder
4. change the machine_ip in the data_query.py file to your machine ip address using 'curl_ifconf.me' on terminal
5. make sure that the base_url in the server function in app.R to be the same as machine_ip
6. Assuming you already have docker configured on your machine, run docker build -t bams_app .
7. You want to map the the data repsitory to the container so that it can run analysis on this netcdf data.
7. Start as docker run -v {full_path}:/usr/local/src/app -p 8080:8080 bams_app .
8. If you want to run it as a background service without blocking the terminal, pass -d as the extra parameter in (7)

Note: This code works well when the host machine is linux. MacOS will be fixed in future.
