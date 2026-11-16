import 'package:flutter/material.dart';
import 'package:project_scheduler/components/project_unit_table.dart';
import 'package:project_scheduler/data/project.dart';
import 'package:project_scheduler/components/project_descriptioneditfield.dart';
import 'package:project_scheduler/components/project_title_edit_field.dart';
import 'package:project_scheduler/components/project_unit_form.dart';
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
  String unitTabValue = 'requirements';

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  void initState() {
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
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: ProjectTitleEditField(
                            selectedProject: selectedProject!, 
                            textController: titleController,
                          )
                        ),
                        ProjectDescriptionEditField(
                          selectedProject: selectedProject!,
                          textController: descController, 
                        ),
                        ShadButton(
                          leading: const Icon(LucideIcons.save),
                          child: Text("Save"),
                          onPressed: () {
                            if (selectedProject == null) {
                              ShadToaster.of(context).show(
                                ShadToast(
                                  title: const Text('Unable to add project'),
                                  description:
                                      const Text('No project selected'),
                                )
                              );
                            } else {
                              selectedProject!.saveProject().then((a) {
                                if (a != null) {
                                  // ignore: use_build_context_synchronously
                                  ShadToaster.of(context).show(
                                    ShadToast(
                                      title: const Text('An error occured'),
                                      description:
                                        Text(a.toString()),
                                    )
                                  );
                                }
                              });
                            }
                          },
                        ),
                        SizedBox(height: 1000)
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
