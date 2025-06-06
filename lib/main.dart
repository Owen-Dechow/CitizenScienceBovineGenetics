import 'package:cowflies/page_manager.dart' show PageManager;
import 'package:flutter/material.dart';

import 'const.dart' show appTitle;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: appTitle, home: PageManager());
  }
}
