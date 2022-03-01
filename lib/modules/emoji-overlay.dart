import 'package:flutter/material.dart';
import '../image_editor_plus.dart';

class EmojiOverlay extends StatefulWidget {
  final int index;
  final Map mapValue;
  final Function onUpdate;

  const EmojiOverlay({
    Key? key,
    required this.mapValue,
    required this.index,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _EmojiOverlayState createState() => _EmojiOverlayState();
}

class _EmojiOverlayState extends State<EmojiOverlay> {
  @override
  void initState() {
    //  slider = widget.sizevalue;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
      ),
      child: Column(
        children: [
          SizedBox(height: 10),
          Center(
            child: Text(
              'Size Adjust'.toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Divider(
              // height: 1,
              ),
          Slider(
              activeColor: Colors.white,
              inactiveColor: Colors.grey,
              value: layers[widget.index]['size'],
              min: 0.0,
              max: 100.0,
              onChangeEnd: (v) {
                setState(() {
                  layers[widget.index]['size'] = v.toDouble();
                  widget.onUpdate();
                });
              },
              onChanged: (v) {
                setState(() {
                  slider = v;
                  // print(v.toDouble());
                  layers[widget.index]['size'] = v.toDouble();
                  widget.onUpdate();
                });
              }),
          SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  removedLayers.add(layers.removeAt(widget.index));
                  Navigator.pop(context);
                  widget.onUpdate();
                  // back(context);
                  // setState(() {});
                },
                child: Text(
                  'Remove',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
