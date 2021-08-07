import 'package:final_project/genFunctions.dart';
import 'package:flutter/material.dart';

class MyClipper extends CustomClipper<Path> {
  MyClipper({this.coordinates, this.height, this.width});
  final List<List<num>> coordinates;
  final double height;
  final double width;
  @override
  Path getClip(Size size) {
    Path path = Path();
    List<Offset> points = offsets(coordinates, height, width);
    path.addPolygon(points, true);
    // path.addPolygon([
    //   Offset(0, size.height),
    //   Offset(size.width / 2, 0),
    //   Offset(size.width, size.height)
    // ], true);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
