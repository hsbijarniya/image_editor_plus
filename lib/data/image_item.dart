import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

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
      final buffer = await ImmutableBuffer.fromUint8List(imageFile);
      final codec = await instantiateImageCodecFromBuffer(buffer);
      final frame = await codec.getNextFrame();
      decodedImage = frame.image;
    } else {
      image = await imageFile.readAsBytes();
      final buffer = await ImmutableBuffer.fromUint8List(image);
      final codec = await instantiateImageCodecFromBuffer(buffer);
      final frame = await codec.getNextFrame();
      decodedImage = frame.image;
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
