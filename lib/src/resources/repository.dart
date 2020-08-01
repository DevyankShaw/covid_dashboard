import 'dart:async';

import 'package:covid_dashboard/src/models/state_daily_model.dart';
import 'package:covid_dashboard/src/resources/state_api_provider.dart';

import '../models/district_wise_state_model.dart';

class Repository {
  final statesApiProvider = StateApiProvider();

  Future<DistrictWiseStateModel> fetchAllStates() =>
      statesApiProvider.fetchStateList();

  Future<StateDailyModel> fetchAllStatesDaily() =>
      statesApiProvider.fetchStateDailyList();
}
