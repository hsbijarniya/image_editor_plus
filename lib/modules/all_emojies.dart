import 'package:flutter/material.dart';
import 'package:image_editor_plus/data/data.dart';

class Emojies extends StatefulWidget {
  const Emojies({Key? key}) : super(key: key);

  @override
  _EmojiesState createState() => _EmojiesState();
}

class _EmojiesState extends State<Emojies> {
  List emojes = <dynamic>[];

  List<String> emojis = [];

  @override
  void initState() {
    super.initState();
    emojis = getSmileys();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.0),
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            blurRadius: 10.9,
            color: Color.fromRGBO(0, 0, 0, 0.1),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Select Emoji',
              style: TextStyle(color: Colors.white),
            ),
          ]),
          Divider(height: 1),
          SizedBox(height: 16),
          Container(
            height: 315,
            padding: EdgeInsets.all(0.0),
            child: GridView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 0.0, maxCrossAxisExtent: 60.0),
              children: emojis.map((String emoji) {
                return GridTile(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context, {
                      'type': 'emoji',
                      'background': Colors.transparent,
                      'value': emoji,
                      'color': Colors.white,
                      'size': 32.0,
                      'align': TextAlign.center,
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.zero,
                    child: Text(
                      emoji,
                      style: TextStyle(
                        fontSize: 35,
                      ),
                    ),
                  ),
                ));
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
