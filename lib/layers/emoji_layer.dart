import 'package:flutter/material.dart';
import 'package:image_editor_plus/data/layer.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_editor_plus/modules/emoji_layer_overlay.dart';

/// Emoji layer
class EmojiLayer extends StatefulWidget {
  final EmojiLayerData layerData;
  final VoidCallback? onUpdate;
  final bool editable;

  const EmojiLayer({
    super.key,
    required this.layerData,
    this.onUpdate,
    this.editable = false,
  });

  @override
  createState() => _EmojiLayerState();
}

class _EmojiLayerState extends State<EmojiLayer> {
  double initialSize = 0;
  double initialRotation = 0;

  @override
  Widget build(BuildContext context) {
    initialSize = widget.layerData.size;
    initialRotation = widget.layerData.rotation;

    return Positioned(
      left: widget.layerData.offset.dx,
      top: widget.layerData.offset.dy,
      child: GestureDetector(
        onTap: widget.editable
            ? () {
                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return EmojiLayerOverlay(
                      index: layers.indexOf(widget.layerData),
                      layer: widget.layerData,
                      onUpdate: () {
                        if (widget.onUpdate != null) widget.onUpdate!();
                        setState(() {});
                      },
                    );
                  },
                );
              }
            : null,
        onScaleUpdate: widget.editable
            ? (detail) {
                if (detail.pointerCount == 1) {
                  widget.layerData.offset = Offset(
                    widget.layerData.offset.dx + detail.focalPointDelta.dx,
                    widget.layerData.offset.dy + detail.focalPointDelta.dy,
                  );
                } else if (detail.pointerCount == 2) {
                  widget.layerData.size = initialSize +
                      detail.scale * 5 * (detail.scale > 1 ? 1 : -1);
                }

                setState(() {});
              }
            : null,
        child: Transform.rotate(
          angle: widget.layerData.rotation,
          child: Container(
            padding: const EdgeInsets.all(64),
            child: Text(
              widget.layerData.text.toString(),
              style: TextStyle(
                fontSize: widget.layerData.size,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
