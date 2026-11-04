class Dependency {
  String name = "";
  String version = "";
  String link = "";

  Dependency();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dependency && runtimeType == other.runtimeType && name.trim().toLowerCase() == other.name.trim().toLowerCase());
  @override
  int get hashCode => name.trim().toLowerCase().hashCode;
}