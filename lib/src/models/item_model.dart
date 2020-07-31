class ItemModel {
  List<States> _states = [];

  //Parsing json response to get state name, state code and districts of each states and store them in states list
  ItemModel.fromJson(Map<String, dynamic> parsedJson) {
    List<States> temp = [];
    parsedJson.forEach((key, value) {
      String _state = key;
      String _stateCode = parsedJson[key]['statecode'];
      List<District> _districts = [];
      var jsonReference = parsedJson[key]['districtData'];
      jsonReference.forEach((key, value) {
        _districts.add(District.fromJSON(key, jsonReference[key]));
      });
      temp.add(States(_state, _districts, _stateCode));
    });
    _states = temp;
  }

  List<States> get states => _states;
}

class States {
  final String _state;
  final List<District> _districts;
  final String _stateCode;

  States(this._state, this._districts, this._stateCode);

  String get stateCode => _stateCode;

  List<District> get districts => _districts;

  String get state => _state;
}

class District {
  String _name;
  int _active;
  int _confirmed;
  int _deceased;
  Delta _delta;
  String _notes;
  int _recovered;

  District.fromJSON(String name, Map<String, dynamic> parsedJson) {
    this._name = name;
    this._active = parsedJson['active'];
    this._confirmed = parsedJson['confirmed'];
    this._deceased = parsedJson['deceased'];
    this._delta = Delta.fromJSON(parsedJson['delta']);
    this._notes = parsedJson['notes'];
    this._recovered = parsedJson['recovered'];
  }

  int get recovered => _recovered;

  String get notes => _notes;

  Delta get delta => _delta;

  int get deceased => _deceased;

  int get confirmed => _confirmed;

  int get active => _active;

  String get name => _name;
}

class Delta {
  int _confirmed;
  int _deceased;
  int _recovered;

  Delta.fromJSON(Map<String, dynamic> parsedJson) {
    this._confirmed = parsedJson['confirmed'];
    this._deceased = parsedJson['deceased'];
    this._recovered = parsedJson['recovered'];
  }

  int get confirmed => _confirmed;

  int get deceased => _deceased;

  int get recovered => _recovered;
}
