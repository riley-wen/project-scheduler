import 'package:project_scheduler/data/project_unit.dart';

/// A requirement of the project describes a task that needs to be fulfilled for the project.
class Requirement extends ProjectUnit {
  String description;
  bool completed = false;
  
  Requirement(this.description);

  @override
  Map<String, dynamic> toJson() => super.toJson()..addAll({
    "description": description,
    "completed": completed,
  });

  Requirement.fromJson(super.json) :
    description = json["description"], 
    completed = json["completed"],
    super.fromJson();
}