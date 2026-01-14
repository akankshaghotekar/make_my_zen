class PersonalisedHealingModel {
  final String orderSrNo;
  final String meditationType;
  final String orderDate;
  final String healerStatus;
  final String? fileName;
  final String? endDate;

  PersonalisedHealingModel({
    required this.orderSrNo,
    required this.meditationType,
    required this.orderDate,
    required this.healerStatus,
    this.fileName,
    this.endDate,
  });

  factory PersonalisedHealingModel.fromJson(Map<String, dynamic> json) {
    return PersonalisedHealingModel(
      orderSrNo: json['ordersrno'],
      meditationType: json['meditation_type'],
      orderDate: json['orderdate'],
      healerStatus: json['healer_status'],
      fileName: json['file_name'],
      endDate: json['end_date'],
    );
  }
}
