import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid_dashboard/src/blocs/state_detail_bloc.dart';
import 'package:covid_dashboard/src/models/district_wise_state_model.dart';
import 'package:covid_dashboard/src/models/state_daily_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StateDetail extends StatefulWidget {
  final String state;
  final String stateCode;
  final String confirmed;
  final String active;
  final String recovered;
  final String deceased;
  final List<District> districts;

  StateDetail(
      {this.state,
      this.stateCode,
      this.confirmed,
      this.active,
      this.recovered,
      this.deceased,
      this.districts});

  @override
  _StateDetailState createState() => _StateDetailState();
}

class _StateDetailState extends State<StateDetail> {
  List<charts.Series<PieBarData, String>> _seriesPieData;
  List<charts.Series<PieBarData, String>> _seriesBarData;

  @override
  void initState() {
    super.initState();
    bloc.fetchAllStatesDaily();
    _seriesPieData = List<charts.Series<PieBarData, String>>();
    _seriesBarData = List<charts.Series<PieBarData, String>>();
    _generatePieBarData();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  void _generatePieBarData() {
    //Pie Data
    var pieData = [
      PieBarData(
          name: 'Confirmed',
          value: num.parse(widget.confirmed),
          colorValue: Colors.red.shade400),
      PieBarData(
          name: 'Active',
          value: num.parse(widget.active),
          colorValue: Colors.blue.shade400),
      PieBarData(
          name: 'Recovered',
          value: num.parse(widget.recovered),
          colorValue: Colors.green.shade400),
      PieBarData(
          name: 'Deceased',
          value: num.parse(widget.deceased),
          colorValue: Colors.grey.shade400),
    ];

    _seriesPieData.add(
      charts.Series(
        domainFn: (PieBarData data, _) => data.name,
        measureFn: (PieBarData data, _) => data.value,
        colorFn: (PieBarData data, _) =>
            charts.ColorUtil.fromDartColor(data.colorValue),
        id: 'Total Cases',
        data: pieData,
        labelAccessorFn: (PieBarData row, _) => '${row.value}',
      ),
    );

    //Bar Data
    List<PieBarData> confirmedCases = [];

    widget.districts.forEach((element) {
      confirmedCases.add(PieBarData(
        name: element.name,
        value: element.confirmed,
        colorValue: Colors.red.shade400,
      ));
    });

    List<PieBarData> activeCases = [];

    widget.districts.forEach((element) {
      activeCases.add(PieBarData(
        name: element.name,
        value: element.active,
        colorValue: Colors.blue.shade400,
      ));
    });

    List<PieBarData> recoveredCases = [];

    widget.districts.forEach((element) {
      recoveredCases.add(PieBarData(
        name: element.name,
        value: element.recovered,
        colorValue: Colors.green.shade400,
      ));
    });

    List<PieBarData> deceasedCases = [];

    widget.districts.forEach((element) {
      deceasedCases.add(PieBarData(
        name: element.name,
        value: element.deceased,
        colorValue: Colors.grey.shade400,
      ));
    });

    _seriesBarData = [
      new charts.Series<PieBarData, String>(
        id: 'Confirmed',
        data: confirmedCases,
        domainFn: (PieBarData data, _) => data.name,
        measureFn: (PieBarData data, _) => data.value,
        colorFn: (PieBarData data, _) =>
            charts.ColorUtil.fromDartColor(data.colorValue),
        labelAccessorFn: (PieBarData row, _) => '${row.value}',
      ),
      new charts.Series<PieBarData, String>(
        id: 'Active',
        data: activeCases,
        domainFn: (PieBarData data, _) => data.name,
        measureFn: (PieBarData data, _) => data.value,
        colorFn: (PieBarData data, _) =>
            charts.ColorUtil.fromDartColor(data.colorValue),
        labelAccessorFn: (PieBarData row, _) => '${row.value}',
      ),
      new charts.Series<PieBarData, String>(
        id: 'Recovered',
        data: recoveredCases,
        domainFn: (PieBarData data, _) => data.name,
        measureFn: (PieBarData data, _) => data.value,
        colorFn: (PieBarData data, _) =>
            charts.ColorUtil.fromDartColor(data.colorValue),
        labelAccessorFn: (PieBarData row, _) => '${row.value}',
      ),
      new charts.Series<PieBarData, String>(
        id: 'Deceased',
        data: deceasedCases,
        domainFn: (PieBarData data, _) => data.name,
        measureFn: (PieBarData data, _) => data.value,
        colorFn: (PieBarData data, _) =>
            charts.ColorUtil.fromDartColor(data.colorValue),
        labelAccessorFn: (PieBarData row, _) => '${row.value}',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('State Details'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(FontAwesomeIcons.chartPie),
                text: 'Pie Chart',
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.chartBar),
                text: 'Bar Chart',
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.chartLine),
                text: 'Line Chart',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            PieChart(widget: widget, seriesPieData: _seriesPieData),
            BarChart(widget: widget, seriesLegend: _seriesBarData),
            LineChart(widget: widget),
          ],
        ),
      ),
    );
  }
}

class LineChart extends StatefulWidget {
  final StateDetail widget;

  LineChart({@required this.widget});

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  List<charts.Series<LineData, int>> _seriesLineData;

  @override
  void initState() {
    _seriesLineData = List<charts.Series<LineData, int>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.allStatesDaily,
      builder: (context, AsyncSnapshot<StateDailyModel> snapshot) {
        if (snapshot.hasData) {
          return buildLineChart(snapshot, context);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildLineChart(
      AsyncSnapshot<StateDailyModel> snapshot, BuildContext context) {
    _generateLineData(snapshot);

    final customTickFormatter =
        charts.BasicNumericTickFormatterSpec((num value) {
      if (value < snapshot.data.confirmedStateDailyList.length)
        return snapshot
            .data.confirmedStateDailyList[value.toInt()].dailyDatas[7].value;
      else
        return snapshot
            .data
            .confirmedStateDailyList[
                snapshot.data.confirmedStateDailyList.length - 1]
            .dailyDatas[7]
            .value;
    });

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            'Daily Cases Of ${widget.widget.state}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.solid,
              decorationThickness: 1.2,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Container(
            height: MediaQuery.of(context).size.height - 260.0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: snapshot.data.confirmedStateDailyList.length * 10.0,
                padding: EdgeInsets.all(10.0),
                child: charts.LineChart(
                  _seriesLineData,
                  defaultRenderer: charts.LineRendererConfig(includeArea: true),
                  animate: true,
                  domainAxis: charts.NumericAxisSpec(
                    tickFormatterSpec: customTickFormatter,
                  ),
                  behaviors: [
                    charts.SeriesLegend(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _generateLineData(AsyncSnapshot<StateDailyModel> snapshot) {
    List<LineData> confirmedDailyCases = [];

    snapshot.data.confirmedStateDailyList.forEach((element) {
      confirmedDailyCases.add(LineData(
          year: snapshot.data.confirmedStateDailyList.indexOf(element),
          cases: num.parse(element.dailyDatas
              .singleWhere((element) =>
                  element.key.toLowerCase() ==
                  widget.widget.stateCode.toLowerCase())
              .value),
          colorValue: Colors.red.shade400));
    });

    List<LineData> recoveredDailyCases = [];

    snapshot.data.recoveredStateDailyList.forEach((element) {
      recoveredDailyCases.add(LineData(
          year: snapshot.data.recoveredStateDailyList.indexOf(element),
          cases: num.parse(element.dailyDatas
              .singleWhere((element) =>
                  element.key.toLowerCase() ==
                  widget.widget.stateCode.toLowerCase())
              .value),
          colorValue: Colors.green.shade400));
    });

    List<LineData> deceasedDailyCases = [];

    snapshot.data.deceasedStateDailyList.forEach((element) {
      deceasedDailyCases.add(LineData(
          year: snapshot.data.deceasedStateDailyList.indexOf(element),
          cases: num.parse(element.dailyDatas
              .singleWhere((element) =>
                  element.key.toLowerCase() ==
                  widget.widget.stateCode.toLowerCase())
              .value),
          colorValue: Colors.grey.shade400));
    });

    _seriesLineData = [
      charts.Series<LineData, int>(
        id: 'Confirmed',
        data: confirmedDailyCases,
        domainFn: (LineData data, _) => data.year,
        measureFn: (LineData data, _) => data.cases,
        colorFn: (LineData data, _) =>
            charts.ColorUtil.fromDartColor(data.colorValue),
        labelAccessorFn: (LineData row, _) => '${row.cases}',
      ),
      charts.Series<LineData, int>(
        id: 'Recovered',
        data: recoveredDailyCases,
        domainFn: (LineData data, _) => data.year,
        measureFn: (LineData data, _) => data.cases,
        colorFn: (LineData data, _) =>
            charts.ColorUtil.fromDartColor(data.colorValue),
        labelAccessorFn: (LineData row, _) => '${row.cases}',
      ),
      charts.Series<LineData, int>(
        id: 'Deceased',
        data: deceasedDailyCases,
        domainFn: (LineData data, _) => data.year,
        measureFn: (LineData data, _) => data.cases,
        colorFn: (LineData data, _) =>
            charts.ColorUtil.fromDartColor(data.colorValue),
        labelAccessorFn: (LineData row, _) => '${row.cases}',
      ),
    ];
  }
}

class BarChart extends StatelessWidget {
  const BarChart({
    Key key,
    @required this.widget,
    @required List<charts.Series<PieBarData, String>> seriesLegend,
  })  : _seriesLegend = seriesLegend,
        super(key: key);

  final StateDetail widget;
  final List<charts.Series<PieBarData, String>> _seriesLegend;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            'Cities Of ${widget.state}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.solid,
              decorationThickness: 1.2,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Container(
            height: MediaQuery.of(context).size.height - 260.0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: widget.districts.length * 200.0,
                child: charts.BarChart(
                  _seriesLegend,
                  animate: true,
                  barGroupingType: charts.BarGroupingType.grouped,
                  behaviors: [
                    charts.SeriesLegend(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PieChart extends StatelessWidget {
  const PieChart({
    Key key,
    @required this.widget,
    @required List<charts.Series<PieBarData, String>> seriesPieData,
  })  : _seriesPieData = seriesPieData,
        super(key: key);

  final StateDetail widget;
  final List<charts.Series<PieBarData, String>> _seriesPieData;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            widget.state,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.solid,
              decorationThickness: 1.2,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Container(
            height: 500.0,
            child: charts.PieChart(_seriesPieData,
                animate: true,
                animationDuration: Duration(seconds: 5),
                behaviors: [
                  charts.DatumLegend(
                    outsideJustification: charts.OutsideJustification.end,
                    insideJustification: charts.InsideJustification.topStart,
                    horizontalFirst: false,
                    desiredMaxRows: 2,
                    cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
                    entryTextStyle: charts.TextStyleSpec(
                        color: charts.MaterialPalette.black,
                        fontFamily: 'Georgia',
                        fontSize: 11),
                  )
                ],
                defaultRenderer: charts.ArcRendererConfig(
                    arcWidth: 100,
                    arcRendererDecorators: [
                      charts.ArcLabelDecorator(
                        labelPosition: charts.ArcLabelPosition.auto,
                      )
                    ])),
          ),
        ],
      ),
    );
  }
}

class PieBarData {
  String name;
  num value;
  Color colorValue;

  PieBarData(
      {@required this.name, @required this.value, @required this.colorValue});
}

class LineData {
  final int year;
  final int cases;
  Color colorValue;

  LineData(
      {@required this.year, @required this.cases, @required this.colorValue});
}
