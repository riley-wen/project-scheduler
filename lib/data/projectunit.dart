import 'dart:math';

/// A unit that represents an attribute of a project.
abstract class ProjectUnit {
  static final Random _random = Random(DateTime.now().microsecondsSinceEpoch);
  static const int idLength = 30;
  static const String idCharList = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890";
  /// All registered ids for each project unit. IDs are unique among all units across all projects.
  static final Set<String> _registeredIds = <String>{};

  /// A unique identifier for a project unit. IDs are unique among all units across all projects (to avoid JSON mapping conflicts)
  final String unitId;
  final DateTime timeCreated;
  DateTime timeModified;

  // Empty constructor generates a new project unit ID instead of passing through a labeled constructor or factory, I did this because I was too lazy to figure out a different way
  ProjectUnit() : 
    unitId = _generateUnitId(),
    timeCreated = DateTime.now(),
    timeModified = DateTime.now();

  /// Loads a project unit from a provided JSON map. Should be called by classes extending [ProjectUnit] when loading from JSON.
  ProjectUnit.fromJson(Map<String, dynamic> data) :
    unitId = data["unit_id"],
    timeCreated = DateTime.fromMillisecondsSinceEpoch(data["time_created"]),
    timeModified = DateTime.fromMillisecondsSinceEpoch(data["time_modified"]) {
      _registeredIds.add(unitId);
    }
  
  /// Converts a project unit to a JSON map. Should be appended to additional JSON mapped fields when calling [toJson] from extending classes.
  Map<String, dynamic> toJson() => {
    "unit_id" : unitId,
    "time_created" : timeCreated.millisecondsSinceEpoch,
    "time_modified" : timeModified.millisecondsSinceEpoch,
  };

  /// Generates a unique unit ID among all registered IDs.
  static String _generateUnitId() {
    String newUnitId;
    do { // ensure unique ID
      newUnitId = List<String>.generate(idLength, (_) => idCharList[_random.nextInt(idCharList.length)]).join("");
    } while (_registeredIds.contains(newUnitId));
    _registeredIds.add(newUnitId);
    return newUnitId;
  }
}