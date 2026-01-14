class FavoriteSeries {
  final String title;
  final String image;

  FavoriteSeries({required this.title, required this.image});
}

class FavoritesStore {
  static final List<FavoriteSeries> likedSeries = [];

  static bool isLiked(String title) {
    return likedSeries.any((e) => e.title == title);
  }

  static void toggleLike(FavoriteSeries item) {
    final index = likedSeries.indexWhere((e) => e.title == item.title);
    if (index >= 0) {
      likedSeries.removeAt(index);
    } else {
      likedSeries.add(item);
    }
  }
}
