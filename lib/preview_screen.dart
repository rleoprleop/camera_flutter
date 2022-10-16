import 'dart:io';

import 'package:example/db/ImgInfo.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'captures_screen.dart';

class PreviewScreen extends StatelessWidget {
  final ImgInfo imageFile;
  final List<ImgInfo> fileList;

  PreviewScreen({
    required this.imageFile,
    required this.fileList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.file(File(imageFile.image)),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Material(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          '나이는 23세로 추정됩니다.\n성별은 남성으로 추정됩니다.\n추천되었던 카테고리는 모자입니다.',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                        child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _launchUrl(
                                'https://www.musinsa.com/app/goods/2053753?loc=goods_rank');
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.width * 0.15,
                              width: MediaQuery.of(context).size.width * 0.45,
                              padding: const EdgeInsets.all(10.0),
                              margin: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xffB4C5D5),
                              ),
                              child: const Center(
                                child: Text(
                                  "광고로 이동!",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => CapturesScreen(
                                  imageFileList: fileList,
                                ),
                              ),
                            );
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.width * 0.15,
                              width: MediaQuery.of(context).size.width * 0.45,
                              padding: const EdgeInsets.all(2.0),
                              margin: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xffB4C5D5),
                              ),
                              child: const Center(
                                child: Text(
                                  "돌아가기",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ),
                      ],
                    )),
                  ],
                )),
          )
        ],
      ),
    );
  }

  void _launchUrl(String adurl) async {
    ///url 실행
    Uri _url = Uri.parse(adurl);
    if (await (canLaunchUrl(_url))) {
      await launchUrl(_url, webOnlyWindowName: "_blank");
    } else {
      throw 'Could not launch $_url';
    }
  }
}
