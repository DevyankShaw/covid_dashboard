import 'package:covid_dashboard/src/blocs/state_bloc.dart';
import 'package:covid_dashboard/src/models/district_wise_state_model.dart';
import 'package:covid_dashboard/src/ui/state_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class StateList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StateListState();
}

class StateListState extends State<StateList> {
  @override
  void initState() {
    checkPermission();
    bloc.fetchAllStates();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Future<void> checkPermission() async {
    bool checkMediaPermission = await Permission.storage.request().isGranted;
    if (checkMediaPermission) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: StreamBuilder(
        stream: bloc.allStates,
        builder: (context, AsyncSnapshot<DistrictWiseStateModel> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildList(AsyncSnapshot<DistrictWiseStateModel> snapshot) {
    return ListView.builder(
        padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        itemCount: snapshot.data.states.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(bottom: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 0.0), //(x,y)
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: Material(
              borderRadius: BorderRadius.circular(25.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(25.0),
                onTap: () => openDetailPage(snapshot.data, index),
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        snapshot.data.states[index].state,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.aBeeZee(
                            fontWeight: FontWeight.w600, fontSize: 15.0),
                      ),
                      SizedBox(height: 2.0),
                      GridView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 15 / 4),
                        children: <Widget>[
                          CardSummary(
                              data: totalCase(
                                  snapshot.data.states[index], 'Confirmed'),
                              caseType: 'Confirmed'),
                          CardSummary(
                              data: totalCase(
                                  snapshot.data.states[index], 'Active'),
                              caseType: 'Active'),
                          CardSummary(
                              data: totalCase(
                                  snapshot.data.states[index], 'Recovered'),
                              caseType: 'Recovered'),
                          CardSummary(
                              data: totalCase(
                                  snapshot.data.states[index], 'Deceased'),
                              caseType: 'Deceased'),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  openDetailPage(DistrictWiseStateModel data, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return StateDetail(
          state: data.states[index].state,
          stateCode: data.states[index].stateCode,
          confirmed: totalCase(data.states[index], 'Confirmed'),
          active: totalCase(data.states[index], 'Active'),
          recovered: totalCase(data.states[index], 'Recovered'),
          deceased: totalCase(data.states[index], 'Deceased'),
          districts: data.states[index].districts,
        );
      }),
    );
  }

  // Calculating total cases for each type for each state
  String totalCase(States state, String caseType) {
    if (caseType == 'Confirmed') {
      return state.districts
          .fold(
              0, (previousValue, element) => previousValue + element.confirmed)
          .toString();
    } else if (caseType == 'Active') {
      return state.districts
          .fold(0, (previousValue, element) => previousValue + element.active)
          .toString();
    } else if (caseType == 'Recovered') {
      return state.districts
          .fold(
              0, (previousValue, element) => previousValue + element.recovered)
          .toString();
    } else {
      return state.districts
          .fold(0, (previousValue, element) => previousValue + element.deceased)
          .toString();
    }
  }
}

class CardSummary extends StatelessWidget {
  final String caseType;
  final String data;

  CardSummary({@required this.caseType, @required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          data,
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        Text(caseType)
      ],
    );
  }
}
