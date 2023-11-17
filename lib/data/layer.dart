import 'package:flutter/material.dart';
import 'package:image_editor_plus/data/image_item.dart';

/// Layer class with some common properties
class Layer {
  Offset offset;
  late double rotation, scale, opacity;

  Layer({
    this.offset = const Offset(64, 64),
    this.opacity = 1,
    this.rotation = 0,
    this.scale = 1,
  });

  copyFrom(Map json) {
    offset = Offset(json['offset'][0], json['offset'][1]);
    opacity = json['opacity'];
    rotation = json['rotation'];
    scale = json['scale'];
  }

  static Layer fromJson(Map json) {
    switch (json['type']) {
      case 'BackgroundLayer':
        return BackgroundLayerData.fromJson(json);
      case 'EmojiLayer':
        return EmojiLayerData.fromJson(json);
      case 'ImageLayer':
        return ImageLayerData.fromJson(json);
      case 'LinkLayer':
        return LinkLayerData.fromJson(json);
      case 'TextLayer':
        return TextLayerData.fromJson(json);
      case 'BackgroundBlurLayer':
        return BackgroundBlurLayerData.fromJson(json);
      default:
        return Layer();
    }
  }

  Map toJson() {
    return {
      'offset': [offset.dx, offset.dy],
      'opacity': opacity,
      'rotation': rotation,
      'scale': scale,
    };
  }
}

/// Attributes used by [BackgroundLayer]
class BackgroundLayerData extends Layer {
  ImageItem image;

  BackgroundLayerData({
    required this.image,
  });

  static BackgroundLayerData fromJson(Map json) {
    return BackgroundLayerData(
      image: ImageItem.fromJson(json['image']),
    );
  }

  @override
  Map toJson() {
    return {
      'type': 'BackgroundLayer',
      'image': image.toJson(),
    };
  }
}

/// Attributes used by [EmojiLayer]
class EmojiLayerData extends Layer {
  String text;
  double size;

  EmojiLayerData({
    this.text = '',
    this.size = 64,
    super.offset,
    super.opacity,
    super.rotation,
    super.scale,
  });

  static EmojiLayerData fromJson(Map json) {
    var layer = EmojiLayerData(
      text: json['text'],
      size: json['size'],
    );

    layer.copyFrom(json);
    return layer;
  }

  @override
  Map toJson() {
    return {
      'type': 'EmojiLayer',
      'text': text,
      'size': size,
      ...super.toJson(),
    };
  }
}

/// Attributes used by [ImageLayer]
class ImageLayerData extends Layer {
  ImageItem image;
  double size;

  ImageLayerData({
    required this.image,
    this.size = 64,
    super.offset,
    super.opacity,
    super.rotation,
    super.scale,
  });

  static ImageLayerData fromJson(Map json) {
    var layer = ImageLayerData(
      image: ImageItem.fromJson(json['image']),
      size: json['size'],
    );

    layer.copyFrom(json);
    return layer;
  }

  @override
  Map toJson() {
    return {
      'type': 'ImageLayer',
      'image': image.toJson(),
      'size': size,
      ...super.toJson(),
    };
  }
}

/// Attributes used by [TextLayer]
class TextLayerData extends Layer {
  String text;
  double size;
  Color color, background;
  double backgroundOpacity;
  TextAlign align;

  TextLayerData({
    required this.text,
    this.size = 64,
    this.color = Colors.white,
    this.background = Colors.transparent,
    this.backgroundOpacity = 0,
    this.align = TextAlign.left,
    super.offset,
    super.opacity,
    super.rotation,
    super.scale,
  });

  static TextLayerData fromJson(Map json) {
    var layer = TextLayerData(
      text: json['text'],
      size: json['size'],
      color: Color(json['color']),
      background: Color(json['background']),
      backgroundOpacity: json['backgroundOpacity'],
      align: TextAlign.values.firstWhere((e) => e.name == json['align']),
    );

    layer.copyFrom(json);
    return layer;
  }

  @override
  Map toJson() {
    return {
      'type': 'TextLayer',
      'text': text,
      'size': size,
      'color': color.value,
      'background': background.value,
      'backgroundOpacity': backgroundOpacity,
      'align': align.name,
      ...super.toJson(),
    };
  }
}

/// Attributes used by [TextLayer]
class LinkLayerData extends Layer {
  String text;
  double size;
  Color color, background;
  double backgroundOpacity;
  TextAlign align;

  LinkLayerData({
    required this.text,
    this.size = 64,
    this.color = Colors.white,
    this.background = Colors.transparent,
    this.backgroundOpacity = 0,
    this.align = TextAlign.left,
    super.offset,
    super.opacity,
    super.rotation,
    super.scale,
  });

  static LinkLayerData fromJson(Map json) {
    var layer = LinkLayerData(
      text: json['text'],
      size: json['size'],
      color: Color(json['color']),
      background: Color(json['background']),
      backgroundOpacity: json['backgroundOpacity'],
      align: TextAlign.values.firstWhere((e) => e.name == json['align']),
    );

    layer.copyFrom(json);
    return layer;
  }

  @override
  Map toJson() {
    return {
      'type': 'LinkLayer',
      'text': text,
      'size': size,
      'color': color.value,
      'background': background.value,
      'backgroundOpacity': backgroundOpacity,
      'align': align.name,
      ...super.toJson(),
    };
  }
}

/// Attributes used by [BackgroundBlurLayer]
class BackgroundBlurLayerData extends Layer {
  Color color;
  double radius;

  BackgroundBlurLayerData({
    required this.color,
    required this.radius,
    super.offset,
    super.opacity,
    super.rotation,
    super.scale,
  });

  static BackgroundBlurLayerData fromJson(Map json) {
    var layer = BackgroundBlurLayerData(
      color: Color(json['color']),
      radius: json['radius'],
    );

    layer.copyFrom(json);
    return layer;
  }

  @override
  Map toJson() {
    return {
      'type': 'BackgroundBlurLayer',
      'color': color.value,
      'radius': radius,
      ...super.toJson(),
    };
  }
}
