import 'package:example/model/model.dart';
import 'dart:async';
import 'package:dio/dio.dart';


class DataManager {
  static late Model model;

  Future<void> fetchModel(String imagepath) async {
    ///post
    //찍은 사진의 이미지 path를 가져옴

    Dio dio = new Dio();
    var formData =
    FormData.fromMap({'image': await MultipartFile.fromFile(imagepath)});
    //'image'를 key로 갖는 formdata를 생성

    final response = await dio.post(
      'http://3.35.147.134/api/predict',
      data: formData,
    );
    //dio.post로 서버에 전송. 광고 이미지와 광고url을 받음

    if (response.statusCode == 200) {
      print(response.data);
      model=Model.fromJson(response.data);
    } else {
      throw Exception('Failed to load album');
    }
  }

  String getAdUrl(){
    return model.ad_url;
  }

  String getImageUrl(){
    return model.banner_url;
  }

  String getText(){
    String gender = model.gender==0?"남성":"여성";
    String age;

    return "${model.age}대 ${gender}에게 추천되는 카테고리는 ${model.name}입니다.";
  }
}
