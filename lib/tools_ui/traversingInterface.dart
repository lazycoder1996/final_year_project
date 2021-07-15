import 'package:final_project/computations/traversing/linkTraverseComp.dart';
import 'package:final_project/genFunctions.dart';
import 'package:final_project/utils/widgets.dart';
import 'package:flutter/material.dart';

class Traversing extends StatefulWidget {
  @override
  _TraversingState createState() => _TraversingState();
}

class _TraversingState extends State<Traversing> {
  String _fileName = '';
  bool dataPicked = false;
  String typeOfTraverseDropdown = 'Closed Loop';
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
  Widget dropDownButton(
      {List<String> items, String value, void Function(String) onChanged}) {
    return DropdownButtonFormField(
      decoration: InputDecoration(border: OutlineInputBorder()),
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

  void putDropdownValues(List<dynamic> headers) {
    stationDropdown = headers[0].toString();
    backsightDropdown = headers[1].toString();
    foresightDropdown = headers[2].toString();
    circleReadingsDropdown = headers[4].toString();
    distanceDropdown = headers[5].toString();
    controlDropdown = headers[6].toString();
  }

  List<dynamic> backsightData = [];
  List<dynamic> foresightData = [];
  List<String> stationData = [];
  List<dynamic> circleReadings = [];
  List<dynamic> distanceData = [];
  List<dynamic> controls = [];

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
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: processButton(onPressed: () {
                            fileChosen(traverseData, dataHeaders);
                            if (typeOfTraverseDropdown == 'Link') {
                              linkTraverse(
                                  adjustBy: adjustmentMethodDropdown,
                                  rawValues: {
                                    'backsight': backsightData,
                                    'foresight': foresightData,
                                    'station': stationData,
                                    'circle': circleReadings,
                                    'distance': distanceData,
                                    'control': controls
                                  });
                            }
                            setState(() {});
                          }))
                    ],
                  ),
                ),
              ));
  }
}
