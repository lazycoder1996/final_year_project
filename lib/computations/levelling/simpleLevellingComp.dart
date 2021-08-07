import 'dart:math' as math;

import 'package:final_project/computations/traversing/travFunctions.dart';

simpleLevelling(List<List<dynamic>> rawData, initialValues, String initMethod,
    String initAccuracy) {
  DateTime startTime = DateTime.now();
  List<List<dynamic>> processedData = rawData;
  var backSight = [];
  var benchmark = [];
  var interSight = [];
  var foreSight = [];
  var initialReducedLevels = <num>[];
  int size;
  var heightDifferences = <num>[0];
  var dataHeadings = <String>[];
  var adj = <dynamic>[0.0];
  var error;
  var newBackSight = [];
  var newIntersight = [];
  String arithmeticCheck = 'correct';
  num allowableMisclose = 0;
  // ignore: unused_local_variable
  String condition;
  String misclose = 'accepted';
  var finalReducedLevels = <num>[];
  num nonZeroBs = 0;
  num sumOfBs = 0;
  num sumOfRise = 0;
  num sumOfFall = 0;
  num sumOfIs = 0;
  num sumRl = 0;
  num sumOfFs = 0;
  num hpcTimesApplication = 0;
  num sumOfHeights = 0;
  num diffBtnBsAndFs = 0;
  num diffFirstRlAndLastRl = 0;
  num k = double.parse(initialValues['k']);
  // ignore: omit_local_variable_types
  List<dynamic> rise = [''];
  // ignore: omit_local_variable_types
  List<dynamic> fall = [''];
  List heightCollimation = [];
  var errorData = <List<dynamic>>[];
  var mySwitch = false;
  var computeSwitch = true;
  bool chainagesExist;
  bool statsPressed;
  // static File myCsvFile = new File(_fileName);
  var data = <List<dynamic>>[];
  num max = 0;
  num absMax;
  num absMin;
  num min;
  num a;
  num b;
  var timesDownloaded = 0;
  var fileNames = [];
  List timesHPCused = [];

  var selectedComputation = initMethod;
  dynamic initialBmValue;
  dynamic finalBmValue;
  List headers = processedData[0];
  // putting appropriate data in columns
  for (var i = 1; i < processedData.length; i++) {
    backSight.add(
        processedData[i][headers.indexOf(initialValues['backsightValue'])]);
    interSight.add(
        processedData[i][headers.indexOf(initialValues['intersightValue'])]);
    foreSight.add(
        processedData[i][headers.indexOf(initialValues['foresightValue'])]);
    benchmark.add(
        processedData[i][headers.indexOf(initialValues['benchmarkValue'])]);
  }
  // getting initial bench mark
  try {
    print(benchmark.first);
    initialBmValue = benchmark.first;
    initialReducedLevels.add(num.parse(initialBmValue.toString()));
  } catch (e) {
    initialBmValue = '';
  }
  size = backSight.length;
  num h;
  var n = 0;
  num reducedLevel;
  int count(var count, List countIn) {
    int times = 0;
    for (var i in countIn) {
      if (i == count) {
        times++;
      }
    }
    return times;
  }

  // Calculating rise or fall
  if (initMethod == 'Rise or Fall') {
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
        initialReducedLevels.add(double.parse(reducedLevel.toStringAsFixed(3)));
        n++;
      }
    } catch (e) {
      // print(e.toString());
    }
    print(initialReducedLevels);
  } else {
    selectedComputation = 'Height of plane of collimation';

    // Calculating for hpc
    try {
      num hpc;
      heightCollimation = [
        backSight[0] + double.parse(initialBmValue.toString())
      ];
      initialReducedLevels = [double.parse(initialBmValue.toString())];
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
    print('hpc is $heightCollimation');
    // for (var i in heightCollimation) {
    //   timesHPCused.add(count(i, heightCollimation));
    // }
    n = 0;
    try {
      while (n <= heightCollimation.length) {
        int a = count(heightCollimation[n], heightCollimation);
        timesHPCused.add(a);
        n += a;
      }
    } catch (e) {}
    print('times hpc used $timesHPCused');
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
  if (num.tryParse(benchmark.last.toString()) != null) {
    // nonZeroBs = 0;
    try {
      n = 0;
      error = double.parse(
          ((initialReducedLevels.last) - (num.parse(benchmark.last.toString())))
              .toStringAsFixed(3));
      print('error is $error');
      // Counting non-null values in backsight
    } catch (e) {}

    //Custom function to count non null backsights at a specified length
    num countNonZero(int n) {
      var z = 0;
      var nonZeroBackSightSpecified = 0;
      var subBackSight = [];
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
  if (num.tryParse(benchmark.last.toString()) != null) {
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
  adj[0] = '';
  // Arithmetic check
  try {
    // removing empty strings in foresights and backsights
    var newBacksight = [];
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

    // summing intersights
    try {
      int x;
      x = 0;
      while (x <= size) {
        if (interSight[x] != '') {
          sumOfIs = sumOfIs + interSight[x];
        }
        x++;
      }
    } catch (e) {} finally {
      print('sum of IS: $sumOfIs');
    }

    //Summing foresights
    try {
      var a = 0;
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
    if (initMethod == 'Rise or Fall') {
      try {
        var b = 0;
        while (b <= size) {
          sumOfHeights = heightDifferences[b] + sumOfHeights;
          b++;
        }
      } catch (e) {} finally {
        print('sum of Rises: $sumOfHeights');
      }
    }
    sumRl = sumItems(initialReducedLevels.sublist(1));

    sumOfFs = double.parse(sumOfFs.toStringAsFixed(3));
    diffBtnBsAndFs = sumOfBs - sumOfFs;
    diffFirstRlAndLastRl = initialReducedLevels.last - initialReducedLevels[0];
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
      k = int.parse(initAccuracy.toString());
      allowableMisclose =
          double.parse(((k * math.sqrt(nonZeroBs)) / 1000).toStringAsFixed(5));
      if (num.tryParse(benchmark.last.toString()) != null) {
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
    var newHeights = heightDifferences.sublist(1);
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
  if (initMethod != 'Rise or Fall') {
    try {
      n = 1;
      var x = 0;
      while (n <= size) {
        if (heightCollimation[x] == heightCollimation[n]) {
          heightCollimation[n] = '';
        } else {
          x = n;
        }
        n++;
      }
    } catch (e) {}
    n = 0;
    timesHPCused[timesHPCused.length - 1] = timesHPCused.last - 1;
    for (var i in heightCollimation) {
      if (i != '') {
        hpcTimesApplication += i * timesHPCused[n];
        n++;
      }
    }
  }

  //Summing rises and falls
  if (initMethod == 'Rise or Fall') {
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
  }

  var m = 0;

  if (initMethod == 'Rise or Fall') {
    m = 2;
  } else {
    m = 1;
  }
  // Adding results to myData
  try {
    n = 0;
    while (n < size) {
      // Adding adjustment and final reduced levels to table
      if (num.tryParse(benchmark.last.toString()) != null) {
        // Adding rise and fall columns to table
        if (initMethod == 'Rise or Fall') {
          processedData[n + 1].insert(m + 1, rise[n]);
          processedData[n + 1].insert(m + 2, fall[n]);
        }
        // Adding HPC to table
        else {
          processedData[n + 1].insert(m + 2, heightCollimation[n]);
        }
        processedData[n + 1].insert(m + 3, initialReducedLevels[n]);
        processedData[n + 1].insert(m + 4, adj[n]);
        processedData[n + 1].insert(m + 5, finalReducedLevels[n]);
      }
      // Not adding adjustment and final reduced levels to table
      else {
        // Adding rise and fall columns to table
        if (initMethod == 'Rise or Fall') {
          processedData[n + 1].insert(3, rise[n]);
          processedData[n + 1].insert(4, fall[n]);
        }
        // Adding HPC to table
        else {
          processedData[n + 1].insert(3, heightCollimation[n]);
        }
        processedData[n + 1].insert(m + 3, initialReducedLevels[n]);
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
  if (initMethod == 'Rise or Fall') {
    errorData.add([' Sum of rise']);
    errorData[n + 1].add(' ' + sumOfRise.toStringAsFixed(3));
    errorData.add([' Sum of fall']);
    errorData[n + 2].add(' ' + sumOfFall.toStringAsFixed(3));
    errorData.add([' Σ Rise - Σ Fall']);
    errorData[n + 3].add(' ' + sumOfHeights.toStringAsFixed(3));
    errorData.add([' Arithmetic check']);
    errorData[n + 4].add(' $arithmeticCheck');
    if (num.tryParse(benchmark.last.toString()) != null) {
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
    if (num.tryParse(benchmark.last.toString()) != null) {
      errorData.add([' The allowable misclose']);
      errorData[n + 2].add(' $allowableMisclose');
      errorData.add([' The misclose calculated']);
      errorData[n + 3].add(' $error');
    }
  }

  dataHeadings = [];
  dataHeadings.add('Backsight');
  dataHeadings.add('Intersight');
  dataHeadings.add('Foresight');

  if (num.tryParse(benchmark.last.toString()) != null) {
    if (initMethod == 'Rise or Fall') {
      dataHeadings.add('Rise');
      dataHeadings.add('Fall');
      dataHeadings.add('Initial Reduced Level');
      dataHeadings.add('Adjustment');
      dataHeadings.add('Final Reduced Level');
      dataHeadings.add('Remarks');
    } else {
      dataHeadings.add('Height of plane of collimation');
      dataHeadings.add('Initial Reduced Level');
      dataHeadings.add('Adjustment');
      dataHeadings.add('Final Reduced Level');
      dataHeadings.add('Remarks');
    }
  } else {
    if (initMethod == 'Rise or Fall') {
      dataHeadings.add('Rise');
      dataHeadings.add('Fall');
      dataHeadings.add('Initial Reduced Level');
      dataHeadings.add('Remarks');
    } else {
      dataHeadings.add('Height of plane of collimation');
      dataHeadings.add('Initial Reduced Level');
      dataHeadings.add('Remarks');
    }
  }
  dataHeadings.add('Benchmark');
  processedData[0] = dataHeadings;
  // print('result is $processedData');
  backSight.removeWhere((element) => element == '');
  int rks = processedData[0].indexOf("Remarks");
  List remarks = [];
  for (var i in processedData.sublist(1)) {
    remarks.add(i[rks]);
  }
  print('remarks are $remarks');
  List reportBM = [];
  n = 0;
  for (var i = 0; i < remarks.length; i++) {
    if (benchmark[i] != '') {
      reportBM.add('-   ${remarks[i]} (${benchmark[i]})');
    }
  }
  String benchmarksIdentified = reportBM.join("\r\n");
  List summary = [];
  for (var i = 0; i < remarks.length; i++) {
    if (benchmark[i] != '') {
      String error =
          (initialReducedLevels[i] - benchmark[i]).toStringAsFixed(3);
      summary.add(
          '${remarks[i]}\t\t${benchmark[i]}\t\t${initialReducedLevels[i]}\t\t$error');
    }
  }

  String misclosureSummary = summary.join("\r\n");
  DateTime endTime = DateTime.now();
  DateTime duration = DateTime.fromMillisecondsSinceEpoch(
      endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch);
  return [
    processedData,
    {
      'duration': Duration(
        milliseconds: duration.millisecond,
      ).inMilliseconds,
      'Benchmarks identified': benchmarksIdentified,
      'Total number of instrument setup': backSight.length,
      'Sum of backsight': sumOfBs,
      'Sum of foresight': sumOfFs,
      'Arithmetic check': arithmeticCheck,
      'Method of computation': initMethod,
      'Accuracy factor k': initAccuracy,
      'Acceptable Misclosure': allowableMisclose,
      'sum of rise': sumOfRise,
      'sum of fall': sumOfFall,
      'is+fs+rl': (sumOfIs + sumOfFs + sumRl).toStringAsFixed(5),
      'sum intersight': sumOfIs.toStringAsFixed(5),
      'sum rl': sumRl.toStringAsFixed(5),
      'hpc*application': hpcTimesApplication.toStringAsFixed(5),
      'check': initMethod == 'Rise or Fall'
          ? (diffBtnBsAndFs - sumOfHeights).roundToDouble().toInt()
          : (sumOfIs + sumOfFs + sumRl - hpcTimesApplication).roundToDouble(),
      'Project Misclosue': error,
      'true final IRL': benchmark.last,
      'comp final IRL': initialReducedLevels.last,
      'last bm': remarks.last,
      // 'Summary': misclosureSummary
    }
  ];
}
