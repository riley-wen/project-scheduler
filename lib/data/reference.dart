

import 'package:project_scheduler/data/projectunit.dart';

class Reference extends ProjectUnit {
  final String label;
  final String reference;

  const Reference(this.label, this.reference);

  Map<String, dynamic> toJson() => {
    "label": label,
    "reference": reference
  };
  Reference.fromJson(Map<String, dynamic> json) :
    label = json["label"],
    reference = json["reference"];
}