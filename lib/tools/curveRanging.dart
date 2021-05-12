import 'package:final_project/utils/curveRanging.dart';
import 'package:final_project/utils/widgets.dart';
import 'package:flutter/material.dart';

import '../functions.dart';

class CurveRanging extends StatefulWidget {
  @override
  _CurveRangingState createState() => _CurveRangingState();
}

class _CurveRangingState extends State<CurveRanging> {
  bool changePage = false;
  String typeOfCurveValue = 'Circular Curve';
  String circularCurveValue = 'Scenario 1';
  String verticalCurveValue = 'Scenario 1';
  Widget newPage;
  Map<String, dynamic> horizontalCurveComputationInputs = {
    'direction': direction
  };
  Map<String, dynamic> verticalCurveComputationInputs = {};
  TextEditingController radius = new TextEditingController();
  TextEditingController chainagePI = new TextEditingController();
  TextEditingController pegInterval = new TextEditingController();
  TextEditingController deflectionAngle = new TextEditingController();
  TextEditingController northingsOfSetupControl = new TextEditingController();
  TextEditingController eastingsOfSetupControl = new TextEditingController();
  TextEditingController northingsOfBacksightControl =
      new TextEditingController();
  TextEditingController eastingsOfBacksightControl =
      new TextEditingController();
  TextEditingController northingsOfPI = new TextEditingController();
  TextEditingController eastingsOfPI = new TextEditingController();
  TextEditingController bearingOfBackTangent = new TextEditingController();
  TextEditingController directionOfAngle = new TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  List<String> circularCurveScenarios = [
    'Scenario 1',
    'Scenario 2',
    'Scenario 3',
    'Scenario 4'
  ];
  List<String> verticalCurveScenarios = [
    'Scenario 1',
    'Scenario 2',
  ];
  static String direction = 'Left';
  Map<String, Map<String, String>> descriptions = {
    'Circular Curve': {
      'Scenario 1': 'Scenario 1 of circular curve',
      'Scenario 2': '',
      'Scenario 3': '',
      'Scenario 4': '',
    },
    'Vertical Curve': {
      'Scenario 1': '',
      'Scenario 2': 'Scenario 2 of vertical curve',
    }
  };

  Widget _textfield({String label, TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20.0),
      child: Container(
        width: 300,
        child: TextFormField(
          controller: controller,
          validator: (val) {
            if (val.isEmpty) {
              return 'Required';
            }
            if (val.contains(RegExp(
              r'[A-Z]',
              caseSensitive: false,
            ))) {
              return 'Cannot contain letters';
            }
            if (double.tryParse(val) == null) {
              return 'Incorrect input, please try again';
            }
            return null;
          },
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (value) {
            setState(() {
              horizontalCurveComputationInputs[label] = controller;
            });
          },
          onChanged: (value) {
            setState(() {
              horizontalCurveComputationInputs[label] = controller;
            });
          },
          decoration:
              InputDecoration(border: OutlineInputBorder(), labelText: label),
        ),
      ),
    );
  }

  _nextPage({String typeOfCurveValue, String scenario}) {
    List<Widget> children = [
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  changePage = false;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Curve Ranging - $typeOfCurveValue',
              style: titleStyle,
            ),
          ),
        ],
      ),
    ];
    if (typeOfCurveValue == 'Circular Curve') {
      children.addAll([
        _textfield(label: 'Radius', controller: radius),
        _textfield(label: 'Deflection angle', controller: deflectionAngle),
        _textfield(label: 'Peg interval', controller: pegInterval),
      ]);
      if (scenario == 'Scenario 1' || scenario == 'Scenario 2') {
        children.insert(
            2, _textfield(label: 'Chainage of PI', controller: chainagePI));
      } else if (scenario == 'Scenario 4') {
        children.insert(
            2, _textfield(label: 'Chainage of PI', controller: chainagePI));
        children.insert(
            4,
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20.0),
              child: Container(
                width: 300,
                child: dropDownButton(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Direction of Angle'),
                    items: ['Left', 'Right'],
                    value: direction,
                    onChanged: (newValue) {
                      setState(() {
                        horizontalCurveComputationInputs['direction'] =
                            newValue;
                      });
                    }),
              ),
            )
            // _textfield(
            //     label: 'Direction of angle L / R',
            //     controller: directionOfAngle)
            );
        children.add(_textfield(
            label: 'Bearing of back tangent',
            controller: bearingOfBackTangent));
        children.add(
            _textfield(label: 'Northings of PI', controller: northingsOfPI));
        children
            .add(_textfield(label: 'Eastings of PI', controller: eastingsOfPI));
        children.add(_textfield(
            label: 'Northings of X', controller: northingsOfSetupControl));
        children.add(_textfield(
            label: 'Eastings of X', controller: eastingsOfSetupControl));
        children.add(_textfield(
            label: 'Northings of Y', controller: northingsOfBacksightControl));
        children.add(_textfield(
            label: 'Eastings of Y', controller: eastingsOfBacksightControl));
      }
    } else if (typeOfCurveValue == 'Vertical Curve') {
      children.addAll([
        _textfield(label: 'Gradient one (%)'),
        _textfield(label: 'Gradient two (%)'),
        _textfield(label: 'Chainage of PVI'),
        _textfield(label: 'Reduced Level of PVI'),
      ]);
      if (scenario == 'Scenario 1') {
        children.insert(3, _textfield(label: 'Length of curve'));
        children.add(_textfield(label: 'Increment'));
      } else if (scenario == 'Scenario 2') {
        children.insert(3, _textfield(label: 'Length of tangent one'));
        children.insert(4, _textfield(label: 'Length of tangent two'));
        children.add(_textfield(label: 'Increment on tangent one'));
        children.add(_textfield(label: 'Increment on tangent two'));
      }
    }
    children.add(Padding(
      padding: const EdgeInsets.all(20.0),
      child: processButton(onPressed: () {
        if (formKey.currentState.validate()) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('Please wait'),
                );
              });
          setState(() {
            result = typeOfCurveValue == 'Circular Curve'
                ? computeHorizontalCurveParameters(
                    scenario: scenario,
                    computationalValues: horizontalCurveComputationInputs)
                : computeVerticalCurveParameters(
                    scenario: scenario,
                    computationalValues: verticalCurveComputationInputs);
          });
          Navigator.of(context).pop();
          setState(() {
            showResults = true;
          });
        }
      }),
    ));
    return Form(
      key: formKey,
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }

  bool showResults = false;
  Widget result;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets padding = EdgeInsets.only(top: 20, left: 20);
    return Scaffold(
      appBar: myAppBar(),
      body: showResults
          ? result
          : changePage == true
              ? _nextPage(
                  scenario: typeOfCurveValue == 'Circular Curve'
                      ? circularCurveValue
                      : verticalCurveValue,
                  typeOfCurveValue: typeOfCurveValue)
              : Container(
                  width: size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: padding,
                          child: Text(
                            'Curve Ranging',
                            style: titleStyle,
                          ),
                        ),
                        Padding(
                          padding: padding,
                          child: Text(
                            'Configuration',
                            style: configurationStyle,
                          ),
                        ),
                        Padding(
                          padding: padding,
                          child: Text(
                            'Type of curve',
                            style: inputStyle,
                          ),
                        ),
                        Padding(
                          padding: padding,
                          child: Container(
                            width: 300,
                            child: dropDownButton(
                                items: ['Circular Curve', 'Vertical Curve'],
                                value: typeOfCurveValue,
                                onChanged: (value) {
                                  setState(() {
                                    typeOfCurveValue = value;
                                  });
                                }),
                          ),
                        ),
                        Padding(
                          padding: padding,
                          child: Text(
                            'Parameters given',
                            style: inputStyle,
                          ),
                        ),
                        Padding(
                          padding: padding,
                          child: Container(
                            width: 300,
                            child: dropDownButton(
                                items: typeOfCurveValue == 'Circular Curve'
                                    ? circularCurveScenarios
                                    : verticalCurveScenarios,
                                value: typeOfCurveValue == 'Circular Curve'
                                    ? circularCurveValue
                                    : verticalCurveValue,
                                onChanged: (value) {
                                  setState(() {
                                    typeOfCurveValue == 'Circular Curve'
                                        ? circularCurveValue = value
                                        : verticalCurveValue = value;
                                  });
                                }),
                          ),
                        ),
                        Padding(
                          padding: padding,
                          child: Text(
                            'Description',
                            style: inputStyle,
                          ),
                        ),
                        Padding(
                            padding: padding,
                            child: Container(
                              child: Text(
                                  descriptions[typeOfCurveValue][
                                      typeOfCurveValue == 'Circular Curve'
                                          ? circularCurveValue
                                          : verticalCurveValue],
                                  overflow: TextOverflow.visible),
                            )),
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
                              setState(() {
                                changePage = true;
                              });

                              // _nextPage(
                              //     scenario: typeOfCurveValue == 'Circular Curve'
                              //         ? circularCurveValue
                              //         : verticalCurveValue,
                              //     typeOfCurveValue: typeOfCurveValue);
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
                ),
    );
  }
}
