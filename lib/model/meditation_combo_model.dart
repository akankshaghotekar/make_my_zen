class MeditationComboModel {
  final String srNo;
  final String name;
  final String description;
  final String image;
  final String audio;
  final String favouriteColor;
  final String commercials;

  MeditationComboModel({
    required this.srNo,
    required this.name,
    required this.description,
    required this.image,
    required this.audio,
    required this.favouriteColor,
    required this.commercials,
  });

  factory MeditationComboModel.fromJson(Map<String, dynamic> json) {
    return MeditationComboModel(
      srNo: json['meditation_combo_srno'] ?? '',
      name: json['name'] ?? '',
      description: json['descr'] ?? '',
      image: json['img1'] ?? '',
      audio: json['img2'] ?? '',
      favouriteColor: json['favourite'] ?? '#777777',
      commercials: json['commercials'] ?? '',
    );
  }

  bool get isFavourite => favouriteColor.toLowerCase() != '#777777';
}
