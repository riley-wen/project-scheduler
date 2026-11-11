
import 'package:flutter/material.dart';
import 'package:project_scheduler/data/dependency.dart';
import 'package:project_scheduler/data/projectunit.dart';
import 'package:project_scheduler/data/reference.dart';
import 'package:project_scheduler/data/requirement.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProjectUnitTable extends StatelessWidget {
  final List<ProjectUnit> units;
  final void Function(Requirement, bool)? onCheck;
  const ProjectUnitTable({
    super.key, 
    required this.units, 
    this.onCheck
  });

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
        children: (units as List<Requirement>).map(
          (requirement) => [
            ShadTableCell(
              child: ShadCheckbox(
                value: requirement.completed,
                onChanged: (value) => onCheck?.call(requirement, value)
              )
            ),
            ShadTableCell(
              child: Text(requirement.description, overflow: TextOverflow.ellipsis)
            )
          ]
        ),
      ) : Text("Requirements will appear here", style: theme.textTheme.small.merge(TextStyle(color: theme.colorScheme.mutedForeground)))
    )
    : units is List<Dependency> ? (
    // ==============================================
    // Requirement unit table UI
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
          // uses the default value
          return const FixedTableSpanExtent(140);
        },
        onRowTap: (row) {
          
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
    // Unknown type of project unit passed
      : Text("Unknown project unit", style: theme.textTheme.small.merge(TextStyle(color: theme.colorScheme.mutedForeground)));
    
    
  }

}