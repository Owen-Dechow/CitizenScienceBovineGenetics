import 'dart:io';
import 'package:cowflies/image_select.dart';
import 'package:cowflies/submit_animal_form.dart';
import 'package:flutter/material.dart';

class SubmitAnimal extends StatefulWidget {
  const SubmitAnimal({super.key});

  @override
  State<SubmitAnimal> createState() => _SubmitAnimalState();
}

class _SubmitAnimalState extends State<SubmitAnimal> {
  File? _image;
  bool submitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _image == null
              ? PickImageScreen(
                onImgSelected: (file) {
                  setState(() {
                    _image = file;
                  });
                },
              )
              : Stack(
                children: [
                  AbsorbPointer(
                    absorbing: submitting,
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 400),
                        alignment: Alignment.center,
                        child: SubmitAnimalForm(
                          image: _image!,
                          onRetakeImage:
                              () => setState(() {
                                _image = null;
                              }),
                          toggleSubmit:
                              () => setState(() {
                                submitting = !submitting;
                              }),
                        ),
                      ),
                    ),
                  ),
                  if (submitting)
                    Container(
                      color: Colors.black.withAlpha(120),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
    );
  }
}
