import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_scheduler/components/project_tab.dart';
import 'package:project_scheduler/data/project.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ShadButton(
        size: ShadButtonSize.lg,
        onPressed: () {
          Navigator.of(context).pushNamed("/createproject");
        },
        leading: const Icon(LucideIcons.folderEdit),
        child: const Text('New project'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Stack(
          children: [
            ProjectList(),
          ],
        ),
      ),
    );
  }
}

class ProjectList extends StatefulWidget {
  const ProjectList({super.key});

  @override
  State<StatefulWidget> createState() => _ProjectListState();
}
class _ProjectListState extends State<ProjectList> {
  List<Project> projectHeaders = [];
  late StreamSubscription headerListener;

  @override
  void initState() {
    headerListener = HeaderCache.instance.headerStream.listen((headers) {
      setState(() {
        projectHeaders = headers..sort((a, b) => -a.timeModified.compareTo(b.timeModified));
      });
    });

    super.initState();
    
  }
  @override
  void dispose() {
    headerListener.cancel();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12
        ),
        child: SingleChildScrollView(
          child: Column(
            spacing: 8.0,
            children: [
              ...projectHeaders.map(
                (header) => ProjectTab(project: header)
              ),
              if (projectHeaders.isEmpty) Text("No project created yet")
            ],
          )
        )
      ),

    );
  }

}
