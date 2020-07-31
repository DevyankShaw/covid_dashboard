import 'dart:convert';

import 'package:covid_dashboard/src/models/item_model.dart';
import 'package:http/http.dart' show Client;

class StateApiProvider {
  Client client = Client();
  final _baseUrl = "https://api.covid19india.org/state_district_wise.json";

  Future<ItemModel> fetchStateList() async {
    final response = await client.get(_baseUrl);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
