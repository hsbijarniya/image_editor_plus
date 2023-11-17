import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:flutter/material.dart';

class OutputFormat {
  static const int

      /// get all layers in json
      json = 0x1,

      /// get merged layer in heic
      heic = 0x2,

      /// get merged layer in jpeg
      jpeg = 0x4,

      /// get merged layer in png
      png = 0x8,

      /// get merged layer in webp
      webp = 0x10;
}

class AspectRatio {
  final String title;
  final double? ratio;

  const AspectRatio({required this.title, this.ratio});
}

class CropOption {
  final bool reversible;

  /// List of availble ratios
  final List<AspectRatio> ratios;

  const CropOption({
    this.reversible = true,
    this.ratios = const [
      AspectRatio(title: 'Freeform'),
      AspectRatio(title: '1:1', ratio: 1),
      AspectRatio(title: '4:3', ratio: 4 / 3),
      AspectRatio(title: '5:4', ratio: 5 / 4),
      AspectRatio(title: '7:5', ratio: 7 / 5),
      AspectRatio(title: '16:9', ratio: 16 / 9),
    ],
  });
}

class BlurOption {
  const BlurOption();
}

class BrushOption {
  /// show background image on draw screen
  final bool showBackground;

  /// User will able to move, zoom drawn image
  /// Note: Layer may not be placed precisely
  final bool translatable;
  final List<BrushColor> colors;

  const BrushOption({
    this.showBackground = true,
    this.translatable = false,
    this.colors = const [
      BrushColor(color: Colors.black, background: Colors.white),
      BrushColor(color: Colors.white),
      BrushColor(color: Colors.blue),
      BrushColor(color: Colors.green),
      BrushColor(color: Colors.pink),
      BrushColor(color: Colors.purple),
      BrushColor(color: Colors.brown),
      BrushColor(color: Colors.indigo),
    ],
  });
}

class BrushColor {
  /// Color of brush
  final Color color;

  /// Background color while brush is active only be used when showBackground is false
  final Color background;

  const BrushColor({
    required this.color,
    this.background = Colors.black,
  });
}

class EmojiOption {
  const EmojiOption();
}

class FiltersOption {
  final List<ColorFilterGenerator>? filters;
  const FiltersOption({this.filters});
}

class FlipOption {
  const FlipOption();
}

class RotateOption {
  const RotateOption();
}

class TextOption {
  const TextOption();
}

class ImagePickerOption {
  final bool pickFromGallery, captureFromCamera;
  final int maxLength;

  const ImagePickerOption({
    this.pickFromGallery = false,
    this.captureFromCamera = false,
    this.maxLength = 99,
  });
}
