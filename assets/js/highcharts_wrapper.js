function createGraph(theData, graph_location, title, y_axis_label, x_axis_label = "Year", plot_band_width = 5){

  fetch(theData)
  .then((response) => {
    return response.text();
  })
  .then((theCsv) => {
  
    // Find last year in data, with a csv generally outputted by google sheets
    var theCsvLines = theCsv.split(/\r\n|\n/);
    var linenum = theCsvLines.length - 1;
    var lastRow = theCsvLines[linenum];
    var lastYear = lastRow.split(",")[0];
    //If the csv isn't outputted by google sheets, this extra step needed
    if (lastYear.length === 0) {
      lastRow = theCsvLines[linenum-1];
      lastYear = lastRow.split(",")[0];
    }
    
    // Produce highcharts graph
    Highcharts.chart(graph_location, {
      title: {text: title},
      credits: {enabled: false},
      data: {
        csv: theCsv,
        firstRowAsNames: true,
        startRow: 0 }, 
      series: [{
        name: 'value', 
        showInLegend: true,
        marker: {
          enabled: false,
          fillColor: 'white',
          lineWidth: 1,
          lineColor: Highcharts.getOptions().colors[0] }}],
      xAxis: {
        plotBands: [{
          from: lastYear - plot_band_width, 
          to: lastYear,
          color: '#DEDEFF'}],
        title: {text: x_axis_label}},
      yAxis: {
        title: {text: y_axis_label} }});
  });
   
}