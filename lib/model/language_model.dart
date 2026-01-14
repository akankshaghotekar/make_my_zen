class LanguageModel {
  final String srNo;
  final String language;

  LanguageModel({required this.srNo, required this.language});

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      srNo: json['language_srno'],
      language: json['language'],
    );
  }
}
