class CountryModel {
  final String srNo;
  final String country;

  CountryModel({required this.srNo, required this.country});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(srNo: json['country_srno'], country: json['country']);
  }
}
