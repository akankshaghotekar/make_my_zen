class CommercialDetailModel {
  final String feature;

  CommercialDetailModel({required this.feature});

  factory CommercialDetailModel.fromJson(Map<String, dynamic> json) {
    return CommercialDetailModel(
      feature: json['commercials'].toString().replaceAll('\n', ' ').trim(),
    );
  }
}
