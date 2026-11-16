import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_scheduler/data/project.dart';
import 'package:project_scheduler/data/project_export.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter/services.dart';

class ProjectExportSheet extends StatefulWidget {
  final String exportedProjectId;
  const ProjectExportSheet({
    super.key, 
    required this.exportedProjectId, 
  });

  @override
  State<StatefulWidget> createState() => _ProjectExportSheetState();
}
class _ProjectExportSheetState extends State<ProjectExportSheet> {
  final TextEditingController exportController = TextEditingController();
  Project? exportProject;
  ExportSettings exportSettings = ExportSettings(
    format: ExportFormat.github
  );

  void rebuildExport() async {
      exportProject = await Project.loadById(widget.exportedProjectId);
      if (exportProject != null) {
        setState(() {
          exportController.text = exportProjectReadMe(
            exportProject!,
            settings: exportSettings
          );
        });
      }
  }
  @override
  void initState() {
    super.initState();
    rebuildExport();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return ShadSheet(
      constraints: const BoxConstraints(maxWidth: 612),
      title: const Text('Export Project'),
      description: const Text("Export a project into a format suitable for Github README.md's or as plain documentation."),
      actions: [
        ShadButton.outline(
          leading: Icon(LucideIcons.refreshCcw),
          child: Text('Rebuild'),
          onPressed: () => rebuildExport(),
        ),
        ShadButton.outline(
          leading: Icon(LucideIcons.copy),
          child: Text('Copy'),
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: exportController.text));
            if(context.mounted) {
              ShadToaster.of(context).show(
                ShadToast(
                  title: const Text('Copied to clipboard'),
                  showCloseIconOnlyWhenHovered: false,
                ),
              );
            }
          },
        ),
        ShadButton(
          child: const Text('Done'),
          onPressed: () {
            Navigator.of(context).pop();    
          },
        ),
      ],
      child: Padding(
        padding: .symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShadTextarea(
              placeholder: Text("Loading..."),
              minHeight: 370,
              maxHeight: 600,
              controller: exportController,
              enabled: true,
              style: GoogleFonts.spaceMono(),
            ),
            const SizedBox(height: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12.0,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 380),
                  child: ShadSelect<ExportFormat>(
                    initialValue: ExportFormat.github,
                    options: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Text(
                          'Formats',
                          style: theme.textTheme.muted.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.popoverForeground,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      ...ExportFormat.values
                          .map((e) => ShadOption(
                            value: e, 
                            child: Text(e.name.replaceRange(0, 1, e.name.substring(0, 1).toUpperCase())))),
                    ],
                    selectedOptionBuilder: (context, value) => Text(value.name.replaceRange(0, 1, value.name.substring(0, 1).toUpperCase())),
                    onChanged: (value) {
                      setState(() {
                        if (value == null) {
                          return;
                        }
                        exportSettings.format = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                ShadCheckbox(
                  label: const Text("Include requirements"),
                  value: exportSettings.includeRequirements,
                  onChanged: (value) {
                    setState(() {
                      exportSettings.includeRequirements = value;
                    });
                  },
                ),
                ShadCheckbox(
                  label: const Text("Include references"),
                  value: exportSettings.includeReferences,
                  onChanged: (value) {
                    setState(() {
                      exportSettings.includeReferences = value;
                    });
                  },
                ),
                ShadCheckbox(
                  label: const Text("Include dependencies"),
                  value: exportSettings.includeDependencies,
                  onChanged: (value) {
                    setState(() {
                      exportSettings.includeDependencies = value;
                    });
                  },
                ),
              ]
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

}