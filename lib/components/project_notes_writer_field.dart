import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:project_scheduler/data/project.dart';
import 'package:project_scheduler/data/project_note.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProjectNotesWriterField extends StatefulWidget {
  final Project project;
  final ProjectNote projectNote;
  final QuillController controller;
  final void Function() onDelete;
  const ProjectNotesWriterField({
    super.key, 
    required this.projectNote, 
    required this.project, 
    required this.controller, 
    required this.onDelete
  });

  @override
  State<StatefulWidget> createState() => _ProjectNotesWriterFieldState();
}
class _ProjectNotesWriterFieldState extends State<ProjectNotesWriterField> {  
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Column(
      spacing: 8.0,
      mainAxisAlignment: .start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 10.0,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400,
                minWidth: 140
              ),
              child: ShadInput(
                initialValue: widget.projectNote.name,
                onChanged: (value) {
                  setState(() {
                    widget.projectNote.name = value;
                  });
                },
                style: theme.textTheme.h3,
              )
            ),
            ShadButton(
              leading: const Icon(LucideIcons.save),
              child: const Text("Save"),
              onPressed: () {
                widget.projectNote.document = widget.controller.document;
                widget.project.saveProject();
              },
            ),
            ShadButton.destructive(
              leading: const Icon(LucideIcons.trash),
              child: const Text("Delete"),
              onPressed: () {
                showShadDialog(
                  context: context, 
                  builder: (context) => ShadDialog.alert(
                    description: const Text("Are you sure? This can't be reversed."),
                    actions: [
                      ShadButton(
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ShadButton.destructive(
                        leading: const Icon(LucideIcons.trash),
                        child: const Text("Delete"),
                        onPressed: () {
                          widget.onDelete();
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
                );
              },
            ),
          ],
        ),
        QuillSimpleToolbar(
          controller: widget.controller,
          config: const QuillSimpleToolbarConfig(),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 200,
            maxHeight: 1000
          ),
          child: ShadCard(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.symmetric(
              vertical: 30, 
              horizontal: 10
            ),
            child: QuillEditor.basic(
              controller: widget.controller,
              config: const QuillEditorConfig(
                expands: true
              ),
            ),
          )
        )
      ],
    );
  }

}