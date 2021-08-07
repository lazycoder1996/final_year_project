import 'dart:math';
import 'package:final_project/utils/polygon.dart';
import 'package:final_project/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plot/flutter_plot.dart';

class Polygon extends StatelessWidget {
  Polygon({this.points, this.type});
  final List<Point> points;
  final String type;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppBar(),
      // body: Padding(
      //   padding: const EdgeInsets.all(20.0),
      //   child: ClipPath(
      //       clipper: MyClipper(coordinates: [
      //         [0, 1],
      //         [0.6, 0.5],
      //         [1, 0.5],
      //         [1, 0],
      //         [0, 0],
      //         [0, 1]
      //       ], height: size.height, width: size.width),
      //       child: Container(
      //         decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      //         // color: Colors.red,
      //       )),
      // ),
      body: SingleChildScrollView(
        child: new Plot(
          height: size.height,
          padding: EdgeInsets.all(20),
          data: points,
          gridSize: new Offset(1, 1),
          style: new PlotStyle(
            axisStrokeWidth: 2.0,
            pointRadius: 3.0,
            outlineRadius: 1.0,
            primary: Colors.yellow,
            secondary: Colors.red,
            trace: true,
            traceStokeWidth: 3.0,
            traceColor: Colors.blueGrey,
            traceClose: type == 'Closed Loop' ? true : false,
            showCoordinates: true,
            textStyle: new TextStyle(
              fontSize: 8.0,
              color: Colors.grey,
            ),
            axis: Colors.blueGrey[600],
            gridline: Colors.blueGrey[100],
          ),
        ),
      ),
    );
  }
}
