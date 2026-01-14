class AddPersonalisedHealingResponseModel {
  final int status;
  final String message;
  final int orderSrNo;

  AddPersonalisedHealingResponseModel({
    required this.status,
    required this.message,
    required this.orderSrNo,
  });

  factory AddPersonalisedHealingResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AddPersonalisedHealingResponseModel(
      status: json['status'] ?? 1,
      message: json['message'] ?? '',
      orderSrNo: json['ordersrno'] ?? 0,
    );
  }
}
