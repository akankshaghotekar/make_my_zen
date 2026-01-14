class UserProfileModel {
  final String name;
  final String email;
  final String gender;
  final String ageGroup;
  final String language;
  final String country;

  UserProfileModel({
    required this.name,
    required this.email,
    required this.gender,
    required this.ageGroup,
    required this.language,
    required this.country,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'][0];

    return UserProfileModel(
      name: data['name'],
      email: data['email'],
      gender: data['gender'],
      ageGroup: data['age_group'],
      language: data['language'],
      country: data['country'],
    );
  }
}
