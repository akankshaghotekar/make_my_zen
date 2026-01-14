class AgeGroupModel {
  final String srNo;
  final String ageGroup;

  AgeGroupModel({required this.srNo, required this.ageGroup});

  factory AgeGroupModel.fromJson(Map<String, dynamic> json) {
    return AgeGroupModel(
      srNo: json['age_group_srno'],
      ageGroup: json['age_group'],
    );
  }
}
