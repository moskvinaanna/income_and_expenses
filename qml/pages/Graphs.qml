import QtQuick 2.0
import "d3.js" as D3
import Sailfish.Silica 1.0
import "db.js" as JS
import QtQuick.LocalStorage 2.0

Page {


    Canvas {
        id:canvas

        property real minX
        property real maxX
        property real minY
        property real maxY
        property int leftMargin: 70
        property int bottomMargin: 50
        property var rootLine: 0

        anchors.margins: 10
        anchors.fill: parent

        onPaint: {
            var context = canvas.getContext('2d');
            context.clearRect(0,0,canvas.width,canvas.height);
            minX = 0;
            maxX =10;
            minY = 0;
            maxY = 1000;

            var xScale = d3.scaleLinear().range([leftMargin, width]).domain([minX, maxX]);
            var yScale = d3.scaleLinear().range([height - bottomMargin, 0]).domain([minY, maxY]);
            var d3CurveFunction = lineFunction(xScale, yScale, context);

            context.beginPath();
            context.lineWidth = 1.5;
            context.strokeStyle = "white";
            context.fillStyle = "white";

            drawXAxis(context, 5);
            drawYAxis(context, 10);
            context.stroke();

            context.beginPath();
            context.lineWidth = 2;
            context.strokeStyle = "red";
            getPoints();
            d3CurveFunction(graphData);

            context.stroke();
        }

        function lineFunction(xScale, yScale, context) {
            return d3.line().x(function (d) {
                return xScale(d[0]);
            }).y(function (d) {
                return yScale(d[1]);
            }).curve(d3.curveNatural) // Альтернатива: d3.curveStep
            .context(context);
        }

        function drawXAxis(context, steps) {
            var xScale = d3.scaleLinear().range([0, width]).domain([0, width])
            var yScale = d3.scaleLinear().range([0, height]).domain([height, 0]);
            var d3CurveFunction = lineFunction(xScale, yScale, context);
            d3CurveFunction([[leftMargin, bottomMargin], [width, bottomMargin]]);
            context.font = '20px serif';
            var stepSize = (width - leftMargin) / steps;
            var plotStepSize = (maxX - minX) / steps;
            for (var i = 1; i < steps; i++) {
                d3CurveFunction([[stepSize * i + leftMargin, bottomMargin],
                                 [stepSize * i + leftMargin, bottomMargin - 20]])
                // Decimal points should be configured with dependency on max - min interval length
                var text = (minX + plotStepSize * i).toFixed(1).toString();
                context.fillText(text, stepSize * i + leftMargin -
                                 context.measureText(text).width / 2, yScale(bottomMargin - 45));
            }
        }

        function drawYAxis(context, steps) {
            var xScale = d3.scaleLinear().range([0, width]).domain([0, width])
            var yScale = d3.scaleLinear().range([0, height]).domain([height, 0]);
            var d3CurveFunction = lineFunction(xScale, yScale, context)
            d3CurveFunction([[leftMargin, bottomMargin], [leftMargin, height]]);
            context.font = '20px serif';
            var stepSize = (height - bottomMargin) / steps;
            var plotStepSize = (maxY - minY) / steps;
            for (var i = 1; i < steps; i++) {
                d3CurveFunction([[leftMargin, stepSize * i + bottomMargin],
                                 [leftMargin - 20, stepSize * i + bottomMargin]])
                // Decimal points should be configured with dependency on max - min interval length
                var text = (minY + plotStepSize * i).toFixed(1).toString();
                context.fillText(text, leftMargin - 65, yScale(stepSize * i + bottomMargin - 10));
            }
        }

        property real graphData

        function handlePoints(pointsY) {
            var points = [];
            var dx = (pointsY.length) / 20;
            var i = 0;
            for(var x = 0; x < pointsY.length*dx; x+=dx) {
                points.push([x, pointsY[i]]);
                i++;
                console.log(points[i])
            }
            graphData = points;
        }

        function getPoints() {
            JS.dbGetOperationsPoints(handlePoints);
        }
    }

}
