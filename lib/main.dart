import 'package:final_project/screens/homepage.dart';
import 'package:final_project/tools/levelling.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(elevation: 0.0), primarySwatch: Colors.teal),
      home: HomePage(),
      title: 'Geomatic ',
    );
  }
}
