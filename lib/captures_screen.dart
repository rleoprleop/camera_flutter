import 'dart:io';
import 'package:example/db/ImgInfo.dart';
import 'package:flutter/material.dart';
import 'package:example/preview_screen.dart';

class CapturesScreen extends StatelessWidget {
  final List<ImgInfo>? imageFileList;

  const CapturesScreen({required this.imageFileList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('돌아가기'),
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            imageFileList != null ?
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: [
                for (ImgInfo imageFile in imageFileList!)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>
                                PreviewScreen(
                                  fileList: imageFileList!,
                                  imageFile: imageFile,
                                ),
                          ),
                        );
                      },
                      child: Image.file(
                        File(imageFile.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            )
            : const Center(
              child: Text(
                'Empty',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
