import 'package:flutter/material.dart';

LoadingScreenHandler showLoadingScreen(
  BuildContext context, {
  String? text,
  Color? color,
}) {
  var handler = LoadingScreenHandler(
    color: color,
    text: text,
    context: context,
  );

  showDialog<String>(
    context: context,
    builder: (BuildContext context) => LoadingScreenBody(
      handler: handler,
    ),
  );

  return handler;
}

class LoadingScreen {
  final Color? color;
  final GlobalKey<NavigatorState> globalKey;

  LoadingScreen({
    this.color,
    required this.globalKey,
  });

  LoadingScreenHandler show({
    String? text,
  }) {
    return showLoadingScreen(
      globalKey.currentContext!,
      text: text,
      color: color,
    );
  }
}

@protected
class LoadingScreenHandler {
  String? id, text;
  Color? color;
  double? _progress;
  late void Function() refresh;
  BuildContext context;
  bool expired = false;

  LoadingScreenHandler({
    required this.context,
    this.id,
    this.color,
    this.text,
    double? progress,
    void Function()? refresh,
  }) {
    this.refresh = refresh ?? () {};
    this.progress = progress;
  }

  double? get progress => _progress;
  set progress(double? value) {
    _progress = value;
    refresh();
  }

  hide() {
    if (expired) return;

    expired = true;

    Navigator.pop(context);
  }
}

@protected
class LoadingScreenBody extends StatefulWidget {
  final LoadingScreenHandler handler;
  const LoadingScreenBody({super.key, required this.handler});

  @override
  State<LoadingScreenBody> createState() => _LoadingScreenBodyState();
}

class _LoadingScreenBodyState extends State<LoadingScreenBody> {
  @override
  void initState() {
    widget.handler.refresh = () {
      if (mounted) {
        setState(() {});
      }
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.handler.context = context;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              color: widget.handler.color ?? Colors.white,
              value: widget.handler.progress,
              semanticsLabel: widget.handler.text,
            ),
            if (widget.handler.progress != null) const SizedBox(height: 8),
            if (widget.handler.progress != null)
              Text(
                '${(widget.handler.progress! * 100).toStringAsFixed(2)}%',
                style: TextStyle(
                  color: widget.handler.color ?? Colors.white,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
