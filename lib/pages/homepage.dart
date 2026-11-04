import 'package:flutter/material.dart';
import 'package:project_scheduler/components/project_tab.dart';
import 'package:project_scheduler/data/project.dart';

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
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Stack(
          children: [
            ProjectTab()
          ],
        ),
      ),
    );
  }
}

