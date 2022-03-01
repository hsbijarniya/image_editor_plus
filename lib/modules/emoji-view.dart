import 'package:flutter/material.dart';

class EmojiView extends StatefulWidget {
  final double left;
  final double top;
  final Function onTap;
  final Map details;
  final Function() onUpdate;

  const EmojiView({
    Key? key,
    required this.left,
    required this.top,
    required this.onTap,
    required this.onUpdate,
    required this.details,
  }) : super(key: key);
  @override
  _EmojiViewState createState() => _EmojiViewState();
}

class _EmojiViewState extends State<EmojiView> {
  double initialSize = 0;
  double initialRotation = 0;

  @override
  Widget build(BuildContext context) {
    initialSize = widget.details['size'];
    initialRotation = widget.details['rotation'] ?? 0.0;

    return Positioned(
      left: widget.left,
      top: widget.top,
      child: GestureDetector(
        onTap: () {
          widget.onTap();
        },
        onScaleUpdate: (detail) {
          if (detail.pointerCount == 1) {
            widget.details['offset'] = Offset(
              widget.details['offset'].dx + detail.focalPointDelta.dx,
              widget.details['offset'].dy + detail.focalPointDelta.dy,
            );
          } else if (detail.pointerCount == 2) {
            widget.details['size'] =
                initialSize + detail.scale * 5 * (detail.scale > 1 ? 1 : -1);
          }

          widget.onUpdate();
        },
        child: Transform.rotate(
          angle: widget.details['rotation'] ?? 0.0,
          child: Container(
            padding: const EdgeInsets.all(64),
            child: Text(
              widget.details['value'].toString(),
              textAlign: widget.details['align'],
              style: TextStyle(
                color: widget.details['color'],
                fontSize: widget.details['size'],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
