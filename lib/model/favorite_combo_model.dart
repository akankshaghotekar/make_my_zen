class FavoriteComboModel {
  final String srNo;
  final String name;

  FavoriteComboModel({required this.srNo, required this.name});

  factory FavoriteComboModel.fromJson(Map<String, dynamic> json) {
    return FavoriteComboModel(
      srNo: json['meditation_combo_srno'],
      name: json['name'].toString().replaceAll('\n', ' ').trim(),
    );
  }
}
