import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker, ImageSource;

import 'const.dart' show buttonStyle;

class PickImageScreen extends StatelessWidget {
  final Function(File) onImgSelected;
  final _picker = ImagePicker();
  final _width = 200.0;
  final String subtitle;

  PickImageScreen({
    super.key,
    required this.onImgSelected,
    required this.subtitle,
  });

  pickImage() async {
    final img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      onImgSelected(File(img.path));
    }
  }

  takeImage() async {
    final img = await _picker.pickImage(source: ImageSource.camera);
    if (img != null) {
      onImgSelected(File(img.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 10.0,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select Image", textScaler: TextScaler.linear(2.0)),
            Text(subtitle),
            SizedBox(
              width: _width,
              child: Column(
                spacing: 10.0,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FittedBox(
                      child: IconButton(
                        onPressed: takeImage,
                        icon: Icon(Icons.camera_alt_outlined),
                        style: buttonStyle,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: IconButton(
                      onPressed: pickImage,
                      icon: Icon(Icons.folder_outlined),
                      style: buttonStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
