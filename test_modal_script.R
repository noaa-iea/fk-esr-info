# Test code to create modal windows for everything in icons_to_data google spreadsheet

modals_from_spreadsheet <- function() {
icons_to_data_csv <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vSAROGVpYB58Zkr8P0iwJdTMRPNLZtJ07IyUn-dQ62C2HMuCEScyl8x7urCD7QbRXQYSIJwDn_wku9G/pub?gid=0&single=true&output=csv"

icons_to_data <- read.csv(icons_to_data_csv, sep = ",", header = T)

icon_number <- nrow(icons_to_data)

for (i in 1:icon_number){
  icon <- icons_to_data$icon[i]
  input_csv_url <- icons_to_data$data[i]
 
  input_csv <- tryCatch(
    {read.csv(input_csv_url, sep = ",", header = T)
    output_head <- paste0(
'<html>
  <head>
    <meta charset="utf-8">
    <title>', icons_to_data$title[i],'</title>
    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/data.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
  </head>\n')
   
    output_body <- paste0('<body>
    <div id="container" style="width:100%; height:350px;"></div>
      <script>
      csv = "', input_csv_url, '";\n',
    'title = "', icons_to_data$title[i], '";\n',
    'x_axis_label = "', colnames(input_csv)[1], '";\n',
    'y_axis_label = "', colnames(input_csv)[2], '";\n',
    'last_year = ', input_csv[nrow(input_csv),1], ';\n',
    'plot_band_width = 5;
    Highcharts.chart("container", {
      title: {text: title},
      credits: {enabled: false},
      data: {
        csvURL: csv,
        firstRowAsNames: true,
        startRow: 0
      }, 
      series: [{
        name: "value", 
        showInLegend: false
      }],
      xAxis: {
        plotBands: [{
          from: last_year-plot_band_width, 
          to: last_year,
          color: "#DEDEFF"}],
        title: {text: x_axis_label}
      },
      yAxis: {
        title: {text: y_axis_label}  
      }
    });
    </script>
    </body>
    </html>')
     output_file <- paste0("test_modals/", icon, ".html")
    write(paste0(output_head, output_body), output_file) 
    },
    error=function(cond) {
      message(paste0("Problem with data column for ", icon, " (row ", i +1, "): here's the error."))
      message(cond)
      message()
    }
  )    
} 
}
  
