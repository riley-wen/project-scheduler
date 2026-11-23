import 'package:project_scheduler/data/project_unit.dart';

/// A dependency is an external resource that the project depends on in order to function.
class Dependency extends ProjectUnit {
  String name;
  String? version;
  /// The link to where the resource is hosted or its documentation, if applicable.
  String? link;

  Dependency(
    this.name,
    this.version,
    this.link  
  );

  @override
  Map<String, dynamic> toJson() => super.toJson()..addAll({
    "name": name,
    "version": version,
    "link": link
  });

  Dependency.fromJson(super.json) :
    name = json["name"],
    version = json["version"],
    link = json["link"],
    super.fromJson();

  /// Checks if a dependency is equal to another by checking if the names are identical.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dependency && runtimeType == other.runtimeType && name.trim().toLowerCase() == other.name.trim().toLowerCase());
  
  @override
  int get hashCode => name.trim().toLowerCase().hashCode;
}