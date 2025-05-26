import 'package:cowflies/on_start.dart';
import 'package:flutter/material.dart';

const title = "Cow Flies";

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: title, home: OnStart());
  }
}
