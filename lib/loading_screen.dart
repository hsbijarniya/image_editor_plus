import 'package:flutter/material.dart';

class LoadingScreen {

  static show(BuildContext currentContext, [String? text]) {
    showDialog<String>(
      context: currentContext,
      builder: (BuildContext context) => const Scaffold(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                semanticsLabel: 'Linear progress indicator',
              ),
            ],
          ),
        ),
      ),
    );
  }

  static hide(BuildContext currentContext) {
    Navigator.pop(currentContext);
  }
}
