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
  

  //  var f_child = div.node().appendChild(f.documentElement);
  d3.xml(svg).then((f) => {
    // https://gist.github.com/mbostock/1014829#gistcomment-2692594
  
    //var tip = d3.tip().attr('class', 'd3-tip').html(function(d) { return d; });
    
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
      
      /* dropping svg field from csv, so not filtering
      if (debug){ 
        console.log("data before filter");
        console.log(data);
      }
      
      data = data.filter(function(d){ return basename(d.svg) == basename(svg) });
      
      if (debug){ 
        console.log("data after filter");
        console.log(data);
      }
      */
      
      // TODO: if has section column in argument to fxn
      data = data.sort(
        function(a,b) { return d3.ascending(a.section, b.section) ||  d3.ascending(a.title, b.title) });
    
      var section_now = null;

      // iterate through rows of csv
      data.forEach(function(d) {
        if (debug){ 
          console.log('forEach d.icon: ' + d.icon);
        }
        
        // TODO: wrap this hack into function args
        d.link = 'modals/' + d.icon + '.html';
        d.title = d.title ? d.title : d.icon;  // fall back on id if title not set
        
        function handleClick(){
          if (d.not_modal == 'T'){
            window.location = d.link;
          } else {
            
            if (debug){ 
              console.log('  link:' + d.link);
            }
            
            $('#'+ modal_id).find('iframe')
              .prop('src', function(){ return d.link });
            
            $('#'+ modal_id + '-title').html( d.title );
            
            $('#'+ modal_id).on('show.bs.modal', function () {
              $('.modal-content').css('height',$( window ).height()*0.9);
              $('.modal-body').css('height','calc(100% - 65px - 55.33px)');
            });
            
            $('#'+ modal_id).modal();
          }
        }
        function handleMouseOver(){
          if (debug){ 
              console.log('  mouseover():' + d.icon);
          }
           
          d3.select('#' + d.icon)
            .style("stroke-width", 2)
            .style("stroke", hover_color);
          
          tooltip_div.transition()
            .duration(200)
            .style("opacity", 0.8);
          tooltip_div.html(d.title + "<br/>")
            .style("left", (d3.event.pageX) + "px")
            .style("top", (d3.event.pageY - 28) + "px");
        }
        function handleMouseOverSansTooltip(){
          if (debug){ 
              console.log(' handleMouseOverSansTooltip():' + d.icon);
          }
           
          d3.select('#' + d.icon)
            .style("stroke-width", 2)
            .style("stroke", hover_color);
          
        }
        function handleMouseOut(){
          if (debug){ 
              console.log('  mouseout():' + d.icon);
            }
            
            //d3.select(this)
            d3.select('#' + d.icon)
              .style("stroke-width",0);
  
            tooltip_div.transition()
              .duration(500);
            tooltip_div.style("opacity", 0);
        }
        
        h.select('#' + d.icon)
          .on("click", handleClick)
          .on('mouseover', handleMouseOver)
          .on('mouseout', handleMouseOut);
          
        // set outline of paths within group to null
        d3.select('#' + d.icon).selectAll("path")
            .style("stroke-width", null)
            .style("stroke", null);
          
        // add to bulleted list of svg elements
        list_text = d.title ? d.title : d.icon;  // fall back on id if title not set
        
        // if first in section, then add header
        if (d.section != section_now){
          section_list = d3.select("#svg_list").append("li")
            .text(d.section).append("ul");
          section_now = d.section;
        }
        
        //d3.select("#svg_list").append("li").append("a")
        section_list.append("li").append("a")
          .text(list_text)
          .on("click", handleClick)
          .on('mouseover', handleMouseOverSansTooltip)
          .on('mouseout', handleMouseOut);

      }); // end: data.forEach({
    }) // end: d3.csv().then({
    .catch(function(error){
      // d3.csv() error   
    }); // end: d3.csv()
    
  // turn off questions by default
  d3.select("#text").attr("display", "none");

  }); // d3.xml(svg).then((f) => {

}
