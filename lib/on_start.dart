import 'package:cowflies/submit_animal.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const prelude = """
This is the program prelude. This will give some general information about the program and what you are supposed to do with the program.

In general you can fill out the following fields.
""";

class OnStart extends StatefulWidget {
  @override
  State<OnStart> createState() => _OnStartState();
}

class _OnStartState extends State<OnStart> {
  bool? _showing;
  SharedPreferences? _prefs;

  setPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _prefs = prefs;
    });
  }

  Scaffold startScreen() {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          child: Text(prelude, textAlign: TextAlign.justify),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_prefs == null) {
      setPrefs();
    }

    if (_showing == null && _prefs != null) {
      setState(() {
        final lastShown = _prefs!.getInt("lastOnStartShow");
        if (lastShown == null) {
          _showing = true;
        } else if (DateTime.now()
            .subtract(Duration(days: 180))
            .isAfter(DateTime.fromMillisecondsSinceEpoch(lastShown))) {
          _showing = true;
        } else {
          _showing = false;
        }
      });
    }

    return _showing == null
        ? Scaffold()
        : _showing!
        ? startScreen()
        : SubmitAnimal();
  }
}
