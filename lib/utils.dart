import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

var _formatMap = <String, CompressFormat>{
  'jpeg': CompressFormat.jpeg,
  'jpg': CompressFormat.jpeg,
  'heic': CompressFormat.heic,
  'png': CompressFormat.png,
  'webp': CompressFormat.webp,
};

class ImageUtils {
  static Future<Uint8List> convert(
    image, {
    String format = 'jpeg',
    int quality = 80,
  }) async {
    if (!_formatMap.containsKey(format)) {
      throw Exception('Output format not supported by library.');
    }

    if (image is Uint8List) {
      var output = await FlutterImageCompress.compressWithList(
        image,
        quality: quality,
        format: _formatMap[format]!,
        keepExif: true,
      );

      return output;
    } else if (image is String) {
      var output = await FlutterImageCompress.compressWithFile(
        image,
        quality: quality,
        format: _formatMap[format]!,
        keepExif: true,
      );

      if (output == null) {
        throw Exception('Unable to compress image file');
      }

      return output;
    } else {
      throw Exception('Image must be a Uint8List or path.');
    }
  }

  static Future<List<Uint8List>> convertAll(
    List images, {
    String format = 'jpeg',
    int quality = 80,
  }) async {
    List<Uint8List> outputs = [];

    for (var image in images) {
      outputs.add(await convert(
        image,
        format: format,
        quality: quality,
      ));
    }

    return outputs;
  }
}
