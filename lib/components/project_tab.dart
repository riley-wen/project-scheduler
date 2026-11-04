import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_scheduler/data/Project.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProjectTab extends StatelessWidget {
  final Project project = Project.testProject;

  @Preview(name: "Project Tab")
  ProjectTab({super.key});
  
  @override
  Widget build(BuildContext context) {
    return 
      ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 120,
          maxWidth: 850
        ),
        child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(5),
          border: BoxBorder.all(
            color: Theme.of(context).colorScheme.surfaceContainer,
            width: 1,
            strokeAlign: BorderSide.strokeAlignOutside
          )
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 3
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 3.0,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 14.0,
                  children: [
                    Text(
                      project.name,
                      style: GoogleFonts.openSans(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface
                      ),
                    ),
                    Text(
                      "Last modified ${project.timeModified.toString()}",
                      style: GoogleFonts.openSans(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 100, 100, 100)
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.0),
                Text(
                  project.description,
                  style: GoogleFonts.openSans(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onSurface
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                SizedBox(height: 4.0),
              ],
            ),
            Row(
              spacing: 8.0,
              children: [
                ShadTooltip(
                  builder: (context) => Text("Edit"),
                  child: ShadIconButton.outline(
                  onPressed: () {

                  },
                  icon: const Icon(LucideIcons.edit),
                )),
                ShadTooltip(
                  builder: (context) => Text("Export"),
                  child: ShadIconButton.outline(
                  onPressed: () {

                  },
                  icon: const Icon(LucideIcons.share),
                )),
                ShadTooltip(
                  builder: (context) => Text("Delete"),
                  child: ShadIconButton.outline(
                  onPressed: () {
                    showShadDialog(
                      context: context,
                      builder: (context) => ShadDialog.alert(
                        title: const Text('Delete project?'),
                        description: Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(text: 'This will permanently delete project '),
                              TextSpan(text: '"${project.name}"', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: '. You won\'t be able to recover any data lost from this operation.')
                            ])
                          ),
                        ),
                        actions: [
                          ShadButton.outline(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          ShadButton(
                            backgroundColor: ShadTheme.of(context).colorScheme.destructive,
                            foregroundColor: ShadTheme.of(context).colorScheme.destructiveForeground,
                            child: const Text('Delete'),
                            onPressed: () => Navigator.of(context).pop(true)
                          ),
                        ],
                      ),
                    ).then((isDelete) {
                      // delete project here
                    });
                  },
                  icon: const Icon(LucideIcons.trash),
                )
                ),
                SizedBox(width: 8,)
              ]
            )
          ],
        ),
      )
    );
  }

}