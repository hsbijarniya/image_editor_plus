import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../image_editor_plus.dart';
import 'colors_picker.dart';

class TextOverlay extends StatefulWidget {
  final int index;
  final Map mapValue;
  final Function onUpdate;

  const TextOverlay({
    Key? key,
    required this.mapValue,
    required this.index,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _TextOverlayState createState() => _TextOverlayState();
}

class _TextOverlayState extends State<TextOverlay> {
  @override
  void initState() {
    //  slider = widget.sizevalue;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 20),
              Text('Color', style: TextStyle(color: Colors.white))
                  .paddingLeft(16),
              Row(children: [
                SizedBox(width: 8),
                Expanded(
                  child: BarColorPicker(
                    width: 300,
                    thumbColor: Colors.white,
                    cornerRadius: 10,
                    pickMode: PickMode.Color,
                    colorListener: (int value) {
                      setState(() {
                        layers[widget.index]['color'] = Color(value);
                        widget.onUpdate();
                      });
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      layers[widget.index]['color'] = Colors.black;
                      widget.onUpdate();
                    });
                  },
                  child: Text('Reset', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 16),
              ]),
              SizedBox(height: 20),
              Text('Background Color', style: TextStyle(color: Colors.white))
                  .paddingLeft(16),
              Row(children: [
                SizedBox(width: 8),
                Expanded(
                  child: BarColorPicker(
                    width: 300,
                    thumbColor: Colors.white,
                    cornerRadius: 10,
                    pickMode: PickMode.Color,
                    colorListener: (int value) {
                      setState(() {
                        layers[widget.index]['background'] = Color(value);
                        widget.onUpdate();
                      });
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      layers[widget.index]['background'] = Colors.transparent;
                      widget.onUpdate();
                    });
                  },
                  child: Text('Reset', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 16),
              ]),
              SizedBox(height: 20),
              Text('Background Transparency',
                      style: TextStyle(color: Colors.white))
                  .paddingLeft(16),
              Row(children: [
                SizedBox(width: 8),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: 100,
                    divisions: 100,
                    value: layers[widget.index]['backgroundTransparency']
                        .toDouble(),
                    thumbColor: Colors.white,
                    onChanged: (double value) {
                      setState(() {
                        layers[widget.index]['backgroundTransparency'] =
                            value.toInt();
                        widget.onUpdate();
                      });
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      layers[widget.index]['backgroundTransparency'] = 0;
                      widget.onUpdate();
                    });
                  },
                  child: Text('Reset', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 16),
              ]),
            ]),
          ),
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
