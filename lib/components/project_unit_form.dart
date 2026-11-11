import 'package:flutter/material.dart';
import 'package:project_scheduler/data/dependency.dart';
import 'package:project_scheduler/data/project.dart';
import 'package:project_scheduler/data/reference.dart';
import 'package:project_scheduler/data/requirement.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ReferenceUnitForm extends StatefulWidget {
  final Project selectedProject;
  final void Function(Reference) onAdd;
  const ReferenceUnitForm({
    super.key, 
    required this.selectedProject, 
    required this.onAdd
  });
  @override
  State<StatefulWidget> createState() => _ReferenceUnitFormState();
}
class _ReferenceUnitFormState extends State<ReferenceUnitForm> {
  final GlobalKey<ShadFormState> formKey = GlobalKey<ShadFormState>();
  
  @override
  Widget build(BuildContext context) {
    return ShadForm(
      key: formKey,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350),
        child: Column(
          spacing: 4,
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
                  widget.onAdd(Reference(formKey.currentState!.value["label"], formKey.currentState!.value["reference"]));
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
    );
  }
}

class RequirementUnitForm extends StatefulWidget {
  final Project selectedProject;
  final void Function(Requirement) onAdd;
  const RequirementUnitForm({
    super.key, 
    required this.selectedProject, 
    required this.onAdd
  });
  @override
  State<StatefulWidget> createState() => _RequirementUnitForm();
}
class _RequirementUnitForm extends State<RequirementUnitForm> {
  final GlobalKey<ShadFormState> formKey = GlobalKey<ShadFormState>();
  
  @override
  Widget build(BuildContext context) {
    return ShadForm(
      key: formKey,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ShadInputFormField(
              id: 'description',
              label: const Text('Add requirement'),
              placeholder: const Text('Write some code ...'),
              description: const Text("Description for the requirement"),
              validator: (v) {
                if (v.length < 2) {
                  return 'Requirement must be at least 2 characters.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ShadButton(
              child: const Text('Add'),
              onPressed: () {
                if (formKey.currentState!.saveAndValidate()){
                    widget.onAdd(Requirement(formKey.currentState!.value["description"]));
                } else {
                  ShadToaster.of(context).show(
                    ShadToast(
                      title: const Text('Unable to add requirement'),
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
    );
  }
}

class DependencyUnitForm extends StatefulWidget {
  final Project selectedProject;
  final void Function(Dependency) onAdd;
  const DependencyUnitForm({
    super.key, 
    required this.selectedProject, 
    required this.onAdd
  });
  @override
  State<StatefulWidget> createState() => _DependencyUnitForm();
}
class _DependencyUnitForm extends State<DependencyUnitForm> {
  final GlobalKey<ShadFormState> formKey = GlobalKey<ShadFormState>();
  
  @override
  Widget build(BuildContext context) {
    return ShadForm(
      key: formKey,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ShadInputFormField(
              id: 'name',
              label: const Text('Name'),
              placeholder: const Text('Dependency'),
              description: const Text("The name for the dependency"),
              validator: (v) {
                if (v.length < 2) {
                  return 'Name must be at least 2 characters.';
                }
                return null;
              },
            ),
            ShadInputFormField(
              id: 'version',
              label: const Text('Version'),
              placeholder: const Text('0.0.0'),
              description: const Text("The version of the dependency (optional)"),
            ),
            ShadInputFormField(
              id: 'link',
              label: const Text('Link'),
              placeholder: const Text('https://dependency.com ...'),
              description: const Text("The link to the dependency (optional)"),
            ),
            const SizedBox(height: 16),
            ShadButton(
              child: const Text('Add'),
              onPressed: () {
                if (formKey.currentState!.saveAndValidate()){
                    widget.onAdd(
                      Dependency(
                        formKey.currentState!.value["name"],
                        formKey.currentState!.value["version"],
                        formKey.currentState!.value["link"]
                      )
                    );
                } else {
                  ShadToaster.of(context).show(
                    ShadToast(
                      title: const Text('Unable to add requirement'),
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
    );
  }
}