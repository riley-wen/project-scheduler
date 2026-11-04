import 'package:flutter/material.dart';
import 'package:project_scheduler/pages/createprojectpage.dart';
import 'package:project_scheduler/pages/homepage.dart';

/// Class for storing routes provided to the main [MaterialApp]. 
/// 
/// Routes are intended to and must always start with a '/' before the route name. Objects are not
/// intended to be instantiated outside static final fields within the class. If intending to make 
/// new routes outside of this class, consider using [MaterialPageRoute] to create independent
/// unnamed pages instead.
final class Routes {
  Widget Function(BuildContext) widget;
  String name;
  Widget Function(BuildContext)? image;
  Routes({required this.widget, required this.name, this.image});
  
  static void navigate(BuildContext context, String routeName){
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  /// Constant mappings for primary routes that do not accept incoming route data.
  static final Map<String, Routes> routes = {
    "/home": Routes(
      widget: (BuildContext context) => const HomePage(),
      name: "Home",
      image: (BuildContext context) => Icon(
        Icons.home,
        color: Theme.of(context).colorScheme.onSurface,
      )
    ),
    "/createproject": Routes( // figure out dynamic routing for editing / creatubg
      widget: (BuildContext context) => const CreateProjectPage(),
      name: "CreateProject",
      image: (BuildContext context) => Icon(
        Icons.home,
        color: Theme.of(context).colorScheme.onSurface,
      )
    ),
    
  };
}