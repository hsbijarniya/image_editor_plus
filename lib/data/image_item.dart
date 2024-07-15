import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageItem {
  int width = 1;
  int height = 1;
  Uint8List bytes = Uint8List.fromList([]);
  Completer<bool> loader = Completer<bool>();

  ImageItem([dynamic image]) {
    if (image != null) load(image);
  }

  Future load(dynamic image) async {
    loader = Completer<bool>();

    if (image is ImageItem) {
      bytes = image.bytes;

      height = image.height;
      width = image.width;

      return loader.complete(true);
    } else if (image is Uint8List) {
      bytes = image;
      var decodedImage = await decodeImageFromList(bytes);

      height = decodedImage.height;
      width = decodedImage.width;

      return loader.complete(true);
    } else if (image is XFile) {
      bytes = await image.readAsBytes();
      var decodedImage = await decodeImageFromList(bytes);

      height = decodedImage.height;
      width = decodedImage.width;

      return loader.complete(true);
    } else {
      return loader.complete(false);
    }
  }

  static ImageItem fromJson(Map json) {
    var image = ImageItem(json['bytes']);

    image.width = json['width'];
    image.height = json['height'];

    return image;
  }

  Map toJson() {
    return {
      'height': height,
      'width': width,
      'bytes': bytes,
    };
  }
}
