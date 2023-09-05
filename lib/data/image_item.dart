import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageItem {
  int width = 300;
  int height = 300;
  Uint8List image = Uint8List.fromList([]);
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
      loader.complete(true);
    } else if (imageFile is Uint8List) {
      image = imageFile;
      decodedImage = await decodeImageFromList(imageFile);
    } else {
      image = await imageFile.readAsBytes();
      decodedImage = await decodeImageFromList(image);
    }

    // image was decoded
    if (decodedImage != null) {
      // print(['height', viewportSize.height, decodedImage.height]);
      // print(['width', viewportSize.width, decodedImage.width]);

      height = decodedImage.height;
      width = decodedImage.width;

      loader.complete(decodedImage);
    }

    return true;
  }
}
