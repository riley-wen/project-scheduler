import 'package:flutter/material.dart';
import 'package:project_scheduler/data/project.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProjectDescriptionEditField extends StatelessWidget {
  final TextEditingController textController;
  final Project selectedProject;

  const ProjectDescriptionEditField({super.key, required this.textController, required this.selectedProject});
  @override
  Widget build(BuildContext context) {
    return ShadTextarea(
      placeholder: const Text("A description for what your project is about"),
      controller: textController,
      onChanged: (value) => selectedProject.description = value,
    );
  }
}