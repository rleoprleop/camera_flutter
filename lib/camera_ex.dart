import 'dart:async';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import 'package:image_cropper/image_cropper.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late String adurl;
  late String adimage;
  late String imagepath;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    overlayEntry.dispose();
    super.dispose();
  }

  late final OverlayEntry overlayEntry =
      OverlayEntry(builder: (context) => overlay(context));

  void insertOverlay() {
    // 적절한 타이밍에 호출
    if (!overlayEntry.mounted) {
      OverlayState overlayState = Overlay.of(context)!;
      overlayState.insert(overlayEntry);
    }
  }

  void _launchUrl(String adurl) async {
    Uri _url = Uri.parse(adurl);
    if (await (canLaunchUrl(_url))) {
      await launchUrl(_url, webOnlyWindowName: "_blank");
    } else {
      throw 'Could not launch $_url';
    }
  }

  Widget overlay(BuildContext context) {
    return Positioned(
        height: MediaQuery.of(context).size.width * 0.75,
        width: MediaQuery.of(context).size.width,
        bottom: 0,
        child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _launchUrl(adurl);
                    },
                    child: Image.network(
                      adimage,
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 20,
                  child: GestureDetector(
                    onTap: () {
                      // When the icon is pressed the OverlayEntry
                      // is removed from Overlay
                      removeOverlay();
                    },
                    child: Container(
                      height: 30.0,
                      width: 30.0,
                      padding: const EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1.0),
                        color: Colors.white,
                      ),
                      child: Icon(Icons.close,
                          color: Colors.black,
                          size: MediaQuery.of(context).size.height * 0.025),
                    ),
                  ),
                ),
              ],
            )));
  }

  void removeOverlay() {
    // 적절한 타이밍에 호출
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;
            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final path = join(
              // 본 예제에서는 임시 디렉토리에 이미지를 저장합니다. `path_provider`
              // 플러그인을 사용하여 임시 디렉토리를 찾으세요.
              (await getApplicationDocumentsDirectory()).path,
            );
            final image = await _controller.takePicture();

            print(path + " " + image.path);/*
            await rotateImage(image.path).then((value) {
              imagepath = value;
            }).catchError((onError) {
              print("rotate error");
            }); //이미지 정상으로.*/

            print(image.path);
            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
            await fetchAlbum(image.path).then((value) {
              //adurl = value.ad_url;
              //adimage = value.banner_url;
              adurl='https://pages.coupang.com/p/64094?from=home_C2&traid=home_C2&trcid=11165648';
              adimage='https://static.coupangcdn.com/ta/cmg_paperboy/image/1657068306263/C2-1-%ED%97%AC%EC%8A%A4%ED%95%98%EC%9A%B0%EC%8A%A4.jpg';
              insertOverlay();
            });
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: Container(
          height: 80.0,
          width: 80.0,
          padding: const EdgeInsets.all(1.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
            Border.all(color: Colors.black, width: 1.0),
            color: Colors.white,
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
              Border.all(color: Colors.black, width: 3.0),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: (FloatingActionButtonLocation.centerFloat),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Image.file(
          File(imagePath),
        ));
  }
}

Future<Ad> fetchAlbum(String imagepath) async {
  Dio dio = new Dio();
  var formData =
      FormData.fromMap({'image': await MultipartFile.fromFile(imagepath)});
  final response = await dio.post(
    'http://3.35.147.134/api/predict',
    data: formData,
  );

  print(response.data);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final a = Ad.fromJson(response.data);
    print(a.banner_url);
    return a;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Ad {
  final int age;
  final String name;
  final String banner_url;
  final String ad_url;

  const Ad({
    required this.age,
    required this.name,
    required this.banner_url,
    required this.ad_url,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      age: json['age'],
      name: json['name'],
      banner_url: json['banner_url'],
      ad_url: json['ad_url'],
    );
  }
}

Future<String> rotateImage(String path) async {
  final originalFile = File(path);
  List<int> imageBytes = await originalFile.readAsBytes();
  final originalImage = img.decodeImage(imageBytes);

  img.Image fixedImage;
  fixedImage = img.flipHorizontal(originalImage!);

  final fixedFile = await originalFile.writeAsBytes(img.encodeJpg(fixedImage));
  return fixedFile.path;
}

Future<String> cropImage(String imagepath) async {
  print(imagepath);
  final croppedImage = await ImageCropper().cropImage(
    sourcePath: imagepath,
    compressQuality: 50,
  );
  return croppedImage!.path;
}

/*final Uri _url = Uri.parse('https://naver.com');

class CameraExample extends StatefulWidget {
  const CameraExample({Key? key}) : super(key: key);

  @override
  _CameraExampleState createState() => _CameraExampleState();
}

class _CameraExampleState extends State<CameraExample> {
  CameraController? _cameraController;
  Future<void>? _initCameraControllerFuture;
  int cameraIndex = 0;

  bool isCapture = false;
  File? captureImage;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    _cameraController =
        CameraController(cameras[cameraIndex], ResolutionPreset.veryHigh);
    _initCameraControllerFuture = _cameraController!.initialize().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  void _launchUrl() async {
    if (await (canLaunchUrl(_url))) {
      await launchUrl(_url, webOnlyWindowName: "_blank");
    } else {
      throw 'Could not launch $_url';
    }
  }

  void _showOverlay(BuildContext context) async {
    // Declaring and Initializing OverlayState
    // and OverlayEntry objects
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        height: MediaQuery.of(context).size.width * 0.75,
        width: MediaQuery.of(context).size.width,
        bottom: 0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white,
          ),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  _launchUrl();
                },
                child: Image.asset(
                  'assets/eye.png',
                ),
              ),
              Positioned(
                right: 20,
                top: 20,
                child: GestureDetector(
                  onTap: () {
                    // When the icon is pressed the OverlayEntry
                    // is removed from Overlay
                    overlayEntry?.remove();
                  },
                  child: Container(
                    height: 30.0,
                    width: 30.0,
                    padding: const EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1.0),
                      color: Colors.white,
                    ),
                    child: Icon(Icons.close,
                        color: Colors.black,
                        size: MediaQuery.of(context).size.height * 0.025),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
    overlayState?.insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: isCapture
          ? Column(
              // 촬영 된 이미지 출력
              children: [
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: SizedBox(
                    width: size.width,
                    height: size.width,
                    child: ClipRect(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: SizedBox(
                          width: size.width,
                          child: AspectRatio(
                            aspectRatio:
                                1 / _cameraController!.value.aspectRatio,
                            child: Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: MemoryImage(
                                      captureImage!.readAsBytesSync()),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // 재촬영 선택시 카메라 삭제 및 상태 변경
                            captureImage!.delete();
                            captureImage = null;
                            setState(() {
                              isCapture = false;
                            });
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  "다시 찍기",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: FutureBuilder<void>(
                    future: _initCameraControllerFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SizedBox(
                          width: size.width,
                          height: size.width,
                          child: ClipRect(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: SizedBox(
                                width: size.width,
                                child: AspectRatio(
                                    aspectRatio: 1 /
                                        _cameraController!.value.aspectRatio,
                                    child: CameraPreview(_cameraController!)),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            try {
                              await _cameraController!
                                  .takePicture()
                                  .then((value) {
                                captureImage = File(value.path);
                              });
                              // 화면 상태 변경 및 이미지 저장
                              setState(() {
                                isCapture = true;
                              });
                              _showOverlay(context);
                            } catch (e) {
                              print("$e");
                            }
                          },
                          child: Container(
                            height: 80.0,
                            width: 80.0,
                            padding: const EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.black, width: 1.0),
                              color: Colors.white,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.black, width: 3.0),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () async {
                              //await, async 비동기 처리
                              // 후면 카메라 <-> 전면 카메라 변경
                              cameraIndex = cameraIndex == 0 ? 1 : 0;
                              await _initCamera();
                            },
                            icon: const Icon(
                              Icons.flip_camera_android,
                              color: Colors.white,
                              size: 34.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
*/
