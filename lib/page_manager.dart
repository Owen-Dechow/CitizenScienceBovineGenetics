import 'package:cowflies/cow_flies.dart' show CowFlies;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import 'const.dart' show appTitle, buttonStyle, keyLastInfoScreenShow;
import 'genetic_issue.dart' show GeneticIssue;
import 'on_start.dart' show OnStart;

enum Screen { start, cowflies, geneticIssue }

class PageManager extends StatefulWidget {
  const PageManager({super.key});

  @override
  State<PageManager> createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager> {
  SharedPreferences? _prefs;
  Screen _page = Screen.start;
  bool openSoftwareBackup = true;

  setPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _prefs = prefs;
      final lastShown = prefs.getInt(keyLastInfoScreenShow);

      if (lastShown == null) {
        openSoftwareBackup = true;
      } else if (DateTime.now()
          .subtract(Duration(days: 180))
          .isAfter(DateTime.fromMillisecondsSinceEpoch(lastShown))) {
        openSoftwareBackup = true;
      } else {
        openSoftwareBackup = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 10,
          children: [
            Flexible(
              child: Text(
                "$appTitle | Created by Owen Dechow",
                style: TextStyle(fontSize: 14),
                softWrap: true,
                textAlign: TextAlign.right,
              ),
            ),
            IconButton(
              style: buttonStyle,
              onPressed: () {
                setState(() {
                  _page = Screen.start;
                });
              },
              icon: Icon(Icons.question_mark_rounded),
            ),
          ],
        ),
      ),
      body:
          _prefs != null
              ? switch (_page) {
                Screen.cowflies => CowFlies(prefs: _prefs!),
                Screen.start => OnStart(
                  softwareBackupInitialOpen: openSoftwareBackup,
                  prefs: _prefs!,
                  setPage:
                      (screen) => setState(() {
                        _page = screen;
                      }),
                ),
                Screen.geneticIssue => GeneticIssue(prefs: _prefs!),
              }
              : null,
    );
  }
}
