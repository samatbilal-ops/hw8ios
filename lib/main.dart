import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'screens/registration_screen.dart';

/// Lab 8: lets mouse / touchpad drag scrollables too, so Pull-to-Refresh
/// can be tested in Chrome (on a phone touch works by default).
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoleStore',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const AppScrollBehavior(),
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepOrange),
      // Flow: Registration (Lab 6) -> Root with tabs (Lab 7) -> Detail (Lab 5)
      home: const RegistrationScreen(),
    );
  }
}
