library image_editor_plus;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:colorfilter_generator/presets.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:image_editor/image_editor.dart' as image_editor;
import 'package:image_editor_plus/modules/emoji-overlay.dart';
import 'package:image_editor_plus/modules/text-overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_editor_plus/modules/all_emojies.dart';
import 'package:image_editor_plus/modules/emoji-view.dart';
import 'package:image_editor_plus/modules/text.dart';
import 'package:image_editor_plus/modules/text-view.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';
import 'dart:math' as math;
import 'modules/colors_picker.dart'; // import this

TextEditingController heightcontroler = TextEditingController();
TextEditingController widthcontroler = TextEditingController();
int width = 300;
int height = 300;
String currentLayout = 'home';
late Size viewportSize;
double viewportRatio = 1;
SignatureController _controller = SignatureController(
  penStrokeWidth: 5,
  penColor: Colors.green,
);

var slider = 0.0;
List layers = [], undoLayers = [], removedLayers = [];

class ImageEditor extends StatefulWidget {
  final Color? appBarColor;
  final Color bottomBarColor;
  final Directory? pathSave;
  final dynamic image;

  const ImageEditor({
    Key? key,
    this.appBarColor = Colors.black87,
    this.bottomBarColor = Colors.black,
    this.pathSave,
    this.image,
  }) : super(key: key);

  @override
  _ImageEditorState createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    var points = _controller.points;

    _controller = SignatureController(
      penStrokeWidth: 5,
      penColor: color,
      points: points,
    );
  }

  Offset offset1 = Offset.zero;
  Offset offset2 = Offset.zero;
  final scaf = GlobalKey<ScaffoldState>();

  final GlobalKey container = GlobalKey();
  final GlobalKey globalKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();

  Map<String, Widget> filterBottomNavigationBar = {};

  @override
  void dispose() {
    _controller.clear();
    layers.clear();
    heightcontroler.clear();
    widthcontroler.clear();
    super.dispose();
  }

  Map<String, List<Widget>> get filterActions {
    return {
      'Brush': [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            currentLayout = 'home';
            currentColor = Colors.transparent;
            layers.removeLast();
            setState(() {});
          },
        ).paddingSymmetric(horizontal: 8),
        Spacer(),
        IconButton(
          icon: Icon(Icons.undo),
          onPressed: () {
            _controller.undo();
          },
        ).paddingSymmetric(horizontal: 8),
        IconButton(
          icon: Icon(Icons.redo),
          onPressed: () {
            _controller.redo();
          },
        ).paddingSymmetric(horizontal: 8),
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () async {
            currentLayout = 'home';
            currentColor = Colors.transparent;

            if (_controller.points.isEmpty) return;

            loadImage(await screenshotController.capture());

            setState(() {});
          },
        ).paddingSymmetric(horizontal: 8),
      ],
      'Crop': [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            currentLayout = 'home';
            currentColor = Colors.transparent;
            setState(() {});
          },
        ).paddingSymmetric(horizontal: 8),
        Spacer(),
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () async {
            currentLayout = 'home';
            currentColor = Colors.transparent;

            setState(() {});
          },
        ).paddingSymmetric(horizontal: 8),
      ],
      'home': [
        BackButton(),
        Spacer(),
        // IconButton(
        //   icon: Icon(FontAwesomeIcons.boxes),
        //   onPressed: () {
        //     showCupertinoDialog(
        //       context: context,
        //       builder: (context) {
        //         return AlertDialog(
        //           title: Text('Select Height Width'),
        //           actions: <Widget>[
        //             TextButton(
        //               child: Text('Done'),
        //               onPressed: () {
        //                 setState(() {
        //                   height = int.parse(heightcontroler.text);
        //                   width = int.parse(widthcontroler.text);
        //                 });
        //                 heightcontroler.clear();
        //                 widthcontroler.clear();
        //                 Navigator.pop(context);
        //               },
        //             ),
        //           ],
        //           content: SingleChildScrollView(
        //             child: Column(
        //               children: [
        //                 Text('Define Height'),
        //                 SizedBox(height: 10.0),
        //                 TextField(
        //                   controller: heightcontroler,
        //                   keyboardType: TextInputType.numberWithOptions(),
        //                   decoration: InputDecoration(
        //                     hintText: 'Height',
        //                     contentPadding: EdgeInsets.only(left: 10),
        //                     border: OutlineInputBorder(),
        //                   ),
        //                 ),
        //                 SizedBox(height: 10.0),
        //                 Text('Define Width'),
        //                 SizedBox(height: 10.0),
        //                 TextField(
        //                     controller: widthcontroler,
        //                     keyboardType: TextInputType.numberWithOptions(),
        //                     decoration: InputDecoration(
        //                         hintText: 'Width',
        //                         contentPadding: EdgeInsets.only(left: 10),
        //                         border: OutlineInputBorder())),
        //               ],
        //             ),
        //           ),
        //         );
        //       },
        //     );
        //   },
        // ).paddingSymmetric(horizontal: 8),
        IconButton(
          icon: Icon(Icons.undo,
              color:
                  layers.length > 1 || removedLayers.isNotEmpty ? white : grey),
          onPressed: () {
            if (removedLayers.isNotEmpty) {
              layers.add(removedLayers.removeLast());
              setState(() {});
              return;
            }

            if (layers.length <= 1) return; // do not remove image layer

            undoLayers.add(layers.removeLast());

            setState(() {});
          },
        ).paddingSymmetric(horizontal: 8),
        IconButton(
          icon: Icon(Icons.redo, color: undoLayers.isNotEmpty ? white : grey),
          onPressed: () {
            if (undoLayers.isEmpty) return;

            layers.add(undoLayers.removeLast());

            setState(() {});
          },
        ).paddingSymmetric(horizontal: 8),
        IconButton(
          icon: const Icon(Icons.photo),
          onPressed: () async {
            var image = await picker.pickImage(source: ImageSource.gallery);

            if (image == null) return;

            await loadImage(File(image.path));
          },
        ).paddingSymmetric(horizontal: 8),
        IconButton(
          icon: const Icon(Icons.camera_alt),
          onPressed: () async {
            var image = await picker.pickImage(source: ImageSource.camera);

            if (image == null) return;

            await loadImage(File(image.path));
          },
        ).paddingSymmetric(horizontal: 8),
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () async {
            var binaryIntList = await screenshotController.capture();

            Navigator.pop(context, binaryIntList);
          },
        ).paddingSymmetric(horizontal: 8),
      ],
      'blank': [],
    };
  }

  @override
  void initState() {
    if (widget.image != null) {
      loadImage(widget.image!);
    }

    _controller.clear();
    layers.clear();

    List<Color> colorList = [
      Colors.black,
      Colors.white,
      Colors.blue,
      Colors.green,
      Colors.pink,
      Colors.purple,
      Colors.brown,
      Colors.indigo,
      Colors.indigo,
    ];

    filterBottomNavigationBar = {
      'Brush': Container(
        height: 80,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: widget.bottomBarColor,
              blurRadius: 10,
            ),
          ],
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            ColorBox(
              color: Colors.yellow,
              onTap: (color) {
                // raise the [showDialog] widget
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Pick a color!'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: pickerColor,
                          onColorChanged: changeColor,
                          pickerAreaHeightPercent: 0.8,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            setState(() => currentColor = pickerColor);
                            Navigator.pop(context);
                          },
                          child: const Text('Got it'),
                        )
                      ],
                    );
                  },
                );
              },
            ),
            for (int i = 0; i < colorList.length; i++)
              ColorBox(
                color: colorList[i],
                onTap: (color) => changeColor(color),
              ),
          ],
        ),
      ),
      'home': Container(
        height: 80,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: widget.bottomBarColor,
              blurRadius: 10,
            ),
          ],
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            ButtonBox(
              icon: Icons.crop,
              text: 'Crop',
              onTap: () async {
                var data = await screenshotController.capture();

                var img = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageCropper(
                      image: data!,
                    ),
                  ),
                );

                if (img == null) return;

                loadImage(img);
              },
            ),
            ButtonBox(
              icon: Icons.edit,
              text: 'Brush',
              onTap: () {
                currentLayout = 'Brush';
                currentColor = white;
                undoLayers.clear();
                removedLayers.clear();

                layers.add({
                  'type': 'drawing',
                  'points': [],
                });

                _controller = SignatureController(
                  penStrokeWidth: 5,
                  penColor: currentColor,
                );

                setState(() {});
              },
            ),
            ButtonBox(
              icon: Icons.text_fields,
              text: 'Text',
              onTap: () async {
                var value = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TextEditorImage(),
                  ),
                );

                if (value['value'] == null) return;

                undoLayers.clear();
                removedLayers.clear();

                layers.add({
                  ...value,
                  'backgroundTransparency': 0,
                  'offset':
                      Offset(viewportSize.width / 2, viewportSize.height / 2),
                });

                setState(() {});
              },
            ),
            ButtonBox(
              icon: Icons.flip,
              text: 'Flip',
              onTap: () {
                setState(() {
                  flipValue = flipValue == 0 ? math.pi : 0;
                });
              },
            ),
            ButtonBox(
              icon: Icons.rotate_left,
              text: 'Rotate left',
              onTap: () {
                setState(() {
                  rotateValue--;
                });
              },
            ),
            ButtonBox(
              icon: Icons.rotate_right,
              text: 'Rotate right',
              onTap: () {
                setState(() {
                  rotateValue++;
                });
              },
            ),
            ButtonBox(
              icon: Icons.blur_on,
              text: 'Blur',
              onTap: () {
                var blurLayer = {
                  'type': 'blur',
                  'color': Colors.transparent,
                  'radius': 0.0,
                  'opacity': 0.0
                };

                undoLayers.clear();
                removedLayers.clear();
                layers.add(blurLayer);
                setState(() {});

                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                  ),
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setS) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                          ),
                          padding: EdgeInsets.all(20),
                          height: 400,
                          child: Column(
                            children: [
                              Center(
                                  child: Text(
                                'Slider Filter Color'.toUpperCase(),
                                style: TextStyle(color: white),
                              )),
                              Divider(

                                  // height: 1,
                                  ),
                              SizedBox(height: 20.0),
                              Text(
                                'Slider Color',
                                style: TextStyle(color: white),
                              ),
                              SizedBox(height: 10),
                              Row(children: [
                                Expanded(
                                  child: BarColorPicker(
                                    width: 300,
                                    thumbColor: white,
                                    cornerRadius: 10,
                                    pickMode: PickMode.Color,
                                    colorListener: (int value) {
                                      setS(() {
                                        setState(() {
                                          blurLayer['color'] = Color(value);
                                        });
                                      });
                                    },
                                  ),
                                ),
                                TextButton(
                                  child: const Text('Reset',
                                      style: TextStyle(color: white)),
                                  onPressed: () {
                                    setState(() {
                                      setS(() {
                                        blurLayer['color'] = Colors.transparent;
                                      });
                                    });
                                  },
                                )
                              ]),
                              SizedBox(height: 5.0),
                              Text(
                                'Blur Radius',
                                style: TextStyle(color: white),
                              ),
                              SizedBox(height: 10.0),
                              Row(children: [
                                Expanded(
                                  child: Slider(
                                    activeColor: white,
                                    inactiveColor: Colors.grey,
                                    value: blurLayer['radius'] as double,
                                    min: 0.0,
                                    max: 10.0,
                                    onChanged: (v) {
                                      setS(() {
                                        setState(() {
                                          blurLayer['radius'] = v;
                                        });
                                      });
                                    },
                                  ),
                                ),
                                TextButton(
                                  child: Text('Reset',
                                      style: TextStyle(color: white)),
                                  onPressed: () {
                                    setS(() {
                                      setState(() {
                                        blurLayer['color'] = 0.0;
                                      });
                                    });
                                  },
                                )
                              ]),
                              SizedBox(height: 5.0),
                              Text(
                                'Color Opacity',
                                style: TextStyle(color: white),
                              ),
                              SizedBox(height: 10.0),
                              Row(children: [
                                Expanded(
                                  child: Slider(
                                    activeColor: white,
                                    inactiveColor: Colors.grey,
                                    value: blurLayer['opacity']! as double,
                                    min: 0.00,
                                    max: 1.0,
                                    onChanged: (v) {
                                      setS(() {
                                        setState(() {
                                          blurLayer['opacity'] = v;
                                        });
                                      });
                                    },
                                  ),
                                ),
                                TextButton(
                                  child: const Text(
                                    'Reset',
                                    style: TextStyle(color: white),
                                  ),
                                  onPressed: () {
                                    setS(() {
                                      setState(() {
                                        blurLayer['opacity'] = 0.0;
                                      });
                                    });
                                  },
                                )
                              ]),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            // ButtonBox(
            //   icon: FontAwesomeIcons.eraser,
            //   text: 'Eraser',
            //   onTap: () {
            //     _controller.clear();
            //     layers.removeWhere((layer) => layer['type'] == 'drawing');
            //     setState(() {});
            //   },
            // ),
            ButtonBox(
              icon: Icons.photo,
              text: 'Filter',
              onTap: () async {
                var data = await screenshotController.capture();

                var layer = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageFilters(
                      image: data!,
                    ),
                  ),
                );

                if (layer == null) return;

                layers.clear();
                removedLayers.clear();
                undoLayers.clear();

                layers.add(layer);
                setState(() {});
              },
            ),
            ButtonBox(
              icon: FontAwesomeIcons.smile,
              text: 'Emoji',
              onTap: () async {
                var emoji = await showModalBottomSheet(
                  context: context,
                  backgroundColor: black,
                  builder: (BuildContext context) {
                    return Emojies();
                  },
                );

                if (emoji == null || emoji['value'] == null) return;

                undoLayers.clear();
                removedLayers.clear();
                layers.add({
                  ...emoji,
                  'offset':
                      Offset(viewportSize.width / 2, viewportSize.height / 2),
                });

                setState(() {});
              },
            ),
          ],
        ),
      ),
      'blank': Container(),
    };

    super.initState();
  }

  double flipValue = 0;
  int rotateValue = 0;

  @override
  Widget build(BuildContext context) {
    viewportSize = MediaQuery.of(context).size;

    var layersStack = Stack(
      children: layers.map((layerItem) {
        // Image layer
        if (layerItem['type'] == 'image') {
          var imageWidget = layerItem['file'] is File
              ? Image.file(layerItem['file'])
              : Image.memory(layerItem['file']);

          return Container(
            width: width.toDouble(),
            height: height.toDouble(),
            // color: black,
            padding: EdgeInsets.zero,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(flipValue),
              child: layerItem['filter'] == null
                  ? imageWidget
                  : Opacity(
                      opacity: layerItem['filter']!['opacity'] ?? 1,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.matrix(
                            layerItem['filter']!['selected']!.matrix),
                        child: imageWidget,
                      ),
                    ),
            ),
          );
        }

        // Background blur layer
        if (layerItem['type'] == 'blur' && layerItem['radius'] > 0) {
          return Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: layerItem['radius'],
                sigmaY: layerItem['radius'],
              ),
              child: Container(
                color: layerItem['color']
                    .withAlpha((layerItem['opacity'] * 100).toInt()),
              ),
            ),
          );
        }

        // Drawing layer
        if (layerItem['type'] == 'drawing') {
          return Signat();
        }

        // Emoji layer
        if (layerItem['type'] == 'emoji') {
          return EmojiView(
            left: layerItem['offset'].dx,
            top: layerItem['offset'].dy,
            onTap: () {
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
                context: context,
                builder: (context) {
                  return EmojiOverlay(
                    index: layers.indexOf(layerItem),
                    mapValue: layerItem,
                    onUpdate: () {
                      setState(() {});
                    },
                  );
                },
              );
            },
            onUpdate: () {
              setState(() {});
            },
            details: layerItem,
          );
        }

        // Text layer
        if (layerItem['type'] == 'text') {
          return TextView(
            left: layerItem['offset'].dx,
            top: layerItem['offset'].dy,
            onTap: () {
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
                context: context,
                builder: (context) {
                  return TextOverlay(
                    index: layers.indexOf(layerItem),
                    mapValue: layerItem,
                    onUpdate: () {
                      setState(() {});
                    },
                  );
                },
              );
            },
            onUpdate: () {
              setState(() {});
            },
            details: layerItem,
          );
        }

        // Blank layer
        return Container();
      }).toList(),
    );

    return Scaffold(
      backgroundColor: black,
      key: scaf,
      appBar: AppBar(
        backgroundColor: widget.appBarColor,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        automaticallyImplyLeading: false,
        actions: filterActions[currentLayout] ?? filterActions['blank'],
      ),
      body: Center(
        child: Screenshot(
          controller: screenshotController,
          child: RotatedBox(
            quarterTurns: rotateValue,
            child: InteractiveViewer(
              child: layersStack,
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
          child: filterBottomNavigationBar[currentLayout] ??
              filterBottomNavigationBar['blank']!),
    );
  }

  final picker = ImagePicker();

  Future<void> loadImage(dynamic imageFile) async {
    late dynamic decodedImage;
    Uint8List data;

    if (imageFile is File || imageFile is XFile) {
      data = await imageFile.readAsBytes();
      decodedImage = await decodeImageFromList(data);
    } else {
      data = imageFile;
      decodedImage = await decodeImageFromList(imageFile);
    }

    print([viewportSize.height, height, decodedImage.height]);
    height = decodedImage.height;
    width = decodedImage.width;
    viewportRatio = viewportSize.height / height;

    _controller.clear();

    layers.clear();
    layers.add({
      'type': 'image',
      'file': data,
      'offset': Offset.zero,
    });

    setState(() {});
  }
}

class Signat extends StatefulWidget {
  @override
  _SignatState createState() => _SignatState();
}

class _SignatState extends State<Signat> {
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print('Value changed'));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Signature(
          controller: _controller,
          height: height.toDouble(),
          width: width.toDouble(),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }
}

Widget ButtonBox({
  onTap,
  onLongPress,
  required IconData icon,
  required String text,
}) {
  return GestureDetector(
    onTap: onTap,
    onLongPress: onLongPress,
    child: Column(
      children: [
        Icon(icon, color: white),
        SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(color: white),
        ),
      ],
    ).paddingSymmetric(horizontal: 16),
  );
}

class ColorBox extends StatelessWidget {
  final Color color;
  final Function onTap;
  const ColorBox({Key? key, required this.color, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      width: 34,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 23),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70, width: 2),
      ),
    ).onTap(() {
      onTap(color);
    });
  }
}

class ImageCropper extends StatefulWidget {
  final Uint8List image;

  const ImageCropper({Key? key, required this.image}) : super(key: key);

  @override
  _ImageCropperState createState() => _ImageCropperState();
}

class _ImageCropperState extends State<ImageCropper> {
  final GlobalKey<ExtendedImageEditorState> _controller =
      GlobalKey<ExtendedImageEditorState>();

  double? aspectRatio;
  double? aspectRatioOriginal;
  bool isLandscape = true;
  int rotateAngle = 0;

  @override
  void initState() {
    _controller.currentState?.rotate(right: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.currentState != null) {
      // _controller.currentState?.
    }

    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              var state = _controller.currentState;

              if (state == null) return;

              var data = await cropImageDataWithNativeLibrary(state: state);

              Navigator.pop(context, data);
            },
          ).paddingSymmetric(horizontal: 8),
        ],
      ),
      body: Container(
        color: black,
        child: ExtendedImage.memory(
          widget.image,
          cacheRawData: true,
          fit: BoxFit.contain,
          extendedImageEditorKey: _controller,
          mode: ExtendedImageMode.editor,
          initEditorConfigHandler: (state) {
            return EditorConfig(
              cropAspectRatio: aspectRatio,
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 80,
          child: Column(
            children: [
              // Container(
              //   height: 48,
              //   decoration: const BoxDecoration(
              //     boxShadow: [
              //       BoxShadow(
              //         color: black,
              //         blurRadius: 10,
              //       ),
              //     ],
              //   ),
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: <Widget>[
              //       IconButton(
              //         icon: Icon(
              //           Icons.portrait,
              //           color: isLandscape ? gray : white,
              //         ).paddingSymmetric(horizontal: 8, vertical: 4),
              //         onPressed: () {
              //           isLandscape = false;
              //           if (aspectRatioOriginal != null) {
              //             aspectRatio = 1 / aspectRatioOriginal!;
              //           }
              //           setState(() {});
              //         },
              //       ),
              //       IconButton(
              //         icon: Icon(
              //           Icons.landscape,
              //           color: isLandscape ? white : gray,
              //         ).paddingSymmetric(horizontal: 8, vertical: 4),
              //         onPressed: () {
              //           isLandscape = true;
              //           aspectRatio = aspectRatioOriginal!;
              //           setState(() {});
              //         },
              //       ),
              //       Slider(
              //         activeColor: Colors.white,
              //         inactiveColor: Colors.grey,
              //         value: rotateAngle.toDouble(),
              //         min: 0.0,
              //         max: 100.0,
              //         onChangeEnd: (v) {
              //           rotateAngle = v.toInt();
              //           setState(() {});
              //         },
              //         onChanged: (v) {
              //           rotateAngle = v.toInt();
              //           setState(() {});
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                height: 80,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: black,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.portrait,
                        color: isLandscape ? gray : white,
                      ).paddingSymmetric(horizontal: 8, vertical: 4),
                      onPressed: () {
                        isLandscape = false;
                        if (aspectRatioOriginal != null) {
                          aspectRatio = 1 / aspectRatioOriginal!;
                        }
                        setState(() {});
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.landscape,
                        color: isLandscape ? white : gray,
                      ).paddingSymmetric(horizontal: 8, vertical: 4),
                      onPressed: () {
                        isLandscape = true;
                        aspectRatio = aspectRatioOriginal!;
                        setState(() {});
                      },
                    ),
                    ImageRatio(null, 'Freeform'),
                    ImageRatio(1, 'Square'),
                    ImageRatio(4 / 3, '4:3'),
                    ImageRatio(5 / 4, '5:4'),
                    ImageRatio(7 / 5, '7:5'),
                    ImageRatio(16 / 9, '16:9'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Uint8List?> cropImageDataWithNativeLibrary(
      {required ExtendedImageEditorState state}) async {
    final Rect? cropRect = state.getCropRect();
    final EditActionDetails action = state.editAction!;

    final int rotateAngle = action.rotateAngle.toInt();
    final bool flipHorizontal = action.flipY;
    final bool flipVertical = action.flipX;
    final Uint8List img = state.rawImageData;

    final image_editor.ImageEditorOption option =
        image_editor.ImageEditorOption();

    if (action.needCrop) {
      option.addOption(image_editor.ClipOption.fromRect(cropRect!));
    }

    if (action.needFlip) {
      option.addOption(image_editor.FlipOption(
          horizontal: flipHorizontal, vertical: flipVertical));
    }

    if (action.hasRotateAngle) {
      option.addOption(image_editor.RotateOption(rotateAngle));
    }

    final DateTime start = DateTime.now();
    final Uint8List? result = await image_editor.ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    print('${DateTime.now().difference(start)} ：total time');

    return result;
  }

  Widget ImageRatio(double? ratio, String title) {
    return TextButton(
      onPressed: () {
        aspectRatioOriginal = ratio;
        if (aspectRatioOriginal != null && isLandscape == false) {
          aspectRatio = 1 / aspectRatioOriginal!;
        } else {
          aspectRatio = aspectRatioOriginal;
        }
        setState(() {});
      },
      child: Text(
        title,
        style: TextStyle(
          color: aspectRatioOriginal == ratio ? white : gray,
        ),
      ).paddingSymmetric(horizontal: 8, vertical: 4),
    );
  }
}

class ImageFilters extends StatefulWidget {
  final Uint8List image;

  // apply each filter to given image in background and cache it to improve UX
  final bool useCache;

  const ImageFilters({
    Key? key,
    required this.image,
    this.useCache = false,
  }) : super(key: key);

  @override
  _ImageFiltersState createState() => _ImageFiltersState();
}

class _ImageFiltersState extends State<ImageFilters> {
  late img.Image decodedImage;
  ColorFilterGenerator selectedFilter = PresetFilters.none;
  Uint8List resizedImage = Uint8List.fromList([]);
  double filterOpacity = 1;

  @override
  void initState() {
    // decodedImage = img.decodeImage(widget.image)!;
    // resizedImage = img.copyResize(decodedImage, height: 64).getBytes();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              // var data = await cropImageDataWithNativeLibrary(state: state);

              Navigator.pop(context, {
                'type': 'image',
                'file': widget.image,
                'filter': {
                  'selected': selectedFilter,
                  'opacity': filterOpacity,
                }
              });
            },
          ).paddingSymmetric(horizontal: 8),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            Image.memory(
              widget.image,
              fit: BoxFit.cover,
            ),
            Opacity(
              opacity: filterOpacity,
              child: FilterAppliedImage(
                image: widget.image,
                filter: selectedFilter,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 160,
          child: Column(children: [
            SizedBox(
              height: 40,
              child: selectedFilter == PresetFilters.none
                  ? Container()
                  : ColorFiltered(
                      colorFilter: ColorFilter.matrix(selectedFilter.matrix),
                      child: Slider(
                        min: 0,
                        max: 1,
                        divisions: 100,
                        value: filterOpacity,
                        onChanged: (value) {
                          filterOpacity = value;
                          setState(() {});
                        },
                      ),
                    ),
            ),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  for (int i = 0; i < presetFiltersList.length; i++)
                    FilterPreview(
                      filter: presetFiltersList[i],
                      name: presetFiltersList[i].name,
                    ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget FilterPreview({required filter, required String name}) {
    return Column(children: [
      Container(
        height: 64,
        width: 64,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(48),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(48),
          child: FilterAppliedImage(
            image: widget.image,
            filter: filter,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Text(name, style: const TextStyle(color: white, fontSize: 12)),
    ]).onTap(() {
      selectedFilter = filter;
      setState(() {});
    });
  }
}

class FilterAppliedImage extends StatelessWidget {
  final Uint8List image;
  final ColorFilterGenerator? filter;
  final BoxFit? fit;

  const FilterAppliedImage({
    Key? key,
    required this.image,
    required this.filter,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (filter == null) return Image.memory(image, fit: fit);

    return ColorFiltered(
      colorFilter: ColorFilter.matrix(filter!.matrix),
      child: Image.memory(image, fit: fit),
    );
  }
}
