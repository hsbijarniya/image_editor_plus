# ImageEditor

Image Editor Plugin with simple, easy support for image editing using Paints, Text, Filters, Emoji and Sticker like stories.
  
  
<img src="https://cdn.ensorta.com/com.ensorta.biller/albums/5b53309f6073bd7662404dc7.1644562653000.HTG8Y6NV8BG.png" width="24%">
<img src="https://cdn.ensorta.com/com.ensorta.biller/albums/5b53309f6073bd7662404dc7.1644562729000.T9UPP7D59Y.png" width="24%">
<img src="https://cdn.ensorta.com/com.ensorta.biller/albums/5b53309f6073bd7662404dc7.1644566966000.YKAA8C382JB.png" width="24%">
<img src="https://cdn.ensorta.com/com.ensorta.biller/albums/5b53309f6073bd7662404dc7.1644567026000.Y9080Y1JYU9.png" width="24%">
  

To start with this, we need to simply add the dependencies in the gradle file of our app module like this

## Installation

First, add `image_editor_plus:` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

Import

```dart
import 'package:image_editor_plus/image_editor_plus.dart';
```

### iOS

Add the following keys to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

* `NSPhotoLibraryUsageDescription` - describe why your app needs permission for the photo library. This is called _Privacy - Photo Library Usage Description_ in the visual editor.
* `NSCameraUsageDescription` - describe why your app needs access to the camera. This is called _Privacy - Camera Usage Description_ in the visual editor.
* `NSMicrophoneUsageDescription` - describe why your app needs access to the microphone, if you intend to record videos. This is called _Privacy - Microphone Usage Description_ in the visual editor.

Or in text format add the key:

``` xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Used to demonstrate image picker plugin</string>
<key>NSCameraUsageDescription</key>
<string>Used to demonstrate image picker plugin</string>
<key>NSMicrophoneUsageDescription</key>
<string>Used to capture audio for image picker plugin</string>
```

### Android

No configuration required - the plugin should work out of the box.


### Example - Language translation

```dart
// before using image editor
ImageEditor.i18n({
    'Remove': 'हटा दीजिये',
    'Save': 'सहेजें',
    'Slider Filter Color': 'स्लाइडर फिल्टर का रंग',
});
```


### Example - Full Editor

```dart
final editedImage = await Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => ImageEditor(
            image: data, // <-- Uint8List of image
            appBarColor: Colors.blue,
            bottomBarColor: Colors.blue,
        ),
    ),
);
```


### Example - Image Crop Only

```dart
final editedImage = await Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => ImageCropper(
            image: data, // <-- Uint8List of image
        ),
    ),
);
```
  
  
### Example - Image Convert

```dart
import 'package:image_editor_plus/utils.dart';

// to jpeg
final convertedImage = await ImageUtils.convert(
    image: data, // <-- Uint8List/path of image
    format: 'jpg',
    quality: 80,
);

// to heic
final convertedImage = await ImageUtils.convert(
    image: data, // <-- Uint8List/path of image
    format: 'heic',
    quality: 80,
);

// to png
final convertedImage = await ImageUtils.convert(
    image: data, // <-- Uint8List/path of image
    format: 'png',
);

// to webp
final convertedImage = await ImageUtils.convert(
    image: data, // <-- Uint8List/path of image
    format: 'webp',
    quality: 80,
);
```
  
  
## MIT License

Copyright (c) 2022 hsbijarniya@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
