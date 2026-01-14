class DesiredStateModel {
  final String srNo;
  final String name;

  DesiredStateModel({required this.srNo, required this.name});

  factory DesiredStateModel.fromJson(Map<String, dynamic> json) {
    return DesiredStateModel(
      srNo: json['desired_state_srno'],
      name: json['desired_state_name'],
    );
  }
}
