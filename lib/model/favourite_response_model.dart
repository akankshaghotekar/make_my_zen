class FavouriteResponseModel {
  final int status;
  final String message;

  FavouriteResponseModel({required this.status, required this.message});

  factory FavouriteResponseModel.fromJson(Map<String, dynamic> json) {
    return FavouriteResponseModel(
      status: json['status'] ?? 1,
      message: json['message'] ?? '',
    );
  }
}
