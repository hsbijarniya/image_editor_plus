import 'package:flutter/material.dart';
import 'package:image_editor_plus/data/image_item.dart';
import 'package:nb_utils/nb_utils.dart';

class Layer {}

class BackgroundLayerData extends Layer {
  ImageItem file;

  BackgroundLayerData({
    required this.file,
  });
}

class EmojiLayerData extends Layer {
  String text;
  late Offset offset;
  double rotation, size;

  EmojiLayerData({
    Key? key,
    this.offset = const Offset(64, 64),
    this.text = '',
    this.rotation = 0.0,
    this.size = 64,
  });
}

class ImageLayerData extends Layer {
  ImageItem image;
  late Offset offset;
  double rotation, size, scaleFactor;

  ImageLayerData({
    Key? key,
    required this.image,
    this.rotation = 0.0,
    this.size = 64,
    this.offset = const Offset(64, 64),
    this.scaleFactor = 1,
  });
}

class TextLayerData extends Layer {
  String text;
  late Offset offset;
  double rotation, size;
  Color color, background;
  int backgroundOpacity;
  TextAlign align;

  TextLayerData({
    required this.text,
    this.offset = const Offset(64, 64),
    this.rotation = 0.0,
    this.size = 64,
    this.color = white,
    this.background = Colors.transparent,
    this.backgroundOpacity = 1,
    this.align = TextAlign.left,
  });
}

class BackgroundBlurLayerData extends Layer {
  Color color;
  double radius, opacity;

  BackgroundBlurLayerData({
    required this.color,
    required this.radius,
    required this.opacity,
  });
}
