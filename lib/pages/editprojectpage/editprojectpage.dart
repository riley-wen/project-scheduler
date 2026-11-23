import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:project_scheduler/components/project_notes_writer_field.dart';
import 'package:project_scheduler/components/project_unit_table.dart';
import 'package:project_scheduler/data/project.dart';
import 'package:project_scheduler/components/project_description_edit_field.dart';
import 'package:project_scheduler/components/project_title_edit_field.dart';
import 'package:project_scheduler/components/project_unit_form.dart';
import 'package:project_scheduler/data/project_note.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class EditProjectScreenArguments {
  final String projectId;
  const EditProjectScreenArguments(this.projectId);
}

class EditProjectPage extends StatelessWidget {
  const EditProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as EditProjectScreenArguments;
    return _EditProjectPage(projectId : args.projectId);
  }

}
class _EditProjectPage extends StatefulWidget {
  final String projectId;
  const _EditProjectPage({required this.projectId});

  @override
  State<StatefulWidget> createState() => _EditProjectPageState();
}
class _EditProjectPageState extends State<_EditProjectPage> {
  Project? selectedProject;
  ProjectNote? selectedNote;
  String unitTabValue = 'requirements';

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final QuillController noteController = .basic();

  @override
  void initState() {
    // Loads the selected project into widget memory
    Project.loadById(widget.projectId).then((proj) => setState(() {
      if (proj == null) return;
      selectedProject = proj;
      titleController.text = proj.name;
      descController.text = proj.description;
    }));
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: ShadBreadcrumb(
          children: [
            ShadBreadcrumbLink(
              onPressed: () => Navigator.pop(context),
              child: const Text('Home'),
            ),
            Text("Edit project")
          ]
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: theme.radius,
          border: Border.all(
            color: theme.colorScheme.border,
          ),
        ),
        child: ClipRRect(
          borderRadius: theme.radius,
          child: ShadResizablePanelGroup(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            showHandle: true,
            children: [
              ShadResizablePanel(
                id: 0,
                defaultSize: .6,
                minSize: .2,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    spacing: 20.0,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(selectedProject != null) ...[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "ID: ${selectedProject?.projectId ?? "..."}", 
                            style: theme.textTheme.muted.apply(
                              color: theme.colorScheme.mutedForeground,
                              fontSizeDelta: -2.0
                            )
                          ),
                        ),
                        ProjectDescriptionEditField(
                          selectedProject: selectedProject!,
                          titleController: titleController,
                          descriptionController: descController, 
                        ),
                        const SizedBox(height: 16),
                        if(selectedProject != null) ShadResizablePanelGroup(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShadResizablePanel(
                              id: 11, 
                              defaultSize: 0.25,
                              minSize: 0.1,
                              child: Padding(
                                padding: .symmetric(
                                  horizontal: 18,
                                  vertical: 12
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: 4.0,
                                  children: [
                                    ...(selectedProject != null ? selectedProject!.notes : <ProjectNote>[]).map(
                                      (note) => ConstrainedBox(
                                        constraints: BoxConstraints(),
                                        child: ShadItem.outline(
                                          backgroundColor: selectedNote == note ? theme.colorScheme.primaryForeground : null,
                                          size: ShadItemSize.sm,
                                          onPressed: () {
                                            setState(() {
                                              if (selectedNote != note) {
                                                selectedNote = note;
                                                noteController.document = note.document;
                                              }
                                            });
                                          },
                                          media: selectedNote == note ? const Icon(LucideIcons.chevronRight) : null,
                                          title: Text(note.name)
                                        ),
                                      )
                                    ),
                                    ShadItem.outline(
                                      onPressed: () {
                                        if(selectedProject == null) {
                                          return;
                                        }
                                        ProjectNote newNote = ProjectNote(
                                          "Untitled note",
                                          Document()
                                        );
                                        setState(() {
                                          selectedProject!.notes.add(newNote);
                                          selectedNote = newNote;
                                          noteController.document = newNote.document;
                                        });
                                      },
                                      media: const Icon(LucideIcons.plus),
                                      child: const Text("Add note"),
                                    )
                                  ],
                                ), 
                              )
                            ),
                            ShadResizablePanel(
                              id: 12, 
                              minSize: 0.4,
                              defaultSize: 0.75,
                              child: Padding(
                                padding: .symmetric(
                                  horizontal: 18,
                                  vertical: 12
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: 4.0,
                                  children: [
                                    if(selectedNote != null) ProjectNotesWriterField(
                                      key: Key(selectedNote!.unitId),
                                      controller: noteController,
                                      projectNote: selectedNote!, 
                                      project: selectedProject!,
                                      onDelete: () {
                                        selectedProject!.removeUnit(selectedNote!);
                                        selectedProject!.saveProject();
                                        setState(() {
                                          selectedNote = null;
                                        });
                                      },
                                    ) else Container(
                                      alignment: .center,
                                      child: const Text("No note selected"),
                                    )
                                  ],
                                ),
                              )
                            )
                          ]
                        ),
                        SizedBox(height: 100)
                      ]
                    ],
                  ),
                ),
              ),
              ShadResizablePanel(
                id: 1,
                defaultSize: .4,
                minSize: .25,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4.0,
                    children: [
                      ShadTabs(
                        value: unitTabValue,
                        gap: 40.0,
                        tabBarConstraints: const BoxConstraints(maxWidth: 700),
                        tabs: [
                          ShadTab(
                            value: 'requirements',
                            onPressed: () => unitTabValue = "requirements",
                            maintainState: true,
                            content: Column(
                              spacing: 14.0,
                              children: selectedProject == null ? [] : [
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxHeight: 500),
                                  child: ProjectUnitTable(
                                    units: selectedProject!.requirements, 
                                    onCheck: (req, v) {
                                      setState(() {
                                        req.completed = v;
                                      });  
                                    },
                                    onEdit: (unit) {
                                      setState(() {});
                                      selectedProject!.saveProject();
                                    },
                                    onDelete: (unit) {
                                      setState(() {
                                        selectedProject!.removeUnit(unit);
                                      });
                                      selectedProject!.saveProject();
                                    },
                                  ),
                                ),
                                RequirementUnitForm(
                                  selectedProject: selectedProject!,
                                  onAdd: (req) => setState(() {
                                    selectedProject!.requirements.add(req);
                                    selectedProject!.saveProject();
                                  }),
                                )
                              ],
                            ), 
                            child: Text("Requirements"),
                          ),
                          ShadTab(
                            value: 'dependencies',
                            onPressed: () => unitTabValue = "dependencies",
                            content: Column(
                              spacing: 14.0,
                              children: selectedProject == null ? [] : [
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxHeight: 500),
                                  child: ProjectUnitTable(
                                    units: selectedProject!.dependencies,
                                    onEdit: (unit) {
                                      setState(() {});
                                      selectedProject!.saveProject();
                                    },
                                    onDelete: (unit) {
                                      setState(() {
                                        selectedProject!.removeUnit(unit);
                                      });
                                      selectedProject!.saveProject();
                                    },
                                  ),
                                ),
                                DependencyUnitForm(selectedProject: selectedProject!, onAdd: (dep){
                                  setState(() {
                                    selectedProject!.dependencies.add(dep);
                                    selectedProject!.saveProject();
                                  });
                                })
                              ],
                            ), 
                            child: Text("Dependencies"),
                          ),
                          ShadTab(
                            value: 'references',
                            onPressed: () => unitTabValue = "references",
                            content: Column(
                              spacing: 14.0,
                              children: selectedProject == null ? [] : [
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxHeight: 500),
                                  child: ProjectUnitTable(
                                    units: selectedProject!.references,
                                    onEdit: (unit) {
                                      setState(() {});
                                      selectedProject!.saveProject();
                                    },
                                    onDelete: (unit) {
                                      setState(() {
                                        selectedProject!.removeUnit(unit);
                                      });
                                      selectedProject!.saveProject();
                                    },
                                  ),
                                ),
                                ReferenceUnitForm(
                                  selectedProject: selectedProject!,
                                  onAdd: (ref) => setState(() {
                                    selectedProject!.references.add(ref);
                                    selectedProject!.saveProject();
                                  }),
                                )
                              ],
                            ), 
                            child: Text("References"),
                          )
                        ]
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
