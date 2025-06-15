import 'dart:io' show File;

import 'package:cowflies/url.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'
    show Position, Geolocator, LocationPermission;
import 'package:http/http.dart'
    show MultipartFile, MultipartRequest, Response, StreamedResponse;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import 'const.dart' show buttonStyle, keyEmail, keySoftwareBackupSent;

class CowFliesSubmitForm extends StatefulWidget {
  final File image;
  final Function() onRetakeImage;
  final Function(bool) toggleSubmit;
  final SharedPreferences prefs;

  const CowFliesSubmitForm({
    super.key,
    required this.image,
    required this.onRetakeImage,
    required this.toggleSubmit,
    required this.prefs,
  });

  @override
  State<CowFliesSubmitForm> createState() => _CowFliesSubmitFormState();
}

class _CowFliesSubmitFormState extends State<CowFliesSubmitForm> {
  final _formKey = GlobalKey<FormState>();
  String? _animalId;
  bool? _softwareBackupSent;
  String? _sireId;
  int? _cowFlies;
  int? _cowValue;
  int? _lactationNumber;
  int? _ringworm;
  bool _side = true;

  submit() async {
    widget.toggleSubmit(true);

    if (_formKey.currentState!.validate()) {
      final contextR = context;
      ScaffoldMessenger.of(
        contextR,
      ).showSnackBar(const SnackBar(content: Text("Submitting")));

      final loc = await getLocation();

      final uri = Uri.parse(serverUrl).replace(
        queryParameters: {
          "animalId": _animalId,
          "softwareBackupSent": _softwareBackupSent.toString(),
          "sireId": _sireId,
          "cowFlies": _cowFlies == null ? "" : _cowFlies.toString(),
          "cowValue": _cowValue == null ? "" : _cowValue.toString(),
          "lactationNumber":
              _lactationNumber == null ? "" : _lactationNumber.toString(),
          "hadRingworm": _ringworm == null ? "" : _ringworm.toString(),
          "long": loc == null ? "" : loc.longitude.toString(),
          "lat": loc == null ? "" : loc.latitude.toString(),
          "timestamp": DateTime.now().toIso8601String(),
          "sideImage": _side.toString(),
          "DBTarget": "cowflies",
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

  @override
  void initState() {
    super.initState();

    _softwareBackupSent = widget.prefs.getBool(keySoftwareBackupSent);
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

                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText:
                            "Is this a picture of the animal's side or face.",
                      ),
                      value: _side,
                      items: [
                        DropdownMenuItem(value: true, child: Text("Side")),
                        DropdownMenuItem(value: false, child: Text("Face")),
                      ],
                      onChanged:
                          (value) => setState(() {
                            _side = value ?? true;
                          }),
                    ),

                    /// How many flies are on this cow
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText:
                            "How many flies does this animal have on its ${_side ? 'side' : 'body'}?",
                      ),
                      value: _cowFlies,
                      items: const [
                        DropdownMenuItem(value: 1, child: Text("None")),
                        DropdownMenuItem(value: 2, child: Text("Few")),
                        DropdownMenuItem(value: 3, child: Text("Moderate")),
                        DropdownMenuItem(value: 4, child: Text("Many")),
                        DropdownMenuItem(value: 5, child: Text("Heavy")),
                      ],
                      onChanged:
                          (value) => setState(() {
                            _cowFlies = value;
                          }),
                    ),

                    /// Lactation #
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: "How many lactations has this animal had?",
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 0,
                          child: Text("No Lactations"),
                        ),
                        DropdownMenuItem(
                          value: 1,
                          child: Text("First Lactation"),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text("No Second Lactation"),
                        ),
                        DropdownMenuItem(
                          value: 3,
                          child: Text("Third Lactation"),
                        ),
                        DropdownMenuItem(
                          value: 4,
                          child: Text("4+ Lactations"),
                        ),
                      ],
                      onChanged:
                          (value) => setState(() {
                            _lactationNumber = value;
                            if (value == 0) {
                              _cowValue = null;
                            } else {
                              _ringworm = null;
                            }
                          }),
                    ),

                    /// I like this cow / Ringworm
                    _lactationNumber == 0
                        ? DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: "Has this animal had ringworm before?",
                          ),
                          items: [
                            DropdownMenuItem(value: 0, child: Text("No")),
                            DropdownMenuItem(value: 1, child: Text("Yes")),
                            DropdownMenuItem(
                              value: 2,
                              child: Text("Yes, many times"),
                            ),
                          ],
                          onChanged:
                              (value) => setState(() {
                                _ringworm = value;
                              }),
                        )
                        : DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: "How much do you like this animal?",
                          ),

                          value: _cowValue,
                          items: const [
                            DropdownMenuItem(
                              value: 1,
                              child: Text("Strongly Dislike"),
                            ),
                            DropdownMenuItem(value: 2, child: Text("Dislike")),
                            DropdownMenuItem(
                              value: 3,
                              child: Text("Indifferent"),
                            ),
                            DropdownMenuItem(value: 4, child: Text("Like")),
                            DropdownMenuItem(
                              value: 5,
                              child: Text("Strongly Like"),
                            ),
                          ],
                          onChanged:
                              (value) => setState(() {
                                _cowValue = value;
                              }),
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
