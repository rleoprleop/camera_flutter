import 'package:example/model/model.dart';
import 'dart:async';
import 'package:dio/dio.dart';


class DataManager {
  late Model _model;
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
      _model=Model.fromJson(response.data);
    } else {
      throw Exception('Failed to load album');
    }
  }

  String getAdUrl(){
    return _model.ad_url;
  }

  String getImageUrl(){
    return _model.banner_url;
  }

  String getText(){
    return "${_model.age}대 ${_model.gender}에게 추천되는 카테고리는 ${_model.name}입니다.";
  }

}