import 'dart:html';

final String TableName = 'ImageInfo';

class ImageFields {
  static final List<String> values=[
    id, info, age, image, gender, name, banner, ad
  ];

  static final String id = '_id';
  static final String info = '_info';
  static final String age = '_age';
  static final String image = '_image';
  static final String gender = '_gender';
  static final String name = '_name';
  static final String banner = '_banner';
  static final String ad = '_ad';
}

class ImageInfo {
  final int? id;
  final bool info;
  final int age;
  final String image;
  final String gender;
  final String name;
  final String banner;
  final String ad;

  const ImageInfo(
      {this.id,
      required this.info,
      required this.age,
      required this.image,
      required this.gender,
      required this.name,
      required this.banner,
      required this.ad}
      );

  Map<String, dynamic> toMap() {
    return {
      ImageFields.id: id,
      ImageFields.info: info ? 1 : 0,
      ImageFields.age: age,
      ImageFields.image: image,
      ImageFields.gender: gender,
      ImageFields.name: name,
      ImageFields.banner: banner,
      ImageFields.ad: ad
    };
  }

  static ImageInfo fromJson(Map<String, Object?> json)=> ImageInfo(
    id:json[ImageFields.id] as int?,
    info:json[ImageFields.info] == 1,
    age:json[ImageFields.age] as int,
    image:json[ImageFields.image] as String,
    gender:json[ImageFields.gender] as String,
    name:json[ImageFields.name] as String,
    banner:json[ImageFields.banner] as String,
    ad:json[ImageFields.ad] as String,
  );


  ImageInfo copy({
    int? id,
    bool? info,
    int? age,
    String? image,
    String? gender,
    String? name,
    String? banner,
    String? ad,
  }) =>
      ImageInfo(
          id: id ?? this.id,
          info: info ?? this.info,
          age: age ?? this.age,
          image: image ?? this.image,
          gender: gender ?? this.gender,
          name: name ?? this.name,
          banner: banner ?? this.banner,
          ad: ad ?? this.ad);
}
