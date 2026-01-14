class PersonalisedHealingDetailModel {
  final String orderSrNo;
  final String meditationType;
  final String orderDate;
  final String healerStatus;
  final String? fileName;
  final String? endDate;

  PersonalisedHealingDetailModel({
    required this.orderSrNo,
    required this.meditationType,
    required this.orderDate,
    required this.healerStatus,
    this.fileName,
    this.endDate,
  });

  factory PersonalisedHealingDetailModel.fromJson(Map<String, dynamic> json) {
    return PersonalisedHealingDetailModel(
      orderSrNo: json['ordersrno']?.toString() ?? "",
      meditationType: json['meditation_type']?.toString() ?? "",
      orderDate: json['orderdate']?.toString() ?? "",
      healerStatus: json['healer_status']?.toString() ?? "",
      fileName: json['file_name'],
      endDate: json['end_date'],
    );
  }
}
