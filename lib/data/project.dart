import 'dart:math';
import 'package:project_scheduler/data/dependency.dart';
import 'package:project_scheduler/data/requirement.dart';

class Project {
  static final Project testProject = Project._test();

  static final Random _random = Random(DateTime.now().microsecondsSinceEpoch);
  static const int idLength = 30;
  static const String idCharList = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890";
  static final List<String> _registeredIds = List<String>.empty(growable: true);

  final List<Requirement> requirements = List<Requirement>.empty(growable: true);
  final List<Dependency> dependencies = List<Dependency>.empty(growable: true);
  final List<String> references = List<String>.empty(growable: true);
  final List<String> tools = List<String>.empty(growable: true);

  late final String projectId;
  late final DateTime timeCreated;
  late DateTime timeModified;
  String name = "Untitled project";
  String description = "A new project";


  factory Project() {
    return Project._new(_generateProjectId(), DateTime.now());
  }
  
  Project._new(this.projectId, this.timeCreated) {
    timeModified = timeCreated;
  }

  Project._test() {
    name = "Untitled Project";
    description = "Description for an untitled project";
    projectId = _generateProjectId();
    timeCreated = DateTime(2016, 7);
    timeModified = timeCreated.add(Duration(days: 500));
  }

  // factory for importing Project from Localstore

  String toReadMe() {
    throw UnimplementedError("'toReadMe' func is not implemented");
  }

  static String _generateProjectId() {
    String newProjectId;
    do { // ensure unique ID
      newProjectId = List<String>.generate(idLength, (_) => idCharList[_random.nextInt(idCharList.length)]).join("");
    } while (_registeredIds.contains(newProjectId));
    _registeredIds.add(newProjectId);
    return newProjectId;
  }
}