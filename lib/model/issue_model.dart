class IssueModel {
  final String srNo;
  final String name;

  IssueModel({required this.srNo, required this.name});

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(srNo: json['issue_srno'], name: json['issue_name']);
  }
}
