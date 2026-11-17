
import 'package:flutter/material.dart';
import 'package:project_scheduler/data/dependency.dart';
import 'package:project_scheduler/data/projectunit.dart';
import 'package:project_scheduler/data/reference.dart';
import 'package:project_scheduler/data/requirement.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProjectUnitTable extends StatelessWidget {
  final List<ProjectUnit> units;
  final void Function(ProjectUnit) onEdit;
  final void Function(ProjectUnit) onDelete;
  final void Function(Requirement, bool)? onCheck;
  ProjectUnitTable({
    super.key, 
    required this.units,
    required this.onEdit,
    required this.onDelete,  
    this.onCheck, 
  });

  final GlobalKey<ShadFormState> _formKey = GlobalKey<ShadFormState>();

  void _infoDialog(BuildContext context, String type) {
    showShadDialog(
      context: context,
      builder: (context) {

        return ShadDialog.alert(
        title: const Text('Info Tab'),
        description: Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Column(
            children: type == "requirement" ? [
            ] : type == "reference" ? [

            ] : type == "dependency" ? [

            ] : [
              Text("Error")
            ],
          )
        ),
        actions: [
          ShadButton.outline(
            child: const Text('Continue'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      );
    });
  }
  void _editDialog(BuildContext context, ProjectUnit unit) {
    final theme = ShadTheme.of(context);
    showShadDialog(
      context: context,
      builder: (context) => ShadDialog.alert(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 12.0,
          children: [
            const Text('Edit unit'),
            Text("ID: ${unit.unitId}", 
              style: theme.textTheme.muted.apply(
                color: theme.colorScheme.mutedForeground,
                fontSizeDelta: -2.0
              )
            ),
          ],
        ),
        description: Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: ([
              Text("Last modified ${DateFormat('yyyy-MM-dd').format(unit.timeModified)}", 
                style: theme.textTheme.muted,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20,)
            // ==============================================
            // Reference editing dialog UI
            // ==============================================
            ]) + (unit is Reference ? [
               ShadForm(
                key: _formKey,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 900,
                    maxHeight: 900
                  ),
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      ShadInputFormField(
                        id: 'reference_label',
                        placeholder: const Text('Website'),
                        initialValue: unit.label,
                        validator: (v) {
                          if (v.length < 2) {
                            return 'Label must be at least 2 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 4),
                      ShadInputFormField(
                        id: 'reference_reference',
                        placeholder: const Text('https://www.website.com'),
                        initialValue: unit.reference,
                        description: const Text('A reference is a link to a project\'s related resources. You can always add these later.'),
                        validator: (v) {
                          if (v.length < 2) {
                            return 'Reference must be at least 2 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  )
                ),
              )
            // ==============================================
            // Requirement editing dialog UI
            // ==============================================
            ] : unit is Requirement ? [
               ShadForm(
                key: _formKey,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 900,
                    maxHeight: 900
                  ),
                  child: ShadInputFormField(
                      id: 'requirement_description',
                      initialValue: unit.description,
                      placeholder: const Text('Write some code..'),
                      description: const Text('A requirement is a specific task or goal to accomplish within the project.'),
                    ),
                ),
              )
            // ==============================================
            // Dependency editing dialog UI
            // ==============================================
            ] : unit is Dependency ? [
              ShadForm(
                key: _formKey,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 900,
                    maxHeight: 900
                  ),
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      ShadInputFormField(
                        id: 'dependency_name',
                        initialValue: unit.name,
                        placeholder: const Text('Dependency'),
                      ),
                      const SizedBox(height: 4),
                      ShadInputFormField(
                        id: 'dependency_version',
                        initialValue: unit.version,
                        placeholder: const Text('1.0.0'),
                      ),
                      const SizedBox(height: 4),
                      ShadInputFormField(
                        id: 'dependency_link',
                        placeholder: const Text('https://dependency.com'),
                        initialValue: unit.link,
                        description: const Text('A dependency is an external the project depends on to function.'),
                      ),
                      const SizedBox(height: 4),
                    ],
                  )
                ),
              )
            ] : [
              Text("Error"),
            ]),
          )
        ),
        actions: [
          ShadButton.outline(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ShadButton(
            backgroundColor: ShadTheme.of(context).colorScheme.destructive,
            foregroundColor: ShadTheme.of(context).colorScheme.destructiveForeground,
            leading: const Icon(LucideIcons.trash),
            child: const Text('Delete'),
            onPressed: () {
              showShadDialog(
                context: context, builder: (context) => ShadDialog.alert(
                  title: Text("Delete unit?"),
                  actions: [
                    ShadButton.outline(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    ShadButton(
                      backgroundColor: ShadTheme.of(context).colorScheme.destructive,
                      foregroundColor: ShadTheme.of(context).colorScheme.destructiveForeground,
                      leading: const Icon(LucideIcons.trash),
                      child: const Text('Delete'),
                      onPressed: () {
                        // Deletes the project unit, then calls setState a widget upwards to update the UI.
                        onDelete(unit);
                        (Navigator.of(context)..pop(true)).pop(true);
                      }
                    ),
                  ],
                  child: Column(
                    children: [
                      Text("Are you sure you want to delete this item?"),
                      const SizedBox(height: 10)
                    ],
                  ),
                )
              );
            }
          ),
          ShadButton(
            backgroundColor: ShadTheme.of(context).colorScheme.primary,
            foregroundColor: ShadTheme.of(context).colorScheme.primaryForeground,
            leading: const Icon(LucideIcons.save),
            child: const Text('Save'),
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                if (context.mounted) {
                  ShadToaster.of(context).show(
                    ShadToast(
                      title: const Text("Could not edit project unit"),
                      showCloseIconOnlyWhenHovered: false,
                    )
                  );
                }
                return;
              } 
              // Edits a project unit by reference, then calls upwards a widget in order to rebuild the UI for updated changes
              // Automatically saves the project when edited (because I forget to click save)
              // (I refuse to use switch statements)
              if (unit is Reference) {

                unit.label = _formKey.currentState!.value["reference_label"];
                unit.reference = _formKey.currentState!.value["reference_reference"];

              } else if (unit is Requirement) {

                unit.description = _formKey.currentState!.value["requirement_description"];

              } else if (unit is Dependency) {

                unit.name = _formKey.currentState!.value["dependency_name"];
                unit.version = _formKey.currentState!.value["dependency_version"];
                unit.link = _formKey.currentState!.value["dependency_link"];

              }

              onEdit(unit);
              Navigator.of(context).pop(true);
            }
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return 
      units is List<Reference> ? (
      // ==============================================
      // Reference unit table UI
      // ==============================================
      units.isNotEmpty ? ShadTable.list(
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
          return const FixedTableSpanExtent(170);
        },
        onRowTap: (row) {
          if (row == 0) {
            _infoDialog(context, "reference");
            return;
          }
          _editDialog(context, units[row - 1]);
        },
        children: (units as List<Reference>).map(
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
      ) : Text("References will appear here", style: theme.textTheme.small.merge(TextStyle(color: theme.colorScheme.mutedForeground)))
    )
    : units is List<Requirement> ? (
    // ==============================================
    // Requirement unit table UI
    // ==============================================
      units.isNotEmpty ? ShadTable.list(
        header: [
          ShadTableCell.header(child: Text("")),
          ShadTableCell.header(child: Text("Description")),
        ],
        columnSpanExtent: (index) {
          if (index == 1) {
            return const MaxTableSpanExtent(
              FixedTableSpanExtent(200),
              RemainingTableSpanExtent(),
            );
          }
          // uses the default value
          return const FixedTableSpanExtent(60);
        },
        onRowTap: (row) {
          if (row == 0) {
            _infoDialog(context, "requirement");
            return;
          }
          _editDialog(context, units[row - 1]);
        },
        rowSpanExtent: (row) {
          return const FixedTableSpanExtent(60);
        },
        children: (units as List<Requirement>).map(
          (requirement) => [
            ShadTableCell(
              child: ShadCheckbox(
                value: requirement.completed,
                onChanged: (value) => onCheck?.call(requirement, value)
              )
            ),
            ShadTableCell(
              style: theme.textTheme.p.apply(
                overflow: TextOverflow.fade
              ),
              child: Text(requirement.description),
            )
          ]
        ),
      ) : Text("Requirements will appear here", style: theme.textTheme.small.merge(TextStyle(color: theme.colorScheme.mutedForeground)))
    )
    : units is List<Dependency> ? (
    // ==============================================
    // Dependency unit table UI
    // ==============================================
      units.isNotEmpty ? ShadTable.list(
        header: [
          ShadTableCell.header(child: Text("Name")),
          ShadTableCell.header(child: Text("Version")),
          ShadTableCell.header(child: Text("Link"))
        ],
        columnSpanExtent: (index) {
          if (index == 2) {
            return const MaxTableSpanExtent(
              FixedTableSpanExtent(120),
              RemainingTableSpanExtent(),
            );
          } else if (index == 1) {
            return const FixedTableSpanExtent(100);
          }
          return const FixedTableSpanExtent(200);
        },
        onRowTap: (row) {
          if (row == 0) {
            _infoDialog(context, "dependency");
            return;
          }
          _editDialog(context, units[row - 1]);
        },
        children: (units as List<Dependency>).map(
          (requirement) => [
            ShadTableCell(
              child: Text(requirement.name, overflow: TextOverflow.ellipsis)
            ),
            ShadTableCell(
              child: Text(requirement.version ?? "", overflow: TextOverflow.ellipsis)
            ),
            ShadTableCell(
              child: Text(requirement.link ?? "", overflow: TextOverflow.ellipsis)
            )
          ]
        ),
      ) : Text("Dependencies will appear here", style: theme.textTheme.small.merge(TextStyle(color: theme.colorScheme.mutedForeground)))
    )
    // Unknown type of project unit passed somehow
      : Text("Unknown project unit", style: theme.textTheme.small.merge(TextStyle(color: theme.colorScheme.mutedForeground)));
    
    
  }

}