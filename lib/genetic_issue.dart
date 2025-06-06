import 'dart:io' show File;

import 'package:cowflies/genetic_issue_submit_form.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import 'image_select.dart' show PickImageScreen;
import 'submitting.dart' show Submitting;

class GeneticIssue extends StatefulWidget {
  final SharedPreferences prefs;
  const GeneticIssue({super.key, required this.prefs});

  @override
  State<GeneticIssue> createState() => _GeneticIssueState();
}

class _GeneticIssueState extends State<GeneticIssue> {
  File? _image;
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _image == null
              ? PickImageScreen(
                subtitle:
                    "Select image of animal that may have genetic disablity, disease, or anomily.",
                onImgSelected: (file) {
                  setState(() {
                    _image = file;
                  });
                },
              )
              : Submitting(
                toggled: _submitting,
                child: GeneticIssueSubmitForm(
                  prefs: widget.prefs,
                  image: _image!,
                  onRetakeImage:
                      () => setState(() {
                        _image = null;
                      }),
                  toggleSubmit:
                      (val) => setState(() {
                        _submitting = val;
                      }),
                ),
              ),
    );
  }
}
