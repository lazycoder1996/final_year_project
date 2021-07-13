import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SimpleLevellingResults extends StatefulWidget {
  SimpleLevellingResults({this.remarks, this.elevation, this.title});
  final List<String> remarks;
  final List<num> elevation;
  final String title;
  @override
  _SimpleLevellingResultsState createState() => _SimpleLevellingResultsState();
}

class _SimpleLevellingResultsState extends State<SimpleLevellingResults> {
  @override
  void initState() {
    chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  TooltipBehavior _tooltipBehavior;
  List<Results> chartData = [];
  List<Results> getChartData() {
    int n = 0;
    while (n < widget.elevation.length) {
      chartData.add(Results(widget.elevation[n], widget.remarks[n]));
      n++;
    }
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SfCartesianChart(
              enableAxisAnimation: true,
              title: ChartTitle(
                  text: widget.title + ' results',
                  textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Akaya')),
              tooltipBehavior: _tooltipBehavior,
              primaryXAxis: CategoryAxis(),
              series: <ChartSeries>[
                SplineSeries<Results, String>(
                    name: 'Elevation',
                    enableTooltip: true,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    dataSource: chartData,
                    xValueMapper: (Results results, _) => results.remark,
                    yValueMapper: (Results results, _) => results.elevation)
              ]),
        ),
      ),
    );
  }
}

class Results {
  Results(this.elevation, this.remark);
  final num elevation;
  final String remark;
}
