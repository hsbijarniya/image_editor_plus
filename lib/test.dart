import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

class TestEditorUI extends StatelessWidget {
  const TestEditorUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleImageEditor(
		allowGallery: true,
	);
  }
}