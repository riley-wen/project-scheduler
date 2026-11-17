import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProjectNotesWriterField extends StatefulWidget {
  final String projectId;
  final String notesId;
  const ProjectNotesWriterField({
    super.key, 
    required this.projectId, 
    required this.notesId
  });

  @override
  State<StatefulWidget> createState() => _ProjectNotesWriterFieldState();
}
class _ProjectNotesWriterFieldState extends State<ProjectNotesWriterField> {
  final QuillController _controller = QuillController.basic();
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuillSimpleToolbar(
        controller: _controller,
        config: const QuillSimpleToolbarConfig(),
      ),
      ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 200,
          maxHeight: 1000
        ),
        child: ShadCard(
          padding: EdgeInsets.symmetric(
            vertical: 30, 
            horizontal: 10
          ),
          child: QuillEditor.basic(
            controller: _controller,
            config: const QuillEditorConfig(),
          ),
        )
      )
      ],
    );
  }

}