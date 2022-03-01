import 'package:flutter/material.dart';

class BottomBarContainer extends StatelessWidget {
  final Color colors;
  final Function onTap;
  final String title;
  final IconData icons;

  const BottomBarContainer({
    Key? key,
    required this.onTap,
    required this.title,
    required this.icons,
    required this.colors,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(0.0),
      width: size.width / 5,
      child: Material(
        color: colors,
        child: InkWell(
          onTap: () {
            onTap();
          },
          child: Column(
            children: [
              Icon(icons, color: Colors.white),
              SizedBox(height: 4),
              Text(title, style: TextStyle(color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }
}
