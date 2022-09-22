import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:example/camera_screen.dart';

import 'overlay.dart';


void _saveImage(String path) async {
  ///이미지 갤러리 저장
  await GallerySaver.saveImage(path)
      .then((value) => print("save Image"))
      .catchError((err) {
    print("error");
  });
}


Future<void> cropFile(String path, List<Face> faces) async {
  ///얼굴 crop
  late Size imagesize;
  await imageSize(File(path)).then((value) {
    print("image Size ${value}");
    imagesize = value;
  });
  File cimage = File(path);
  if (faces[0].boundingBox.right <= imagesize.width &&
      faces[0].boundingBox.left >= 0 &&
      faces[0].boundingBox.top >= 0 &&
      faces[0].boundingBox.bottom <= imagesize.height) {
    print("can crop!");

    cimage = await FlutterNativeImage.cropImage(
        path,
        faces[0].boundingBox.left.toInt(),
        faces[0].boundingBox.top.toInt(),
        faces[0].boundingBox.width.toInt(),
        faces[0].boundingBox.height.toInt());
  }
  compressFile(cimage).then((value) => cimage = value);
  _saveImage(cimage.path);
}


Future<File> compressFile(File image) async {
  return await FlutterNativeImage.compressImage(image.path,
      quality: 50, percentage: 50);
}

Future<Size> imageSize(File file) {
  Completer<Size> completer = Completer();
  Image imageFile = Image.file(file);
  imageFile.image
      .resolve(const ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo info, bool _) {
    var myimage = info.image;
    Size size = Size(myimage.width.toDouble(), myimage.height.toDouble());
    completer.complete(size);
  }));
  return completer.future;
}

Future<String> rotateImage(String path) async {
  ///사진 좌우반전
  final originalFile = File(path);
  List<int> imageBytes = await originalFile.readAsBytes();
  final originalImage = img.decodeImage(imageBytes);
  img.Image fixedImage;
  fixedImage = img.flipHorizontal(originalImage!);

  final fixedFile = await originalFile.writeAsBytes(img.encodeJpg(fixedImage));
  return fixedFile.path;
}