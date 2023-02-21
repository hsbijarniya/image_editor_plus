import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'colors_picker.dart';

class ColorPickersSlider extends StatefulWidget {
  const ColorPickersSlider({Key? key}) : super(key: key);

  @override
  createState() => _ColorPickersSliderState();
}

class _ColorPickersSliderState extends State<ColorPickersSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(20),
      height: 240,
      child: Column(
        children: [
          Center(
            child: Text(
              i18n('Slider Filter Color').toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const Divider(),
          const SizedBox(height: 20),
          Text(i18n('Slider Color'),
              style: const TextStyle(color: Colors.white)),
          // const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: BarColorPicker(
                  width: 300,
                  thumbColor: Colors.white,
                  cornerRadius: 10,
                  pickMode: PickMode.color,
                  colorListener: (int value) {
                    setState(() {
                      //  currentColor = Color(value);
                    });
                  },
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(i18n('Reset'),
                    style: const TextStyle(color: Colors.white)),
              )
            ],
          ),
          const SizedBox(height: 5),
          Text(i18n('Slider Opicity'),
              style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
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
              child: Text(i18n('Reset'),
                  style: const TextStyle(color: Colors.white)),
            )
          ]),
        ],
      ),
    );
  }
}
