class StateDailyModel {
  List<StatesDaily> confirmedStateDailyList = [];
  List<StatesDaily> recoveredStateDailyList = [];
  List<StatesDaily> deceasedStateDailyList = [];

  //Storing daily cases of every state in different types of cases list.
  StateDailyModel.fromJSON(Map<String, dynamic> parsedJson) {
    List<StatesDaily> statesDailyList = [];
    for (int i = 0; i < parsedJson['states_daily'].length; i++) {
      StatesDaily statesDaily =
          StatesDaily.fromJSON(parsedJson['states_daily'][i]);
      statesDailyList.add(statesDaily);
    }
    confirmedStateDailyList.addAll(statesDailyList
        .where((element) => element.dailyDatas[32].value == 'Confirmed')
        .toList());
    recoveredStateDailyList.addAll(statesDailyList
        .where((element) => element.dailyDatas[32].value == 'Recovered')
        .toList());
    deceasedStateDailyList.addAll(statesDailyList
        .where((element) => element.dailyDatas[32].value == 'Deceased')
        .toList());
  }
}

class StatesDaily {
  List<Data> dailyDatas = [];

  StatesDaily.fromJSON(Map<String, dynamic> parsedJson) {
    parsedJson.forEach((key, value) {
      dailyDatas.add(Data(key, value));
    });
  }
}

class Data {
  String _key;
  String _value;

  Data(this._key, this._value);

  String get key => _key;

  String get value => _value;
}
