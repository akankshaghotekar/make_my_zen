class CommercialPlanModel {
  final String srNo;
  final String name;
  final String monthlyRate;
  final String yearlyRate;

  CommercialPlanModel({
    required this.srNo,
    required this.name,
    required this.monthlyRate,
    required this.yearlyRate,
  });

  factory CommercialPlanModel.fromJson(Map<String, dynamic> json) {
    return CommercialPlanModel(
      srNo: json['commercials_srno'],
      name: json['commercials'],
      monthlyRate: json['monthly_rate'],
      yearlyRate: json['yearly_rate'],
    );
  }
}
