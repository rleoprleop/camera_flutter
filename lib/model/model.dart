class Model {
  final int age;
  final int gender;
  final String name;
  final String banner_url;
  final String ad_url;

  const Model({
    required this.age,
    required this.gender,
    required this.name,
    required this.banner_url,
    required this.ad_url,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      age: json['age'],
      gender: json['gender'],
      name: json['name'],
      banner_url: json['banner_url'],
      ad_url: json['ad_url'],
    );
  }
}