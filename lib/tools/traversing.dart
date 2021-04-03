import 'package:final_project/functions.dart';
import 'package:final_project/tools/levelling.dart';
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
  List<dynamic> stationData = [];
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
    setState(() {
      changeBody = true;
    });
    print('backskight data $backsightData');
    print('station data is $stationData');
  }

  String closedLinkScenario = 'Scenario 1';
  String closedLoopScenario = 'Scenario 1';

  List<Widget> newBody(EdgeInsetsGeometry padding) {
    TextEditingController northingsOfOne = TextEditingController();
    TextEditingController northingsOfTwo = TextEditingController();
    TextEditingController eastingsOfOne = TextEditingController();
    TextEditingController eastingsOfTwo = TextEditingController();
    Map<String, TextEditingController> textControllers = {
      'Northings of ${backsightData[0]}': northingsOfOne,
      'Eastings of ${backsightData[0]}': eastingsOfOne,
      'Northings of ${stationData[0]}': northingsOfTwo,
      'Eastings of ${stationData[0]}': eastingsOfTwo
    };

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
          padding: EdgeInsets.all(20), child: processButton(onPressed: () {})));
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets padding = EdgeInsets.only(top: 20, left: 20);

    return Scaffold(
        appBar: myAppBar(),
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
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
                                        csvToList(result['csvString']);
                                    _fileName = result['fileName'];
                                    dataHeaders = extractHeaders(traverseData);
                                    putDropdownValues(dataHeaders);
                                    dataPicked = true;
                                  });
                                }, onError: (error) {
                                  print(error.toString());
                                  errorAlert(context);
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
                            'Direction of Traverse',
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
                                      directionOfTraverseDropdown = value;
                                    });
                                  },
                                  items: ['Clockwise', 'Counter - clockwise'],
                                  value: directionOfTraverseDropdown)),
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
                              textStyle: MaterialStateProperty.all(TextStyle(
                                  fontFamily: 'Akaya', letterSpacing: 2.0)),
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
