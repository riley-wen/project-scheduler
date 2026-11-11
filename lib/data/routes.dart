import 'package:flutter/material.dart';
import 'package:project_scheduler/pages/createprojectpage.dart';
import 'package:project_scheduler/pages/editprojectpage/editprojectpage.dart';
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
  Routes({required this.widget, required this.name});
  
  static void navigate(BuildContext context, String routeName){
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  /// Constant mappings for primary routes that do not accept incoming route data.
  static final Map<String, Routes> routes = {
    "/home": Routes(
      widget: (BuildContext context) => HomePage(),
      name: "Home",
    ),
    "/createproject": Routes( // figure out dynamic routing for editing / creatubg
      widget: (BuildContext context) => CreateProjectPage(),
      name: "CreateProject",
    ),
    "/editproject": Routes(
      widget: (BuildContext context) => EditProjectPage(),
      name: "EditProject",
    )
    
  };
}