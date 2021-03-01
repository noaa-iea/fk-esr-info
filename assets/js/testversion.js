// append div for tooltip
var tooltip_div = d3.select("body").append("div")
  .attr("class", "tooltip")
  .style("opacity", 0);

// append div for modal
function appendHtml(el, str) {
  var div = document.createElement('div');
  div.innerHTML = str;
  while (div.children.length > 0) {
    el.appendChild(div.children[0]);
  }
}

var modal_html = '<div aria-labelledby="modal-title" class="modal fade bs-example-modal-lg" id="modal" role="dialog" tabindex="-1"><div class="modal-dialog modal-lg" role="document"><div class="modal-content"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button><h4 class="modal-title" id="modal-title">title</h4></div><div class="modal-body"><iframe data-src="" height="100%" width="100%" frameborder="0"></iframe></div><div class="modal-footer"><button class="btn btn-default btn-sm" data-dismiss="modal">Close</button></div></div></div></div>';

appendHtml(document.body, modal_html); // "body" has two more children - h1 and span.

function basename(path) {
     return path.replace(/.*\//, '');
}

// main function to link svg elements to modal popups with data in csv
function link_svg(svg, csv, debug = false, hover_color = 'yellow', width = '100%', height = '100%', modal_id = 'modal') {

  d3.xml(svg).then((f) => {
    
    var div = d3.select('#svg');
  
    var f_child = div.node().appendChild(f.documentElement);
    
    // get handle to svg
    var h = d3.select(f_child);
    
    // full size
    h.attr('width', width)
     .attr('height', height);
    
    if (debug){ 
      console.log('before data.forEach');
    }

    d3.csv(csv).then(function(data) {
      // iterate through rows of csv
    
      data.forEach(function(d) {
        
        // TODO: wrap this hack into function args
        d.link = 'modals/' + d.icon + '.html';
        d.title = d.title ? d.title : d.icon;  // fall back on id if title not set
          
        // set outline of paths within group to null
        d3.select('#' + d.icon).selectAll("path")
            .style("stroke-width", null)
            .style("stroke", null);
          
        // add to bulleted list of svg elements
        list_text =  d.title ? d.title : d.icon;  // fall back on id if title not set
        
        //two examples of the trouble with changing global variable
        section_list.push([d.section, d.title]); 
        a_number = 5;
        
        d3.select("#svg_list").append("li").append("a")
          .text(list_text);
    
      }); // end: data.forEach({
     
    }) // end: d3.csv().then({
    .catch(function(error){
      // d3.csv() error   
    }); // end: d3.csv()

console.log("section_list: ", section_list);
console.log("fifth row of section_list: ", section_list[4]);
console.log("a number: ", a_number);
  // turn off questions by default
  d3.select("#text").attr("display", "none");

  }); // d3.xml(svg).then((f) => {

}
