import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:localstore/localstore.dart';
import 'package:project_scheduler/data/datainfo.dart';
import 'package:project_scheduler/data/dependency.dart';
import 'package:project_scheduler/data/reference.dart';
import 'package:project_scheduler/data/requirement.dart';

class HeaderCache {
  List<Project> headerList = List<Project>.empty(growable: true);
  final _headerStream = StreamController<List<Project>>.broadcast();
  Stream<List<Project>> get headerStream => _headerStream.stream;
  late final StreamSubscription _headerSubscription;

  static final HeaderCache instance = HeaderCache._internal();

  HeaderCache._internal() {
    _headerSubscription = Localstore.instance.collection(Datainfo.projectCollectionKey).stream.listen((data) {
      Project header = Project.fromJson(data);
      headerList.removeWhere((p) => p.projectId == header.projectId);
      headerList = [...headerList, header];
      _headerStream.sink.add([...headerList]);
    });
  }

  
  void delete(String projectId) {
    Localstore.instance.collection(Datainfo.projectCollectionKey).doc(projectId).delete();
    headerList.removeWhere((p) => p.projectId == projectId);
    _headerStream.sink.add([...headerList]);
  }
  void dispose() {
    _headerSubscription.cancel();
  }
}
class Project {
  static final Project testProject = Project._test();
  
  static final Random _random = Random(DateTime.now().microsecondsSinceEpoch);
  static const int idLength = 30;
  static const String idCharList = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890";
  static final List<String> _registeredIds = List<String>.empty(growable: true);

  final List<Requirement> requirements = List<Requirement>.empty(growable: true);
  final List<Dependency> dependencies = List<Dependency>.empty(growable: true);
  final List<Reference> references = List<Reference>.empty(growable: true);

  late final String projectId;
  late final DateTime timeCreated;
  late DateTime timeModified;
  String name = "Untitled project";
  String description = "A new project";

  factory Project.create() => Project._new(_generateProjectId(), DateTime.now());

  Project();
  
  Project._new(this.projectId, this.timeCreated) {
    timeModified = timeCreated;
  }

  Project._test() {
    name = "Untitled Project";
    description = "Description for an untitled project";
    projectId = _generateProjectId();
    timeCreated = DateTime(2016, 7);
    timeModified = timeCreated.add(Duration(days: 500));
    references.add(Reference("Label1", "Reference1"));
  }

  // json constructors / funcs

  factory Project.fromJson(Map<String, dynamic> json) {
    Project proj = Project();
    proj.projectId = json["projectId"];
    proj.name = json["name"];
    proj.description = json["description"];
    proj.timeModified = DateTime.parse(json["timeModified"]);
    proj.timeCreated = DateTime.parse(json["timeCreated"]);
    return proj;
  }
  Map<String, dynamic> toJson() => {
      "projectId": projectId,
      "name": name,
      "description": description,
      "timeModified": timeModified.toIso8601String(),
      "timeCreated": timeCreated.toIso8601String()
    };
  

  static Future<List<String>> getAllIds() async 
    => Localstore.instance.collection(Datainfo.projectCollectionKey).get().then((all) => all?.keys.toList() ?? []);

  static Future<List<Project>> getProjectHeaders() async 
    => Localstore.instance.collection(Datainfo.projectCollectionKey).get().then((all) => all?.values.map(
      (data) => Project.fromJson(data as Map<String, dynamic>)).toList() ?? []);

  static Future<Project?> loadById(String id) async {
    Project? ret = await Localstore.instance.collection(Datainfo.projectCollectionKey).doc(id).get().then(
      (data) => data != null ? Project.fromJson(data) : null);
    if (ret == null) return null;
    ret._loadElements();
    return ret;
  }

  Future<Object?> saveProject() async {
    try {
      timeModified = DateTime.now();
      await Localstore.instance.collection(Datainfo.projectCollectionKey).doc(projectId).set(toJson());
      await _saveElements();
      return null;
    } catch (e) {
      return e;
    }
  }

  Future<void> _saveElements() async {
    await Localstore.instance.collection(Datainfo.dependencyCollectionKey).doc(projectId).set({
    "data" : dependencies.map((d) => d.toJson()).toList()
    });
    await Localstore.instance.collection(Datainfo.requirementCollectionKey).doc(projectId).set({
      "data" : requirements.map((d) => d.toJson()).toList()
    });
    await Localstore.instance.collection(Datainfo.referenceCollectionKey).doc(projectId).set({
      "data" : references.map((d) => d.toJson()).toList()
    });
  }
  void _loadElements() {
    Localstore.instance.collection(Datainfo.dependencyCollectionKey).doc(projectId).get().then(
      (data) {
        if(data != null && (data["data"] as List).isNotEmpty) {
          replaceDependencies((data["data"] as List).map((d) => Dependency.fromJson(d as Map<String, dynamic>)).toList());
        }
      }
    );
    Localstore.instance.collection(Datainfo.referenceCollectionKey).doc(projectId).get().then(
      (data) {
        if(data != null && (data["data"] as List).isNotEmpty) {
          replaceReferences((data["data"] as List).map((d) => Reference.fromJson(d as Map<String, dynamic>)).toList());
        }
      }
    );
    Localstore.instance.collection(Datainfo.requirementCollectionKey).doc(projectId).get().then(
      (data) {
        if(data != null && (data["data"] as List).isNotEmpty) {
          replaceRequirements((data["data"] as List).map((d) => Requirement.fromJson(d as Map<String, dynamic>)).toList());
        }
      }
    );
  }

  void replaceRequirements(List<Requirement> res) => requirements.replaceRange(0, requirements.length, res);
  void replaceDependencies(List<Dependency> res) => dependencies.replaceRange(0, dependencies.length, res);
  void replaceReferences(List<Reference> res) => references.replaceRange(0, references.length, res);
  

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

  @override
  String toString() {
    return """
      Project '$name' (${projectId})\n
      Description: $description\n
      Requirements: ${requirements.map((e) => e.description).join(", ")}\n
      References: ${references.map((e) => "${e.label}: ${e.reference}").join(", ")}\n
      Dependencies: ${dependencies.map((e) => "${e.name} (${e.version}): ${e.link}").join(", ")}\n
      """;
  }
}
