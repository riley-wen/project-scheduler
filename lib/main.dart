import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_scheduler/data/routes.dart';
import 'package:project_scheduler/pages/unknownPage.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp.custom(
      themeMode: ThemeMode.dark,
      darkTheme: ShadThemeData(
        //brightness: Brightness.dark,
        colorScheme: const ShadSlateColorScheme.dark(),
      ),
      appBuilder: (context) {
        return MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            FlutterQuillLocalizations.delegate,
          ],
          theme: ThemeData.dark(),
          title: 'Project Scheduler',
          debugShowCheckedModeBanner: false,
          initialRoute: "/home",
          builder: (context, child) {
            return ShadAppBuilder(child: child!);
          },
          routes: Routes.routes.map((route, routeObj) => MapEntry(route, (BuildContext cxt) => routeObj.widget(cxt))),
          onGenerateRoute: (settings) {
            if(settings.name == null || !Routes.routes.keys.contains("${settings.name}")){
              return MaterialPageRoute(builder: (_) => UnknownPage());
            }
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (context, animation, secondaryAnimation) => Routes.routes[settings.name]!.widget(context),
              transitionsBuilder: (_, a, _, c) => FadeTransition(opacity: a, child: c)
            );
          },
        );
      },
    );
  }
}
