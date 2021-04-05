import 'dart:math';
import 'package:csv/csv.dart' as csv;
import 'package:file_access/file_access.dart';
import 'package:flutter/material.dart';

List forwardGeodetic(
    num eastingsOne, num northingsOne, num eastingsTwo, num northingsTwo) {
  num inverseTan = (180 / pi);
  num changeInEastings = eastingsTwo - eastingsOne;
  num changeInNorthings = northingsTwo - northingsOne;
  num bearing;
  num length = sqrt((pow(changeInEastings, 2) + pow(changeInNorthings, 2)));
  try {
    bearing = atan(changeInEastings / changeInNorthings) * inverseTan;
  } catch (e) {}
  if (changeInNorthings > 0 && changeInEastings > 0) {
    bearing = bearing;
  } else if (changeInNorthings < 0 && changeInEastings < 0) {
    bearing += 180;
  } else if (changeInNorthings > 0 && changeInEastings < 0) {
    bearing += 360;
  } else if (changeInNorthings < 0 && changeInEastings > 0) {
    bearing += 180;
  } else if (changeInEastings == 0 && changeInNorthings > 0) {
    bearing = 0;
  } else if (changeInEastings == 0 && changeInNorthings < 0) {
    bearing = 180;
  } else if (changeInEastings > 0 && changeInNorthings == 0) {
    bearing = 90;
  } else if (changeInEastings < 0 && changeInNorthings == 0) {
    bearing = 270;
  }
  return [length, bearing];
}

num backBearing(num foreBearing) {
  return foreBearing < 180 ? 180 + foreBearing : foreBearing - 180;
}

Future<Map<String, dynamic>> chooseFile() async {
  String fileName = '';
  String csvString;
  final _myFile = await openFile();
  if (_myFile != null) {
    await _myFile.readAsString().then((value) {
      fileName = _myFile.path;
      csvString = value;
    });
  }
  return {'csvString': csvString, 'fileName': fileName};
}

List<List> csvToList(String csvString) {
  csv.CsvToListConverter c = new csv.CsvToListConverter(
    eol: "\r\n",
    fieldDelimiter: ",",
  );
  List<List> csvData = c.convert(csvString);
  return csvData;
}

List<dynamic> extractHeaders(List<List<dynamic>> csvData) {
  return csvData[0].map((e) => e.toString()).toList();
}

void errorAlert(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('An error occurred'),
          content:
              Text('The selected file is not a csv type. Please try again'),
          actions: [
            TextButton(
              child: Text('Return'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      });
}

String decimalPlaces(dynamic value) {
  return value != ""
      ? double.tryParse(value.toString()).toStringAsFixed(4)
      : "";
}

TextStyle headerStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Akaya');
TextStyle rowStyle = TextStyle(fontFamily: 'Maths', fontSize: 18);
