import 'package:flutter/material.dart';
import 'package:project_scheduler/data/project.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProjectTitleEditField extends StatelessWidget {
  final TextEditingController textController;
  final Project selectedProject;

  const ProjectTitleEditField({super.key, required this.textController, required this.selectedProject});
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return ShadInput(
      placeholder: Text(
        "Project title ...",
        style: theme.textTheme.h2,
      ),
      controller: textController,
      onChanged: (value) {
        selectedProject.name = value;
      },
      keyboardType: TextInputType.name,
      style: theme.textTheme.h2,
      decoration: ShadDecoration(
        focusedBorder: ShadBorder.all(
          width: 0.0,
        ).merge(
          ShadBorder(
            bottom: ShadBorderSide(
              width: 1.0
            )
          )
        ),
        border: ShadBorder.all(
          width: 0.0,
        ).merge(
          ShadBorder(
            bottom: ShadBorderSide(
              width: 1.0
            )
          )
        )
      ),
    );
  }
}