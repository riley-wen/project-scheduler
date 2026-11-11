import 'package:project_scheduler/data/projectunit.dart';

class Requirement extends ProjectUnit {
  String description;
  bool completed = false;
  
  Requirement(this.description);

  Map<String, dynamic> toJson() => {
    "description": description,
    "completed": completed,
  };
  Requirement.fromJson(Map<String, dynamic> json) :
  description = json["description"], 
  completed = json["completed"];
}