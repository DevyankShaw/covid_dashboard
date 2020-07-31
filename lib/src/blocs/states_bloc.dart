import 'package:rxdart/rxdart.dart';

import '../models/item_model.dart';
import '../resources/repository.dart';

class StatesBloc {
  final _repository = Repository();
  final _statesFetcher = PublishSubject<ItemModel>();

  Stream<ItemModel> get allStates => _statesFetcher.stream;

  fetchAllStates() async {
    ItemModel itemModel = await _repository.fetchAllStates();
    _statesFetcher.sink.add(itemModel);
  }

  dispose() {
    _statesFetcher.close();
  }
}

final bloc = StatesBloc();
