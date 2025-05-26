import 'package:cowflies/image_select.dart';
import 'package:cowflies/main.dart';
import 'package:cowflies/submit_animal.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const keySoftwareBackupSent = "softwareBackupSent";
const keyLastInfoScreenShow = "lastInfoScreenShow";

const license = """
MIT License

Copyright (c) 2025 Owen Dechow

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
""";

const softwareBackupsEmail = "john.doe@gmail.com";

const softwareBackups = """
Lorem ipsum

Lorem ipsum dolor sit amit Lorem ipsum dolor sit amit Lorem ipsum dolor sit amit Lorem ipsum dolor sit amit Lorem ipsum dolor sit amit Lorem ipsum dolor sit amit Lorem ipsum dolor sit amit Lorem ipsum dolor sit amit Lorem ipsum dolor sit amit Lorem ipsum dolor sit amit Lorem ipsum dolor sit amit Lorem ipsum dolor sit amit Lorem ipsum dolor sit amit

Software backups can be sent to $softwareBackupsEmail
""";

class OnStart extends StatefulWidget {
  @override
  State<OnStart> createState() => _OnStartState();
}

class _OnStartState extends State<OnStart> {
  bool? _showing;
  SharedPreferences? _prefs;
  bool _softwareBackupSent = false;

  setPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _prefs = prefs;
      _softwareBackupSent = prefs.getBool(keySoftwareBackupSent) ?? false;
    });
  }

  Scaffold startScreen() {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: [
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text("Software Backups"),
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.all(20),
                      child: Column(
                        children: [
                          SelectableText(
                            softwareBackups,
                            textAlign: TextAlign.justify,
                          ),
                          DropdownButtonFormField(
                            value: _softwareBackupSent,
                            decoration: InputDecoration(
                              labelText: "Did you send in a software backup?",
                            ),
                            onChanged:
                                (value) => setState(() {
                                  if (value != null) {
                                    setState(() {
                                      _softwareBackupSent = value;
                                    });
                                    _prefs?.setBool(
                                      keySoftwareBackupSent,
                                      value,
                                    );
                                  }
                                }),
                            items: [
                              DropdownMenuItem(value: true, child: Text("Yes")),
                              DropdownMenuItem(value: false, child: Text("No")),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  initiallyExpanded: false,
                  title: Text("Copyright (c) 2025 Owen Dechow"),
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.all(20),
                      child: SelectableText(
                        license,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: buttonStyle,
                    onPressed: () {
                      _prefs?.setInt(
                        keyLastInfoScreenShow,
                        DateTime.now().millisecondsSinceEpoch,
                      );
                      setState(() {
                        _showing = false;
                      });
                    },
                    child: Text("Continue to $title"),
                  ),
                ),
                SelectableText(
                  "You may return to this menu by selecting the (?) on the bottom of the app.",
                ),
              ],
            ),
          ),
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
        final lastShown = _prefs!.getInt(keyLastInfoScreenShow);
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

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 10,
          children: [
            Text(
              "$title | Created by Owen Dechow",
              style: TextStyle(fontSize: 14),
            ),
            IconButton(
              style: buttonStyle,
              onPressed: () {
                setState(() {
                  _showing = true;
                });
              },
              icon: Icon(Icons.question_mark_rounded),
            ),
          ],
        ),
      ),
      body:
          _showing == null
              ? null
              : _showing!
              ? startScreen()
              : SubmitAnimal(prefs: _prefs!),
    );
  }
}
