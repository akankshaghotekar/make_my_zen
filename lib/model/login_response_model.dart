class LoginResponseModel {
  final String userSrNo;
  final String name;
  final String email;
  final String gender;
  final String ageGroup;
  final String language;
  final String country;

  LoginResponseModel({
    required this.userSrNo,
    required this.name,
    required this.email,
    required this.gender,
    required this.ageGroup,
    required this.language,
    required this.country,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'][0];

    return LoginResponseModel(
      userSrNo: data['usersrno'],
      name: data['name'],
      email: data['email'],
      gender: data['gender'],
      ageGroup: data['age_group'],
      language: data['language'],
      country: data['country'],
    );
  }
}
