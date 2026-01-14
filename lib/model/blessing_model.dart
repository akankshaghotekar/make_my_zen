class BlessingModel {
  final String srNo;
  final String blessingName;

  BlessingModel({required this.srNo, required this.blessingName});

  factory BlessingModel.fromJson(Map<String, dynamic> json) {
    return BlessingModel(
      srNo: json['blessing_srno'],
      blessingName: json['blessing_name'],
    );
  }
}
