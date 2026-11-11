import 'package:project_scheduler/data/projectunit.dart';

class Dependency extends ProjectUnit {
  String name;
  String? version;
  String? link;

  Dependency(
    this.name,
    this.version,
    this.link  
  );
  Map<String, dynamic> toJson() => {
    "name": name,
    "version": version,
    "link": link
  };
  Dependency.fromJson(Map<String, dynamic> json) :
    name = json["name"],
    version = json["version"],
    link = json["link"];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dependency && runtimeType == other.runtimeType && name.trim().toLowerCase() == other.name.trim().toLowerCase());
  @override
  int get hashCode => name.trim().toLowerCase().hashCode;
}