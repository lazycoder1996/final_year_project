import 'dart:math';

import 'package:final_project/functions.dart';
import 'package:flutter/material.dart';

Widget computeParameters(
    {String typeOfCurve,
    String scenario,
    Map<String, dynamic> computationalValues}) {
  if (typeOfCurve == 'Circular Curve') {
    try {
      radiusValue = num.parse(computationalValues['Radius'].text);
      deflectionAngleValue =
          num.parse(computationalValues['Deflection angle'].text);
      pegIntervalValue = num.parse(computationalValues['Peg interval'].text);

      // obtaining inputs
      if (scenario == "Scenario 1" ||
          scenario == "Scenario 2" ||
          scenario == "Scenario 4") {
        chainagePiValue = num.parse(computationalValues['Chainage of PI'].text);

        halfDeflection = deflectionAngleValue / 2;

        // tangent length
        tangentLength = num.parse(
            (radiusValue * tan(halfDeflection * converter)).toStringAsFixed(3));

        // length of curve
        lengthOfCurve = num.parse(
            ((pi * deflectionAngleValue * radiusValue) / 180)
                .toStringAsFixed(3));

        // PC
        pointOfCommencement =
            num.parse((chainagePiValue - tangentLength).toStringAsFixed(3));

        // PT
        pointOfTangency =
            num.parse((pointOfCommencement + lengthOfCurve).toStringAsFixed(3));

        // Long chord
        longChord = num.parse(
            (2 * radiusValue * sin(halfDeflection * converter))
                .toStringAsFixed(3));

        // subchords
        // intial subchord
        num x = 0;
        num y;
        while (true) {
          if (x > pointOfCommencement) {
            initialSubchord = x - pointOfCommencement;
            y = x;
            break;
          }
          x += pegIntervalValue;
        }
        chords.add(num.parse(pointOfCommencement.toStringAsFixed(3)));

        // regular chords
        while (y < pointOfTangency) {
          chords.add(y);
          y += pegIntervalValue;
        }
        // final subchord
        while (true) {
          if (x > pointOfTangency) {
            finalSubchord = pointOfTangency - (x - pegIntervalValue);
            break;
          }
          x += pegIntervalValue;
        }
        chords.add(num.parse(pointOfTangency.toStringAsFixed(3)));

        // number of chords
        numberOfChords = chords.length - 1;

        // chord lengths
        // List<num> chordLengths = [];
        chordLengths.add(0);

        chordLengths.add(num.parse(initialSubchord.toStringAsFixed(3)));
        int n = 1;
        while (n < numberOfChords - 1) {
          chordLengths.add(pegIntervalValue);
          n++;
        }
        chordLengths.add(num.parse(finalSubchord.toStringAsFixed(3)));
      }

      // Some specifications to Scenario 1 and 4
      if (selectedScenario == "Scenario 1" ||
          selectedScenario == "Scenario 4") {
        // tangential angles
        num constant = 1718.873385;
        tangentialAngles
            .add(((initialSubchord * constant) / (radiusValue * 60)));

        int n = 1;
        while (n < numberOfChords - 1) {
          tangentialAngles
              .add(((pegIntervalValue * constant) / (radiusValue * 60)));
          n++;
        }
        tangentialAngles.add(((finalSubchord * constant) / (radiusValue * 60)));

        // deflection angles
        deflectionAngles = [tangentialAngles[0]];
        n = 0;
        try {
          while (n < numberOfChords) {
            deflectionAngles
                .add((deflectionAngles[n] + tangentialAngles[n + 1]));
            n++;
          }
        } catch (e) {}
        deflectionAngles.insert(0, 0);
        tangentialAngles.insert(0, 0);

        // Points
        int size = tangentialAngles.length;
        for (int i = 1; i <= size; i++) {
          points.add(i);
        }
      }
      if (selectedScenario == "Scenario 2") {
        chordLengths.removeAt(0);
        chordLengths.insert(1, pegIntervalValue);
        chordsProducedOffsets = [0];
        // First offset
        chordsProducedOffsets.add(num.parse(
            (((initialSubchord * initialSubchord) / (2 * radiusValue)))
                .toStringAsFixed(3)));
        // Second offset
        chordsProducedOffsets.add(num.parse((pegIntervalValue *
                (initialSubchord + pegIntervalValue) /
                (2 * radiusValue))
            .toStringAsFixed(3)));
        // Regular offsets
        int n = 1;
        while (n < chordLengths.length - 3) {
          chordsProducedOffsets.add(num.parse(
              ((pegIntervalValue * pegIntervalValue) / (radiusValue))
                  .toStringAsPrecision(3)));
          n++;
        }
        // Last offset
        chordsProducedOffsets.add(num.parse((finalSubchord *
                (finalSubchord + pegIntervalValue) /
                (2 * radiusValue))
            .toStringAsFixed(3)));
        int size = chords.length;
        for (int i = 1; i <= size; i++) {
          points.add(i);
        }
        n = 0;
        try {
          while (n < chordLengths.length) {
            dataRows.insert(n, [points[n]]);
            dataRows[n].add(chords[n]);
            dataRows[n].add(chordLengths[n]);
            dataRows[n].add(chordsProducedOffsets[n]);
            n++;
          }
        } catch (e) {}
        columns = ["Point", "Chainage", "Chord Length", "Offsets"];
      }
      if (selectedScenario == "Scenario 3") {
        dataRows = [];
        halfDeflection = deflectionAngleValue / 2;
        xS = [];
        // maximum value of x at the apex of the curve
        num xC = radiusValue * sin(halfDeflection * converter);
        num x = pegIntervalValue;

        // xs for which offsets to be calculated for
        while (x < xC) {
          xS.add(x);
          x += pegIntervalValue;
        }
        xS.add(num.parse(xC.toStringAsFixed(3)));

        // calculating for offsets
        yS = [];
        for (var i in xS) {
          num a = pow(radiusValue, 2) - pow(i, 2);
          num b = sqrt(a);
          num c = radiusValue - b;
          yS.add(num.parse(c.toStringAsFixed(3)));
        }
        points = [];
        int size = yS.length;

        int n = 1;
        while (n <= size) {
          points.add(n);
          n++;
        }
        n = 0;
        try {
          while (n < size) {
            dataRows.add([points[n]]);
            dataRows[n].add(xS[n]);
            dataRows[n].add(yS[n]);
            n++;
          }
        } catch (e) {}
        columns = [
          "Point",
          "x",
          "perpendicular offset(y)",
        ];
      }
      if (selectedScenario == "Scenario 4") {
        direction = computationalValues['direction'];
        num bearingOfBacktangentValue =
            num.parse(computationalValues['Bearing of back tangent'].text);
        num eastingsPIValue =
            num.parse(computationalValues['Eastings of PI'].text);
        num northingsPIValue =
            num.parse(computationalValues['Northings of PI'].text);
        num eastingsSetupValue =
            num.parse(computationalValues['Eastings of X'].text);
        num northingsSetupValue =
            num.parse(computationalValues['Northings of X'].text);
        num eastingsBacksightValue =
            num.parse(computationalValues['Eastings of Y'].text);
        num northingsBacksightValue =
            num.parse(computationalValues['Northings of Y'].text);
        sign = direction == 'Right' ? 1 : -1;
        // Bearing of tangents
        num bearingOfIT1 = bearingOfBacktangentValue + (sign * 180);
        // num bearingOfIT2 = bearingOfIT1 - (180 - deflectionAngleValue);

        // Coordinates of tangents
        num changeEastingsIT1 = tangentLength * sin(bearingOfIT1 * converter);
        num eastingsT1 = changeEastingsIT1 + eastingsPIValue;
        num changeNorthingsIT1 = tangentLength * cos(bearingOfIT1 * converter);
        num northingsT1 = changeNorthingsIT1 + northingsPIValue;

        // num changeEastingsIT2 = tangentLength * sin(bearingOfIT2 * converter);
        // num eastingsT2 = changeEastingsIT2 + eastingsPIValue;
        // num changeNorthingsIT2 = tangentLength * cos(bearingOfIT2 * converter);
        // num northingsT2 = changeNorthingsIT2 + northingsPIValue;

        // Bearings from T1 to points on curve
        bearingsfromT1ToPointsOnCurve = [];
        int size = chordLengths.length;
        int n = 0;
        while (n < size) {
          num a =
              (bearingOfBacktangentValue + (sign * deflectionAngles[n])) % 360;
          bearingsfromT1ToPointsOnCurve.add(num.parse(a.toStringAsFixed(3)));
          n++;
        }

        // Lengths from T1 to points on curve
        lengthOfTItoPointsOnCurve = [];
        n = 0;
        while (n < size) {
          num a = 2 * radiusValue * sin(converter * deflectionAngles[n]);
          lengthOfTItoPointsOnCurve.add(num.parse(a.toStringAsFixed(3)));
          n++;
        }

        // Departures of line T1 to points on curve
        latitudesOfPointsOnCurve = [];
        departuresOfPointsOnCurve = [];
        n = 0;
        while (n < size) {
          num a = lengthOfTItoPointsOnCurve[n] *
              sin(bearingsfromT1ToPointsOnCurve[n] * converter);
          departuresOfPointsOnCurve.add(a);
          n++;
        }

        // Latitudes of line T1 to points on curve
        latitudesOfPointsOnCurve = [];
        n = 0;
        while (n < size) {
          num a = lengthOfTItoPointsOnCurve[n] *
              cos(bearingsfromT1ToPointsOnCurve[n] * converter);
          latitudesOfPointsOnCurve.add(num.parse(a.toStringAsFixed(3)));
          n++;
        }

        // Coordinates for each of the points on curve
        eastingsOfPointsOnCurve = [];
        northingsOfPointsOnCurve = [];

        n = 0;
        while (n < size) {
          num a = eastingsT1 + departuresOfPointsOnCurve[n];
          num b = northingsT1 + latitudesOfPointsOnCurve[n];
          eastingsOfPointsOnCurve.add(num.parse(a.toStringAsFixed(3)));
          northingsOfPointsOnCurve.add(num.parse(b.toStringAsFixed(3)));
          n++;
        }

        // For setting out

        //Lengths and bearings from setup Station to points on curve
        lengthsSetupStationToPointsOnCurve = [];
        bearingsSetupStationToPointsOnCurve = [];

        n = 0;
        while (n < size) {
          num a = forwardGeodetic(eastingsSetupValue, northingsSetupValue,
              eastingsOfPointsOnCurve[n], northingsOfPointsOnCurve[n])[0];
          num b = forwardGeodetic(eastingsSetupValue, northingsSetupValue,
              eastingsOfPointsOnCurve[n], northingsOfPointsOnCurve[n])[1];
          lengthsSetupStationToPointsOnCurve
              .add(num.parse(a.toStringAsFixed(3)));
          bearingsSetupStationToPointsOnCurve.add(b);
          n++;
        }

        // Bearing from setup control station to backsight control station
        num bearingsSetupStationToBacksightStation = forwardGeodetic(
            eastingsSetupValue,
            northingsSetupValue,
            eastingsBacksightValue,
            northingsBacksightValue)[1];

        // included angles angles subtended at setup control station
        List<num> includedAngles = [];
        n = 0;
        while (n < size) {
          num a = (bearingsSetupStationToPointsOnCurve[n] -
                  bearingsSetupStationToBacksightStation) %
              360;
          if (a > 360) {
            a = 360 - a;
          } else {
            a = a;
          }
          includedAngles.add(num.parse(a.toStringAsFixed(3)));
          n++;
        }
        n = 1;
        // points.clear();
        size = eastingsOfPointsOnCurve.length;
        while (n < size) {
          points.add(n);
          n++;
        }
        n = 0;
        try {
          while (n < size) {
            dataRows.add([points[n]]);
            dataRows[n].add(xS[n]);
            dataRows[n].add(yS[n]);
            n++;
          }
        } catch (e) {}
        columns = [
          "Point",
          "Eastings",
          "Northings",
          "Bearing Xp",
          "Distance Xp"
        ];
      }
      if (selectedScenario == "Scenario 1") {
        dataRows = [];
        int size = chordLengths.length;
        int n = 0;
        try {
          while (n < size) {
            dataRows.insert(n, [points[n]]);
            dataRows[n].add(chords[n]);
            dataRows[n].add(chordLengths[n]);
            dataRows[n].add(degreesToDms(tangentialAngles[n]));
            dataRows[n].add(degreesToDms(deflectionAngles[n]));
            n++;
          }
        } catch (e) {}
        columns = [
          "Point",
          "Chainage",
          "Chord Length",
          "Tangential Angle",
          "Deflection Angle"
        ];
      }
      displayResults = new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  SingleChildScrollView(
                    child: new DataTable(
                      columns: columns.map((column) {
                        return DataColumn(label: new Text(column.toString()));
                      }).toList(),
                      rows: dataRows.map((item) {
                        return DataRow(
                            cells: item.map((row) {
                          return DataCell(new Text(row.toString()));
                        }).toList());
                      }).toList(),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
      computationsIsDone = true;
    } catch (e) {
      computationsIsDone = false;
    }
  } else if (typeOfCurve == 'Vertical Curve') {}
  return displayResults;
}

List<TextInputType> textsType = [];
String selectedScenario = "Scenario 1";
String description = 'Description';
num converter = (pi / 180);
bool computationsIsDone = false;
bool processed = false;
num sign;

List<String> parameters = [];
int counter = 0;
List<num> chords = [];
Widget displayResults;
List<num> chordLengths = [];
List<num> tangentialAngles = [];
List<num> deflectionAngles;
List<num> points = [];
List<List<dynamic>> dataRows = [];
List<String> columns = [];

num radiusValue;
num pegIntervalValue;
num chainagePiValue;
num deflectionAngleValue;
num halfDeflection;
num pointOfCommencement;
num pointOfTangency;
num tangentLength;
num lengthOfCurve;
num longChord;
num initialSubchord;
num finalSubchord;
int numberOfChords;
String direction = 'Left';
List<num> chordsProducedOffsets = [];

List<num> lengthsSetupStationToPointsOnCurve = [];
List<num> bearingsSetupStationToPointsOnCurve = [];
List<num> eastingsOfPointsOnCurve = [];
List<num> northingsOfPointsOnCurve = [];
List<num> departuresOfPointsOnCurve = [];
List<num> latitudesOfPointsOnCurve = [];
List<num> bearingsfromT1ToPointsOnCurve = [];
List<num> lengthOfTItoPointsOnCurve = [];
List<num> xS = [];
List<num> yS = [];

void computations() {}
