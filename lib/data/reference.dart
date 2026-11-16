

import 'package:project_scheduler/data/projectunit.dart';

class Reference extends ProjectUnit {
  String label;
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