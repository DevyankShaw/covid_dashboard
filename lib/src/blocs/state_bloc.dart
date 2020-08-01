import 'package:rxdart/rxdart.dart';

import '../models/district_wise_state_model.dart';
import '../resources/repository.dart';

class StatesBloc {
  final _repository = Repository();
  final _statesFetcher = PublishSubject<DistrictWiseStateModel>();

  Stream<DistrictWiseStateModel> get allStates => _statesFetcher.stream;

  fetchAllStates() async {
    DistrictWiseStateModel districtWiseStateModel =
        await _repository.fetchAllStates();
    _statesFetcher.sink.add(districtWiseStateModel);
  }

  dispose() {
    _statesFetcher.close();
  }
}

final bloc = StatesBloc();
