import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Ad> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('http://ec2-52-79-226-24.ap-northeast-2.compute.amazonaws.com/'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Ad.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Ad {
  final String name;
  final String banner_url;
  final String ad_url;

  const Ad({
    required this.name,
    required this.banner_url,
    required this.ad_url,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      name: json['name'],
      banner_url: json['banner_url'],
      ad_url: json['ad_url'],
    );
  }
}

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
                return Text(snapshot.data!.name);
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
}