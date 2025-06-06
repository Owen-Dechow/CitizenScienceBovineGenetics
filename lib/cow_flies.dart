import 'dart:io' show File;

import 'package:cowflies/submitting.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import 'cow_flies_submit_form.dart' show CowFliesSubmitForm;
import 'image_select.dart' show PickImageScreen;

class CowFlies extends StatefulWidget {
  final SharedPreferences prefs;
  const CowFlies({super.key, required this.prefs});

  @override
  State<CowFlies> createState() => _CowFliesState();
}

class _CowFliesState extends State<CowFlies> {
  File? _image;
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _image == null
              ? PickImageScreen(
                subtitle: "Select image of animal for fly counting.",
                onImgSelected: (file) {
                  setState(() {
                    _image = file;
                  });
                },
              )
              : Submitting(
                toggled: _submitting,
                child: CowFliesSubmitForm(
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
