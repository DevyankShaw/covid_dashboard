import 'dart:async';

import 'package:covid_dashboard/src/models/state_daily_model.dart';
import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';

class StatesDetailBloc {
  final _repository = Repository();
  final _stateDetailFetcher = BehaviorSubject<StateDailyModel>();

  Stream<StateDailyModel> get allStatesDaily => _stateDetailFetcher.stream;

  fetchAllStatesDaily() async {
    StateDailyModel stateDailyModel = await _repository.fetchAllStatesDaily();
    _stateDetailFetcher.sink.add(stateDailyModel);
  }

  dispose() {
    _stateDetailFetcher.close();
  }
}

final bloc = StatesDetailBloc();
