import 'package:csv/csv.dart';
import 'package:final_project/computations/traversing/linkTraverseComp.dart';
import 'package:final_project/computations/traversing/loopTraverseComp.dart';
import 'package:final_project/genFunctions.dart';
import 'package:final_project/utils/download.dart';
import 'package:final_project/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Traversing extends StatefulWidget {
  @override
  _TraversingState createState() => _TraversingState();
}

class _TraversingState extends State<Traversing> {
  String _fileName = '';
  bool dataPicked = false;
  String typeOfTraverseDropdown = 'Closed Loop';
  List<List<dynamic>> res = [];
  Map<String, dynamic> errorReport = {};
  String backsightDropdown;
  String foresightDropdown;
  String stationDropdown;
  String controlDropdown;
  String circleReadingsDropdown;
  String distanceDropdown;
  String directionOfTraverseDropdown = 'Clockwise';
  String adjustmentMethodDropdown = 'Bowditch';
  List<List<dynamic>> traverseData = [];
  List<String> dataHeaders = [];
  bool changeBody = false;

  void putDropdownValues(List<dynamic> headers) {
    try {
      backsightDropdown = headers[0].toString();
      stationDropdown = headers[1].toString();
      foresightDropdown = headers[2].toString();
      circleReadingsDropdown = headers[4].toString();
      distanceDropdown = headers[5].toString();
      controlDropdown = headers[6].toString();
    } catch (e) {}
  }

  List<dynamic> backsightData = [];
  List<dynamic> foresightData = [];
  List<dynamic> stationData = [];
  List<dynamic> circleReadings = [];
  List<dynamic> distanceData = [];
  List<dynamic> controls = [];
  var results = [];

  void fileChosen(List<List<dynamic>> traverseData, List<String> headers) {
    // extracting actual data
    int dataSize = traverseData.length;
    backsightData = [];
    foresightData = [];
    stationData = [];
    circleReadings = [];
    distanceData = [];
    controls = [];
    for (int i = 1; i < dataSize; i++) {
      backsightData.add(traverseData[i][headers.indexOf(backsightDropdown)]);
      foresightData.add(traverseData[i][headers.indexOf(foresightDropdown)]);
      stationData.add(traverseData[i][headers.indexOf(stationDropdown)]);
      circleReadings
          .add(traverseData[i][headers.indexOf(circleReadingsDropdown)]);
      distanceData.add(traverseData[i][headers.indexOf(distanceDropdown)]);
      controls.add(traverseData[i][headers.indexOf(controlDropdown)]);
    }
    // stationData.removeWhere((item) => item == '');
    setState(() {
      changeBody = true;
    });
  }

  String closedLinkScenario = 'Scenario 1';
  String closedLoopScenario = 'Scenario 1';
  List<String> dataColumns = [];
  List<List<String>> computedData = [];

  Widget resultPage(
      {EdgeInsetsGeometry padding,
      List<String> dataColumns,
      List<List<dynamic>> dataRows}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: padding,
          child: Text('Results',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  fontFamily: 'Akaya'))),
      Expanded(
        child: Padding(
          padding: padding,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SingleChildScrollView(
                child: DataTable(
                    columns: dataColumns.map((e) {
                      return DataColumn(label: Text(e, style: headerStyle));
                    }).toList(),
                    rows: computedData
                        .map((e) => DataRow(
                                cells: e.map((f) {
                              return DataCell(
                                  Text(f.toString(), style: rowStyle));
                            }).toList()))
                        .toList()),
              )
            ],
          ),
        ),
      ),
    ]);
  }

  bool showProcessedResults = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets padding = EdgeInsets.only(top: 20, left: 20);

    return Scaffold(
        appBar: myAppBar(),
        body: showProcessedResults == true
            ? resultPage(
                dataColumns: dataColumns,
                dataRows: computedData,
                padding: padding)
            : SingleChildScrollView(
                child: Container(
                  width: size.width,
                  // height: size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: padding,
                        child: Text(
                          'Theodolite Traversing',
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
                          'Configuration',
                          style:
                              TextStyle(fontSize: 18, fontFamily: 'Berkshire'),
                        ),
                      ),
                      Padding(
                        padding: padding,
                        child: Text(
                          'Input Data',
                          style: TextStyle(fontSize: 22, fontFamily: 'Akaya'),
                        ),
                      ),
                      Padding(
                        padding: padding,
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
                                await chooseFile().then((result) {
                                  setState(() {
                                    traverseData =
                                        readFile(result['csvString']);
                                    _fileName = result['fileName'];
                                    dataHeaders = extractHeaders(traverseData);
                                    putDropdownValues(dataHeaders);
                                    dataPicked = true;
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
                      if (dataPicked)
                        Padding(
                          padding: padding,
                          child: Text(
                            'Type of Traverse',
                            style: inputStyle,
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
                                      typeOfTraverseDropdown = value;
                                    });
                                  },
                                  items: ['Closed Link', 'Closed Loop'],
                                  value: typeOfTraverseDropdown)),
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
                                      backsightDropdown = value;
                                    });
                                  },
                                  items: dataHeaders,
                                  value: backsightDropdown)),
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
                                      foresightDropdown = value;
                                    });
                                  },
                                  items: dataHeaders,
                                  value: foresightDropdown)),
                        ),
                      if (dataPicked)
                        Padding(
                          padding: padding,
                          child: Text(
                            'Instrument Station Data',
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
                                      stationDropdown = value;
                                    });
                                  },
                                  items: dataHeaders,
                                  value: stationDropdown)),
                        ),
                      if (dataPicked)
                        Padding(
                          padding: padding,
                          child: Text(
                            'Horizontal Circle Readings',
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
                                      circleReadingsDropdown = value;
                                      print(circleReadingsDropdown);
                                    });
                                  },
                                  items: dataHeaders,
                                  value: circleReadingsDropdown)),
                        ),
                      if (dataPicked)
                        Padding(
                          padding: padding,
                          child: Text(
                            'Distances',
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
                                      distanceDropdown = value;
                                    });
                                  },
                                  items: dataHeaders,
                                  value: distanceDropdown)),
                        ),
                      if (dataPicked)
                        Padding(
                          padding: padding,
                          child: Text(
                            'Controls',
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
                                      controlDropdown = value;
                                    });
                                  },
                                  items: dataHeaders,
                                  value: controlDropdown)),
                        ),
                      if (dataPicked)
                        Padding(
                          padding: padding,
                          child: Text(
                            'Adjustment By',
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
                                      adjustmentMethodDropdown = value;
                                    });
                                  },
                                  items: ['Bowditch', 'Transit'],
                                  value: adjustmentMethodDropdown)),
                        ),
                      if (dataPicked)
                        Padding(
                            padding: EdgeInsets.all(20),
                            child: processButton(onPressed: () {
                              print('traverse data is $traverseData');
                              print(
                                  'type of traverse is $typeOfTraverseDropdown');
                              setState(() {
                                fileChosen(traverseData, dataHeaders);
                                print('done');
                                if (typeOfTraverseDropdown == 'Closed Link') {
                                  results = linkTraverse(
                                      traverseData: traverseData,
                                      adjustBy: adjustmentMethodDropdown,
                                      rawValues: {
                                        'backsight': backsightData,
                                        'foresight': foresightData,
                                        'station': stationData,
                                        'circle': circleReadings,
                                        'distance': distanceData,
                                        'control': controls
                                      });
                                  res = results[0];
                                  errorReport = results[1];
                                } else {
                                  print('loop traverse');
                                  print('backsight data: $backsightData');
                                  results = loopTraverse(
                                      adjustBy: adjustmentMethodDropdown,
                                      traverseData: traverseData,
                                      rawValues: {
                                        'backsight': backsightData,
                                        'foresight': foresightData,
                                        'station': stationData,
                                        'circle': circleReadings,
                                        'distance': distanceData,
                                        'control': controls
                                      });
                                  res = results[0];
                                  errorReport = results[1];
                                }
                                print('report is $errorReport');
                                var result = ListToCsvConverter().convert(res);

                                download(
                                    addFilesToZip(
                                      reportFile: {
                                        'filename': 'processing report.txt',
                                        'data': 'Processing Report\r\n'
                                                'Date: ${DateFormat.yMEd().add_jms().format(DateTime.now())}\r\n'
                                                'Duration: ${errorReport['duration']} ms\r\n\r\n'
                                                'Points of depature\r\n'
                                                '${errorReport['departure']}\r\n'
                                                'Points of closure\r\n'
                                                '${errorReport['closure']}\r\n\r\n'
                                                'Arithmetic check\r\n'
                                                'Number of instrument station: ${errorReport['setup']}\r\n' +
                                            (typeOfTraverseDropdown ==
                                                    'Closed Loop'
                                                ? 'Observed final bearing :${errorReport['observed final bearing']}\r\n'
                                                : 'Observed sum of included angles: ${errorReport['observed sum angles']}\r\n') +
                                            (typeOfTraverseDropdown ==
                                                    'Closed Loop'
                                                ? 'Expected final bearing :${errorReport['expected final bearing']}\r\n'
                                                : 'Expected sum of included angles: ${errorReport['expected sum angles']}\r\n') +
                                            'Error: ${errorReport['error']}\r\n' +
                                            (typeOfTraverseDropdown ==
                                                    'Closed Loop'
                                                ? ''
                                                : 'Adjustment per station: ${errorReport['adj per station']}\r\n\r\n') +
                                            'Misclosure\r\n'
                                                'Method of adjusting coordinates: ${errorReport['adj By']}\r\n'
                                                'Observed sum of departures: ${errorReport['sum of dep']}\r\n'
                                                'Expected sum of depatures: ${errorReport['exp sum of dep']}\r\n'
                                                'Error in departure: ${errorReport['error in dep']}\r\n'
                                                'Observed sum of latitudes: ${errorReport['sum of lat']}\r\n'
                                                'Expected sum of latitudes: ${errorReport['exp sum of lat']}\r\n'
                                                'Error in latitude: ${errorReport['error in lat']}\r\n'
                                                'Observed sum of distances: ${errorReport['sum dist']}\r\n'
                                                'Linear misclose: ${errorReport['linear misclose']}\r\n'
                                                'Fractional misclose: ${errorReport['fractional misclose']}'
                                      },
                                      csvFile: {
                                        'data': result,
                                        'filename': 'processed data.csv'
                                      },
                                    ),
                                    downloadName:
                                        '${_fileName.split(".")[0]} result.zip');
                              });
                            }))
                    ],
                  ),
                ),
              ));
  }
}
