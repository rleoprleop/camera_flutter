import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:example/camera_screen.dart';


void _saveImage(String path) async {
  ///이미지 갤러리 저장
  await GallerySaver.saveImage(path)
      .then((value) => print("save Image"))
      .catchError((err) {
    print("error");
  });
}

Future<void> processImage(String path) async {
  ///face detect
  if (path == null) {
    print('path null');
    return;
  }
  final inputImage = InputImage.fromFilePath(path);
  print("is Busy? ${_isBusy}");
  if (!_canProcess) return;
  if (_isBusy) return;
  _isBusy = true;

  final faces = await _faceDetector.processImage(inputImage);

  String text = 'face find ${faces.length}\n\n';
  for (final face in faces) {
    text += 'face ${face.boundingBox}\n\n';
  }
  print(text);
  if (faces.length > 0) {
    cropFile(path, faces);
  }
  _isBusy = false;
  if (mounted) {
    setState(() {});
  }
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

  await fetchAlbum(cimage.path).then((value) {
    /*var ran=Random();
                                var a=ran.nextInt(5);
                                if(value.gender==0){
                                  _adimage=adlist0[a]['banner_url']!;
                                  _adurl=adlist0[a]['ad_url']!;
                                }
                                else{
                                  _adimage=adlist1[a]['banner_url']!;
                                  _adurl=adlist1[a]['ad_url']!;
                                }*/
    _adurl = value.ad_url;
    _adimage = value.banner_url;
    insertOverlay();
  });
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