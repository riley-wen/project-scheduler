import 'dart:math';

abstract class ProjectUnit {
  static final Random _random = Random(DateTime.now().microsecondsSinceEpoch);
  static const int idLength = 30;
  static const String idCharList = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890";
  static final Set<String> _registeredIds = <String>{};

  final String unitId;
  final DateTime timeCreated;
  DateTime timeModified;

  ProjectUnit() : 
    unitId = _generateUnitId(),
    timeCreated = DateTime.now(),
    timeModified = DateTime.now();
  ProjectUnit.fromJson(Map<String, dynamic> data) :
    unitId = data["unit_id"],
    timeCreated = DateTime.fromMillisecondsSinceEpoch(data["time_created"]),
    timeModified = DateTime.fromMillisecondsSinceEpoch(data["time_modified"]) {
      _registeredIds.add(unitId);
    }
  
  Map<String, dynamic> toJson() => {
    "unit_id" : unitId,
    "time_created" : timeCreated.millisecondsSinceEpoch,
    "time_modified" : timeModified.millisecondsSinceEpoch,
  };
  static String _generateUnitId() {
    String newUnitId;
    do { // ensure unique ID
      newUnitId = List<String>.generate(idLength, (_) => idCharList[_random.nextInt(idCharList.length)]).join("");
    } while (_registeredIds.contains(newUnitId));
    _registeredIds.add(newUnitId);
    return newUnitId;
  }
}