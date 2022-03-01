import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import 'colors_picker.dart';

class TextEditorImage extends StatefulWidget {
  @override
  _TextEditorImageState createState() => _TextEditorImageState();
}

class _TextEditorImageState extends State<TextEditorImage> {
  TextEditingController name = TextEditingController();
  Color currentColor = Colors.black;
  double slider = 32.0;
  TextAlign? align;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          align == TextAlign.left
              ? IconButton(
                  icon: Icon(FontAwesomeIcons.alignLeft, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      align = null;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(FontAwesomeIcons.alignLeft),
                  onPressed: () {
                    setState(() {
                      align = TextAlign.left;
                    });
                  },
                ),
          align == TextAlign.center
              ? IconButton(
                  icon: Icon(FontAwesomeIcons.alignCenter, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      align = null;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(FontAwesomeIcons.alignCenter),
                  onPressed: () {
                    setState(() {
                      align = TextAlign.center;
                    });
                  },
                ),
          align == TextAlign.right
              ? IconButton(
                  icon: Icon(FontAwesomeIcons.alignRight, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      align = null;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(FontAwesomeIcons.alignRight),
                  onPressed: () {
                    setState(() {
                      align = TextAlign.right;
                    });
                  },
                ),
          IconButton(
            icon: Icon(Icons.check, color: white),
            onPressed: () {
              Navigator.pop(context, {
                'type': 'text',
                'background': Colors.transparent,
                'value': name.text,
                'color': currentColor,
                'size': slider.toDouble(),
                'align': align,
              });
            },
            color: Colors.black,
            padding: EdgeInsets.all(15),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              height: size.height / 2.2,
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Insert Your Message',
                  hintStyle: TextStyle(color: Colors.white),
                  alignLabelWithHint: true,
                ),
                scrollPadding: EdgeInsets.all(20.0),
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: 99999,
                style: TextStyle(
                  color: Colors.white,
                ),
                autofocus: true,
              ),
            ),
            Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  //   SizedBox(height: 20.0),
                  Text('Slider Color', style: TextStyle(color: white)),
                  //   SizedBox(height: 10.0),
                  Row(children: [
                    Expanded(
                      child: BarColorPicker(
                        width: 300,
                        thumbColor: Colors.white,
                        cornerRadius: 10,
                        pickMode: PickMode.Color,
                        colorListener: (int value) {
                          setState(() {
                            currentColor = Color(value);
                          });
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('Reset', style: TextStyle(color: white)),
                    ),
                  ]),
                  //   SizedBox(height: 20.0),
                  Text('Slider White Black Color',
                      style: TextStyle(color: white)),
                  //   SizedBox(height: 10.0),
                  Row(children: [
                    Expanded(
                      child: BarColorPicker(
                        width: 300,
                        thumbColor: Colors.white,
                        cornerRadius: 10,
                        pickMode: PickMode.Grey,
                        colorListener: (int value) {
                          setState(() {
                            currentColor = Color(value);
                          });
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('Reset', style: TextStyle(color: white)),
                    )
                  ]),
                  Container(
                    color: Colors.black,
                    child: Column(
                      children: [
                        SizedBox(height: 10.0),
                        Center(
                          child: Text(
                            'Size Adjust'.toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Slider(
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey,
                            value: slider,
                            min: 0.0,
                            max: 100.0,
                            onChangeEnd: (v) {
                              setState(() {
                                slider = v;
                              });
                            },
                            onChanged: (v) {
                              setState(() {
                                slider = v;
                              });
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
