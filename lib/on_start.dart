import 'package:cowflies/const.dart'
    show
        buttonStyle,
        fliesTitle,
        geneticsTitle,
        keyEmail,
        keyLastInfoScreenShow,
        keySoftwareBackupSent,
        license,
        softwareBackups,
        privacyStatement;
import 'package:cowflies/page_manager.dart' show Screen;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class OnStart extends StatefulWidget {
  final SharedPreferences prefs;
  final Function(Screen) setPage;
  final bool softwareBackupInitialOpen;
  const OnStart({
    super.key,
    required this.prefs,
    required this.setPage,
    required this.softwareBackupInitialOpen,
  });

  @override
  State<OnStart> createState() => _OnStartState();
}

class _OnStartState extends State<OnStart> {
  bool? _softwareBackupSent;
  String? _email;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    setState(() {
      _softwareBackupSent = widget.prefs.getBool(keySoftwareBackupSent);
      _email = widget.prefs.getString(keyEmail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 10,
                children: [
                  SizedBox(height: 40),
                  SelectableText("* = required field."),
                  ExpansionTile(
                    initiallyExpanded: widget.softwareBackupInitialOpen,
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
                                      widget.prefs.setBool(
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
                  ExpansionTile(
                    initiallyExpanded: false,
                    title: Text("Data Privacy Statement"),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: SelectableText(
                          privacyStatement,
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

                      widget.prefs.setString(keyEmail, _email!);
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
                  SelectableText(
                    "This email will be used to send research updates and sire PTAs.",
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: buttonStyle,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.prefs.setInt(
                            keyLastInfoScreenShow,
                            DateTime.now().millisecondsSinceEpoch,
                          );
                          widget.setPage(Screen.cowflies);
                        }
                      },
                      child: Text("Continue to $fliesTitle"),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: buttonStyle,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.prefs.setInt(
                            keyLastInfoScreenShow,
                            DateTime.now().millisecondsSinceEpoch,
                          );
                          widget.setPage(Screen.geneticIssue);
                        }
                      },
                      child: Text("Continue to $geneticsTitle"),
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
    );
  }
}
