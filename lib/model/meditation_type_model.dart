class MeditationTypeModel {
  final String srNo;
  final String title;
  final String image;

  MeditationTypeModel({
    required this.srNo,
    required this.title,
    required this.image,
  });

  factory MeditationTypeModel.fromJson(Map<String, dynamic> json) {
    return MeditationTypeModel(
      srNo: json['meditation_type_srno'],
      title: json['meditation_type'].toString().replaceAll('\n', ' ').trim(),
      image: json['img1'],
    );
  }
}
