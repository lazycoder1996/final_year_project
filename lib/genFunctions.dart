import 'package:csv/csv.dart';
import 'package:file_access/file_access.dart';
import 'package:final_project/results/simpleLevellingResults.dart';
import 'package:final_project/utils/download.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

num minimum(List numbers) {
  num result = numbers[0];
  num n = 1;
  try {
    while (n <= numbers.length) {
      if (numbers[n] <= result) {
        result = numbers[n];
      }
      n++;
    }
  } catch (e) {}
  return result;
}

num maximum(List numbers) {
  num result = numbers[1];
  num n = 1;
  try {
    while (n <= numbers.length) {
      if (numbers[n] >= result) {
        result = numbers[n];
      }
      n++;
    }
  } catch (e) {}
  return result;
}

List<Offset> offsets(List<List<num>> coordinates, double height, double width) {
  List<Offset> offsets = [];
  for (var i in coordinates) {
    offsets.add(Offset(i[0] * width, i[1] * height));
  }
  return offsets;
}

Widget previewData({List<String> columns, List<List<dynamic>> rows}) {
  return Scrollbar(
    child: DataTable(
        columns: columns.map((e) {
          return DataColumn(label: Text(e.toString(), style: headerStyle));
        }).toList(),
        rows: rows.map((e) {
          return DataRow(
              cells: e.map((e) {
            return DataCell(Text(e.toString(), style: rowStyle));
          }).toList());
        }).toList()),
  );
}

Widget doneProcessing(BuildContext context,
    {List<List<dynamic>> results,
    Map<dynamic, dynamic> errorReport,
    Map<dynamic, dynamic> reportFile,
    Map<dynamic, dynamic> previewMapData,
    String rksHeading,
    String elevHeading,
    bool plot,
    String fileName}) {
  return AlertDialog(
    title: Text('Results are ready!'),
    actions: [
      Tooltip(
        textStyle: TextStyle(fontSize: 16, color: Colors.white),
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // gradient:
          //     const LinearGradient(colors: <Color>[Colors.amber, Colors.red]),
        ),
        message: 'Preview results',
        waitDuration: Duration(milliseconds: 500),
        child: IconButton(
          icon: Icon(Icons.preview),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Scaffold(
                floatingActionButton: plot
                    ? FloatingActionButton.extended(
                        label: Text('Plot'),
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            // var elev =
                            //     results[0].indexOf(results[0].length - 3);
                            // var rks = results[0].indexOf(results[0].length - 2);
                            return SimpleLevellingResults(
                                remarks: results.sublist(1).map((e) {
                                  return e[results[0].length - 2].toString();
                                }).toList(),
                                elevation: results.sublist(1).map((e) {
                                  return num.parse(
                                      e[results[0].length - 3].toString());
                                }).toList());
                          }));
                        },
                        icon: Icon(Icons.pie_chart_outline_outlined),
                      )
                    : SizedBox(),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SingleChildScrollView(
                            child: Container(
                              child: previewData(
                                  rows: previewMapData['rows'],
                                  columns: previewMapData['columns']),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
          },
        ),
      ),
      Tooltip(
        textStyle: TextStyle(fontSize: 16, color: Colors.white),
        height: 30,
        message: 'Download results',
        waitDuration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // gradient:
          //     const LinearGradient(colors: <Color>[Colors.amber, Colors.red]),
        ),
        child: IconButton(
            icon: Icon(Icons.file_download, color: Colors.green),
            onPressed: () {
              var result = ListToCsvConverter().convert(results);
              // var errorReport = results
              var data = addFilesToZip(csvFile: {
                'data': result,
                'filename': 'processed data.csv',
              }, reportFile: reportFile);
              download(data,
                  downloadName: '${fileName.split(".")[0]} result.zip');
              Navigator.of(context).pop(false);
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   duration: Duration(seconds: 4),
              //   content: Container(
              //     child: Text(
              //         '${fileName.split(".")[0]} result.zip downloaded successfully'),
              //   ),
              // ));
            }),
      ),
      Tooltip(
        textStyle: TextStyle(fontSize: 16, color: Colors.white),
        height: 30,
        message: 'Cancel',
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // gradient:
          //     const LinearGradient(colors: <Color>[Colors.amber, Colors.red]),
        ),
        waitDuration: Duration(milliseconds: 500),
        child: IconButton(
            icon: Icon(
              Icons.cancel,
              color: Colors.red,
            ),
            onPressed: () => Navigator.of(context).pop(false)),
      ),
    ],
  );
}

// List forwardGeodetic(
//     num eastingsOne, num northingsOne, num eastingsTwo, num northingsTwo) {
//   num inverseTan = (180 / pi);
//   num changeInEastings = eastingsTwo - eastingsOne;
//   num changeInNorthings = northingsTwo - northingsOne;
//   num bearing;
//   num length = sqrt((pow(changeInEastings, 2) + pow(changeInNorthings, 2)));
//   try {
//     bearing = atan(changeInEastings / changeInNorthings) * inverseTan;
//   } catch (e) {}
//   if (changeInNorthings > 0 && changeInEastings > 0) {
//     bearing = bearing;
//   } else if (changeInNorthings < 0 && changeInEastings < 0) {
//     bearing += 180;
//   } else if (changeInNorthings > 0 && changeInEastings < 0) {
//     bearing += 360;
//   } else if (changeInNorthings < 0 && changeInEastings > 0) {
//     bearing += 180;
//   } else if (changeInEastings == 0 && changeInNorthings > 0) {
//     bearing = 0;
//   } else if (changeInEastings == 0 && changeInNorthings < 0) {
//     bearing = 180;
//   } else if (changeInEastings > 0 && changeInNorthings == 0) {
//     bearing = 90;
//   } else if (changeInEastings < 0 && changeInNorthings == 0) {
//     bearing = 270;
//   }
//   return [length, bearing];
// }

// num backBearing(num foreBearing) {
//   return foreBearing < 180 ? 180 + foreBearing : foreBearing - 180;
// }

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
// Widget dropDownButton(
//     {List<String> items,
//     InputDecoration decoration,
//     String value,
//     void Function(String) onChanged}) {
//   return DropdownButtonFormField(
//     decoration: decoration ?? InputDecoration(border: OutlineInputBorder()),
//     items: items
//         .map((e) => DropdownMenuItem(
//               child: Text(e.toString()),
//               value: e,
//             ))
//         .toList(),
//     value: value,
//     onChanged: onChanged,
//   );
// }

// String degreesToDms(num myNumber) {
//   String sign;
//   num a = myNumber.abs();
//   int degrees = a.truncate();
//   num b = (a - degrees) * 60;
//   int minutes = b.truncate();
//   num c = b - minutes;
//   num seconds = num.parse((c * 60).toStringAsFixed(4));
//   if (seconds >= 60) {
//     minutes++;
//     seconds = 60 - seconds;
//   }
//   if (minutes >= 60) {
//     degrees++;
//     minutes = 60 - minutes;
//   }
//   if (myNumber.isNegative == true) {
//     sign = "-";
//   } else {
//     sign = "";
//   }
//   String degreesStandard = degrees.toString();
//   String minutesStandard = minutes.toString();
//   String sec = seconds.toString();
//   String endSec = sec.substring(sec.indexOf(".") + 1);
//   String secondsStandard = sec.substring(0, sec.indexOf("."));
//   if (degreesStandard.length == 1) {
//     degreesStandard = "00" + degreesStandard;
//   } else if (degreesStandard.length == 2) {
//     degreesStandard = "0" + degreesStandard;
//   } else {
//     degreesStandard = degreesStandard;
//   }
//   if (minutesStandard.length == 1) {
//     minutesStandard = "0" + minutesStandard;
//   } else {
//     minutesStandard = minutesStandard;
//   }
//   if (secondsStandard.length == 1) {
//     secondsStandard = "0" + secondsStandard;
//   } else {
//     secondsStandard = secondsStandard;
//   }
//   if (endSec.length == 1) {
//     endSec = endSec + "000";
//   } else if (endSec.length == 2) {
//     endSec = endSec + "00";
//   } else if (endSec.length == 3) {
//     endSec = endSec + "0";
//   } else {
//     endSec = endSec;
//   }
//   return sign +
//       degreesStandard +
//       "°" +
//       minutesStandard +
//       "'" +
//       secondsStandard +
//       "." +
//       endSec +
//       "\"";
// }

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
