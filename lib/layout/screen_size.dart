import 'package:flutter/material.dart';

class ScreenSize {
  ScreenSize({this.context});
  final BuildContext context;
  Size get size => MediaQuery.of(context).size;
  Size mySize;
  set height(val) => size.height;
  set width(val) => size.width;
}
