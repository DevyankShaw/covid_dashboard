import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid_dashboard/src/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StateDetail extends StatefulWidget {
  final String state;
  final String confirmed;
  final String active;
  final String recovered;
  final String deceased;
  final List<District> districts;

  StateDetail(
      {this.state,
      this.confirmed,
      this.active,
      this.recovered,
      this.deceased,
      this.districts});

  @override
  _StateDetailState createState() => _StateDetailState();
}

class _StateDetailState extends State<StateDetail> {
  List<charts.Series<Data, String>> _seriesPieData;
  List<charts.Series<Data, String>> _seriesLegendData;

  @override
  void initState() {
    super.initState();
    print(widget.districts.length);
    _seriesPieData = List<charts.Series<Data, String>>();
    _seriesLegendData = List<charts.Series<Data, String>>();
    _generateData();
  }

  void _generateData() {
    var pieData = [
      Data(
          name: 'Confirmed',
          value: num.parse(widget.confirmed),
          colorValue: Colors.red.shade400),
      Data(
          name: 'Active',
          value: num.parse(widget.active),
          colorValue: Colors.blue.shade400),
      Data(
          name: 'Recovered',
          value: num.parse(widget.recovered),
          colorValue: Colors.green.shade400),
      Data(
          name: 'Deceased',
          value: num.parse(widget.deceased),
          colorValue: Colors.grey.shade400),
    ];

    _seriesPieData.add(
      charts.Series(
        domainFn: (Data data, _) => data.name,
        measureFn: (Data data, _) => data.value,
        colorFn: (Data data, _) =>
            charts.ColorUtil.fromDartColor(data.colorValue),
        id: 'Total Cases',
        data: pieData,
        labelAccessorFn: (Data row, _) => '${row.value}',
      ),
    );

    List<Data> confirmedCases = [];

    widget.districts.forEach((element) {
      confirmedCases.add(Data(
        name: element.name,
        value: element.confirmed,
        colorValue: Colors.red.shade400,
      ));
    });

    List<Data> activeCases = [];

    widget.districts.forEach((element) {
      activeCases.add(Data(
        name: element.name,
        value: element.active,
        colorValue: Colors.blue.shade400,
      ));
    });

    List<Data> recoveredCases = [];

    widget.districts.forEach((element) {
      recoveredCases.add(Data(
        name: element.name,
        value: element.recovered,
        colorValue: Colors.green.shade400,
      ));
    });

    List<Data> deceasedCases = [];

    widget.districts.forEach((element) {
      deceasedCases.add(Data(
        name: element.name,
        value: element.deceased,
        colorValue: Colors.grey.shade400,
      ));
    });

    _seriesLegendData = [
      new charts.Series<Data, String>(
        id: 'Confirmed',
        data: confirmedCases,
        domainFn: (Data data, _) => data.name,
        measureFn: (Data data, _) => data.value,
        colorFn: (Data data, _) =>
            charts.ColorUtil.fromDartColor(data.colorValue),
        labelAccessorFn: (Data row, _) => '${row.value}',
      ),
      new charts.Series<Data, String>(
        id: 'Active',
        data: activeCases,
        domainFn: (Data data, _) => data.name,
        measureFn: (Data data, _) => data.value,
        colorFn: (Data data, _) =>
            charts.ColorUtil.fromDartColor(data.colorValue),
        labelAccessorFn: (Data row, _) => '${row.value}',
      ),
      new charts.Series<Data, String>(
        id: 'Recovered',
        data: recoveredCases,
        domainFn: (Data data, _) => data.name,
        measureFn: (Data data, _) => data.value,
        colorFn: (Data data, _) =>
            charts.ColorUtil.fromDartColor(data.colorValue),
        labelAccessorFn: (Data row, _) => '${row.value}',
      ),
      new charts.Series<Data, String>(
        id: 'Deceased',
        data: deceasedCases,
        domainFn: (Data data, _) => data.name,
        measureFn: (Data data, _) => data.value,
        colorFn: (Data data, _) =>
            charts.ColorUtil.fromDartColor(data.colorValue),
        labelAccessorFn: (Data row, _) => '${row.value}',
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
                text: 'Legend',
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
            Legend(widget: widget, seriesLegend: _seriesLegendData),
            Container(),
          ],
        ),
      ),
    );
  }
}

class Legend extends StatelessWidget {
  const Legend({
    Key key,
    @required this.widget,
    @required List<charts.Series<Data, String>> seriesLegend,
  })  : _seriesLegend = seriesLegend,
        super(key: key);

  final StateDetail widget;
  final List<charts.Series<Data, String>> _seriesLegend;

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
            width: 500.0,
            height: 500.0,
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
    @required List<charts.Series<Data, String>> seriesPieData,
  })  : _seriesPieData = seriesPieData,
        super(key: key);

  final StateDetail widget;
  final List<charts.Series<Data, String>> _seriesPieData;

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
            width: 500.0,
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

class Data {
  String name;
  num value;
  Color colorValue;

  Data({@required this.name, @required this.value, @required this.colorValue});
}
