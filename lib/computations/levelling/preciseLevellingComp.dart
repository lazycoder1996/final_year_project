preciseLevelling(List<List<dynamic>> levelData, initialValues) {
  DateTime startTime = DateTime.now();
  var headers = levelData[0].map((e) {
    return e.toString();
  }).toList();
  // Extracting data
  var upperReading = headers.indexOf(initialValues['upperStadia']);
  var middleReading = headers.indexOf(initialValues['middleStadia']);
  var lowerReading = headers.indexOf(initialValues['lowerStadia']);
  var digitalReading = headers.indexOf(initialValues['digitalReading']);
  var benchmark = headers.indexOf(initialValues['benchmarkValue']);
  print('middle is $middleReading');
  // Computing X
  levelData[0].insert(5, 'X');
  for (var i in levelData.sublist(1)) {
    i.insert(
        5,
        ((double.parse(i[upperReading].toString()) +
                    double.parse(i[lowerReading].toString())) /
                2)
            .toStringAsFixed(3));
  }
  // 'bs,fs,u,m,l,x,d'
  // Computing C values
  levelData[0].insert(7, 'C');
  for (var i in levelData.sublist(1)) {
    i.insert(
        7,
        ((double.parse(i[middleReading].toString()) +
                    double.parse(i[5].toString()) +
                    double.parse(i[digitalReading + 1].toString())) /
                3)
            .toStringAsFixed(3));
  }
  // Computing rise and fall
  levelData[0].insert(8, 'Rise or Fall');
  try {
    for (var i = 1; i <= levelData.length; i = i + 2) {
      var rise =
          double.parse(levelData[i][7]) - double.parse(levelData[i + 1][7]);
      levelData[i + 1].insert(8, rise.toStringAsFixed(3));
      levelData[i].insert(8, '');
    }
    // ignore: empty_catches
  } catch (d) {}
  double reducedLevel;
  levelData[0].insert(9, 'Reduced Level');
  levelData[1].insert(9, double.parse(levelData[1][benchmark + 3].toString()));
  try {
    for (var a = 2; a <= levelData.length; a = a + 2) {
      if (a == 2) {
        levelData[a + 1].add('');
        reducedLevel = double.parse(levelData[a - 1][9].toString()) +
            double.parse(levelData[a][8].toString());
        levelData[a].insert(9, reducedLevel.toStringAsFixed(3));
      }
      if (a % 2 == 0 && a != 2) {
        if (a != levelData.length - 1) levelData[a + 1].add('');
        reducedLevel = double.parse(levelData[a - 2][9].toString()) +
            double.parse(levelData[a][8].toString());
        levelData[a].insert(9, reducedLevel.toStringAsFixed(3));
      }
    }
    // ignore: empty_catches
  } catch (e) {}
  print('result is $levelData');
  List reportBM = [];
  int n = 0;
  for (var i = 1; i < levelData[0].length; i++) {
    if (levelData[i].last != '') {
      reportBM.add('-   ${levelData[i].first} (${levelData[i].last})');
    }
  }
  String benchmarksIdentified = reportBM.join("\r\n");

  DateTime endTime = DateTime.now();
  DateTime duration = DateTime.fromMillisecondsSinceEpoch(
      endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch);

  return [
    levelData,
    {
      'duration': duration.millisecond,
      'Benchmarks identified': benchmarksIdentified,
      'last bm': levelData.last[1].toString(),
      'true final IRL': levelData[1].last.toString(),
      'comp final IRL': levelData.last[9].toString(),
      'Project Misclosue':
          (num.parse(levelData.last[9]) - levelData[1].last).toStringAsFixed(3),
    }
  ];
}
