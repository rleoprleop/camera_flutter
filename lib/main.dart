import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'camera_ex.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  //runApp()전에 초기화 작업을 할 때 사용
WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras[0];

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}
/*
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

Future<Ad> fetchAlbum() async {
  late Ad ad;
//  var url='https://reqres.in/api/users';
//  String url='http://ec2-52-79-226-24.ap-northeast-2.compute.amazonaws.com/api/1/';
  var url='http://3.35.147.134/api/predict';

  try{
    print(url);

    Dio dio = Dio();

    var formData=FormData.fromMap({'image': MultipartFile.fromFile('assets/eye.png')});
    var response = await dio.post(
      url,
      data: formData
    );

    print(response);
    print('${response.statusCode}');
    print(url);
    // If the server did return a 200 OK response,
    // then parse the JSON.
    ad=Ad.fromJson(response.data);
    print(ad);
  } on DioError catch(e){
    if(e.response !=null){
      print('Dio Error!');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      print('HEADERS: ${e.response?.headers}');
    }
    else{
      print('Error sending request!');
      print(e.message);
    }
  }
  return ad;
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

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}):super(key:key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Ad> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
    print(futureAlbum);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Ad>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.banner_url);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}22');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}*/
// A screen that allows users to take a picture using a given camera.

/*
import 'package:flutter/material.dart';
import 'camera_ex.dart';

void main() {
  runApp(const MyApp());
}
*/