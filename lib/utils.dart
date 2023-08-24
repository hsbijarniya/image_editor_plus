import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';

class ImageUtils {
  static Future<Uint8List> convert<InputImageType>(
    InputImageType image, {
    String format = 'jpeg',
    int quality = 80,
  }) async {
    Uint8List imageBytes;

    if (InputImageType is Uint8List) {
      imageBytes = image as Uint8List;
    } else if (InputImageType is String) {
      imageBytes = File(image as String).readAsBytesSync();
    } else {
      throw Exception('Image must be a Uint8List or path.');
    }

    var formatMap = {
      'jpeg': ImageOutputType.jpg,
      'jpg': ImageOutputType.jpg,
      'png': ImageOutputType.png,
      'webp|jpg': ImageOutputType.webpThenJpg,
      'webp|png': ImageOutputType.webpThenPng,
    };

    var input = ImageFile(
      filePath: 'temp.jpg',
      rawBytes: imageBytes,
    );

    var config = Configuration(
      outputType: formatMap[format]!,
      useJpgPngNativeCompressor: true,
      quality: quality,
    );

    final param = ImageFileConfiguration(input: input, config: config);
    final output = await compressor.compress(param);

    return output.rawBytes;
  }

  static Future<List<Uint8List>> convertAll<InputImageType>(
    List<InputImageType> images, {
    String format = 'jpeg',
    int quality = 80,
  }) async {
    List<Uint8List> outputs = [];

    for (var image in images) {
      outputs.add(await convert<InputImageType>(
        image,
        format: format,
        quality: quality,
      ));
    }

    return outputs;
  }
}
