import 'dart:math';
import 'package:final_project/functions.dart';
import 'package:flutter/material.dart';

num converter = (pi / 180);

List computeIncludedAngles({List<dynamic> circleReadings}) {
  List<dynamic> doubleIncludedAngles = [];
  List<dynamic> includedAngles = [];
  circleReadings.insert(0, 0);
  int n = 2;
  num angle;
  int size = circleReadings.length;
  // double included angles
  try {
    while (n < size) {
      if (n % 2 == 0 && n % 4 != 0) {
        angle = (circleReadings[n] - circleReadings[n - 1]) % 360;
      } else if (n % 2 == 0 && n % 4 == 0) {
        angle = (circleReadings[n - 1] - circleReadings[n]) % 360;
      }
      doubleIncludedAngles.add(angle);
      n += 2;
    }
  } catch (e) {}
  n = 0;
  num meanAngle;
  try {
    while (n < doubleIncludedAngles.length) {
      meanAngle = doubleIncludedAngles[n] + doubleIncludedAngles[n + 1];
      includedAngles.add(meanAngle / 2);
      n += 2;
    }
  } catch (e) {}
  return includedAngles;
}

List<dynamic> computeBearings(
    {num initialBearing, List<dynamic> includedAngles}) {
  List<dynamic> results = [initialBearing];
  int size = includedAngles.length;
  int n = 0;
  try {
    while (n <= size) {
      results.add((backBearing(results[n]) + includedAngles[n]) % 360);
      n++;
    }
  } catch (e) {}
  return results;
}

List<dynamic> adjustBearings({List<dynamic> initialBearings}) {
  num error = initialBearings.last - initialBearings.first;
  num adjustment = error / (initialBearings.length - 1);
  List<dynamic> adjPerStation = [];
  List<dynamic> finalBearing = [];
  for (var i in initialBearings) {
    adjPerStation.add(-adjustment * initialBearings.indexOf(i));
  }
  for (int i = 0; i < adjPerStation.length; i++) {
    finalBearing.add((initialBearings[i] + adjPerStation[i]) % 360);
  }
  return [adjPerStation, finalBearing];
}

List<List<dynamic>> computeLatDdep(
    {List<dynamic> bearings, List<dynamic> distances}) {
  List<List<dynamic>> latDep = [[], []];
  try {
    for (int i = 0; i < bearings.length; i++) {
      latDep[0].add(distances[i] * cos(converter * bearings[i + 1]));
      latDep[1].add(distances[i] * sin(converter * bearings[i + 1]));
    }
  } catch (e) {}
  return latDep;
}

List<List<dynamic>> adjustLatDep(
    {String adjustmentMethod,
    List<List<dynamic>> initialLatDep,
    List<dynamic> distances}) {
  List<dynamic> adjLat = [];
  List<dynamic> adjDep = [];
  List<dynamic> correctedLat = [];
  List<dynamic> correctedDep = [];

  if (adjustmentMethod == 'Bowditch') {
    num sumLat = 0;
    num sumDistances = 0;
    num sumDep = 0;
    for (var i in initialLatDep[0]) {
      sumLat += i;
    }
    for (var i in initialLatDep[1]) {
      sumDep += i;
    }
    for (var i in distances.sublist(0, distances.length - 1)) {
      sumDistances += i;
    }
    int n = 0;
    int size = initialLatDep[0].length;
    try {
      while (n < size - 1) {
        adjLat.add((distances[n] / sumDistances) * -sumLat);
        correctedLat.add(adjLat[n] + initialLatDep[0][n]);
        adjDep.add((distances[n] / sumDistances) * -sumDep);
        correctedDep.add(adjDep[n] + initialLatDep[1][n]);
        n++;
      }
      adjLat.add(0);
      adjDep.add(0);
      correctedLat.add(initialLatDep[0].last);
      correctedDep.add(initialLatDep[1].last);
    } catch (e) {}
  } else {}
  return [adjLat, correctedLat, adjDep, correctedDep];
}

List<List<dynamic>> computeNorthingsEastings(
    {List<List<dynamic>> latDep, List<dynamic> controls}) {
  List<List<dynamic>> results = [
    [controls[0]],
    [controls[1]]
  ];
  try {
    for (int i = 0; i <= latDep[1].length; i++) {
      results[0].add(results[0][i] + latDep[1][i]);
      results[1].add(results[1][i] + latDep[3][i]);
    }
  } catch (e) {}
  return results;
}

void linkTraverseComputation(
    {List<List<dynamic>> data,
    TextEditingController northingsOfOne,
    TextEditingController eastingsOfOne,
    TextEditingController northingsOfTwo,
    TextEditingController eastingsOfTwo,
    TextEditingController northingsOfThree,
    TextEditingController eastingsOfThree,
    TextEditingController northingsOfFour,
    TextEditingController eastingsOfFour}) {
  num northingsOfThreeValue;
  num eastingsOfThreeValue;
  num northingsOfFourValue;
  num eastingsOfFourValue;
  num northingsOfOneValue;
  num northingsOfTwoValue;
  num eastingsOfOneValue;
  num eastingsOfTwoValue;
  List<dynamic> distances = [];
  List<dynamic> angleData;
  List<dynamic> backbearings;

  // coordinates of control points

  northingsOfOneValue = num.parse(northingsOfOne.text);
  eastingsOfOneValue = num.parse(eastingsOfOne.text);
  northingsOfTwoValue = num.parse(northingsOfTwo.text);
  eastingsOfTwoValue = num.parse(eastingsOfTwo.text);
  northingsOfThreeValue = num.parse(northingsOfThree.text);
  eastingsOfThreeValue = num.parse(eastingsOfThree.text);
  northingsOfFourValue = num.parse(northingsOfFour.text);
  eastingsOfFourValue = num.parse(eastingsOfFour.text);
  // finding bearings of coordinates
  List<dynamic> bearings = [];
  num initialBearing = 0;
  initialBearing = forwardGeodetic(eastingsOfOneValue, northingsOfOneValue,
      eastingsOfTwoValue, northingsOfTwoValue)[1];
  bearings.add(initialBearing);
  num initialDistance = 0;
  initialDistance = forwardGeodetic(eastingsOfOneValue, northingsOfOneValue,
      eastingsOfTwoValue, northingsOfTwoValue)[0];
  distances.insert(0, initialDistance);
  num finalDistance = 0;
  num finalBearing = 0;
  finalDistance = forwardGeodetic(eastingsOfThreeValue, northingsOfThreeValue,
      eastingsOfFourValue, northingsOfFourValue)[0];
  finalBearing = forwardGeodetic(eastingsOfThreeValue, northingsOfThreeValue,
      eastingsOfFourValue, northingsOfFourValue)[1];

  // finding bearings of consecutive lines
  num size = angleData.length;
  backbearings = [];
  int n = 0;
  num bb;
  num fb;
  try {
    while (n < size) {
      bb = backBearing(bearings[n]);
      backbearings.add(bb);
      fb = (backbearings[n] + angleData[n]) % 360;
      bearings.add(fb);
      n++;
    }
  } catch (e) {}
  // adjusting bearings
  List<dynamic> correctedBearings = [initialBearing];
  num error = 0;
  num corr = 0;
  num adjPerStation = 0;
  num adjustedBearing = 0;

  distances.add(finalDistance);
  error = bearings.last - finalBearing;
  adjPerStation = (-error) / size;
  n = 1;
  try {
    while (n < size) {
      corr = n * adjPerStation;
      adjustedBearing = (corr + bearings[n]) % 360;
      correctedBearings.add(adjustedBearing);
      n++;
    }
  } catch (e) {}

  // latitudes and departures

  List<dynamic> latitudes = [];
  List<dynamic> departures = [];
  num lat = 0;
  num dep = 0;
  n = 1;
  try {
    while (n < size) {
      lat = distances[n] * cos(converter * correctedBearings[n]);
      dep = distances[n] * sin(converter * correctedBearings[n]);
      latitudes.add(lat);
      departures.add(dep);
      n++;
    }
  } catch (e) {}

  // adjusting latitudes and departures

  if ('adj' == 'Bowditch') {
    num sumLat = 0;
    num sumDistances = 0;
    num sumDep = 0;
    for (var i in latitudes) {
      sumLat += i;
    }
    for (var i in departures) {
      sumDep += i;
    }
    for (var i in distances) {
      sumDistances += i;
    }
    sumDistances -= distances[0];
    sumDistances -= distances.last;

    List<dynamic> adjustedDepartures = [];
    List<dynamic> adjustedLatitudes = [];
    num errorInLat = sumLat - (northingsOfThreeValue - northingsOfTwoValue);
    num errorInDep = sumDep - (eastingsOfThreeValue - eastingsOfTwoValue);
    distances.removeAt(0);
    distances.remove(distances.last);

    n = 0;
    try {
      while (n < size) {
        num adjLat = (distances[n] / sumDistances) * -errorInLat;
        num adjDep = (distances[n] / sumDistances) * -errorInDep;
        adjustedDepartures.add(adjDep + departures[n]);
        adjustedLatitudes.add(adjLat + latitudes[n]);
        n++;
      }
    } catch (e) {}

    // calculating northings and eastings
    List<dynamic> northings = [northingsOfTwoValue];
    List<dynamic> eastings = [eastingsOfTwoValue];

    n = 0;
    try {
      while (n < size) {
        num north = northings[n] + adjustedLatitudes[n];
        num east = eastings[n] + adjustedDepartures[n];
        northings.add(north);
        eastings.add(east);
        n++;
      }
    } catch (e) {}

    latitudes.insert(0, initialDistance * cos(converter * initialBearing));
    departures.insert(0, initialDistance * sin(converter * initialBearing));
    adjustedLatitudes.insert(
        0, initialDistance * cos(converter * initialBearing));
    adjustedDepartures.insert(
        0, initialDistance * sin(converter * initialBearing));
    distances.insert(0, initialDistance);
    bearings.remove(bearings.last);

    // end
  } else if ('adj' == 'Transit') {}
}
