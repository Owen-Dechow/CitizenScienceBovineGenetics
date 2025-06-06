import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'
    show Position, LocationPermission, Geolocator;
import 'package:http/http.dart'
    show StreamedResponse, MultipartRequest, MultipartFile;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import 'const.dart' show buttonStyle, keySoftwareBackupSent, keyEmail;

class GeneticIssueSubmitForm extends StatefulWidget {
  final File image;
  final Function() onRetakeImage;
  final Function(bool) toggleSubmit;
  final SharedPreferences prefs;

  const GeneticIssueSubmitForm({
    super.key,
    required this.image,
    required this.onRetakeImage,
    required this.toggleSubmit,
    required this.prefs,
  });

  @override
  State<GeneticIssueSubmitForm> createState() => _GeneticIssueSubmitFormState();
}

class _GeneticIssueSubmitFormState extends State<GeneticIssueSubmitForm> {
  final _formKey = GlobalKey<FormState>();
  String? _animalId;
  String? _sireId;
  bool? _softwareBackupSent;

  Future<Position?> getLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return null;
    }

    LocationPermission permissionStatus = await Geolocator.checkPermission();
    if (permissionStatus == LocationPermission.deniedForever) {
      return null;
    }

    if (permissionStatus == LocationPermission.denied) {
      permissionStatus = await Geolocator.requestPermission();
      if (permissionStatus == LocationPermission.denied) {
        return null;
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  submit() async {
    widget.toggleSubmit(true);

    if (_formKey.currentState!.validate()) {
      final contextR = context;
      ScaffoldMessenger.of(
        contextR,
      ).showSnackBar(const SnackBar(content: Text("Submitting")));

      final loc = await getLocation();
      final uri = Uri.parse(
        "https://hiddenstring",
      ).replace(
        queryParameters: {
          "animalId": _animalId,
          "softwareBackupSent": _softwareBackupSent.toString(),
          "sireId": _sireId,
          "long": loc == null ? "" : loc.longitude.toString(),
          "lat": loc == null ? "" : loc.latitude.toString(),
          "timestamp": DateTime.now().toIso8601String(),
          "DBTarget": "geneticAnomily",
          "email": widget.prefs.getString(keyEmail) ?? "",
        },
      );

      MultipartRequest request = MultipartRequest("POST", uri);
      request.files.add(
        await MultipartFile.fromPath("image", widget.image.path),
      );

      StreamedResponse response = await request.send();

      if (response.statusCode != 200) {
        if (contextR.mounted) {
          ScaffoldMessenger.of(contextR).removeCurrentSnackBar();
          ScaffoldMessenger.of(contextR).showSnackBar(
            const SnackBar(
              content: Text(
                "An error occurred when submitting this animal. Please try again later.",
              ),
            ),
          );
        }
      } else {
        if (contextR.mounted) {
          widget.onRetakeImage();
          ScaffoldMessenger.of(contextR).removeCurrentSnackBar();
          ScaffoldMessenger.of(
            contextR,
          ).showSnackBar(const SnackBar(content: Text("Animal submitted.")));
        }
      }
    }

    widget.toggleSubmit(false);
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _softwareBackupSent = widget.prefs.getBool(keySoftwareBackupSent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.file(widget.image),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: widget.onRetakeImage,
                  style: buttonStyle,
                  child: Text("Retake Image"),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  spacing: 10.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText("* = required field."),
                    TextFormField(
                      decoration: InputDecoration(labelText: "*Animal Id/Name"),
                      autocorrect: false,
                      onChanged: (value) {
                        setState(() {
                          _animalId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is required.";
                        }
                        return null;
                      },
                    ),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText:
                            "${_softwareBackupSent == false ? '*' : ''}Sire NAAB Code",
                        hintText: "7HO12198",
                      ),
                      autocorrect: false,
                      onChanged:
                          (value) => setState(() {
                            _sireId = value;
                          }),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          if (_softwareBackupSent == false) {
                            return "This field is required if software backup is not sent.";
                          }
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: submit,
                        style: buttonStyle,
                        child: Text("Submit"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
