import 'package:flutter/material.dart';

class TextView extends StatefulWidget {
  final double left;
  final double top;
  final Function onTap;
  final Function onUpdate;
  final Map details;

  const TextView({
    Key? key,
    required this.left,
    required this.top,
    required this.onTap,
    required this.onUpdate,
    required this.details,
  }) : super(key: key);
  @override
  _TextViewState createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {
  double initialSize = 0;
  double initialRotation = 0;

  @override
  Widget build(BuildContext context) {
    initialSize = widget.details['size'] ?? 0.0;
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
                initialSize + detail.scale * (detail.scale > 1 ? 1 : -1);

            print('angle');
            print(detail.rotation);
            widget.details['rotation'] = detail.rotation;
          }

          widget.onUpdate();
        },
        child: Transform.rotate(
          angle: widget.details['rotation'] ?? 0.0,
          child: Container(
            padding: const EdgeInsets.all(64),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: widget.details['background'].withAlpha(
                    widget.details['backgroundTransparency'].toInt()),
                borderRadius: BorderRadius.circular(8),
              ),
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
      ),
    );
  }
}
