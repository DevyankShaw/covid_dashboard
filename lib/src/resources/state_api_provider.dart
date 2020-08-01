import 'dart:convert';

import 'package:covid_dashboard/src/models/district_wise_state_model.dart';
import 'package:covid_dashboard/src/models/state_daily_model.dart';
import 'package:http/http.dart' show Client;

class StateApiProvider {
  Client client = Client();
  final _baseUrl = "https://api.covid19india.org";

  Future<DistrictWiseStateModel> fetchStateList() async {
    final response = await client.get('$_baseUrl/state_district_wise.json');
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return DistrictWiseStateModel.fromJSON(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<StateDailyModel> fetchStateDailyList() async {
    final response = await client.get('$_baseUrl/states_daily.json');
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return StateDailyModel.fromJSON(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
