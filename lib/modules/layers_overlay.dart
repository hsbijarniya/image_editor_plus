import 'package:flutter/material.dart';
import 'package:image_editor_plus/data/layer.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_editor_plus/modules/emoji_layer_overlay.dart';
import 'package:image_editor_plus/modules/image_layer_overlay.dart';
import 'package:image_editor_plus/modules/text_layer_overlay.dart';
import 'package:reorderables/reorderables.dart';

class ManageLayersOverlay extends StatefulWidget {
  final List<Layer> layers;
  final Function onUpdate;

  const ManageLayersOverlay({
    super.key,
    required this.layers,
    required this.onUpdate,
  });

  @override
  createState() => _ManageLayersOverlayState();
}

class _ManageLayersOverlayState extends State<ManageLayersOverlay> {
  var scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      child: ReorderableColumn(
        // controller: scrollController,
        // reverse: true,
        // itemCount: layers.length,
        onReorder: (oldIndex, newIndex) {
          var oi = layers.length - 1 - oldIndex,
              ni = layers.length - 1 - newIndex;

          // skip main layer
          if (oi == 0 || ni == 0) {
            return;
          }

          layers.insert(ni, layers.removeAt(oi));
          widget.onUpdate();
          setState(() {});
        },
        draggedItemBuilder: (context, index) {
          var layer = layers[layers.length - 1 - index];

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xff111111),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              SizedBox(
                width: 64,
                height: 64,
                child: Center(
                  child: layer is TextLayerData || layer is EmojiLayerData
                      ? Text(
                          layer is TextLayerData
                              ? 'T'
                              : (layer as EmojiLayerData).text,
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.w100,
                          ),
                        )
                      : (layer is ImageLayerData
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                layer.image.bytes,
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                              ))
                          : (layer is BackgroundLayerData
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    layer.image.bytes,
                                    fit: BoxFit.cover,
                                    width: 40,
                                    height: 40,
                                  ))
                              : const Text(
                                  '',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ))),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 92 - 64,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (layer is TextLayerData)
                      Text(
                        layer.text,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      )
                    else
                      Text(
                        layer.runtimeType.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
              if (layer is! BackgroundLayerData)
                IconButton(
                  onPressed: () {
                    layers.remove(layer);
                    widget.onUpdate();
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete, size: 22, color: Colors.red),
                )
            ]),
          );
        },
        children: [
          for (var layer in layers.reversed)
            // ReorderableWidget(
            //   reorderable: true,
            //   child:
            GestureDetector(
              key: Key('${layers.indexOf(layer)}:${layer.runtimeType}'),
              onTap: () {
                if (layer is BackgroundLayerData) return;

                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    if (layer is EmojiLayerData) {
                      return EmojiLayerOverlay(
                        index: layers.indexOf(layer),
                        layer: layer,
                        onUpdate: () {
                          widget.onUpdate();
                          setState(() {});
                        },
                      );
                    }

                    if (layer is ImageLayerData) {
                      return ImageLayerOverlay(
                        index: layers.indexOf(layer),
                        layerData: layer,
                        onUpdate: () {
                          widget.onUpdate();
                          setState(() {});
                        },
                      );
                    }

                    if (layer is TextLayerData) {
                      return TextLayerOverlay(
                        index: layers.indexOf(layer),
                        layer: layer,
                        onUpdate: () {
                          widget.onUpdate();
                          setState(() {});
                        },
                      );
                    }

                    return Container();
                  },
                );
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: Center(
                      child: layer is LinkLayerData
                          ? const Icon(Icons.link,
                              size: 32, color: Colors.white)
                          : (layer is TextLayerData || layer is EmojiLayerData
                              ? Text(
                                  layer is TextLayerData
                                      ? 'T'
                                      : (layer as EmojiLayerData).text,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100,
                                  ),
                                )
                              : (layer is ImageLayerData
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.memory(
                                        layer.image.bytes,
                                        fit: BoxFit.cover,
                                        width: 40,
                                        height: 40,
                                      ))
                                  : (layer is BackgroundLayerData
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.memory(
                                            layer.image.bytes,
                                            fit: BoxFit.cover,
                                            width: 40,
                                            height: 40,
                                          ))
                                      : const Text(
                                          '',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        )))),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 92 - 64,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (layer is LinkLayerData)
                          Text(
                            layer.text,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          )
                        else if (layer is TextLayerData)
                          Text(
                            layer.text,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          )
                        else
                          Text(
                            layer.runtimeType.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (layer is! BackgroundLayerData)
                    IconButton(
                      onPressed: () {
                        layers.remove(layer);
                        widget.onUpdate();
                        setState(() {});
                      },
                      icon:
                          const Icon(Icons.delete, size: 22, color: Colors.red),
                    )
                ]),
              ),
              // ),
            )
        ],
      ),
    );
  }
}
