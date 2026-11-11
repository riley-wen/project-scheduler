import 'package:flutter/material.dart';
import 'package:project_scheduler/data/project.dart';
import 'package:project_scheduler/data/reference.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateProjectPageState();

}
class _CreateProjectPageState extends State<CreateProjectPage> {
  final TextEditingController projectTitleController = TextEditingController(text: "Untitled Project");
  final TextEditingController projectDescriptionController = TextEditingController();

  final List<Reference> projectReferences = List.empty(growable: true);

  final formKey = GlobalKey<ShadFormState>();

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: ShadBreadcrumb(
          children: [
            ShadBreadcrumbLink(
              onPressed: () => Navigator.pop(context),
              child: const Text('Home'),
            ),
            Text("Create a project")
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
            showHandle: true,
            children: [
              ShadResizablePanel(
                id: 0,
                defaultSize: .7,
                minSize: .4,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: ShadInput(
                        controller: projectTitleController,
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
                        top: Text(
                            "   Title",
                            style: theme.textTheme.small,
                          ),
                      )
                    ),
                    SizedBox(height: 20,),
                    Text("Description", style: theme.textTheme.muted,),
                    SizedBox(height: 2,),
                    ShadTextarea(
                      placeholder: const Text("A description for what your project is about"),
                      controller: projectDescriptionController,
                    ),
                    SizedBox(height: 30),
                    ShadForm(
                      key: formKey,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 350),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ShadInputFormField(
                              id: 'label',
                              label: const Text('Add reference'),
                              placeholder: const Text('Github, Linkedin, personal website'),
                              validator: (v) {
                                if (v.length < 2) {
                                  return 'Label must be at least 2 characters.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
                            ShadInputFormField(
                              id: 'reference',
                              placeholder: const Text('https://www.website.com'),
                              description: const Text('A reference is a link to a project\'s related resources. You can always add these later.'),
                              validator: (v) {
                                if (v.length < 2) {
                                  return 'Link must be at least 2 characters.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            ShadButton(
                              child: const Text('Add'),
                              onPressed: () {
                                if (formKey.currentState!.saveAndValidate()) {
                                  setState(() {
                                    projectReferences.add(
                                      Reference(formKey.currentState!.value["label"], formKey.currentState!.value["reference"])
                                    );
                                  });
                                } else {
                                  ShadToaster.of(context).show(
                                    ShadToast(
                                      title: const Text('Unable to add reference'),
                                      description:
                                          const Text('Validation failed'),
                                    )
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    if (projectReferences.isNotEmpty) 
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 1000),
                      child: ShadTable.list(
                        header: [
                          ShadTableCell.header(child: Text("Type")),
                          ShadTableCell.header(child: Text("Reference"))
                        ],
                        columnSpanExtent: (index) {
                          if (index == 1) {
                            return const MaxTableSpanExtent(
                              FixedTableSpanExtent(120),
                              RemainingTableSpanExtent(),
                            );
                          }
                          // uses the default value
                          return const FixedTableSpanExtent(230);
                        },
                        children: projectReferences.map(
                          (reference) => [
                            ShadTableCell(
                              child: Text(
                                reference.label, 
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.list.merge(TextStyle(fontWeight: FontWeight.bold)), 
                              )
                            ),
                            ShadTableCell(
                              child: Text(reference.reference, overflow: TextOverflow.ellipsis)
                            )
                          ]
                        ),
                      ),
                    ) else Text("References will appear here", style: theme.textTheme.small.merge(TextStyle(color: theme.colorScheme.mutedForeground)), )
                    
                  ])
                ),
              ),
              ShadResizablePanel(
                id: 1,
                defaultSize: .3,
                minSize: .2,
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 20
                  ),
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 50,
                      ),
                      child: ShadButton(
                        shadows: [
                          BoxShadow(
                            color: theme.colorScheme.input,
                            spreadRadius: 6,
                            blurRadius: 20,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        leading: Icon(LucideIcons.edit),
                        child: Text(
                          "Create Project"
                        ),
                        onPressed: () {
                          Project newProject = Project.create();
                          newProject.name = projectTitleController.text;
                          newProject.description = projectDescriptionController.text;
                          newProject.replaceReferences(projectReferences);
                          setState(() {
                            newProject.saveProject();
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

}