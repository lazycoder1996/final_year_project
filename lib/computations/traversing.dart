import 'dart:math';
import 'package:final_project/functions.dart';
import 'package:flutter/material.dart';

void loopTraverseComputation() {}

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
  num converter = (pi / 180);

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
