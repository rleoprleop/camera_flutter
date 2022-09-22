import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model/DataManager.dart';

class overlay extends StatelessWidget {
  overlay(BuildContext context, {Key? key}) : super(key: key);

  DataManager _dataManager=new DataManager();

  @override
  Widget build(BuildContext context) {
    return Positioned(
        height: MediaQuery
            .of(context)
            .size
            .width * 0.75,
        width: MediaQuery
            .of(context)
            .size
            .width,
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
                      _launchUrl(_dataManager.getAdUrl());
                    },
                    child: Image.network(
                      _dataManager.getImageUrl(),
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
                          size: MediaQuery
                              .of(context)
                              .size
                              .height * 0.025),
                    ),
                  ),
                ),
              ],
            )));
  }

  void removeOverlay() {
    ///오버레이 삭제
    // 적절한 타이밍에 호출
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
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

late final OverlayEntry overlayEntry =
OverlayEntry(builder: (context) => overlay(context));

void insertOverlay(BuildContext context) {
  ///오버레이 삽입
  // 적절한 타이밍에 호출
  if (!overlayEntry.mounted) {
    OverlayState overlayState = Overlay.of(context)!;
    overlayState.insert(overlayEntry);
  }
}
