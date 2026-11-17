
import 'package:project_scheduler/data/project.dart';

String _encapsulateText(String text) =>
"""==============================================================
${text}
==============================================================""";

/// Exports a project into documentation readable by the format and export settings specified.
/// 
/// @param project The project to export
/// 
/// @param settings The export settings to use, uses default if not provided
/// 
/// @returns The project's documentation in one string
String exportProjectReadMe(
  Project project,
  {
    ExportSettings? settings 
  }
) {
  settings ??= ExportSettings.defaultSettings;
  if (settings.format == ExportFormat.github) {
    return 
"""# ${project.name}
${project.description}
${
  !settings.includeReferences ? "" :
  """
## References

| | |
| --- | --- |
${
  project.references.map((ref) => "| ${ref.label} | ${ref.reference} |"  ).join("\n")
}""" 
}
${
  !settings.includeDependencies ? "" :
  """
## Dependencies

| Name | Version | Link |
| --- | --- | --- |
${
  project.dependencies.map((dep) => "| ${dep.name} | ${dep.version ?? ""} | ${dep.link != null ? "[${dep.link}](${dep.link})" : ""} |").join("\n")
}""" 
}
${
  !settings.includeRequirements ? "" :
  """## TODO
${
    project.requirements.map((req) => "- [${req.completed ? "x" : " "}] ${req.description}").join("\n")
}""" 
}
""";
  } else if (settings.format == ExportFormat.text) {
    return
"""${_encapsulateText(project.name)}
${project.description}

${
  !settings.includeReferences ? "" :
"""${_encapsulateText("REFERENCE LINKS")}
${
  project.references.map((ref) => "${ref.label} - ${ref.reference}").join("\n")
}""" 
}

${
  !settings.includeDependencies ? "" :
"""${_encapsulateText("DEPENDENCIES")}
${
  project.dependencies.map((dep) => "${dep.name} - ${dep.version ?? ".."}${dep.link != null ? " [${dep.link}]" : ""}").join("\n")
}""" 
}

${
  !settings.includeRequirements ? "" :
  """${_encapsulateText("TODO")}
${
  project.requirements.map((req) => "- [${req.completed ? "x" : " "}] ${req.description}").join("\n")
}""" 
}
""";
  }
  return "README format error";
}

/// Enums representing format of the project export
enum ExportFormat {
  text,
  github
}

/// Wrapper class for various export settings
class ExportSettings {
  /// The default export settings used if none are provided.
  static final ExportSettings defaultSettings = ExportSettings(
    format: ExportFormat.github
  );
  ExportFormat format;
  bool includeRequirements;
  bool includeDependencies;
  bool includeReferences;

  ExportSettings({
    required this.format,
    this.includeDependencies = true,
    this.includeRequirements = false,
    this.includeReferences = true,
  });
  
}