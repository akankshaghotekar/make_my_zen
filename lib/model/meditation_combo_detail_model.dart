class MeditationComboDetailModel {
  final String srNo;
  final String name;
  final String description;
  final String image;
  final String audio;
  final String commercialsSrNo;

  MeditationComboDetailModel({
    required this.srNo,
    required this.name,
    required this.description,
    required this.image,
    required this.audio,
    required this.commercialsSrNo,
  });

  factory MeditationComboDetailModel.fromJson(Map<String, dynamic> json) {
    return MeditationComboDetailModel(
      srNo: json['meditation_combo_srno'],
      name: json['name'],
      description: json['descr'],
      image: json['img1'],
      audio: json['img2'],
      commercialsSrNo: json['commercials_srno'],
    );
  }
}
