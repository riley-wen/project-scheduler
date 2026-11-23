import 'package:flutter/material.dart';
import 'package:project_scheduler/data/project.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProjectDescriptionEditField extends StatefulWidget {
  final TextEditingController descriptionController;
  final Project selectedProject;
  final TextEditingController titleController;
  

  const ProjectDescriptionEditField({
    super.key, 
    required this.descriptionController, 
    required this.selectedProject, 
    required this.titleController
  });

  @override
  State<StatefulWidget> createState() => _ProjectDescriptionEditFieldState();

}

class _ProjectDescriptionEditFieldState extends State<ProjectDescriptionEditField> {
  bool saving = false;
  int writingDone = 0;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Column(
      mainAxisAlignment: .start,
      spacing: 14.0,
      children: [
        ShadInput(
          placeholder: Text(
            "Project title ...",
            style: theme.textTheme.h2,
          ),
          controller: widget.titleController,
          onChanged: (value) {
            // saves only if 1 second has passed after typing is done
            setState(() {
              saving = true;
            });
            writingDone++;
            int tracked = writingDone;
            widget.selectedProject.name = value;
            () async {
              await Future.delayed(const Duration(seconds: 2));
              if (writingDone == tracked) {
                widget.selectedProject.saveProject();
                setState(() {
                  saving = false;
                });
              }
            }();
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
        ),
        ShadTextarea(
          placeholder: const Text("A description for what your project is about"),
          controller: widget.descriptionController,
          minHeight: 200,
          onChanged: (value) {
            // saves only if 1 second has passed after typing is done
            setState(() {
              saving = true;
            });
            writingDone++;
            int tracked = writingDone;
            widget.selectedProject.description = value;
            () async {
              await Future.delayed(const Duration(seconds: 2));
              if (writingDone == tracked) {
                widget.selectedProject.saveProject();
                setState(() {
                  saving = false;
                });
              }
            }();
          },
        ),
        Row(
          spacing: 6.0,
          children: saving ? [
            Icon(LucideIcons.rotateCcw, size: 16),
            Text("Saving...")
          ] : [
            Icon(LucideIcons.check, size: 16),
            Text("Saved")
          ],
        )
      ],
    );
  }
}