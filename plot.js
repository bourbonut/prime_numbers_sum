// import * as d3 from "d3"
// import * as fs from 'fs'
// var obj = JSON.parse(fs.readFileSync('results/full.json', 'utf8'))

// Set the dimensions and margins of the graph
var margin = { top: 10, right: 70, bottom: 60, left: 70 },
    width = 500 - margin.left - margin.right,
    height = 430 - margin.top - margin.bottom;

// Append the svg object to the body of the page
var svg = d3.select("#my_dataviz")
    .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform",
        "translate(" + margin.left + "," + margin.top + ")");

function zip(arrays) {
    var keys = [];
    for (key in arrays) { keys.push(key) };
    var arrays = keys.map(function(key) { return arrays[key] })
    return Array.apply(null, Array(arrays[0].length)).map(function(_, i) {
        return arrays.map(function(array) { return array[i] })
    });
}

function ceilInt(number){
    var exposant = String(number).length - 1;
    return (Math.floor(number * 10 ** (-exposant)) + 1) * 10 ** exposant;
}

d3.json("results/full.json", function(data) {
    var keys = [];
    for (key in data) { keys.push(key) };

    var data_ready = keys.map(function(key) {
        return {
            name: key,
            values: zip(data[key]).map(function(e) {
                return { x: +e[0], y: +e[1], log: +e[2] };
            })
        };
    })

    // A color scale: one color for each group
    var myColor = d3.scaleOrdinal().domain(keys).range(d3.schemeSet2);

    var xmax = data["python"].x.map(x => +x).reduce((a, b) => Math.max(a, b));
    // Add X axis --> it is a date format
    var x = d3.scaleLinear().domain([0, xmax]).range([0, width]);
    svg.append("g")
        .attr("transform", "translate(0," + height + ")")
        .call(d3.axisBottom(x))

    svg.append("text")
        .attr("class", "x label")
        .attr("text-anchor", "middle")
        .attr("x", width / 2)
        .attr("y", height + 30)
        .text("Power");

    // var ymax = data["python"].x.map(x => +x).reduce((a, b) => Math.max(a, b));
    var ymax = keys.map(key => data[key].y).flat(1).reduce((a, b) => Math.max(a, b));
    // Add Y axis
    var y = d3.scaleLinear().domain([0, ceilInt(ymax)]).range([height, 0]);
    svg.append("g").attr("class", "yaxis").call(d3.axisLeft(y).ticks(10, "s"));

    svg.append("text")
        .attr("class", "y label")
        .attr("text-anchor", "middle")
        .attr("x", -height / 2)
        .attr("y", -2 * margin.left / 3)
        .attr("transform", "rotate(-90)")
        .text("Execution Time");

    // Add the lines
    var line = d3.line().x(function(d) { return x(+d.x) }).y(function(d) { return y(+d.y) })
    svg.selectAll("myLines").data(data_ready).enter().append("path")
        .attr("class", function(d) { return d.name })
        .attr("d", function(d) { return line(d.values) })
        .attr("stroke", function(d) { return myColor(d.name) })
        .style("stroke-width", 4)
        .style("fill", "none")

    // Add the points
    svg
        // First we need to enter in a group
        .selectAll("myDots")
        .data(data_ready)
        .enter()
        .append('g')
        .style("fill", function(d) { return myColor(d.name) })
        .attr("class", function(d) { return d.name })
        // Second we need to enter in the 'values' part of this group
        .selectAll("myPoints")
        .data(function(d) { return d.values })
        .enter()
        .append("circle")
        .attr("cx", function(d) { return x(d.x) })
        .attr("cy", function(d) { return y(d.y) })
        .attr("r", 5)
        .attr("stroke", "white")

    // Add a label at the end of each line
    svg
        .selectAll("myLabels")
        .data(data_ready)
        .enter()
        .append('g')
        .append("text")
        .attr("class", function(d) { return d.name })
        .datum(function(d) { return { name: d.name, value: d.values[d.values.length - 1] }; }) // keep only the last value of each time series
        .attr("transform", function(d) { return "translate(" + x(d.value.x) + "," + y(d.value.y) + ")"; }) // Put the text at the position of the last point
        .attr("x", 12) // shift the text a bit more right
        .text(function(d) { return d.name; })
        .style("fill", function(d) { return myColor(d.name) })
        .style("font-size", 15)

    var visible = keys.reduce((visible, key) => {
        visible[key] = true;
        return visible;
    }, {});
    
    function update(d){
        var name = d.name;
        visible[name] = !visible[name]; 
        // console.log(visible)
        var ymax = keys.filter(key => visible[key]).
                        map(key => data[key].y).
                        flat(1).
                        reduce((a, b) => Math.max(a, b));
        y.domain([0, ceilInt(ymax)]);
        svg.selectAll("g.yaxis").
            transition().
            duration(1000).
            call(d3.axisLeft(y).ticks(10, "s"));

        var line = d3.line().x(function(d) { return x(d.x) }).y(function(d) { return y(d.y) })
        for (key in data){
            svg.selectAll("path."+ key)
                .transition()
                .duration(1000)
                .attr("d", function(d) { return line(d.values)})
                .style("opacity", visible[key] ? 1 : 0);

            svg.selectAll("text." + key)
                .transition()
                .duration(1000)
                .attr("y", function(d){return y(d.y)})
                .attr("transform", function(d) { return "translate(" + x(d.value.x) + "," + y(d.value.y) + ")"; })
                .attr("opacity", visible[key] ? 1 : 0);

            svg.selectAll("g." + key)
                .selectAll("circle")
                .transition()
                .duration(1000)
                .attr("cy", function(d){return y(d.y)})
                .style("opacity", visible[key] ? 1 : 0);
        } 
        // d3.selectAll("." + name).transition().duration(1000).style("opacity", visible[name] ? 1 : 0)
        console.log(name);
    }

    // Add a legend (interactive)
    svg
        .selectAll("myLegend")
        .data(data_ready)
        .enter()
        .append('g')
        .append("text")
        .attr('x', function(d, i) { return 30 + i * 60 })
        .attr('y', 30)
        .text(function(d) { return d.name; })
        .style("fill", function(d) { return myColor(d.name) })
        .style("font-size", 15)
        .on("click", update)
        // .on("click", function(d) {
        //     // is the element currently visible ?
        //     currentOpacity = d3.selectAll("." + d.name).style("opacity")
        //     // Change the opacity: from 0 to 1 or from 1 to 0
        //     d3.selectAll("." + d.name).transition().style("opacity", currentOpacity == 1 ? 0 : 1)
        // })
})
