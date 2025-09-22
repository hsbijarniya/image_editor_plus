import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_editor_plus/data/layer.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

class LinkEditorImage extends StatefulWidget {
  const LinkEditorImage({super.key});

  @override
  createState() => _LinkEditorImageState();
}

class _LinkEditorImageState extends State<LinkEditorImage> {
  TextEditingController name = TextEditingController();
  Color currentColor = Colors.white;
  Color backgroundColor = Colors.transparent;
  double slider = 32.0;
  TextAlign align = TextAlign.left;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.alignLeft,
                  color: align == TextAlign.left
                      ? Colors.white
                      : Colors.white.withAlpha(80)),
              onPressed: () {
                setState(() {
                  align = TextAlign.left;
                });
              },
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.alignCenter,
                  color: align == TextAlign.center
                      ? Colors.white
                      : Colors.white.withAlpha(80)),
              onPressed: () {
                setState(() {
                  align = TextAlign.center;
                });
              },
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.alignRight,
                  color: align == TextAlign.right
                      ? Colors.white
                      : Colors.white.withAlpha(80)),
              onPressed: () {
                setState(() {
                  align = TextAlign.right;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                Navigator.pop(
                  context,
                  LinkLayerData(
                    background: Colors.transparent,
                    text: name.text,
                    color: currentColor,
                    size: slider.toDouble(),
                    align: align,
                  ),
                );
              },
              color: Colors.white,
              padding: const EdgeInsets.all(15),
            )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: size.height / 2.2,
                child: TextField(
                  controller: name,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(10),
                    hintText: i18n('https://example.com'),
                    hintStyle: const TextStyle(color: Colors.white),
                    alignLabelWithHint: true,
                  ),
                  scrollPadding: const EdgeInsets.all(20.0),
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 99999,
                  style: TextStyle(
                    color: currentColor,
                  ),
                  autofocus: true,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
