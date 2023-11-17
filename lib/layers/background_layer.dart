import 'package:flutter/material.dart';
import 'package:image_editor_plus/data/layer.dart';

/// Main layer
class BackgroundLayer extends StatefulWidget {
  final BackgroundLayerData layerData;
  final VoidCallback? onUpdate;
  final bool editable;

  const BackgroundLayer({
    super.key,
    required this.layerData,
    this.onUpdate,
    this.editable = false,
  });

  @override
  State<BackgroundLayer> createState() => _BackgroundLayerState();
}

class _BackgroundLayerState extends State<BackgroundLayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.layerData.image.width.toDouble(),
      height: widget.layerData.image.height.toDouble(),
      // color: black,
      padding: EdgeInsets.zero,
      child: Image.memory(widget.layerData.image.bytes),
    );
  }
}
