final String TableName = 'ImageInfo';

class ImgFields {
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

class ImgInfo {
  final int? id;
  final bool info;
  final int age;
  final String image;
  final String gender;
  final String name;
  final String banner;
  final String ad;

  const ImgInfo(
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
      ImgFields.id: id,
      ImgFields.info: info ? 1 : 0,
      ImgFields.age: age,
      ImgFields.image: image,
      ImgFields.gender: gender,
      ImgFields.name: name,
      ImgFields.banner: banner,
      ImgFields.ad: ad
    };
  }

  static ImgInfo fromJson(Map<String, Object?> json)=> ImgInfo(
    id:json[ImgFields.id] as int?,
    info:json[ImgFields.info] == 1,
    age:json[ImgFields.age] as int,
    image:json[ImgFields.image] as String,
    gender:json[ImgFields.gender] as String,
    name:json[ImgFields.name] as String,
    banner:json[ImgFields.banner] as String,
    ad:json[ImgFields.ad] as String,
  );


  ImgInfo copy({
    int? id,
    bool? info,
    int? age,
    String? image,
    String? gender,
    String? name,
    String? banner,
    String? ad,
  }) =>
      ImgInfo(
          id: id ?? this.id,
          info: info ?? this.info,
          age: age ?? this.age,
          image: image ?? this.image,
          gender: gender ?? this.gender,
          name: name ?? this.name,
          banner: banner ?? this.banner,
          ad: ad ?? this.ad);
}
