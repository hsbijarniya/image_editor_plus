import 'package:flutter/material.dart';

import 'colors_picker.dart';

class ColorPickersSlider extends StatefulWidget {
  @override
  _ColorPickersSliderState createState() => _ColorPickersSliderState();
}

class _ColorPickersSliderState extends State<ColorPickersSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
      ),
      padding: EdgeInsets.all(20),
      height: 240,
      child: Column(
        children: [
          Center(
            child: Text(
              'Slider Filter Color'.toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Divider(
              // height: 1,
              ),
          SizedBox(height: 20),
          Text('Slider Color', style: TextStyle(color: Colors.white)),
          //   SizedBox(height:10),
          Row(
            children: [
              Expanded(
                child: BarColorPicker(
                  width: 300,
                  thumbColor: Colors.white,
                  cornerRadius: 10,
                  pickMode: PickMode.Color,
                  colorListener: (int value) {
                    setState(() {
                      //  currentColor = Color(value);
                    });
                  },
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Reset', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
          SizedBox(height: 5),
          Text('Slider Opicity', style: TextStyle(color: Colors.white)),
          SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: Slider(
                value: 0.1,
                min: 0.0,
                max: 1.0,
                onChanged: (v) {},
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Reset', style: TextStyle(color: Colors.white)),
            )
          ]),
        ],
      ),
    );
  }
}
