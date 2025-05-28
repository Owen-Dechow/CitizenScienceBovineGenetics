import 'package:cowflies/image_select.dart';
import 'package:cowflies/main.dart';
import 'package:cowflies/submit_animal.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const keySoftwareBackupSent = "softwareBackupSent";
const keyLastInfoScreenShow = "lastInfoScreenShow";
const keyEmail = "email";

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
  const OnStart({super.key});

  @override
  State<OnStart> createState() => _OnStartState();
}

class _OnStartState extends State<OnStart> {
  bool? _showing;
  SharedPreferences? _prefs;
  bool _softwareBackupSent = false;
  String? _email;
  final _formKey = GlobalKey<FormState>();

  setPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _prefs = prefs;
      _softwareBackupSent = prefs.getBool(keySoftwareBackupSent) ?? false;
      _email = prefs.getString(keyEmail);
    });
  }

  Scaffold startScreen() {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 400),
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 10,
                  children: [
                    SizedBox(height: 40),
                    Expanded(child: SelectableText("* = required field.")),
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
                                  labelText:
                                      "*Did you send in a software backup?",
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
                                  DropdownMenuItem(
                                    value: true,
                                    child: Text("Yes"),
                                  ),
                                  DropdownMenuItem(
                                    value: false,
                                    child: Text("No"),
                                  ),
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
                    TextFormField(
                      decoration: InputDecoration(
                        labelText:
                            "${_softwareBackupSent == true ? "*" : ""}Email",
                      ),
                      initialValue: _email,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });

                        _prefs?.setString(keyEmail, _email!);
                      },
                      validator: (value) {
                        if (_softwareBackupSent == true) {
                          if (value == null || value == "") {
                            return "You must provide a valid email if you are sending in a software backup.";
                          }
                        }

                        if (value != null && value != "") {
                          if (!RegExp(
                            r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
                          ).hasMatch(value)) {
                            return "Invalid email. You do not need to send in email if you are not sending in software backup.";
                          }
                        }

                        return null;
                      },
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
                            if (_formKey.currentState!.validate()) {
                              _showing = false;
                            }
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
