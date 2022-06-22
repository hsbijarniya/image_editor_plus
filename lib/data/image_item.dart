import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';

class ImageItem {
  int width = 300;
  int height = 300;
  Uint8List image = Uint8List.fromList([]);
  double viewportRatio = 1;
  Completer loader = Completer();

  ImageItem([dynamic img]) {
    if (img != null) load(img);
  }

  Future get status => loader.future;

  Future load(dynamic imageFile) async {
    loader = Completer();

    dynamic decodedImage;

    if (imageFile is ImageItem) {
      height = imageFile.height;
      width = imageFile.width;

      image = imageFile.image;
      viewportRatio = imageFile.viewportRatio;

      loader.complete(true);
    } else if (imageFile is File || imageFile is XFile) {
      image = await imageFile.readAsBytes();
      decodedImage = await decodeImageFromList(image);
    } else {
      image = imageFile;
      decodedImage = await decodeImageFromList(imageFile);
    }

    // image was decoded
    if (decodedImage != null) {
      // print(['height', viewportSize.height, decodedImage.height]);
      // print(['width', viewportSize.width, decodedImage.width]);

      height = decodedImage.height;
      width = decodedImage.width;
      viewportRatio = viewportSize.height / height;

      loader.complete(decodedImage);
    }

    return true;
  }
}
