import 'package:final_project/computations/traversing.dart';
import 'package:final_project/functions.dart';
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
  }

  List<dynamic> backsightData = [];
  List<dynamic> foresightData = [];
  List<String> stationData = [];
  List<dynamic> circleReadings = [];
  List<dynamic> distanceData = [];

  void onNextClicked(List<List<dynamic>> traverseData, List<String> headers) {
    // extracting actual data
    int dataSize = traverseData.length;
    backsightData = [];
    foresightData = [];
    stationData = [];
    circleReadings = [];
    distanceData = [];

    for (int i = 1; i < dataSize; i++) {
      backsightData.add(traverseData[i][headers.indexOf(backsightDropdown)]);
      foresightData.add(traverseData[i][headers.indexOf(foresightDropdown)]);
      stationData.add(traverseData[i][headers.indexOf(stationDropdown)]);
      circleReadings
          .add(traverseData[i][headers.indexOf(circleReadingsDropdown)]);
      distanceData.add(traverseData[i][headers.indexOf(distanceDropdown)]);
    }
    stationData.removeWhere((item) => item == '');
    setState(() {
      changeBody = true;
    });
  }

  String closedLinkScenario = 'Scenario 1';
  String closedLoopScenario = 'Scenario 1';
  List<String> dataColumns = [];
  List<List<String>> computedData = [];

  List<Widget> newBody(EdgeInsetsGeometry padding) {
    TextEditingController northingsOne = TextEditingController();
    TextEditingController northingsTwo = TextEditingController();
    TextEditingController eastingsOne = TextEditingController();
    TextEditingController eastingsTwo = TextEditingController();
    Map<String, TextEditingController> textControllers = {
      'Northings of ${backsightData[0]}': northingsOne,
      'Eastings of ${backsightData[0]}': eastingsOne,
      'Northings of ${stationData[0]}': northingsTwo,
      'Eastings of ${stationData[0]}': eastingsTwo
    };
    List<dynamic> includedAngles = [];
    List<dynamic> rawBearings = [];
    List<dynamic> adjPerStation = [];
    List<dynamic> finalBearings = [];
    List<List<dynamic>> rawLatDep = [];
    List<List<dynamic>> finalLatDep = [];
    List<List<dynamic>> northingsEastings = [];

    List<Widget> children = [
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
        child: Row(
          children: [
            if (changeBody)
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    changeBody = false;
                  });
                },
              ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                'Configuration',
                style: TextStyle(fontSize: 18, fontFamily: 'Berkshire'),
              ),
            ),
          ],
        ),
      ),
    ];
    if (typeOfTraverseDropdown == 'Closed Link') {
      children.add(Padding(
        padding: padding,
        child: Container(
          width: 300,
          child: dropDownButton(
              items: ['Scenario 1', 'Scenario 2'],
              value: 'Scenario 1',
              onChanged: (value) {
                setState(() {
                  closedLinkScenario = value;
                });
              }),
        ),
      ));
      children.add(Padding(
        padding: padding,
        child: Container(
          child: closedLinkScenario == 'Scenario 1'
              ? Image.asset('images/LinkScenarioOne.png')
              : Image.asset('images/theo.jpeg'),
        ),
      ));
    } else if (typeOfTraverseDropdown == 'Closed Loop') {
      children.add(Padding(
        padding: padding,
        child: Container(
          width: 300,
          child: dropDownButton(
              items: ['Scenario 1', 'Scenario 2'],
              value: 'Scenario 1',
              onChanged: (value) {
                setState(() {
                  closedLoopScenario = value;
                });
              }),
        ),
      ));
      children.add(Padding(
        padding: padding,
        child: Container(
          child: closedLoopScenario == 'Scenario 1'
              ? Image.asset('images/LoopScenarioOne.png')
              : Image.asset('images/LoopScenarioTwo.png'),
        ),
      ));
      if (closedLoopScenario == 'Scenario 1')
        for (var i in textControllers.keys) {
          children.add(Padding(
            padding: padding,
            child: textController(
              controller: textControllers[i],
              hintText: 'Enter $i',
            ),
          ));
        }
      if (closedLoopScenario == 'Scenario 2') {}

      children.add(Padding(
          padding: EdgeInsets.all(20),
          child: processButton(onPressed: () {
            setState(() {
              // computing coordinates
              distanceData.removeWhere((element) {
                return element == '';
              });
              distanceData.join(',');
              List<dynamic> distBear = forwardGeodetic(
                  num.parse(eastingsOne.text),
                  num.parse(northingsOne.text),
                  num.parse(eastingsTwo.text),
                  num.parse(northingsTwo.text));
              num initialDistance = distBear[0];
              num initialBearing = distBear[1];
              distanceData.add(initialDistance);
              includedAngles =
                  computeIncludedAngles(circleReadings: circleReadings);
              rawBearings = computeBearings(
                  includedAngles: includedAngles,
                  initialBearing: initialBearing);
              adjPerStation = adjustBearings(initialBearings: rawBearings)[0];
              finalBearings = adjustBearings(initialBearings: rawBearings)[1];
              rawLatDep = computeLatDdep(
                  bearings: finalBearings, distances: distanceData);
              finalLatDep = adjustLatDep(
                  distances: distanceData,
                  adjustmentMethod: adjustmentMethodDropdown,
                  initialLatDep: rawLatDep);
              northingsEastings = computeNorthingsEastings(
                  latDep: finalLatDep,
                  controls: [
                    num.parse(northingsTwo.text),
                    num.parse(eastingsTwo.text)
                  ]);
              // putting data into excel

              includedAngles.insert(0, "");
              distanceData.insert(0, '');
              for (var i in rawLatDep) {
                i.insert(0, "");
              }
              for (var i in finalLatDep) {
                i.insert(0, "");
              }

              // for (var i in northingsEastings) {
              //   i.addAll(["", ""]);
              // }
              int size = includedAngles.length;
              stationData.removeWhere((element) => element == '');
              stationData.insert(0, stationData.last);
              stationData.add(stationData[1]);
              try {
                for (int i = 0; i < size; i++) {
                  computedData.add([stationData[i]]);
                  computedData[i].add(stationData[i + 1]);
                  computedData[i].add(decimalPlaces(includedAngles[i]));
                  computedData[i].add(decimalPlaces(distanceData[i]));
                  computedData[i].add(decimalPlaces(rawBearings[i]));
                  computedData[i].add(decimalPlaces(adjPerStation[i]));
                  computedData[i].add(decimalPlaces(finalBearings[i]));
                  computedData[i].add(decimalPlaces(rawLatDep[0][i]));
                  computedData[i].add(decimalPlaces(finalLatDep[0][i]));
                  computedData[i].add(decimalPlaces(finalLatDep[1][i]));
                  computedData[i].add(decimalPlaces(rawLatDep[1][i]));
                  computedData[i].add(decimalPlaces(finalLatDep[2][i]));
                  computedData[i].add(decimalPlaces(finalLatDep[3][i]));
                  computedData[i].add(decimalPlaces(northingsEastings[0][i]));
                  computedData[i].add(decimalPlaces(northingsEastings[1][i]));
                }
              } catch (e) {
                print('the error is from here');
              }
              dataColumns = [
                'From',
                'To',
                'Angle',
                'Dist',
                'Bearing',
                'Adj. in bear.',
                'Corr. bear.',
                'Latitude',
                'Adj. in Lat.',
                'Corr. Lat',
                'Departure',
                'Adj. in Dep.',
                'Corr. Dep',
                'Northings',
                'Eastings'
              ];
              showProcessedResults = true;
            });
          })));
    }

    return children;
  }

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
                    children: changeBody == true
                        ? newBody(padding)
                        : [
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
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'Berkshire'),
                              ),
                            ),
                            Padding(
                              padding: padding,
                              child: Text(
                                'Input Data',
                                style: TextStyle(
                                    fontSize: 22, fontFamily: 'Akaya'),
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
                                          dataHeaders =
                                              extractHeaders(traverseData);
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
                                  style: TextStyle(
                                      fontSize: 22, fontFamily: 'Akaya'),
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
                                  style: TextStyle(
                                      fontSize: 22, fontFamily: 'Akaya'),
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
                                  style: TextStyle(
                                      fontSize: 22, fontFamily: 'Akaya'),
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
                                  style: TextStyle(
                                      fontSize: 22, fontFamily: 'Akaya'),
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
                                  style: TextStyle(
                                      fontSize: 22, fontFamily: 'Akaya'),
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
                                  'Direction of Traverse',
                                  style: TextStyle(
                                      fontSize: 22, fontFamily: 'Akaya'),
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
                                            directionOfTraverseDropdown = value;
                                          });
                                        },
                                        items: [
                                          'Clockwise',
                                          'Counter - clockwise'
                                        ],
                                        value: directionOfTraverseDropdown)),
                              ),
                            if (dataPicked)
                              Padding(
                                padding: padding,
                                child: Text(
                                  'Adjustment By',
                                  style: TextStyle(
                                      fontSize: 22, fontFamily: 'Akaya'),
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
                                child: ElevatedButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'NEXT',
                                    ),
                                  ),
                                  onPressed: () {
                                    onNextClicked(traverseData, dataHeaders);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.teal),
                                    textStyle: MaterialStateProperty.all(
                                        TextStyle(
                                            fontFamily: 'Akaya',
                                            letterSpacing: 2.0)),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    elevation: MaterialStateProperty.all(6.0),
                                  ),
                                ),
                              ),
                          ],
                  ),
                ),
              ));
  }
}
