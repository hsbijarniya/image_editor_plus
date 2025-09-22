import 'dart:isolate';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

Map<int, img.Image> _cachedWatermark = {};

Future<Uint8List> applyWatermark({
  required Uint8List image,
  required Uint8List watermark,
  required int heightPercentage,
  String position = 'bottomRight',
}) async {
  /// Load the input image and watermark image
  img.Image inputImage =
      await Isolate.run<img.Image>(() => img.decodeImage(image)!);

  /// Calculate the watermark size based on the percentage of the input image height
  int watermarkHeight = (inputImage.height * heightPercentage) ~/ 100;

  if (!_cachedWatermark.containsKey(watermarkHeight)) {
    img.Image watermarkImage =
        await Isolate.run<img.Image>(() => img.decodeImage(watermark)!);

    /// Resize the watermark to the calculated size
    _cachedWatermark[watermarkHeight] = img.copyResize(
      watermarkImage,
      maintainAspect: true,
      height: watermarkHeight,
    );
  }

  img.Image resizedWatermark = _cachedWatermark[watermarkHeight]!;

  /// Position the watermark based on the specified position
  int x, y;
  switch (position) {
    case 'topLeft':
      x = 0;
      y = 0;
      break;
    case 'topRight':
      x = inputImage.width - resizedWatermark.width;
      y = 0;
      break;
    case 'bottomLeft':
      x = 0;
      y = inputImage.height - resizedWatermark.height;
      break;
    case 'bottomRight':
      x = inputImage.width - resizedWatermark.width;
      y = inputImage.height - resizedWatermark.height;
      break;
    default:
      x = (inputImage.width - resizedWatermark.width) ~/ 2;
      y = (inputImage.height - resizedWatermark.height) ~/ 2;
      break;
  }

  /// Apply the watermark to the input image
  return await Isolate.run<Uint8List>(
    () => img.encodeJpg(
      img.compositeImage(inputImage, resizedWatermark, dstX: x, dstY: y),
      quality: 85,
    ),
  );
}
