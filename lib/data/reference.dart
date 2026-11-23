

import 'package:project_scheduler/data/project_unit.dart';

/// A reference to a project's related links (e.g. Github, hosted website, other version control website etc.)
class Reference extends ProjectUnit {
  /// The label to describe the type of reference
  String label;
  /// The link to the project's reference
  String reference;

  Reference(this.label, this.reference);

  @override
  Map<String, dynamic> toJson() => super.toJson()..addAll({
    "label": label,
    "reference": reference
  });

  Reference.fromJson(super.json) :
    label = json["label"],
    reference = json["reference"],
    super.fromJson();
}