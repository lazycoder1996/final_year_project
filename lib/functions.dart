import 'dart:io';
import 'dart:math';
import 'package:csv/csv.dart' as csv;
import 'package:csv/csv.dart';
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

List<List<dynamic>> readFile(String csvString) {
  try {
    // var myCsv = File(filePath);
    // var csvString = myCsv.readAsStringSync();
    var converter = CsvToListConverter(
      fieldDelimiter: ',',
      eol: '\r\n',
    );
    List<List<dynamic>> data = converter.convert(csvString);
    return data;
  } catch (e) {
    print('File path not found');
  }
  return null;
}

// Future<String> chooseFile() async {
//   final _myFile = await openFile();
//   String _fileName = '';
//   String dataFile = '';
//   if (_myFile != null) {
//     await _myFile.readAsString().then((file) {
//       _fileName = _myFile.path;
//       dataFile = file;
//       // extractHeaders(file);
//     }
// , onError: (error) {
//   print(error.toString());
//   errorAlert(
//       context: context,
//       content: 'The selected file is not a csv type. Please try again');
// }
// );
//   } else {
//     print('user cancelled operation');
//   }
//   return dataFile;
// }

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

// List<List> csvToList(String csvString) {
//   csv.CsvToListConverter c = new csv.CsvToListConverter(
//     eol: "\r\n",
//     fieldDelimiter: ",",
//   );
//   List<List> csvData = c.convert(csvString);
//   return csvData;
// }

List<dynamic> extractHeaders(List<List<dynamic>> csvData) {
  return csvData[0].map((e) => e.toString()).toList();
}

void errorAlert({
  BuildContext context,
  String content,
}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('An error occurred'),
          content: Text(content),
          actions: [
            TextButton(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Return'),
              ),
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

TextStyle titleStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 32,
    fontFamily: 'Akaya');
TextStyle configurationStyle = TextStyle(fontSize: 18, fontFamily: 'Berkshire');
TextStyle inputStyle = TextStyle(fontSize: 22, fontFamily: 'Akaya');
Widget dropDownButton(
    {List<String> items,
    InputDecoration decoration,
    String value,
    void Function(String) onChanged}) {
  return DropdownButtonFormField(
    decoration: decoration ?? InputDecoration(border: OutlineInputBorder()),
    items: items
        .map((e) => DropdownMenuItem(
              child: Text(e.toString()),
              value: e,
            ))
        .toList(),
    value: value,
    onChanged: onChanged,
  );
}

String degreesToDms(num myNumber) {
  String sign;
  num a = myNumber.abs();
  int degrees = a.truncate();
  num b = (a - degrees) * 60;
  int minutes = b.truncate();
  num c = b - minutes;
  num seconds = num.parse((c * 60).toStringAsFixed(4));
  if (seconds >= 60) {
    minutes++;
    seconds = 60 - seconds;
  }
  if (minutes >= 60) {
    degrees++;
    minutes = 60 - minutes;
  }
  if (myNumber.isNegative == true) {
    sign = "-";
  } else {
    sign = "";
  }
  String degreesStandard = degrees.toString();
  String minutesStandard = minutes.toString();
  String sec = seconds.toString();
  String endSec = sec.substring(sec.indexOf(".") + 1);
  String secondsStandard = sec.substring(0, sec.indexOf("."));
  if (degreesStandard.length == 1) {
    degreesStandard = "00" + degreesStandard;
  } else if (degreesStandard.length == 2) {
    degreesStandard = "0" + degreesStandard;
  } else {
    degreesStandard = degreesStandard;
  }
  if (minutesStandard.length == 1) {
    minutesStandard = "0" + minutesStandard;
  } else {
    minutesStandard = minutesStandard;
  }
  if (secondsStandard.length == 1) {
    secondsStandard = "0" + secondsStandard;
  } else {
    secondsStandard = secondsStandard;
  }
  if (endSec.length == 1) {
    endSec = endSec + "000";
  } else if (endSec.length == 2) {
    endSec = endSec + "00";
  } else if (endSec.length == 3) {
    endSec = endSec + "0";
  } else {
    endSec = endSec;
  }
  return sign +
      degreesStandard +
      "°" +
      minutesStandard +
      "'" +
      secondsStandard +
      "." +
      endSec +
      "\"";
}

// bool checkScreen(BuildContext context) {}
String standardDistance(num distance, int numberOfDecimals) {
  String dString = distance.toStringAsFixed(numberOfDecimals);
  num pointIndex = dString.indexOf(".");
  String decimals = dString.substring(pointIndex + 1);
  num length = decimals.length;
  num difference = numberOfDecimals - length;
  if (difference != 0 && difference > 0) {
    while (difference < numberOfDecimals) {
      decimals += "0";
      difference = numberOfDecimals - decimals.length;
      if (difference == 0) {
        break;
      }
    }
  }
  String answer = dString.substring(0, pointIndex + 1) + decimals;
  return answer;
}
