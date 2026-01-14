class VisualizationModel {
  final String srNo;
  final String name;
  final String image;

  VisualizationModel({
    required this.srNo,
    required this.name,
    required this.image,
  });

  factory VisualizationModel.fromJson(Map<String, dynamic> json) {
    return VisualizationModel(
      srNo: json['visulization_srno'],
      name: json['visulization_name'],
      image: json['img1'],
    );
  }
}
