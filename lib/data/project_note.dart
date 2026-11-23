import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:localstore/localstore.dart';
import 'package:project_scheduler/data/data_info.dart';
import 'package:project_scheduler/data/project_unit.dart';

class ProjectNote extends ProjectUnit {
    String name;
    Document document;

    ProjectNote(
        this.name,
        this.document
    );
    @override
    Map<String, dynamic> toJson() => super.toJson()..addAll({
        "name": name,
        "document": jsonEncode(document.toDelta().toJson()),
    });

    ProjectNote.fromJson(super.json) :
        name = json["name"],
        document = Document.fromJson(jsonDecode(json["document"])),
        super.fromJson();
  
}