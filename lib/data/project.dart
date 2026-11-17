import 'dart:async';
import 'dart:math';
import 'package:localstore/localstore.dart';
import 'package:project_scheduler/data/datainfo.dart';
import 'package:project_scheduler/data/dependency.dart';
import 'package:project_scheduler/data/projectunit.dart';
import 'package:project_scheduler/data/reference.dart';
import 'package:project_scheduler/data/requirement.dart';

/// HeaderCache is a singleton pattern class that stores a running list of basic project information
/// for each of the user's locally stored projects.
/// 
/// Project headers are automatically loaded on class initialization and listens for newly saved or edited projects.
/// When deleting a project, call [HeaderCache.delete] instead of [DocumentRef.delete] so that project header changes can be tracked over time.
class HeaderCache {
  /// The header list is a running list that keeps track of the basic information of each project
  /// without importing project units (references, dependencies, requirements).
  List<Project> headerList = List<Project>.empty(growable: true);

  /// Subscribes to a Localstore stream to listen for incoming project headers.
  final _headerStream = StreamController<List<Project>>.broadcast();
  Stream<List<Project>> get headerStream => _headerStream.stream;
  late final StreamSubscription _headerSubscription;

  /// Publicly exposed singleton instance, keeps track of all project headers in real-time.
  static final HeaderCache instance = HeaderCache._internal();

  /// Initializes the singleton instance and subscribes to the Localstore stream.
  /// Since project headers do not include project units, only the [Datainfo.projectCollectionKey] needs to be subscribed to.
  HeaderCache._internal() {
    _headerSubscription = Localstore.instance.collection(Datainfo.projectCollectionKey).stream.listen((data) {
      Project header = Project.fromJson(data);
      headerList.removeWhere((p) => p.projectId == header.projectId);
      headerList = [...headerList, header];
      _headerStream.sink.add([...headerList]);
    });
  }

  /// Deletes a project from locally stored data and records changes in [HeaderCache.headerList]
  void delete(String projectId) {
    Localstore.instance.collection(Datainfo.projectCollectionKey).doc(projectId).delete();
    headerList.removeWhere((p) => p.projectId == projectId);
    _headerStream.sink.add([...headerList]);
  }

  void dispose() {
    _headerSubscription.cancel();
  }
}
/// A container for project information and related project units.
/// 
/// A project header is a [Project] object without the [Project.requirements], [Project.dependencies], or [Project.references] loaded from local data,
/// making a header a basic overview of a project's information rather than the representative object.
class Project {  
  static final Random _random = Random(DateTime.now().microsecondsSinceEpoch);
  static const int idLength = 30;
  static const String idCharList = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890";
  /// Keeps track of all project IDs generated or loaded during runtime. Since the project ID is used to track the locally stored save of each project,
  /// this list makes sure that generated IDs do not collide with duplicates.
  /// 
  /// There is a known vulnerability that generated IDs can collide with loaded project IDs if generation occurs before project creation, however
  /// this is a very minimal chance due to the event's sheer improbability.
  static final Set<String> _registeredIds = <String>{};

  /// Keeps track of all [Requirement] objects tied to the project.
  final List<Requirement> requirements = List<Requirement>.empty(growable: true);
  /// Keeps track of all [Dependency] objects tied to the project.
  final List<Dependency> dependencies = List<Dependency>.empty(growable: true);
  /// Keeps track of all [Reference] objects tied to the project.
  final List<Reference> references = List<Reference>.empty(growable: true);

  /// Unique identification string to represent a project, always generated internally or loaded from local data.
  late final String projectId;
  /// Time created of the project.
  late final DateTime timeCreated;
  /// Last time modified of the project.
  late DateTime timeModified;
  /// Name of the project.
  String name = "Untitled project";
  /// Description of the project.
  String description = "A new project";

  /// Generates a new empty and untitled project with a unique ID and recorded creation time.
  factory Project.create() => Project._new(_generateProjectId(), DateTime.now());

  /// Empty initialization of a [Project] object without ID or times, only used internally for [Project.fromJson]
  Project._empty();
  
  Project._new(this.projectId, this.timeCreated) {
    timeModified = timeCreated;
  }
  
  /// Loads a project from a JSON map.
  /// 
  /// @param json The JSON map, must include the fields "project_id", "name", "description", "time_modified", "time_created".
  /// Does not load any related [ProjectUnit]s from local data.
  factory Project.fromJson(Map<String, dynamic> json) {
    Project proj = Project._empty();
    proj.projectId = json["project_id"];
    proj.name = json["name"];
    proj.description = json["description"];
    proj.timeModified = DateTime.parse(json["time_modified"]);
    proj.timeCreated = DateTime.parse(json["time_created"]);
    _registeredIds.add(proj.projectId);
    return proj;
  }

  /// Generates a JSON map from an existing project. Map does not include project units, only surface information.
  Map<String, dynamic> toJson() => {
      "project_id": projectId,
      "name": name,
      "description": description,
      "time_modified": timeModified.toIso8601String(),
      "time_created": timeCreated.toIso8601String()
    };
  
  /// Removes a [ProjectUnit] from the matching array.
  /// 
  /// @param unit The project unit to be removed.
  /// @returns null if the unit was successfully detected as a valid unit, an error message otherwise.
  String? removeUnit(ProjectUnit unit) {
    if (unit is Reference) {
      references.removeWhere((u) => u.unitId == unit.unitId);
    } else if (unit is Requirement) {
      requirements.removeWhere((u) => u.unitId == unit.unitId);
    } else if (unit is Dependency) {
      dependencies.removeWhere((u) => u.unitId == unit.unitId);
    } else {
      return "Error: Could not detect unit type";
    }
    return null;
  }

  /// Returns a future that contains a list of all locally stored project IDs.
  /// 
  /// @returns A future that leads to a list of all locally stored project IDs.
  static Future<List<String>> getAllIds() async 
    => Localstore.instance.collection(Datainfo.projectCollectionKey).get().then((all) => all?.keys.toList() ?? []);

  /// Returns a future that contains a list of all locally stored project headers.
  /// 
  /// @returns A future that leads to a list of all locally stored project headers,
  static Future<List<Project>> getProjectHeaders() async 
    => Localstore.instance.collection(Datainfo.projectCollectionKey).get().then((all) => all?.values.map(
      (data) => Project.fromJson(data as Map<String, dynamic>)).toList() ?? []);

  /// Loads a project header by string ID. Automatically loads all associated project units as well.
  /// 
  /// @param id The ID that corresponds to the locally stored project header.
  /// 
  /// @returns A future that leads to the corresponding project and included elements, null if not existing.
  static Future<Project?> loadById(String id) async {
    Project? ret = await Localstore.instance.collection(Datainfo.projectCollectionKey).doc(id).get().then(
      (data) => data != null ? Project.fromJson(data) : null);
    if (ret == null) return null;
    await ret._loadElements();
    return ret;
  }

  /// Saves a project (including project units) into local data.
  /// 
  /// @returns null if successful, an error object if an error was thrown.
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

  /// Saves all project units in their corresponding files.
  Future<void> _saveElements() async {
    await Localstore.instance.collection(Datainfo.dependencyCollectionKey).doc(projectId).set({
      "last_saved" : DateTime.now().millisecondsSinceEpoch,
      "data" : {for (Dependency item in dependencies) item.unitId : item.toJson()}
    });
    await Localstore.instance.collection(Datainfo.requirementCollectionKey).doc(projectId).set({
      "last_saved" : DateTime.now().millisecondsSinceEpoch,
      "data" : {for (Requirement item in requirements) item.unitId : item.toJson()}
    });
    await Localstore.instance.collection(Datainfo.referenceCollectionKey).doc(projectId).set({
      "last_saved" : DateTime.now().millisecondsSinceEpoch,
      "data" : {for (Reference item in references) item.unitId : item.toJson()}
    });
  }

  /// Loads all project unit lists in the project with all retrieved units related to the project's ID.
  Future<void> _loadElements() async {
    await Localstore.instance.collection(Datainfo.dependencyCollectionKey).doc(projectId).get().then(
      (data) {
        if(data != null && (data["data"] as Map).isNotEmpty) {
          replaceDependencies((data["data"] as Map).values.map((d) => Dependency.fromJson(d as Map<String, dynamic>)).toList());
        }
      }
    );
    await Localstore.instance.collection(Datainfo.referenceCollectionKey).doc(projectId).get().then(
      (data) {
        if(data != null && (data["data"] as Map).isNotEmpty) {
          replaceReferences((data["data"] as Map).values.map((d) => Reference.fromJson(d as Map<String, dynamic>)).toList());
        }
      }
    );
    await Localstore.instance.collection(Datainfo.requirementCollectionKey).doc(projectId).get().then(
      (data) {
        if(data != null && (data["data"] as Map).isNotEmpty) {
          replaceRequirements((data["data"] as Map).values.map((d) => Requirement.fromJson(d as Map<String, dynamic>)).toList());
        }
      }
    );
  }

  /// Replaces the requirements list with the provided array.
  /// 
  /// @param res The replacement list
  void replaceRequirements(List<Requirement> res) => requirements.replaceRange(0, requirements.length, res);
  /// Replaces the dependencies list with the provided array.
  /// 
  /// @param res The replacement list
  void replaceDependencies(List<Dependency> res) => dependencies.replaceRange(0, dependencies.length, res);
  /// Replaces the references list with the provided array.
  /// 
  /// @param res The replacement list
  void replaceReferences(List<Reference> res) => references.replaceRange(0, references.length, res);

  /// Generates a unique ID string among all registered project IDs and then registers it as a used ID.
  /// 
  /// @returns The generated ID
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
      Project '$name' ($projectId)\n
      Description: $description\n
      Requirements: ${requirements.map((e) => e.description).join(", ")}\n
      References: ${references.map((e) => "${e.label}: ${e.reference}").join(", ")}\n
      Dependencies: ${dependencies.map((e) => "${e.name} (${e.version}): ${e.link}").join(", ")}\n
      """;
  }
}
