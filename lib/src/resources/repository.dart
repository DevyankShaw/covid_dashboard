import 'dart:async';

import 'package:covid_dashboard/src/resources/state_api_provider.dart';

import '../models/item_model.dart';

class Repository {
  final statesApiProvider = StateApiProvider();

  Future<ItemModel> fetchAllStates() => statesApiProvider.fetchStateList();
}
