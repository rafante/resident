import 'dart:async';
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';

// import 'detector_painters.dart';

class Identificador {
  static Future<String> identificarImagem(File image) async {
    final File imageFile = image;
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);

    final BarcodeDetector barcodeDetector =
        FirebaseVision.instance.barcodeDetector();
    final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();
    final LabelDetector labelDetector = FirebaseVision.instance.labelDetector();
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    final List<Barcode> barcodes =
        await barcodeDetector.detectInImage(visionImage);
    final List<Face> faces = await faceDetector.detectInImage(visionImage);
    final List<Label> labels = await labelDetector.detectInImage(visionImage);
    final VisionText visionText =
        await textRecognizer.detectInImage(visionImage);
    print('################################################################################');
    print(visionText.text);
    print('################################################################################');
    return barcodes[0].rawValue;
  }
}
