import 'package:flutter/material.dart'
    show IconButton, Colors, BorderRadius, Radius, RoundedRectangleBorder;

const keySoftwareBackupSent = "softwareBackupSent";
const keyEmail = "email";
const keyLastInfoScreenShow = "lastInfoScreenShow";

const appTitle = "Citizen Science Bovine Genetics";
const fliesTitle = "Cow Flies";
const geneticsTitle = "Genetic Abnormalities";

const license = """
MIT License

Copyright (c) 2025 Owen Dechow

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
""";

const softwareBackupsEmail = "john.doe@gmail.com";

const softwareBackups = """
If you use a herd management software (Dairy Comp, PCDart, etc.), please email a backup copy to $softwareBackupsEmail.

We will use the herd management information to construct pedigrees and determine association of fly score with production and health events.

If you submit a herd software backup, you will not need to submit a sire NAAB code for each picture.
""";

const privacyStatement = """
$appTitle Privacy Statement

$appTitle respects your privacy and is committed to protecting your personal information.

The data we collect:
- Images selected by users
- Animal-related information provided by users
- Email addresses provided users
- Your data is used solely for the intended purpose and is not shared without consent.
""";

final buttonStyle = IconButton.styleFrom(
  backgroundColor: Colors.red,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
  ),
);
