import 'travFunctions.dart';

loopTraverse(
    {String adjustBy,
    List<List<dynamic>> traverseData,
    Map<String, dynamic> rawValues}) {
  DateTime startTime = DateTime.now();
  var dataSize = traverseData.length;
  var backsightData = rawValues['backsight'];
  var foresightData = rawValues['foresight'];
  var stationData = rawValues['station'];
  var circleReadings = rawValues['circle'];
  var distanceData = rawValues['distance'];
  var controls = rawValues['control'];
  // print('backsight data $backsightData');
  // print('foresight data $foresightData');
  stationData.removeWhere((element) => element == '');
  // print('station data is $stationData');
  stationData.insert(0, stationData.last);
  stationData.add(stationData[1]);
  // initialBearing
  controls.removeWhere((element) => element == '');
  var backSightControls = controls[0].toString().split(',');
  var stationControls = controls[1].toString().split(',');
  var controlData = forwardGeodetic(
      double.parse(backSightControls[0]),
      double.parse(backSightControls[1]),
      double.parse(stationControls[0]),
      double.parse(stationControls[1]));
  // adding distance of controls to distanceData
  distanceData.insert(0, controlData[0]);
  distanceData.add(controlData[0]);
  distanceData.removeWhere((element) => element == '');
  List departure = [
    '- ${backsightData[0]} (${backSightControls[0]}, ${backSightControls[1]})',
    '- ${stationData[1]} (${stationControls[0]}, ${stationControls[1]})'
  ];
  List closure = [
    '- ${backsightData[0]} (${backSightControls[0]}, ${backSightControls[1]})',
    '- ${stationData[1]} (${stationControls[0]}, ${stationControls[1]})'
  ];
  // print('distance data are $distanceData');
  // computing included angles
  var includedAngles = computeIncludedAngles(circleReadings: circleReadings);
  num sum = 0;
  includedAngles.forEach((element) {
    sum += element;
  });
  // print(includedAngles);
  // print(sum);
  // adjusted included angles
  // var adjustedIncludedAngles = adjustIncludedAngles(
  //     includedAngles: includedAngles, direction: direction);
  // print('adjusted included angles are $adjustedIncludedAngles');
  // compute bearings
  var unadjustedBearings = computeBearings(
      typeOfTraverse: 'Closed Loop',
      includedAngles: includedAngles,
      initialBearing: controlData[1]);
  // print('initial bearing is ${controlData[1]}');
  // print('initial bearings are $unadjustedBearings');
  // adjust bearings
  print('un be is $unadjustedBearings');
  var adjustedBearings = adjustBearings(
      initialBearings: unadjustedBearings['results'],
      typeOfTraverse: 'Closed Loop');
  print('adjusted bearings are $adjustedBearings');
  // compute dep and lat
  var depLat = computeDepLat(
      bearings: adjustedBearings['results'][1], distances: distanceData);
  // print('dep and lat are $depLat');
  // adjust dep lat
  var adjustedDepLat = adjustDepLat(
      typeOfTraverse: 'Closed Loop',
      adjustmentMethod: adjustBy,
      distances: distanceData,
      initialDepLat: depLat,
      expLoopTransit: [
        double.parse(backSightControls[0]) - double.parse(stationControls[0]),
        double.parse(backSightControls[1]) - double.parse(stationControls[1])
      ]);
  print('adjusted dep lat are $adjustedDepLat');
  // computing eastings and northings
  var finalCoordinates = computeEastingNorthing(
      controls: [num.parse(stationControls[0]), num.parse(stationControls[1])],
      depLat: adjustedDepLat['results']);
  print('final coordinates are $finalCoordinates');
  finalCoordinates.forEach((element) {
    print(element.toString());
  });
  List<List<dynamic>> output = [];
  output.insert(0, [
    'From',
    'To',
    'Included Angle',
    'Distance',
    'Bearing',
    'Corr to Bear',
    'Adjusted Bear',
    'Departure',
    'Corr to Dep',
    'Adjusted Dep',
    'Latitude',
    'Corr to Lat',
    'Adjusted Lat',
    'Easting',
    'Northing'
  ]);
  includedAngles.insert(0, '');
  var n = 0;
  try {
    while (n <= finalCoordinates[0].length) {
      // print('start');
      // print('n: $n');
      output.add([
        stationData[n],
        stationData[n + 1],
        includedAngles[n],
        distanceData[n],
        unadjustedBearings['results'][n],
        adjustedBearings['results'][0][n],
        adjustedBearings['results'][1][n],
        depLat[0][n],
        adjustedDepLat['results'][0][n],
        adjustedDepLat['results'][1][n],
        depLat[1][n],
        adjustedDepLat['results'][2][n],
        adjustedDepLat['results'][3][n],
        finalCoordinates[0][n],
        finalCoordinates[1][n]
      ]);
      n++;
    }
  } catch (e) {}
  DateTime endTime = DateTime.now();
  DateTime duration = DateTime.fromMillisecondsSinceEpoch(
      endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch);
  return [
    output,
    {
      'duration': Duration(milliseconds: duration.millisecond).inMilliseconds,
      'departure': departure.join("\r\n"),
      'closure': closure.join('\r\n'),
      'setup': includedAngles.length,
      'adj By': adjustBy,
      'observed final bearing':
          unadjustedBearings['error'][0].toStringAsFixed(6),
      'expected final bearing': controlData[1].toStringAsFixed(6),
      'error': adjustedBearings['error'][0].toStringAsFixed(6),
      'sum of dep': adjustedDepLat['error'][0].toStringAsFixed(6),
      'exp sum of dep': adjustedDepLat['error'][2].toStringAsFixed(6),
      'error in dep': adjustedDepLat['error'][4].toStringAsFixed(6),
      'sum of lat': adjustedDepLat['error'][1].toStringAsFixed(6),
      'exp sum of lat': adjustedDepLat['error'][3].toStringAsFixed(6),
      'error in lat': adjustedDepLat['error'][5].toStringAsFixed(6),
      'sum dist': adjustedDepLat['error'][6].toStringAsFixed(6),
      'linear misclose': adjustedDepLat['error'][7].toStringAsFixed(6),
      'fractional misclose': adjustedDepLat['error'][8],
    }
  ];
}
