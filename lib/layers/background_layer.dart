import 'package:flutter/material.dart';
import 'package:image_editor_plus/data/layer.dart';

/// Main layer
class BackgroundLayer extends StatefulWidget {
  final BackgroundLayerData layerData;
  final VoidCallback? onUpdate;

  const BackgroundLayer({
    Key? key,
    required this.layerData,
    this.onUpdate,
  }) : super(key: key);

  @override
  State<BackgroundLayer> createState() => _BackgroundLayerState();
}

class _BackgroundLayerState extends State<BackgroundLayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.layerData.file.width.toDouble(),
      height: widget.layerData.file.height.toDouble(),
      // color: black,
      padding: EdgeInsets.zero,
      child: Image.memory(widget.layerData.file.image),
    );
  }
}
