import 'package:csv/csv.dart';
import 'package:final_project/computations/levelling/preciseLevellingComp.dart';
import 'package:final_project/computations/levelling/simpleLevellingComp.dart';
import 'package:final_project/genFunctions.dart';
import 'package:final_project/results/simpleLevellingResults.dart';
import 'package:final_project/utils/download.dart';
import 'package:final_project/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Levelling extends StatefulWidget {
  @override
  LevellingState createState() => LevellingState();
}

enum LevellingType { simple, precise }

class LevellingState extends State<Levelling> {
  TextOverflow textOverflow = TextOverflow.ellipsis;
  bool dataPicked = false;

  String _fileName;

  ScrollController controllerOne;
  void extractHeaders(String csvString) {
    try {
      setState(() {
        levelData = [];
        headers = [];
        levelData = readFile(csvString);
        headers = levelData[0].map((e) {
          return e.toString();
        }).toList();
        backsightDropDownValue = headers[0].toString();
        if (radioValue == LevellingType.simple) {
          intersightDropDownValue = headers[1].toString();
          foresightDropDownValue = headers[2].toString();
          benchmarkValue = headers[4].toString();
        } else {
          foresightDropDownValue = headers[1].toString();
          upperStadiaValue = headers[2].toString();
          middleStadiaValue = headers[3].toString();
          lowerStadiaValue = headers[4].toString() ?? 'Lower stadia value';
          digitalReadingValue =
              headers[5].toString() ?? 'Digital reading value';
          benchmarkValue = headers[6].toString();
        }
        dataPicked = true;
      });
    } catch (e) {
      errorAlert(
          context: context,
          content:
              'Error extracting data. Please refer to documentation and try again');
    }
  }

  String dataFile;
  List<List<dynamic>> levelData = [];
  List<List<dynamic>> rawData = [];

  dynamic results = [];
  Map errorReport = {};

  String initMethod = 'Rise or Fall';
  String selectedComputation = 'Rise and Fall';
  String initAccuracy = '3';
  bool computationsDone = false;
  List<String> dataHeadings = [];

  List<dynamic> headers = [];

  String backsightDropDownValue;
  String foresightDropDownValue;
  String benchmarkValue;
  String intersightDropDownValue;
  String upperStadiaValue;
  String middleStadiaValue;
  String lowerStadiaValue;
  String digitalReadingValue;
  String csvString;
  @override
  void initState() {
    super.initState();
  }

  LevellingType radioValue = LevellingType.simple;
  // Widget dropDownButton(
  //     {List<String> items, dynamic value, void Function(String) onChanged}) {
  //   return DropdownButtonFormField(
  //     decoration: InputDecoration(border: OutlineInputBorder()),
  //     value: value.toString(),
  //     onChanged: (newValue) {
  //       setState(() {
  //         if (value == initMethod) initMethod = newValue;
  //         //   if (value == benchmarkValue) benchmarkValue = newValue.toString();
  //         //   if (value == backsightDropDownValue)
  //         //     backsightDropDownValue = newValue.toString();
  //         //   if (value == foresightDropDownValue)
  //         //     foresightDropDownValue = newValue.toString();
  //         //   if (value == intersightDropDownValue)
  //         //     intersightDropDownValue = newValue.toString();
  //         //   if (value == upperStadiaValue) upperStadiaValue = newValue.toString();
  //         //   if (value == lowerStadiaValue) lowerStadiaValue = newValue.toString();
  //         //   if (value == middleStadiaValue)
  //         //     middleStadiaValue = newValue.toString();
  //         //   if (value == digitalReadingValue)
  //         //     digitalReadingValue = newValue.toString();
  //       });
  //     },
  //     items: items.map((e) {
  //       return DropdownMenuItem(
  //         child: Text(
  //           e.toString(),
  //           overflow: textOverflow,
  //         ),
  //         value: e,
  //       );
  //     }).toList(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets padding = EdgeInsets.only(top: 20, left: 20);
    return Scaffold(
        appBar: myAppBar(context),
        body: Container(
          width: size.width,
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: padding,
                child: Text(
                  'LEVELLING IN SURVEYING',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      fontFamily: 'Akaya'),
                ),
              ),
              Padding(
                padding: padding,
                child: Text(
                  'Select an operation',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                  padding: padding,
                  child: Container(
                    width: 300,
                    child: RadioListTile(
                      groupValue: radioValue,
                      title: Text(
                        'Simple Levelling',
                        style: TextStyle(fontFamily: 'Redressed', fontSize: 24),
                      ),
                      value: LevellingType.simple,
                      onChanged: (LevellingType value) {
                        setState(() {
                          computationsDone = false;
                          dataPicked = false;
                          radioValue = value;
                        });
                      },
                    ),
                  )),
              Padding(
                  padding: padding,
                  child: Container(
                    width: 300,
                    child: RadioListTile(
                      value: LevellingType.precise,
                      title: Text(
                        'Precise Levelling',
                        style: TextStyle(fontFamily: 'Redressed', fontSize: 24),
                      ),
                      groupValue: radioValue,
                      onChanged: (LevellingType value) {
                        setState(() {
                          computationsDone = false;
                          dataPicked = false;
                          radioValue = value;
                        });
                      },
                    ),
                  )),
              Padding(
                padding: padding,
                child: Text(
                  'Data',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Berkshire'),
                ),
              ),
              Padding(
                padding: padding,
                child: Container(
                  width: size.width,
                  child: Row(
                    children: [
                      ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Browse Files',
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'Caveat',
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await chooseFile().then((value) {
                            setState(() {
                              _fileName = value['fileName'];
                              csvString = value['csvString'];
                              extractHeaders(value['csvString']);
                            });
                          }, onError: (error) {
                            print(error.toString());
                            errorAlert(
                                context: context,
                                content:
                                    'The selected file is not a csv type. Please try again');
                          });
                        },
                      ),
                      if (dataPicked)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(_fileName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Berkshire',
                                    fontWeight: FontWeight.bold)),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              if (dataPicked)
                Padding(
                  padding: padding,
                  child: Text(
                    'Configuration',
                    style: TextStyle(fontSize: 18, fontFamily: 'Berkshire'),
                  ),
                ),
              if (dataPicked && radioValue == LevellingType.simple)
                Padding(
                  padding: padding,
                  child: Container(
                      width: 300,
                      child: dropDownButton(
                          onChanged: (value) {
                            setState(() {
                              initMethod = value;
                            });
                          },
                          items: [
                            'Rise or Fall',
                            'Height of plane of collimation'
                          ],
                          value: initMethod)),
                ),
              if (dataPicked && radioValue == LevellingType.simple)
                Padding(
                  padding: padding,
                  child: Text(
                    'Accuracy factor',
                    style: TextStyle(fontSize: 22, fontFamily: 'Akaya'),
                  ),
                ),
              if (dataPicked && radioValue == LevellingType.simple)
                Padding(
                  padding: padding,
                  child: Container(
                      width: 300,
                      child: dropDownButton(
                          onChanged: (value) {
                            setState(() {
                              initAccuracy = value;
                            });
                          },
                          items: ['2', '3', '5', '7'],
                          value: initAccuracy)),
                ),
              if (dataPicked)
                Padding(
                  padding: padding,
                  child: Text(
                    'Benchmark',
                    style: TextStyle(fontSize: 22, fontFamily: 'Akaya'),
                  ),
                ),
              if (dataPicked)
                Padding(
                  padding: padding,
                  child: Container(
                      width: 300,
                      child: dropDownButton(
                          onChanged: (value) {
                            setState(() {
                              benchmarkValue = value;
                            });
                          },
                          items: headers,
                          value: benchmarkValue)),
                ),
              if (dataPicked)
                Padding(
                  padding: padding,
                  child: Text(
                    'Backsight Data',
                    style: TextStyle(fontSize: 22, fontFamily: 'Akaya'),
                  ),
                ),
              if (dataPicked)
                Padding(
                  padding: padding,
                  child: Container(
                      width: 300,
                      child: dropDownButton(
                          onChanged: (value) {
                            setState(() {
                              backsightDropDownValue = value;
                            });
                          },
                          items: headers,
                          value: backsightDropDownValue)),
                ),
              if (dataPicked && radioValue == LevellingType.simple)
                Padding(
                  padding: padding,
                  child: Text(
                    'Intersight Data',
                    style: TextStyle(fontSize: 22, fontFamily: 'Akaya'),
                  ),
                ),
              if (dataPicked && radioValue == LevellingType.simple)
                Padding(
                  padding: padding,
                  child: Container(
                      width: 300,
                      child: dropDownButton(
                          onChanged: (value) {
                            setState(() {
                              intersightDropDownValue = value;
                            });
                          },
                          items: headers,
                          value: intersightDropDownValue)),
                ),
              if (dataPicked)
                Padding(
                  padding: padding,
                  child: Text(
                    'Foresight Data',
                    style: TextStyle(fontSize: 22, fontFamily: 'Akaya'),
                  ),
                ),
              if (dataPicked)
                Padding(
                  padding: padding,
                  child: Container(
                      width: 300,
                      child: dropDownButton(
                          onChanged: (value) {
                            setState(() {
                              foresightDropDownValue = value;
                            });
                          },
                          items: headers,
                          value: foresightDropDownValue)),
                ),
              if (dataPicked && radioValue == LevellingType.precise)
                Padding(
                  padding: padding,
                  child: Text(
                    'Upper stadia reading',
                    style: TextStyle(fontSize: 22, fontFamily: 'Akaya'),
                  ),
                ),
              if (dataPicked && radioValue == LevellingType.precise)
                Padding(
                  padding: padding,
                  child: Container(
                      width: 300,
                      child: dropDownButton(
                          onChanged: (value) {
                            setState(() {
                              upperStadiaValue = value;
                            });
                          },
                          items: headers,
                          value: upperStadiaValue)),
                ),
              if (dataPicked && radioValue == LevellingType.precise)
                Padding(
                  padding: padding,
                  child: Text(
                    'Middle stadia reading',
                    style: TextStyle(fontSize: 22, fontFamily: 'Akaya'),
                  ),
                ),
              if (dataPicked && radioValue == LevellingType.precise)
                Padding(
                  padding: padding,
                  child: Container(
                      width: 300,
                      child: dropDownButton(
                          onChanged: (value) {
                            setState(() {
                              middleStadiaValue = value;
                            });
                          },
                          items: headers,
                          value: middleStadiaValue)),
                ),
              if (dataPicked && radioValue == LevellingType.precise)
                Padding(
                  padding: padding,
                  child: Text(
                    'Lower stadia reading',
                    style: TextStyle(fontSize: 22, fontFamily: 'Akaya'),
                  ),
                ),
              if (dataPicked && radioValue == LevellingType.precise)
                Padding(
                  padding: padding,
                  child: Container(
                      width: 300,
                      child: dropDownButton(
                          onChanged: (value) {
                            setState(() {
                              lowerStadiaValue = value;
                            });
                          },
                          items: headers,
                          value: lowerStadiaValue)),
                ),
              if (dataPicked && radioValue == LevellingType.precise)
                Padding(
                  padding: padding,
                  child: Text(
                    'Digital reading',
                    style: TextStyle(fontSize: 22, fontFamily: 'Akaya'),
                  ),
                ),
              if (dataPicked && radioValue == LevellingType.precise)
                Padding(
                  padding: padding,
                  child: Container(
                      width: 300,
                      child: dropDownButton(
                          onChanged: (value) {
                            setState(() {
                              digitalReadingValue = value;
                            });
                          },
                          items: headers,
                          value: digitalReadingValue)),
                ),
              if (dataPicked)
                Padding(
                    padding: EdgeInsets.all(20),
                    child: processButton(
                      onPressed: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => Container(
                                  child: Center(
                                    child: Theme(
                                      data:
                                          ThemeData(accentColor: Colors.white),
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ));
                        Future.delayed(Duration(milliseconds: 250))
                            .then((value) {
                          Navigator.of(context).pop(false);
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => doneProcessing(context,
                                  results: results,
                                  errorReport: errorReport,
                                  plot: false,
                                  previewMapData: {
                                    'columns': dataHeadings,
                                    'rows': results.sublist(1)
                                  },
                                  fileName: _fileName,
                                  reportFile: radioValue ==
                                          LevellingType.precise
                                      ? {
                                          'filename': 'processing report.txt',
                                          'data': 'Processing Report\r\n'
                                              'Date: ${DateFormat.yMEd().add_jms().format(DateTime.now())}\r\n'
                                              'Duration: ${errorReport['duration']} ms\r\n\r\n'
                                              'Benchmarks identified\r\n'
                                              '${errorReport['Benchmarks identified']}\r\n\r\n'
                                              'Project misclosure at ${errorReport['last bm']}: ${errorReport['comp final IRL']} - '
                                              '${errorReport['true final IRL']} = ${errorReport['Project Misclosue']}',
                                        }
                                      : {
                                          'data': 'Processing Report\r\n'
                                                  'Date: ${DateFormat.yMEd().add_jms().format(DateTime.now())}\r\n'
                                                  'Duration: ${errorReport['duration']} ms\r\n\r\n'
                                                  'Benchmarks identified\r\n'
                                                  '${errorReport['Benchmarks identified']}\r\n\r\n'
                                                  'Total number of instrument setup: ${errorReport['Total number of instrument setup']}\r\n\r\n'
                                                  'Arithmetic Check\r\n'
                                                  'Sum of backsight = ${errorReport['Sum of backsight']}\r\n'
                                                  'Sum of foresight = ${errorReport['Sum of foresight']}\r\n' +
                                              (errorReport.containsValue(
                                                      'Rise or Fall')
                                                  ? 'Sum of rise = ${errorReport['sum of rise']}\r\nSum of fall = '
                                                      '${errorReport['sum of fall']}\r\nΣBS + ΣFS - ΣRise - ΣFall = ${errorReport['check']}\r\n'
                                                  : 'Sum of intersight: ${errorReport['sum intersight']} \r\n'
                                                      'Sum of RLs except first: ${errorReport['sum rl']} \r\n'
                                                      'Sum (each HPC * number of applications): ${errorReport['hpc*application']}\r\n') +
                                              'Arithmetically ${errorReport['Arithmetic check']}\r\n\r\n'
                                                  'Method of computation: ${errorReport['Method of computation']}\r\n'
                                                  'Accuracy factor, k: ${errorReport['Accuracy factor k']}\r\n'
                                                  'Acceptable Misclosure: ${errorReport['Acceptable Misclosure']}mm \r\n\r\n'
                                                  'Project misclosure at ${errorReport['last bm']}: ${errorReport['true final IRL']} - '
                                                  '${errorReport['comp final IRL']} = ${errorReport['Project Misclosue']}',
                                          'filename': 'processing report.txt'
                                        }));
                        });

                        if (radioValue == LevellingType.simple) {
                          setState(() {
                            Map initialValues = {
                              'backsightValue': backsightDropDownValue,
                              'foresightValue': foresightDropDownValue,
                              'intersightValue': intersightDropDownValue,
                              'benchmarkValue': benchmarkValue,
                              'k': initAccuracy
                            };
                            var compute = simpleLevelling(readFile(csvString),
                                initialValues, initMethod, initAccuracy);
                            results = compute[0];
                            errorReport = compute[1];
                            dataHeadings = compute[0][0];
                            computationsDone = true;
                            print('results are $errorReport');
                          });
                        } else if (radioValue == LevellingType.precise) {
                          setState(() {
                            Map initialValues = {
                              'backsightValue': backsightDropDownValue,
                              'foresightValue': foresightDropDownValue,
                              'intersightValue': intersightDropDownValue,
                              'benchmarkValue': benchmarkValue,
                              'upperStadia': upperStadiaValue,
                              'middleStadia': middleStadiaValue,
                              'lowerStadia': lowerStadiaValue,
                              'digitalReading': digitalReadingValue,
                            };
                            var compute = preciseLevelling(
                                readFile(csvString), initialValues);
                            results = compute[0];
                            print('results are $results');
                            errorReport = compute[1];
                            print('error report is $errorReport');
                            var dh = compute[0][0];
                            dataHeadings.clear();
                            for (int i = 0; i < dh.length; i++) {
                              dataHeadings.add(dh[i].toString());
                            }
                            print('data headings is $dataHeadings');
                            computationsDone = true;
                          });
                        }
                      },
                    )),
              // if (computationsDone)
              // if (computationsDone)
              //   TextButton(
              //     child: Text('Plot'),
              //     onPressed: () {
              //       Navigator.of(context).push(MaterialPageRoute(
              //           builder: (context) => SimpleLevellingResults(
              //               title: _fileName,
              //               remarks: results.sublist(1).map((e) {
              //                 return e[8].toString();
              //               }).toList(),
              //               elevation: results.sublist(1).map((e) {
              //                 return num.parse(e[7].toString());
              //               }).toList())));
              //     },
              //   ),
              // Padding(
              //   padding: padding,
              //   child: SingleChildScrollView(
              //     key: Key('data'),
              //     child: DataTable(
              //         columns: computationsDone
              //             ? dataHeadings.map((e) {
              //                 return DataColumn(
              //                     label: Text(e.toString(),
              //                         style: headerStyle));
              //               }).toList()
              //             : headers.map((e) {
              //                 return DataColumn(
              //                     label: Text(e.toString(),
              //                         style: headerStyle));
              //               }).toList(),
              //         rows: computationsDone
              //             ? results.sublist(1).map((e) {
              //                 return DataRow(
              //                     cells: e.map((e) {
              //                   return DataCell(Text(e.toString(),
              //                       style: rowStyle));
              //                 }).toList());
              //               }).toList()
              //             : levelData.sublist(1).map((e) {
              //                 return DataRow(
              //                     cells: e
              //                         .map((e) => DataCell(Text(
              //                               e.toString(),
              //                               style: rowStyle,
              //                             )))
              //                         .toList());
              //               }).toList()),
              //   ),
              // ),
            ]),
          ),
        ));
  }
}
