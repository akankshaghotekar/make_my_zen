class MeditationComboMeditationModel {
  final String name;
  final String audio;

  MeditationComboMeditationModel({required this.name, required this.audio});

  factory MeditationComboMeditationModel.fromJson(Map<String, dynamic> json) {
    return MeditationComboMeditationModel(
      name: json['name'] ?? '',
      audio: json['img1'] ?? '',
    );
  }
}
