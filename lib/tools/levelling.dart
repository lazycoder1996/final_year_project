import 'dart:async';
import 'package:final_project/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:grizzly_io/io_loader.dart';
import 'package:file_access/file_access.dart';
import 'package:csv/csv.dart' as csv;
import 'dart:math' as math;

class Levelling extends StatefulWidget {
  @override
  _LevellingState createState() => _LevellingState();
}

enum LevellingType { single_run, double_run }

class _LevellingState extends State<Levelling> {
  TextOverflow textOverflow = TextOverflow.ellipsis;
  bool dataPicked = false;
  static List<List> csvToList(String myCsvFile) {
    csv.CsvToListConverter c = new csv.CsvToListConverter(
      eol: "\r\n",
      fieldDelimiter: ",",
    );
    List<List> listCreated = c.convert(myCsvFile);
    return listCreated;
  }

  Future<List<List<String>>> readData(String fileName) async {
    final csv = await readCsv(fileName);
    return csv;
  }

  String _fileName;

  List<List<dynamic>> levelData = [];
  void chooseFile() async {
    final _myFile = await openFile();
    if (_myFile != null) {
      final _output = await _myFile.readAsString();
      _fileName = _myFile.path;
      setState(() {
        dataPicked = true;
        levelData = csvToList(_output);
        headers = levelData[0].map((e) {
          return e.toString();
        }).toList();
        backsightDropDownValue = headers[0].toString();
        intersightDropDownValue = headers[1].toString();
        foresightDropDownValue = headers[2].toString();
      });
    } else {
      print('user cancelled operation');
    }
  }

  String initMethod = 'Rise or Fall';
  String selectedComputation = 'Rise and Fall';
  String initAccuracy = '3';
  bool computationsDone = false;
  List dataHeadings = [];

  void levelComputation() {
    // defining variables
    List backSight = [];
    List interSight = [];
    List foreSight = [];
    List remarks = [];
    List chainages = [];
    int k;
    List<num> initialReducedLevels = [];
    int size;
    List<num> heightDifferences = [0];
    List adj = [0];
    var numberOfnonZeroBacksight;
    var error;
    List newBackSight = [];
    String arithmeticCheck;
    num allowableMisclose;
    String condition;
    String misclose;
    List<num> finalReducedLevels = [];
    num nonZeroBs = 0;
    num sumOfBs = 0;
    num sumOfRise = 0;
    num sumOfFall = 0;
    num sumOfFs = 0;
    num sumOfHeights = 0;
    num diffBtnBsAndFs;
    num diffFirstRlAndLastRl;
    List rise = [''];
    List fall = [''];
    List heightCollimation;
    List<List<dynamic>> errorData = [];
    bool mySwitch = false;
    bool computeSwitch = true;
    bool chainagesExist;
    bool statsPressed;
    // static File myCsvFile = new File(_fileName);
    List<List<dynamic>> data = [];
    num max = 0;
    num absMax;
    num absMin;
    num min;
    num a;
    num b;
    int timesDownloaded = 0;
    List fileNames = [];
    String initialBmValue = initialBm.text.trim();
    String finalBmValue = finalBm.text.trim();

    // putting appropriate data in columns
    for (int i = 1; i < levelData.length; i++) {
      backSight.add(levelData[i][headers.indexOf(backsightDropDownValue)]);
      interSight.add(levelData[i][headers.indexOf(intersightDropDownValue)]);
      foreSight.add(levelData[i][headers.indexOf(foresightDropDownValue)]);
    }
    // getting initial bench mark
    try {
      initialReducedLevels.add(num.parse(initialBmValue));
    } catch (e) {
      initialBmValue = '';
    }
    size = backSight.length;
    num h;
    int n = 0;
    num reducedLevel;
    // Calculating rise or fall
    if (initMethod == "Rise or Fall") {
      selectedComputation = 'Rise and Fall';
      try {
        while (n <= size) {
          if (backSight[n] != '') {
            if (interSight[n + 1] != '') {
              h = backSight[n] - interSight[n + 1];
              heightDifferences.add(h);
            } else {
              h = backSight[n] - foreSight[n + 1];
              heightDifferences.add(h);
            }
          } else {
            if (interSight[n + 1] != '') {
              h = interSight[n] - interSight[n + 1];
              heightDifferences.add(h);
            } else {
              h = interSight[n] - foreSight[n + 1];
              heightDifferences.add(h);
            }
          }
          n++;
        }
      } catch (e) {
        print(heightDifferences);
        // print(e.toString());
      }
      // Calculating initial reduced levels
      n = 0;
      try {
        while (n <= size) {
          reducedLevel = initialReducedLevels[n] + heightDifferences[n + 1];
          initialReducedLevels
              .add(double.parse(reducedLevel.toStringAsFixed(3)));
          n++;
        }
      } catch (e) {
        // print(e.toString());
      }
      // print(initialReducedLevels);
    } else {
      selectedComputation = 'Height of plane of collimation';

      // Calculating for hpc
      try {
        num hpc;
        heightCollimation = [backSight[0] + double.parse(initialBmValue)];
        initialReducedLevels = [double.parse(initialBmValue)];
        n = 0;
        while (n <= size) {
          if (interSight[n + 1] != '') {
            reducedLevel = heightCollimation[n] - interSight[n + 1];
            initialReducedLevels
                .add(double.parse(reducedLevel.toStringAsFixed(3)));
            if (backSight[n + 1] != '' && foreSight[n + 1] != '') {
              hpc = initialReducedLevels[n + 1] + backSight[n + 1];
              heightCollimation.add(double.parse(hpc.toStringAsFixed(3)));
            } else {
              hpc = heightCollimation[n];
              heightCollimation.add(double.parse(hpc.toStringAsFixed(3)));
            }
          } else {
            if (foreSight[n + 1] != '') {
              reducedLevel = heightCollimation[n] - foreSight[n + 1];
              initialReducedLevels
                  .add(double.parse(reducedLevel.toStringAsFixed(3)));
              if (backSight[n + 1] != '' && foreSight[n + 1] != '') {
                hpc = initialReducedLevels[n + 1] + backSight[n + 1];
                heightCollimation.add(double.parse(hpc.toStringAsFixed(3)));
              } else {
                hpc = heightCollimation[n];
                heightCollimation.add(double.parse(hpc.toStringAsFixed(3)));
              }
            }
          }
          n++;
        }
      } catch (e) {
        print(e.toString());
      }
    }
    newBackSight = backSight;
    try {
      n = 0;
      while (n <= size) {
        if (backSight[n] != '') {
          nonZeroBs++;
        }
        n++;
      }
    } catch (e) {}
    // calculating errors
    if (finalBmValue != '' &&
        finalBmValue.contains(".", finalBmValue.indexOf(".") + 1) == false &&
        finalBmValue.contains(" ") == false &&
        finalBmValue.contains("-", 1) == false) {
      // nonZeroBs = 0;
      try {
        n = 0;
        error = double.parse(
            ((initialReducedLevels.last) - (num.parse(finalBmValue)))
                .toStringAsFixed(3));

        // Counting non-null values in backsight
      } catch (e) {}

      //Custom function to count non null backsights at a specified length
      num countNonZero(num n) {
        int z = 0;
        int nonZeroBackSightSpecified = 0;
        List subBackSight = [];
        subBackSight = newBackSight.sublist(0, n + 1);
        try {
          while (z <= size) {
            if (subBackSight[z] != '') {
              nonZeroBackSightSpecified++;
            }
            z++;
          }
        } catch (e) {}
        return nonZeroBackSightSpecified;
      }

      try {
        num m;
        n = 0;
        while (n <= size) {
          if (error != 0 && initialReducedLevels[n + 1] != 0) {
            m = (-error / nonZeroBs) * countNonZero(n);
            adj.add(double.parse(m.toStringAsFixed(3)));
          } else {
            m = 0;
            adj.add(double.parse(m.toStringAsFixed(3)));
          }
          n++;
        }
      } catch (e) {}
    }

    // // Calculating for final reduced levels if final Bm value is not null
    if (finalBmValue != '' &&
        finalBmValue.contains(".", finalBmValue.indexOf(".") + 1) == false &&
        finalBmValue.contains(" ") == false &&
        finalBmValue.contains("-", 1) == false) {
      num frl;
      n = 0;
      try {
        while (n <= size) {
          frl = adj[n] + initialReducedLevels[n];
          finalReducedLevels.add(double.parse(frl.toStringAsFixed(3)));
          n++;
        }
      } catch (e) {
        print(e.toString());
      }
      print('frl is $finalReducedLevels');
    }
    // Arithmetic check
    try {
      // removing empty strings in foresights and backsights
      List newBacksight = [];
      n = 0;
      try {
        while (n <= size) {
          if (backSight[n] != '') {
            newBacksight.add(newBacksight[n]);
          }
          n++;
        }
      } catch (e) {}

      // Summing backsights
      try {
        int x;
        x = 0;
        while (x <= size) {
          if (newBackSight[x] != '') {
            sumOfBs = sumOfBs + newBackSight[x];
          }
          x++;
        }
      } catch (e) {} finally {
        print('sum of BS: $sumOfBs');
      }

      //Summing foresights
      try {
        int a = 0;
        while (a <= size) {
          if (foreSight[a] != '') {
            sumOfFs = sumOfFs + foreSight[a];
          }
          a++;
        }
      } catch (e) {} finally {
        print('sum of FS: $sumOfFs');
      }

      //summing rises and falls
      if (initMethod == "Rise or Fall") {
        try {
          int b = 0;
          while (b <= size) {
            sumOfHeights = heightDifferences[b] + sumOfHeights;
            b++;
          }
        } catch (e) {} finally {
          print('sum of Rises: $sumOfHeights');
        }
      }

      sumOfFs = double.parse(sumOfFs.toStringAsFixed(3));
      diffBtnBsAndFs = sumOfBs - sumOfFs;
      diffFirstRlAndLastRl =
          initialReducedLevels.last - initialReducedLevels[0];
      if ((double.parse(diffBtnBsAndFs.toStringAsFixed(3)) ==
              double.parse(sumOfHeights.toStringAsFixed(3))) ||
          (double.parse(diffBtnBsAndFs.toStringAsFixed(3))) ==
              double.parse(diffFirstRlAndLastRl.toStringAsFixed(3))) {
        arithmeticCheck = 'correct';
      } else {
        arithmeticCheck = 'incorrect, please check your data';
      }
      print('arithmetic check : $arithmeticCheck');
      // Allowable
      try {
        k = int.parse(initAccuracy);
        allowableMisclose =
            double.parse((k * math.sqrt(nonZeroBs)).toStringAsFixed(3));
        if (finalBmValue != '' &&
            finalBmValue.contains(".", finalBmValue.indexOf(".") + 1) ==
                false &&
            finalBmValue.contains(" ") == false &&
            finalBmValue.contains("-", 1) == false) {
          if (error.abs() <= allowableMisclose) {
            condition = '';
            misclose = 'accepted';
          } else {
            condition = 'not ';
            misclose = 'rejected';
          }
        }
      } catch (e) {
        print(e.toString());
      }
      print('misclose is $misclose');
    } catch (e) {
      print(e.toString());
    }

    //Seperating rises and falls
    try {
      List<num> newHeights = heightDifferences.sublist(1);
      var i;
      for (i in newHeights) {
        if (i >= 0) {
          rise.add(double.parse(i.toStringAsFixed(3)));
          fall.add('');
        } else {
          fall.add(double.parse(i.abs().toStringAsFixed(3)));
          rise.add('');
        }
      }
    } catch (e) {}
    print('rise data: $rise');
    print('fall data: $fall');

    // Removing duplicates in HPC
    try {
      n = 1;
      int x = 0;
      while (n <= size) {
        if (heightCollimation[x] == heightCollimation[n]) {
          heightCollimation[n] = '';
        } else {
          x = n;
        }
        n++;
      }
    } catch (e) {}

    //Summing rises and falls
    try {
      n = 0;
      while (n <= size) {
        if (rise[n] != '') {
          sumOfRise += rise[n];
        }
        if (fall[n] != '') {
          sumOfFall += fall[n];
        }
        n++;
      }
    } catch (e) {}

    int m = 0;

    if (initMethod == "Rise or Fall") {
      m = 2;
    } else {
      m = 1;
    }
    // Adding results to myData
    try {
      n = 0;
      while (n <= size) {
        // Adding adjustment and final reduced levels to table
        if (finalBmValue != '' &&
            finalBmValue.contains(".", finalBmValue.indexOf(".") + 1) ==
                false &&
            finalBmValue.contains(" ") == false &&
            finalBmValue.contains("-", 1) == false) {
          // Adding rise and fall columns to table
          if (initMethod == "Rise or Fall") {
            levelData[n + 1].insert(m + 1, rise[n]);
            levelData[n + 1].insert(m + 2, fall[n]);
          }
          // Adding HPC to table
          else {
            levelData[n + 1].insert(m + 2, heightCollimation[n]);
          }
          levelData[n + 1].insert(m + 3, initialReducedLevels[n]);
          levelData[n + 1].insert(m + 4, adj[n]);
          levelData[n + 1].insert(m + 5, finalReducedLevels[n]);
        }
        // Not adding adjustment and final reduced levels to table
        else {
          // Adding rise and fall columns to table
          if (initMethod == "Rise or Fall") {
            levelData[n + 1].insert(3, rise[n]);
            levelData[n + 1].insert(4, fall[n]);
          }
          // Adding HPC to table
          else {
            levelData[n + 1].insert(3, heightCollimation[n]);
          }
          levelData[n + 1].insert(m + 3, initialReducedLevels[n]);
        }
        n++;
      }
    } catch (e) {}

    //Appending necessary data to error Data
    errorData.add(['The selected accuracy (k)']);
    errorData[0].add(' $k');
    // errorData.add([' The selected method of computation']);
    // errorData[1].add(' $selectedComputation');
    errorData.add([' No. of stations']);
    errorData[1].add(' $nonZeroBs');
    errorData.add([' Sum of backsights']);
    errorData[2].add(' $sumOfBs');
    errorData.add([' Sum of foresights']);
    errorData[3].add(' $sumOfFs');
    errorData.add([' ΣBS - ΣFS']);
    errorData[4].add(' ' + diffBtnBsAndFs.toStringAsFixed(3));

    n = 4;
    // Rise and fall checks
    if (initMethod == "Rise or Fall") {
      errorData.add([' Sum of rise']);
      errorData[n + 1].add(' ' + sumOfRise.toStringAsFixed(3));
      errorData.add([' Sum of fall']);
      errorData[n + 2].add(' ' + sumOfFall.toStringAsFixed(3));
      errorData.add([' Σ Rise - Σ Fall']);
      errorData[n + 3].add(' ' + sumOfHeights.toStringAsFixed(3));
      errorData.add([' Arithmetic check']);
      errorData[n + 4].add(' $arithmeticCheck');
      if (finalBmValue != '' &&
          finalBmValue.contains(".", finalBmValue.indexOf(".") + 1) == false &&
          finalBmValue.contains(" ") == false &&
          finalBmValue.contains("-", 1) == false) {
        errorData.add([' The allowable misclose']);
        errorData[n + 5].add(' $allowableMisclose');
        errorData.add([' The misclose calculated']);
        errorData[n + 6].add('is $error');
      }
    }
    // HPC checks
    else {
      errorData.add([' Arithmetic check']);
      errorData[n + 1].add(' $arithmeticCheck');
      if (finalBmValue != '' &&
          finalBmValue.contains(".", finalBmValue.indexOf(".") + 1) == false &&
          finalBmValue.contains(" ") == false &&
          finalBmValue.contains("-", 1) == false) {
        errorData.add([' The allowable misclose']);
        errorData[n + 2].add(' $allowableMisclose');
        errorData.add([' The misclose calculated']);
        errorData[n + 3].add(' $error');
      }
    }

    dataHeadings = [];
    dataHeadings.add("Backsight");
    dataHeadings.add("Intersight");
    dataHeadings.add("Foresight");

    if (finalBmValue != '' &&
        finalBmValue.contains(".", finalBmValue.indexOf(".") + 1) == false &&
        finalBmValue.contains(" ") == false &&
        finalBmValue.contains("-", 1) == false) {
      if (initMethod == "Rise or Fall") {
        dataHeadings.add("RISE");
        dataHeadings.add("FALL");
        dataHeadings.add("IRL");
        dataHeadings.add("ADJ");
        dataHeadings.add("FRL");
        dataHeadings.add("RKS");
      } else {
        dataHeadings.add("HPC");
        dataHeadings.add("IRL");
        dataHeadings.add("ADJ");
        dataHeadings.add("FRL");
        dataHeadings.add("RKS");
      }
    } else {
      if (initMethod == "Rise or Fall") {
        dataHeadings.add("Rise");
        dataHeadings.add("Fall");
        dataHeadings.add("Initial Reduced Level");
        dataHeadings.add("Remarks");
      } else {
        dataHeadings.add("Height of plane of collimation");
        dataHeadings.add("Initial Reduced Level");
        dataHeadings.add("Remarks");
      }
    }
    setState(() {
      computationsDone = true;
    });
    // print('data heading is $dataHeadings');
    levelData[0] = dataHeadings;
    print('final data is $levelData');
  }

  List<dynamic> headers = [];

  String backsightDropDownValue;
  String foresightDropDownValue;
  String intersightDropDownValue;
  @override
  void initState() {
    super.initState();
  }

  LevellingType radioValue = LevellingType.single_run;
  Widget dropDownButton({List<String> items, dynamic value}) {
    return DropdownButtonFormField(
      decoration: InputDecoration(border: OutlineInputBorder()),
      value: value.toString(),
      onChanged: (newValue) {
        setState(() {
          if (value == initMethod) initMethod = newValue;
          if (value == backsightDropDownValue)
            backsightDropDownValue = newValue.toString();
          if (value == foresightDropDownValue)
            foresightDropDownValue = newValue.toString();
          if (value == intersightDropDownValue)
            intersightDropDownValue = newValue.toString();
        });
      },
      items: items.map((e) {
        return DropdownMenuItem(
          child: Text(
            e.toString(),
            overflow: textOverflow,
          ),
          value: e,
        );
      }).toList(),
    );
  }

  ScrollController firstController = ScrollController();
  ScrollController secondController = ScrollController();
  TextEditingController initialBm = TextEditingController();
  TextEditingController finalBm = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  Widget textController(TextEditingController controller, String hintText) {
    return IntrinsicWidth(
      child: Container(
        width: 300,
        child: TextFormField(
          validator: controller == initialBm
              ? (string) {
                  if (string.isEmpty) return 'Required';
                  return null;
                }
              : null,
          controller: controller,
          decoration:
              InputDecoration(border: OutlineInputBorder(), hintText: hintText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets padding = EdgeInsets.only(top: 20, left: 20);
    return Scaffold(
      appBar: myAppBar(),
      body: Form(
        key: key,
        child: Container(
          width: size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                style: TextStyle(
                                    fontFamily: 'Redressed', fontSize: 24),
                              ),
                              value: LevellingType.single_run,
                              onChanged: (LevellingType value) {
                                setState(() {
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
                              value: LevellingType.double_run,
                              title: Text(
                                'Precise Levelling',
                                style: TextStyle(
                                    fontFamily: 'Redressed', fontSize: 24),
                              ),
                              groupValue: radioValue,
                              onChanged: (LevellingType value) {
                                setState(() {
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
                              onPressed: () {
                                chooseFile();
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
                            'Configuration',
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'Berkshire'),
                          ),
                        ),
                      if (dataPicked)
                        Padding(
                          padding: padding,
                          child: Text(
                            'Initial BM Value',
                            style: TextStyle(fontSize: 22, fontFamily: 'Akaya'),
                          ),
                        ),
                      if (dataPicked)
                        Padding(
                          padding: padding,
                          child: textController(
                              initialBm, 'Enter Initial BM value'),
                        ),
                      if (dataPicked)
                        Padding(
                          padding: padding,
                          child: Text(
                            'Final BM Value',
                            style: TextStyle(fontSize: 22, fontFamily: 'Akaya'),
                          ),
                        ),
                      if (dataPicked)
                        Padding(
                          padding: padding,
                          child: textController(
                              finalBm, 'Leave as empty if there\'s none'),
                        ),
                      if (dataPicked)
                        Padding(
                          padding: padding,
                          child: Text(
                            'Method of computation',
                            style: TextStyle(fontSize: 22, fontFamily: 'Akaya'),
                          ),
                        ),
                      if (dataPicked)
                        Padding(
                          padding: padding,
                          child: Container(
                              width: 300,
                              child: dropDownButton(items: [
                                'Rise or Fall',
                                'Height of plane of collimation'
                              ], value: initMethod)),
                        ),
                      if (dataPicked)
                        Padding(
                          padding: padding,
                          child: Text(
                            'Accuracy factor',
                            style: TextStyle(fontSize: 22, fontFamily: 'Akaya'),
                          ),
                        ),
                      if (dataPicked)
                        Padding(
                          padding: padding,
                          child: Container(
                              width: 300,
                              child: dropDownButton(
                                  items: ['2', '3', '5', '7'],
                                  value: initAccuracy)),
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
                                  items: headers,
                                  value: backsightDropDownValue)),
                        ),
                      if (dataPicked)
                        Padding(
                          padding: padding,
                          child: Text(
                            'Intersight Data',
                            style: TextStyle(fontSize: 22, fontFamily: 'Akaya'),
                          ),
                        ),
                      if (dataPicked)
                        Padding(
                          padding: padding,
                          child: Container(
                              width: 300,
                              child: dropDownButton(
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
                                  items: headers,
                                  value: foresightDropDownValue)),
                        ),
                      if (dataPicked)
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'PROCESS',
                              ),
                            ),
                            onPressed: () {
                              if (key.currentState.validate())
                                levelComputation();
                            },
                            style: ButtonStyle(backgroundColor:
                                MaterialStateProperty.resolveWith(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.white;
                              }
                              return Colors.teal;
                            }), textStyle: MaterialStateProperty.resolveWith(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return TextStyle(
                                    letterSpacing: 2.0,
                                    fontFamily: 'Akaya',
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold);
                              }
                              return TextStyle(
                                  fontFamily: 'Akaya', letterSpacing: 2.0);
                            }), foregroundColor:
                                MaterialStateProperty.resolveWith(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.teal;
                              }
                              return Colors.white;
                            }), elevation: MaterialStateProperty.resolveWith(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return 12.0;
                              }
                              return 6.0;
                            })),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (dataPicked == true)
                Flexible(
                    flex: 2,
                    child: Scrollbar(
                      isAlwaysShown: true,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Padding(
                            padding: padding,
                            child: SingleChildScrollView(
                              child: DataTable(
                                  columns: computationsDone
                                      ? dataHeadings.map((e) {
                                          return DataColumn(
                                              label: Text(e.toString(),
                                                  style: headerStyle));
                                        }).toList()
                                      : headers.map((e) {
                                          return DataColumn(
                                              label: Text(e.toString(),
                                                  style: headerStyle));
                                        }).toList(),
                                  rows: levelData.sublist(1).map((e) {
                                    return DataRow(
                                        cells: e
                                            .map((e) => DataCell(Text(
                                                  e.toString(),
                                                  style: rowStyle,
                                                )))
                                            .toList());
                                  }).toList()),
                            ),
                          ),
                        ],
                      ),
                    ))
            ],
          ),
        ),
      ),
    );
  }

  TextStyle headerStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Akaya');
  TextStyle rowStyle = TextStyle(fontFamily: 'Maths', fontSize: 18);
}
