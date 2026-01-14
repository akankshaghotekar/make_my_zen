class HealingModalityModel {
  final String srNo;
  final String name;
  final String description;
  final String image;

  HealingModalityModel({
    required this.srNo,
    required this.name,
    required this.description,
    required this.image,
  });

  factory HealingModalityModel.fromJson(Map<String, dynamic> json) {
    return HealingModalityModel(
      srNo: json['healing_modalities_srno'],
      name: json['name'],
      description: json['descr'],
      image: json['img1'],
    );
  }
}
