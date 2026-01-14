class HealingModalityDetailModel {
  final String srNo;
  final String name;
  final String description;
  final String image;

  HealingModalityDetailModel({
    required this.srNo,
    required this.name,
    required this.description,
    required this.image,
  });

  factory HealingModalityDetailModel.fromJson(Map<String, dynamic> json) {
    return HealingModalityDetailModel(
      srNo: json['healing_modalities_srno'] ?? '',
      name: json['name'] ?? '',
      description: json['descr'] ?? '',
      image: json['img1'] ?? '',
    );
  }
}
